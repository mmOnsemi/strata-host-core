#pragma once

#include <string>

#include "DatabaseLib.h"
#include "CouchbaseDatabase.h"

class CouchbaseDatabase;

class CouchbaseDocument
{
    friend class CouchbaseDatabase;

public:
    CouchbaseDocument(const std::string id);

    bool setBody(const std::string &body);

    bool setBody(const QString &body);

    fleece::keyref<fleece::MutableDict, fleece::slice> operator[] (const std::string &key);

    void tagChannelField(const std::vector<std::string> &channels);

private:
    std::unique_ptr<cbl::MutableDocument> mutable_doc_;

    std::string doc_ID_;
};
