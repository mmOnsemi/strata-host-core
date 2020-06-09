#include <iostream>
#include <thread>

#include "Database.h"
#include "CouchbaseDocument.h"

#include <QDir>
#include <QDebug>
#include <QStandardPaths>

#define DEBUG(...) printf("\n    Database: "); printf(__VA_ARGS__); printf("\n");

// Replicator URL endpoint
const QString replicator_url = "ws://localhost:4984/strata-db";
const QString replicator_username = "";
const QString replicator_password = "";
const QStringList replicator_channels = {};

int main() {
    /********************************************
     * MAIN CRUD OPERATIONS *
     *******************************************/

    // Default DB location will be the current location
    Database DB_1("Sample Database 1");

    // Open DB 1
    if (DB_1.open()) {
        qDebug() << "Database 1 will be stored in: " << DB_1.getDatabasePath();
    } else {
        qDebug() << "Error: Failed to open database.";
        return -1;
    }

    // Get database name
    qDebug() << "Database name is: " << DB_1.getDatabaseName();

    // Create a document "Doc_1"
    CouchbaseDocument Doc_1("Doc_1");

    // Set document body (Fail case: must be in valid JSON format)
    QString body_string;
    body_string = "NOT A JSON!";
    if (!Doc_1.setBody(body_string)) {
        DEBUG("Failed to set document contents, body must be in JSON format.");
    } else {
        DEBUG("Successfully set document contents.");
    }

    // Set document body with valid JSON
    body_string = R"foo({"name": "My Name", "age" : 50, "myobj" : { "myarray" : [1,2,3,4], "mykey" : "myvalue"}})foo";
    if (!Doc_1.setBody(body_string)) {
        DEBUG("Failed to set document contents, body must be in JSON format.");
    } else {
        DEBUG("Successfully set document contents.");
    }

    // Save "Doc_1" to DB
    DB_1.save(&Doc_1);

    // Retrieve contents of "Doc_1" in JSON format (QString)
    QString result_str = DB_1.getDocumentAsStr("Doc_1");
    DEBUG(("Document contents: " + result_str.toStdString()).c_str());

    // Create a document "Doc_2" on DB 1
    CouchbaseDocument Doc_2("Doc_2");
    body_string = R"foo({"name": "My Other Name", "age" : 1})foo";
    if (!Doc_2.setBody(body_string)) {
        DEBUG("Failed to set document contents, body must be in JSON format.");
    } else {
        DEBUG("Successfully set document contents.");
    }

    // Modify key "age" with value 1 to 30 on "Doc_2"
    Doc_2["age"] = 30;

    // Save "Doc_2" to DB 1
    DB_1.save(&Doc_2);

    // Get all document keys in a QStringList
    auto document_keys = DB_1.getAllDocumentKeys();
    DEBUG("All document keys:");
    qDebug() << document_keys;

    // Retrieve contents of "Doc_1" in JSON format (QJsonObject)
    auto result_obj = DB_1.getDocumentAsJsonObj("Doc_1");
    DEBUG("Doc_1 as a Json Object:");
    foreach(const QString& key, result_obj.keys()) {
        QJsonValue value = result_obj.value(key);
        qDebug() << "Key =" << key << ", value =" << value;
    }

    // Retrieve entire DB as a QJsonObject
    auto db_obj = DB_1.getDatabaseAsJsonObj();
    DEBUG("Entire DB as a Json Object:");
    foreach(const QString& key, db_obj.keys()) {
        QJsonValue value = db_obj.value(key);
        qDebug() << "Key =" << key << ", value =" << value;
    }

    /********************************************
     * REPLICATOR API *
     *******************************************/

    // DB location can be given as a QString argument
    QDir dir;
    const QString documentsPath = dir.absolutePath();

    Database DB_2("Sample Database 2", documentsPath);

    // Open DB 2
    if (DB_2.open()) {
        qDebug() << "Database 2 will be stored in: " << DB_2.getDatabasePath();
    } else {
        qDebug() << "Error: Failed to open database.";
        return -1;
    }

    // Start replicator on DB 2 with all default arguments
    if (DB_2.startReplicator(replicator_url)) {
        DEBUG("Replicator successfully started.");
    } else {
        DEBUG("Replicator failed to start.");
    }

    // Wait until replication is finished
    std::this_thread::sleep_for(std::chrono::milliseconds(1000));

    // Display all document keys
    document_keys = DB_2.getAllDocumentKeys();
    qDebug() << "\nAll document keys of DB 2 after replication: " << document_keys << "\n";

    Database DB_3("Sample Database 3", documentsPath);

    // Open DB 3
    if (DB_3.open()) {
        qDebug() << "Database 3 will be stored in: " << DB_3.getDatabasePath();
    } else {
        qDebug() << "Error: Failed to open database.";
        return -1;
    }

    // Start replicator on DB 3 with all non-default options
    auto changeListener = [](cbl::Replicator, const CBLReplicatorStatus) {
        std::cout << "\nCouchbaseDatabaseSampleApp changeListener -> replication status changed!" << std::endl;
    };

    auto documentListener = [](cbl::Replicator, bool, const std::vector<CBLReplicatedDocument, std::allocator<CBLReplicatedDocument>>) {
        std::cout << "\nCouchbaseDatabaseSampleApp documentListener -> document status changed!" << std::endl;
    };

    if (DB_3.startReplicator(replicator_url, replicator_username, replicator_password, replicator_channels, "pull", changeListener, documentListener)) {
        DEBUG("Replicator successfully started.");
    } else {
        DEBUG("Replicator failed to start.");
    }

    // Wait until replication is finished
    std::this_thread::sleep_for(std::chrono::milliseconds(1000));

    // Display all document keys
    document_keys = DB_3.getAllDocumentKeys();
    qDebug() << "\nAll document keys of DB 3 after replication: " << document_keys << "\n";

    return 0;
}