#include "SGQrcTreeModel.h"
#include "SGUtilsCpp.h"

#include <QDir>
#include <QDebug>
#include <QDirIterator>
#include <QThread>
#include <QStack>
#include <QQmlEngine>

/**************************************************************
 * Class SGQrcTreeModel
**************************************************************/

SGQrcTreeModel::SGQrcTreeModel(QObject *parent) : QAbstractItemModel(parent)
{
    QQmlEngine::setObjectOwnership(root_, QQmlEngine::CppOwnership);
    connect(this, &SGQrcTreeModel::urlChanged, this, &SGQrcTreeModel::setupModelData);
}

SGQrcTreeModel::~SGQrcTreeModel()
{
    clear(false);
}

/***
 * BEGIN OVERRIDES
 ***/

QHash<int, QByteArray> SGQrcTreeModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[FilenameRole] = QByteArray("filename");
    roles[FilepathRole] = QByteArray("filepath");
    roles[FileTypeRole] = QByteArray("filetype");
    roles[InQrcRole] = QByteArray("inQrc");
    roles[IsDirRole] = QByteArray("isDir");
    roles[ChildrenRole] = QByteArray("childNodes");
    roles[ParentRole] = QByteArray("parentNode");
    roles[UniqueIdRole] = QByteArray("uid");
    roles[RowRole] = QByteArray("row");
    roles[EditingRole] = QByteArray("editing");
    return roles;
}

QVariant SGQrcTreeModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid()) {
        return QVariant();
    }

    SGQrcTreeNode *node = getNode(index);

    switch (role) {
    case FilenameRole:
        return QVariant(node->filename());
    case FilepathRole:
        return QVariant(node->filepath());
    case FileTypeRole:
        return QVariant(node->filetype());
    case InQrcRole:
        return QVariant(node->inQrc());
    case IsDirRole:
        return QVariant(node->isDir());
    case ParentRole:
        return QVariant::fromValue(node->parentNode());
    case UniqueIdRole:
        return QVariant(node->uid());
    case RowRole:
        return QVariant(node->row());
    case EditingRole:
        return QVariant(node->editing());
    }

    if (role == ChildrenRole) {
        QVariantList list;
        for (SGQrcTreeNode* child : node->children()) {
            list.append(QVariant::fromValue(child));
        }
        return list;
    }
    return QVariant();
}


bool SGQrcTreeModel::setData(const QModelIndex &index, const QVariant &value, int role)
{
    if (!index.isValid()) {
        return false;
    }

    SGQrcTreeNode *node = getNode(index);
    bool changed;

    switch (role) {
    case FilenameRole:
        changed = node->setFilename(value.toString());
        break;
    case FilepathRole:
        changed = node->setFilepath(value.toUrl());
        break;
    case FileTypeRole:
        changed = node->setFiletype(value.toString());
        break;
    case InQrcRole:
        changed = node->setInQrc(value.toBool());
        break;
    case IsDirRole:
        changed = node->setIsDir(value.toBool());
        break;
    case EditingRole:
        changed = node->setEditing(value.toBool());
        break;
    default:
        return false;
    }

    if (changed) {
        emit dataChanged(index, index, {role});
    }
    return true;
}

Qt::ItemFlags SGQrcTreeModel::flags(const QModelIndex &index) const
{
    if (!index.isValid()) {
        return Qt::NoItemFlags;
    }
    return Qt::ItemIsEditable | Qt::ItemIsEnabled | Qt::ItemIsSelectable;
}

int SGQrcTreeModel::rowCount(const QModelIndex &index) const
{
    if (index.column() > 0)
        return 0;

    SGQrcTreeNode *parent = getNode(index);
    return parent ? parent->childCount() : 0;
}

int SGQrcTreeModel::columnCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);
    return 1;
}

