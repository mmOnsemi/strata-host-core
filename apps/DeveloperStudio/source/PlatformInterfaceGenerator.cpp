#include "PlatformInterfaceGenerator.h"
#include "SGUtilsCpp.h"
#include "logging/LoggingQtCategories.h"

#include <QFile>
#include <QDir>
#include <QDebug>
#include <QJsonDocument>
#include <QJsonArray>
#include <QJsonParseError>
#include <QDateTime>

QString PlatformInterfaceGenerator::lastError_ = QString();

PlatformInterfaceGenerator::PlatformInterfaceGenerator(QObject *parent) : QObject(parent) {}

PlatformInterfaceGenerator::~PlatformInterfaceGenerator() {}

QString PlatformInterfaceGenerator::lastError()
{
    return lastError_;
}

bool PlatformInterfaceGenerator::generate(const QJsonValue &jsonObject, const QString &outputPath)
{
    lastError_ = "";
    QJsonObject platInterfaceData = jsonObject.toObject();

    QDir outputDir(outputPath);

    if (outputDir.exists() == false) {
        lastError_ = "Path to output folder (" + outputPath + ") does not exist.";
        qCCritical(logCategoryControlViewCreator) << "Output folder path does not exist.";
        return false;
    }

    QFile outputFile(outputDir.filePath("PlatformInterface.qml"));

    if (outputFile.open(QFile::WriteOnly | QFile::Truncate) == false) {
        lastError_ = "Could not open " + outputFile.fileName() + " for writing";
        qCCritical(logCategoryControlViewCreator) << "Could not open" << outputFile.fileName() + "for writing";
        return false;
    }

    QTextStream outputStream(&outputFile);
    int indentLevel = 0;

    // Generate imports
    outputStream << generateImports();

    // Generate Header Comment
    QDateTime localTime(QDateTime::currentDateTime());
    SGUtilsCpp utils;
    outputStream << generateCommentHeader("File auto-generated by PlatformInterfaceGenerator on " + utils.formatDateTimeWithOffsetFromUtc(localTime));

    // Start of root item
    outputStream << "PlatformInterfaceBase {\n";
    indentLevel++;
    outputStream << insertTabs(indentLevel)
                 << "id: platformInterface\n"
                 << insertTabs(indentLevel) << "apiVersion: " << API_VERSION << "\n\n";
    outputStream << insertTabs(indentLevel) << "property alias notifications: notifications\n";
    outputStream << insertTabs(indentLevel) << "property alias commands: commands\n\n";

    // Notifications
    outputStream << generateCommentHeader("NOTIFICATIONS", indentLevel);
    outputStream << insertTabs(indentLevel) << "QtObject {\n";

    indentLevel++;
    outputStream << insertTabs(indentLevel) << "id: notifications\n\n";

    // Create QtObjects to handle notifications

    if (platInterfaceData.contains("notifications") == false) {
        lastError_ = "Missing notifications list in JSON.";
        qCCritical(logCategoryControlViewCreator) << lastError_;
        return false;
    }

    QJsonValue notificationsList = platInterfaceData["notifications"];

    if (notificationsList.isArray() == false) {
        lastError_ = "'notifications' needs to be an array";
        qCCritical(logCategoryControlViewCreator) << lastError_;
        return false;
    }

    for (QJsonValue vNotification : notificationsList.toArray()) {
        QJsonObject notification = vNotification.toObject();
        if (notification.contains("payload") && notification["payload"].isNull()) {
            continue;
        }
        outputStream << generateNotification(notification, indentLevel);
        if (lastError_.length() > 0) {
            return false;
        }
    }

    indentLevel--;
    outputStream << insertTabs(indentLevel) << "}\n\n";

    // Commands
    outputStream << generateCommentHeader("COMMANDS", indentLevel);
    outputStream << insertTabs(indentLevel) << "QtObject {\n";

    indentLevel++;
    outputStream << insertTabs(indentLevel) << "id: commands\n";

    if (platInterfaceData.contains("commands") == false) {
        lastError_ = "Missing commands list in JSON.";
        qCCritical(logCategoryControlViewCreator) << lastError_;
        return false;
    }

    QJsonArray commandsList = platInterfaceData["commands"].toArray();

    if (notificationsList.isArray() == false) {
        lastError_ = "'commands' needs to be an array";
        qCCritical(logCategoryControlViewCreator) << lastError_;
        return false;
    }

    for (int i = 0; i < commandsList.count(); ++i) {
        QJsonObject command = commandsList[i].toObject();
        outputStream << generateCommand(command, indentLevel);
        if (lastError_.length() > 0) {
            return false;
        }
    }

    indentLevel--;
    outputStream << insertTabs(indentLevel) + "}\n";
    indentLevel--;
    outputStream << "}\n";
    outputFile.close();

    if (indentLevel != 0) {
        lastError_ = "Final indent level is not 0. Check file for indentation errors";
        qCWarning(logCategoryControlViewCreator) << lastError_;
        return true;
    }

    lastError_ = "";
    return true;
}