bool SGQrcTreeModel::removeRows(int row, int count, const QModelIndex &parent)
{
    SGQrcTreeNode *parentItem = getNode(parent);
    if (!parentItem)
        return false;

    beginRemoveRows(parent, row, row + count - 1);
    const bool success = parentItem->removeChildren(row, count);
    endRemoveRows();

    startSave();

    return success;
}

QModelIndex SGQrcTreeModel::index(int row, int column, const QModelIndex &parent) const
{
    if (!hasIndex(row, column, parent)) {
        return QModelIndex();
    }

    SGQrcTreeNode *parentNode = getNode(parent);
    if (!parentNode) {
        root_->setIndex(QModelIndex());
        return QModelIndex();
    }

    SGQrcTreeNode *child = parentNode->childNode(row);

    if (child) {
        QModelIndex index = createIndex(row, column, child);
        child->setIndex(index);
        return index;
    }

    return QModelIndex();
}

QModelIndex SGQrcTreeModel::parent(const QModelIndex &child) const
{
    if (!child.isValid()) {
        return QModelIndex();
    }

    SGQrcTreeNode *childNode = getNode(child);
    SGQrcTreeNode *parent = childNode ? childNode->parentNode() : nullptr;

    if (!parent || parent == root_) {
        return QModelIndex();
    }
    return createIndex(parent->row(), 0, parent);
}

bool SGQrcTreeModel::hasChildren(const QModelIndex &parent) const
{
    if (!parent.isValid()) {
        return false;
    }
    SGQrcTreeNode *node = getNode(parent);
    if (node) {
        return node->childCount() > 0;
    }
    return false;
}

/***
 * END OVERRIDES
 ***/

/***
 * BEGIN CUSTOM FUNCTIONS
 ***/

SGQrcTreeNode* SGQrcTreeModel::root() const
{
    return root_;
}

QList<SGQrcTreeNode*> SGQrcTreeModel::childNodes()
{
    return root_->children();
}

SGQrcTreeNode* SGQrcTreeModel::get(int uid) const
{
    if (uid >= uidMap_.size() || uid < 0) {
        return nullptr;
    }
    return uidMap_.at(uid);
}

SGQrcTreeNode* SGQrcTreeModel::getNode(const QModelIndex &index) const
{
    if (index.isValid()) {
        return static_cast<SGQrcTreeNode*>(index.internalPointer());
    }
    return root_;
}

SGQrcTreeNode* SGQrcTreeModel::getNodeByUrl(const QUrl &url) const
{
    for (SGQrcTreeNode* node : uidMap_) {
        if (node->filepath() == url) {
            return node;
        }
    }
    return nullptr;
}

bool SGQrcTreeModel::insertChild(const QUrl &fileUrl, int position, const QModelIndex &parent)
{
    SGQrcTreeNode *parentNode = getNode(parent);
    if (position > parentNode->childCount()) {
        return false;
    }
    if (position < 0) {
        position = parentNode->childCount();
    }

    beginInsertRows(parent, position, position);
    QFileInfo fi(SGUtilsCpp::urlToLocalFile(fileUrl));
    SGQrcTreeNode *child = new SGQrcTreeNode(parentNode, fi, fi.isDir(), false, uidMap_.size());
    bool success = parentNode->insertChild(child, position);
    uidMap_.append(child);
    endInsertRows();
    return success;
}

bool SGQrcTreeModel::insertChild(bool isDir, int position, const QModelIndex &parent)
{
    SGQrcTreeNode *parentNode = getNode(parent);
    if (position > parentNode->childCount()) {
        return false;
    }
    if (position < 0) {
        position = parentNode->childCount();
    }

    beginInsertRows(parent, position, position);
    SGQrcTreeNode *child = new SGQrcTreeNode(parentNode, isDir, uidMap_.size());
    bool success = parentNode->insertChild(child, position);
    uidMap_.append(child);
    endInsertRows();
    return success;
}



QUrl SGQrcTreeModel::url() const
{
    return url_;
}

void SGQrcTreeModel::setUrl(QUrl url)
{
    if (url_ != url) {
        url_ = url;
        QDir dir(QFileInfo(SGUtilsCpp::urlToLocalFile(url)).dir());
        projectDir_ = SGUtilsCpp::pathToUrl(dir.path());
        emit urlChanged();
        emit projectDirectoryChanged();
    }
}

QUrl SGQrcTreeModel::projectDirectory() const
{
    return projectDir_;
}

bool SGQrcTreeModel::addToQrc(const QModelIndex &index, bool save)
{
    if (!index.isValid()) {
        return false;
    }

    SGQrcTreeNode *node = getNode(index);
    if (!node || qrcItems_.contains(SGUtilsCpp::urlToLocalFile(node->filepath()))) {
        return false;
    }

    QString relativePath = QDir(SGUtilsCpp::urlToLocalFile(projectDir_)).relativeFilePath(SGUtilsCpp::urlToLocalFile(node->filepath()));
    QDomElement qresource = qrcDoc_.elementsByTagName("qresource").at(0).toElement();
    QDomElement newItem = qrcDoc_.createElement("file");
    QDomText text = qrcDoc_.createTextNode(relativePath);
    newItem.appendChild(text);
    qresource.appendChild(newItem);
    qrcItems_.insert(SGUtilsCpp::urlToLocalFile(node->filepath()));
    setData(index, true, InQrcRole);

    if (save) {
        startSave();
    }

    return true;
}

bool SGQrcTreeModel::removeFromQrc(const QModelIndex &index, bool save)
{
    if (!index.isValid()) {
        return false;
    }

    SGQrcTreeNode *node = getNode(index);
    if (!node || !qrcItems_.contains(SGUtilsCpp::urlToLocalFile(node->filepath()))) {
        return false;
    }

    QString relativePath = QDir(SGUtilsCpp::urlToLocalFile(projectDir_)).relativeFilePath(SGUtilsCpp::urlToLocalFile(node->filepath()));
    QDomNodeList files = qrcDoc_.elementsByTagName("file");

    for (int i = 0; i < files.count(); i++) {
        if (files.at(i).toElement().text() == relativePath) {
            files.at(i).parentNode().removeChild(files.at(i));
            qrcItems_.remove(SGUtilsCpp::urlToLocalFile(node->filepath()));
            setData(index, false, InQrcRole);
            break;
        }
    }

    if (save) {
        startSave();
    }

    return true;
}

bool SGQrcTreeModel::deleteFile(const int row, const QModelIndex &parent)
{
    SGQrcTreeNode *parentNode = getNode(parent);

    if (!parentNode || row < 0 || row >= parentNode->childCount()) {
        return false;
    }

    SGQrcTreeNode *child = parentNode->childNode(row);
    if (!child) {
        return false;
    }

    const bool success = SGUtilsCpp::removeFile(SGUtilsCpp::urlToLocalFile(child->filepath()));
    if (success) {
        removeFromQrc(index(row, 0, parent));
        removeRows(row, 1, parent);
    }
    return success;
}

/***
 * PRIVATE FUNCTIONS
 ***/

void SGQrcTreeModel::childrenChanged(const QModelIndex &index, int role) {
    if (index.isValid()) {
        emit dataChanged(index, index, {role});
    } else {
        qWarning() << "Index is not valid";
    }
}

void SGQrcTreeModel::clear(bool emitSignals)
{
    if (emitSignals) {
        beginResetModel();
    }

    delete root_;
    qDeleteAll(uidMap_);
    uidMap_.clear();

    if (emitSignals) {
        endResetModel();
    }
}