QString PlatformInterfaceGenerator::generateImports()
{
    QString imports = "import QtQuick 2.12\n";
    imports += "import QtQuick.Controls 2.12\n";
    imports += "import tech.strata.common 1.0\n";
    imports += "import QtQml 2.12\n";
    imports += "\n\n";
    return imports;
}

QString PlatformInterfaceGenerator::generateCommand(const QJsonObject &command, int &indentLevel)
{
    if (command.contains("cmd") == false) {
        lastError_ = "Command did not contain 'cmd'";
        qCCritical(logCategoryControlViewCreator) << lastError_;
        return QString();
    }
    const QString cmd = command["cmd"].toString();
    QString documentationText = generateComment("@command " + cmd, indentLevel);
    QString commandBody = "";

    commandBody += insertTabs(indentLevel) + "property var " + cmd + ": ({\n";
    commandBody += insertTabs(indentLevel + 1) + "\"cmd\": \"" + cmd + "\",\n";

    QStringList updateFunctionParams;
    QStringList updateFunctionKwRemoved;

    if (command.contains("payload") && command["payload"].isNull() == false) {
        QJsonArray payload = command["payload"].toArray();
        for (QJsonValue payloadPropertyValue : payload) {
            QJsonObject payloadProperty = payloadPropertyValue.toObject();
            QJsonValue propertyNameValue = payloadProperty.value("name");
            QString propertyName = propertyNameValue.toString();
            updateFunctionParams.append(propertyName);
        }
        updateFunctionKwRemoved = updateFunctionParams;
        removeReservedKeywords(updateFunctionKwRemoved);

        commandBody += insertTabs(indentLevel + 1) + "\"payload\": {\n";
        QStringList payloadProperties;

        for (QJsonValue payloadPropertyValue : payload) {
            QJsonObject payloadProperty = payloadPropertyValue.toObject();
            QJsonValue propNameValue = payloadProperty.value("name");
            QString propName = propNameValue.toString();
            QJsonValue propValue = payloadProperty.value("value");
            QJsonValue typeValue = payloadProperty.value("type");
            QString propType = typeValue.toString();

            payloadProperties.append(insertTabs(indentLevel + 2) + "\"" + propName + "\": " + getPropertyValue(payloadProperty, propType, indentLevel + 2));

            if (lastError_.length() > 0) {
                qCCritical(logCategoryControlViewCreator) << lastError_;
                return "";
            }

            if (propType == TYPE_ARRAY_STATIC) {
                documentationText += generateComment("@property " + propName + ": list of size " + QString::number(propValue.toArray().count()), indentLevel);
            } else {
                documentationText += generateComment("@property " + propName + ": " + propType, indentLevel);
            }
        }

        commandBody += payloadProperties.join(",\n");
        commandBody += "\n";
        commandBody += insertTabs(indentLevel + 1) + "},\n";
        commandBody += insertTabs(indentLevel + 1) + "update: function (";
        commandBody += updateFunctionKwRemoved.join(", ");
        commandBody += ") {\n";
    } else {
        commandBody += insertTabs(indentLevel + 1) + "update: function () {\n";
    }

    // Write update function definition
    if (updateFunctionParams.count() > 0) {
        commandBody += insertTabs(indentLevel + 2) + "this.set(" + updateFunctionKwRemoved.join(", ") + ")\n";
    }
    commandBody += insertTabs(indentLevel + 2) + "this.send(this)\n";
    commandBody += insertTabs(indentLevel + 1) + "},\n";

    // Create set function if necessary
    if (updateFunctionParams.count() > 0) {
        commandBody += insertTabs(indentLevel + 1) + "set: function (" + updateFunctionKwRemoved.join(", ") + ") {\n";
        for (int i = 0; i < updateFunctionParams.count(); ++i) {
            commandBody += insertTabs(indentLevel + 2) + "this.payload." + updateFunctionParams.at(i) + " = " + updateFunctionKwRemoved.at(i) + "\n";
        }
        commandBody += insertTabs(indentLevel + 1) + "},\n";
    }

    // Create send function
    commandBody += insertTabs(indentLevel + 1) + "send: function () { platformInterface.send(this) }\n";
    commandBody += insertTabs(indentLevel) + "})\n\n";

    return documentationText + commandBody;
}