void SGQrcTreeModel::readQrcFile()
{
    QFile qrcFile(SGUtilsCpp::urlToLocalFile(url_));

    if (!qrcDoc_.isNull()) {
        qrcDoc_.clear();
    }

    if (!qrcFile.open(QIODevice::ReadOnly | QIODevice::Text)) {
        qCritical() << "Failed to open qrc file";
        return;
    }

    if (!qrcDoc_.setContent(&qrcFile)) {
        qCritical() << "Failed to parse qrc file";
    }

    QDomNode qresource = qrcDoc_.elementsByTagName("qresource").at(0);
    if (qresource.hasAttributes() && qresource.attributes().contains("prefix") && qresource.attributes().namedItem("prefix").nodeValue() != "/" ) {
        qCritical() << "Unexpected prefix for qresource";
        return;
    }

    QDomNodeList files = qrcDoc_.elementsByTagName("file");

    for (int i = 0; i < files.count(); i++) {
        QDomElement element = files.at(i).toElement();
        QString absolutePath = SGUtilsCpp::joinFilePath(SGUtilsCpp::urlToLocalFile(projectDir_), element.text());
        qrcItems_.insert(absolutePath);
    }

    qDebug() << "Successfully parsed qrc file";
    qrcFile.close();
}

void SGQrcTreeModel::setupModelData()
{
    createModel();
}

void SGQrcTreeModel::createModel()
{
    beginResetModel();
    QFileInfo rootFi(SGUtilsCpp::urlToLocalFile(url_));
    clear(false);
    root_ = new SGQrcTreeNode(nullptr, rootFi, false, false, 0);
    emit rootChanged();
//    connect(root_, &SGQrcTreeNode::dataChanged, this, &SGQrcTreeModel::childrenChanged);
    uidMap_.append(root_);
    QQmlEngine::setObjectOwnership(root_, QQmlEngine::CppOwnership);

    readQrcFile();

    recursiveDirSearch(root_, QDir(SGUtilsCpp::urlToLocalFile(projectDir_)), qrcItems_, 0);
    endResetModel();
}

void SGQrcTreeModel::recursiveDirSearch(SGQrcTreeNode* parentNode, QDir currentDir, QSet<QString> qrcItems, int depth)
{
    for (QFileInfo info : currentDir.entryInfoList(QDir::NoDotAndDotDot | QDir::NoSymLinks | QDir::Files | QDir::Dirs)) {
        if (info.isDir()) {
            SGQrcTreeNode *dirNode = new SGQrcTreeNode(parentNode, info, true, false, uidMap_.size());
//            connect(dirNode, &SGQrcTreeNode::dataChanged, this, &SGQrcTreeModel::childrenChanged);
            QQmlEngine::setObjectOwnership(dirNode, QQmlEngine::CppOwnership);
            parentNode->insertChild(dirNode, parentNode->childCount());
            uidMap_.append(dirNode);
            recursiveDirSearch(dirNode, QDir(info.filePath()), qrcItems, depth + 1);
        } else {
            if (SGUtilsCpp::pathToUrl(info.filePath()) == url_) {
                continue;
            }
            SGQrcTreeNode *node = new SGQrcTreeNode(parentNode, info, false, qrcItems.contains(info.filePath()), uidMap_.size());
//            connect(node, &SGQrcTreeNode::dataChanged, this, &SGQrcTreeModel::childrenChanged);
            QQmlEngine::setObjectOwnership(node, QQmlEngine::CppOwnership);
            parentNode->insertChild(node, parentNode->childCount());
            uidMap_.append(node);
        }
    }
}

void SGQrcTreeModel::startSave()
{
    // Create a thread to write data to disk
    QThread *thread = QThread::create(std::bind(&SGQrcTreeModel::save, this));
    thread->setObjectName("SGQrcTreeModel - FileIO Thread");
    // Delete the thread when it is finished saving
    connect(thread, &QThread::finished, thread, &QObject::deleteLater);
    thread->setParent(this);
    thread->start();
}

void SGQrcTreeModel::save()
{
    QFile qrcFile(SGUtilsCpp::urlToLocalFile(url_));
    if (!qrcFile.open(QIODevice::Truncate | QIODevice::WriteOnly | QIODevice::Text)) {
       qCritical() << "Could not open" << url_;
       return;
    }

    // Write the change to disk
    QTextStream stream(&qrcFile);
    stream << qrcDoc_.toString();
    qrcFile.close();
}