QString PlatformInterfaceGenerator::generateNotification(const QJsonObject &notification, int &indentLevel)
{
    if (notification.contains("value") == false) {
        lastError_ = "Notification did not contain 'value'";
        qCCritical(logCategoryControlViewCreator) << lastError_;
        return QString();
    }

    QString notificationId = notification["value"].toString();
    QString notificationBody = "";
    QString documentationBody = "";

    // Create documentation for notification
    documentationBody += generateComment("@notification: " + notificationId, indentLevel);

    // Create the QtObject to handle this notification
    notificationBody += insertTabs(indentLevel) + "property QtObject " + notificationId + ": QtObject {\n";
    indentLevel++;

    QString childrenNotificationBody = "";
    QString childrenDocumentationBody = "";
    QString propertiesBody = "";

    QJsonArray payload = notification["payload"].toArray();

    // Add the properties to the notification
    for (QJsonValue payloadPropertyValue : payload) {
        if (payloadPropertyValue.isObject() == false) {
            lastError_ = "Payload elements are not objects";
            qCCritical(logCategoryControlViewCreator) << lastError_;
            return QString();
        }

        QJsonObject payloadProperty = payloadPropertyValue.toObject();
        QJsonValue propNameValue = payloadProperty.value("name");
        QString propName = propNameValue.toString();
        QJsonValue propValue = payloadProperty.value("value");
        QJsonValue typeValue = payloadProperty.value("type");
        QString propType =  typeValue.toString();

        generateNotificationProperty(indentLevel, notificationId, propName, propType, propValue, childrenNotificationBody, childrenDocumentationBody);

        if (lastError_.length() > 0) {
            return "";
        }

        if (propType == TYPE_OBJECT_STATIC || propType == TYPE_ARRAY_STATIC) {
            continue;
        } else if (propType == TYPE_ARRAY_DYNAMIC || propType == TYPE_OBJECT_DYNAMIC) {
            propertiesBody += insertTabs(indentLevel) + "property var " + propName + ": " + getPropertyValue(payloadProperty, propType, indentLevel) + "\n";
        } else {
            propertiesBody += insertTabs(indentLevel) + "property " + propType + " " + propName + ": " + getPropertyValue(payloadProperty, propType, indentLevel) + "\n";
        }

        if (lastError_.length() > 0) {
            qCCritical(logCategoryControlViewCreator) << lastError_;
            return "";
        }
    }

    propertiesBody += "\n" + insertTabs(indentLevel) + "signal notificationFinished()\n";

    notificationBody = childrenDocumentationBody + notificationBody + propertiesBody;
    notificationBody += childrenNotificationBody;

    indentLevel--;
    notificationBody += insertTabs(indentLevel) + "}\n\n";
    return documentationBody + notificationBody;
}

void PlatformInterfaceGenerator::generateNotificationProperty(int indentLevel, const QString &parentId, const QString &id, const QString &type, const QJsonValue &value, QString &childrenNotificationBody, QString &childrenDocumentationBody)
{
    QString notificationBody = "";
    QString documentation = "";

    if (type == TYPE_ARRAY_STATIC || type == TYPE_OBJECT_STATIC) {
        QString properties = "";
        QString childNotificationBody = "";
        QString childDocumentationBody = "";
        QJsonArray valueArray = value.toArray();

        // Generate a property for each element in array
        notificationBody += insertTabs(indentLevel) + "property QtObject " + id + ": QtObject {\n";

        // Add object name
        if (type == TYPE_ARRAY_STATIC) {
            notificationBody += insertTabs(indentLevel + 1) + "objectName: \"array\"\n";
        } else {
            notificationBody += insertTabs(indentLevel + 1) + "objectName: \"object\"\n";
        }

        // This documentation text will be passed back to parent
        // This allows us to generate comments above each QtObject for their properties
        documentation += generateComment("@property " + id + ": " + type, indentLevel - 1);

        // Add the properties to the notification
        for (int i = 0; i < valueArray.count(); ++i) {
            QJsonValue element = valueArray[i];
            QJsonObject elementObject = element.toObject();
            QJsonValue elementValue = elementObject.value("value");
            QJsonValue elementTypeValue = elementObject.value("type");
            QString elementType = elementTypeValue.toString();
            QString childId;
            if (type == TYPE_ARRAY_STATIC) {
                childId = "index_" + QString::number(i);
            } else {
                QJsonValue elementNameValue = elementObject.value("name");
                QString elementName = elementNameValue.toString();
                childId = "index_" + QString::number(i);
            }

            generateNotificationProperty(indentLevel + 1, parentId + "_" + id, childId, elementType, elementValue, childNotificationBody, childDocumentationBody);

            if (i == 0) {
                childDocumentationBody = "\n" + childDocumentationBody;
            }

            if (elementType == TYPE_ARRAY_STATIC || elementType == TYPE_OBJECT_STATIC) {
                continue;
            } else if (elementType == TYPE_ARRAY_DYNAMIC || elementType == TYPE_OBJECT_DYNAMIC) {
                properties += insertTabs(indentLevel + 1) + "property var " + childId + ": " + getPropertyValue(elementObject, elementType, indentLevel) + "\n";
            } else {
                properties += insertTabs(indentLevel + 1) + "property " + elementType + " " + childId + ": " + getPropertyValue(elementObject, elementType, indentLevel) + "\n";
            }

            if (lastError_.length() > 0) {
                qCCritical(logCategoryControlViewCreator) << lastError_;
                return;
            }
        }

        notificationBody = childDocumentationBody + notificationBody + properties + childNotificationBody;
        notificationBody += insertTabs(indentLevel) + "}\n";
    } else {
        documentation += generateComment("@property " + id + ": " + type, indentLevel - 1);
    }

    childrenNotificationBody += notificationBody;
    childrenDocumentationBody += documentation;
}

QString PlatformInterfaceGenerator::generateComment(const QString &commentText, int indentLevel)
{
    return insertTabs(indentLevel) + "// " + commentText + "\n";
}

QString PlatformInterfaceGenerator::generateCommentHeader(const QString &commentText, int indentLevel)
{
    QString comment = insertTabs(indentLevel) + "/******************************************************************\n";
    comment += insertTabs(indentLevel) + "  * " + commentText + "\n";
    comment += insertTabs(indentLevel) + "******************************************************************/\n\n";
    return comment;
}

QString PlatformInterfaceGenerator::insertTabs(const int num, const int spaces)
{
    QString text = "";
    for (int tabs = 0; tabs < num; ++tabs) {
        for (int space = 0; space < spaces; ++space) {
            text += " ";
        }
    }
    return text;
}

QString PlatformInterfaceGenerator::getPropertyValue(const QJsonObject &object, const QString &propertyType, const int indentLevel)
{
    if (propertyType == TYPE_BOOL) {
        if (object.value("value").toBool() == 1) {
            return "true";
        } else {
            return "false";
        }
    } else if (propertyType == TYPE_STRING) {
        return "\"" + object.value("value").toString() + "\"";
    } else if (propertyType == TYPE_INT) {
        return QString::number(object.value("value").toInt());
    } else if (propertyType == TYPE_DOUBLE) {
        return QString::number(object.value("value").toDouble());
    } else if (propertyType == TYPE_ARRAY_STATIC) {
        QString returnText = "[";
        QJsonValue arrayValue = object.value("value");
        QJsonArray arr = arrayValue.toArray();

        for (int i = 0; i < arr.count(); ++i) {
            QJsonObject child = arr[i].toObject();
            QString type = child.value("type").toString();
            returnText += getPropertyValue(child, type, indentLevel);
            if (i != arr.count() - 1) {
                returnText += ", ";
            }
        }
        returnText += "]";
        return returnText;
    } else if (propertyType == TYPE_OBJECT_STATIC) {
        QString returnText = "{\n";
        QJsonValue objectValue = object.value("value");
        QJsonArray obj = objectValue.toArray();

        for (int i = 0; i < obj.count(); ++i) {
            QJsonObject child = obj[i].toObject();
            QString type = child.value("type").toString();
            QString name = child.value("name").toString();
            returnText += insertTabs(indentLevel + 1) + "\"" + name + "\": " + getPropertyValue(child, type, indentLevel + 1);
            if (i != obj.count() - 1) {
                returnText += ",";
            }
            returnText += "\n";
        }
        returnText += insertTabs(indentLevel) + "}";
        return returnText;
    } else if (propertyType == TYPE_ARRAY_DYNAMIC) {
        return "[]";
    } else if (propertyType == TYPE_OBJECT_DYNAMIC) {
        return "({})";
    } else {
        lastError_ = "Unable to get value for unknown type " + propertyType;
        qCCritical(logCategoryControlViewCreator) << lastError_;
        return "";
    }
}

void PlatformInterfaceGenerator::removeReservedKeywords(QStringList &paramsList)
{
    for (QString param : paramsList) {
        if (param == "function") {
            param = "func";
        }
    }
}
