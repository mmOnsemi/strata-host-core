#include "CommandValidator.h"

#include "logging/LoggingQtCategories.h"

#include <rapidjson/writer.h>
#include <rapidjson/error/en.h>

// define the schemas

const rapidjson::SchemaDocument CommandValidator::cmdSchema_(
    CommandValidator::parseSchema(
        R"(
		{
			"$schema": "http://json-schema.org/draft-04/schema#",
			"type": "object",
			"properties": {
				"cmd":     { "type": "string" },
				"payload": { "type": "object" }
			},
			"required": [ "cmd" ]
		})"
    )
);

const rapidjson::SchemaDocument CommandValidator::ackSchema_(
    CommandValidator::parseSchema(
        R"(
		{
			"$schema": "http://json-schema.org/draft-04/schema#",
			"type": "object",
			"properties": {
				"ack": {
					"type": "string"
				},
				"payload": {
					"type": "object",
					"properties": {
						"return_value":  { "type": "boolean" },
						"return_string": { "type": "string" }
					},
					"required": [ "return_value", "return_string" ]
				}
			},
			"required": [ "ack", "payload" ]
		})"
    )
);

const rapidjson::SchemaDocument CommandValidator::notificationSchema_(
    CommandValidator::parseSchema(
        R"(
		{
			"$schema": "http://json-schema.org/draft-04/schema#",
			"type": "object",
			"properties": {
				"notification": {
					"type": "object",
					"properties": {
						"value":   { "type": "string" },
						"payload": { "type": "object" }
					},
					"required": [ "value", "payload" ]
				}
			},
			"required": [ "notification" ]
		})"
    )
);

// notification with status in payload
const rapidjson::SchemaDocument CommandValidator::notifPayloadStatusSchema_(
    CommandValidator::parseSchema(
        R"(
		{
			"$schema": "http://json-schema.org/draft-04/schema#",
			"type": "object",
			"properties": {
				"status": { "type": "string" }
			},
			"required": [ "status" ]
		})"
    )
);

// this support platform id v2 only.
const rapidjson::SchemaDocument CommandValidator::reqPlatformId_nps_(
    CommandValidator::parseSchema(
        R"(
		{
			"$schema": "http://json-schema.org/draft-04/schema#",
			"type": "object",
			"properties": {
				"name":                { "type": "string" },
				"verbose_name":        { "type": "string" },
				"controller_type":     { "type": "integer" },
				"platform_id":         { "type": "string" },
				"class_id":            { "type": "string" },
				"count":               { "type": [ "string", "integer" ] },
				"board_count":         { "type": "integer" },
				"platform_id_version": { "type": "string" }
			},
			"oneOf": [
				{
					"required": [ "name", "platform_id", "class_id", "count", "platform_id_version" ]
				},
				{
					"required": [ "name", "controller_type", "platform_id", "class_id", "board_count" ]
				}
			]
		})"
    )
);

const rapidjson::SchemaDocument CommandValidator::getFirmwareInfo_nps_(
    CommandValidator::parseSchema(
        R"(
		{
			"$schema": "http://json-schema.org/draft-04/schema#",
			"type": "object",
			"properties": {
				"bootloader": {
					"oneOf": [
						{
							"type": "object",
							"additionalProperties": false
						},
						{
							"type": "object",
							"properties": {
								"version": { "type": "string" },
								"date":    { "type": "string" }
							},
							"required": [ "version", "date" ]
						}
					]
				},
				"application": {
					"oneOf": [
						{
							"type": "object",
							"additionalProperties": false
						},
						{
							"type": "object",
							"properties": {
								"version": { "type": "string" },
								"date":    { "type": "string" }
							},
							"required": [ "version", "date" ]
						}
					]
				}
			},
			"required": [ "bootloader", "application" ]
		})"
    )
);

const rapidjson::SchemaDocument CommandValidator::startBackupFirmware_nps_(
    CommandValidator::parseSchema(
        R"(
		{
			"$schema": "http://json-schema.org/draft-04/schema#",
			"oneOf": [
				{
					"type": "object",
					"properties": {
						"size":   { "type": "number" },
						"chunks": { "type": "number" }
					},
					"required": [ "size", "chunks" ]
				},
				{
					"type": "object",
					"properties": {
						"status": { "type": "string" }
					},
					"required": [ "status" ]
				}
			]
		})"
    )
);

const rapidjson::SchemaDocument CommandValidator::backupFirmware_nps_(
   CommandValidator::parseSchema(
        R"(
		{
			"$schema": "http://json-schema.org/draft-04/schema#",
			"type": "object",
			"properties": {
				"chunk": {
					"type": "object",
					"properties": {
						"number": { "type": "number" },
						"size":   { "type": "number" },
						"crc":    { "type": "number" },
						"data":   { "type": "string" }
					},
					"required": [ "number", "size", "crc", "data" ]
				}
			},
			"required": [ "chunk" ]
		})"
    )
);

const rapidjson::SchemaDocument CommandValidator::strataCommandSchema_(
    CommandValidator::parseSchema(
        R"(
		{
			"$schema": "http://json-schema.org/draft-04/schema#",
			"type": "object",
			"oneOf": [
				{
					"properties": {
						"cmd":     { "type": "string" },
						"payload": { "type": "object" }
					},
					"required": [ "cmd" ]
				},
				{
					"properties": {
						"notification": {
							"type": "object",
							"properties": {
								"value":   { "type": "string" },
								"payload": { "type": "object" }
							},
							"required": [ "value", "payload" ]
						}
					},
					"required": [ "notification" ]
				},
				{
					"properties": {
						"ack": { "type": "string" },
						"payload": {
							"type": "object",
							"properties": {
								"return_value":  { "type": "boolean" },
								"return_string": { "type": "string" }
							},
							"required": [ "return_value", "return_string" ]
						}
					},
					"required": [ "ack", "payload" ]
				}
			]
		})"
    )
);

const std::map<const CommandValidator::JsonType, const rapidjson::SchemaDocument&> CommandValidator::schemas_ = {
    {JsonType::cmd, cmdSchema_},
    {JsonType::ack, ackSchema_},
    {JsonType::notification, notificationSchema_},
    {JsonType::reqPlatformIdNotif, reqPlatformId_nps_},
    {JsonType::setPlatformIdNotif, notifPayloadStatusSchema_},
    {JsonType::getFirmwareInfoNotif, getFirmwareInfo_nps_},
    {JsonType::startBootloaderNotif, notifPayloadStatusSchema_},
    {JsonType::startApplicationNotif, notifPayloadStatusSchema_},
    {JsonType::startFlashFirmwareNotif, notifPayloadStatusSchema_},
    {JsonType::flashFirmwareNotif, notifPayloadStatusSchema_},
    {JsonType::startBackupFirmwareNotif, startBackupFirmware_nps_},
    {JsonType::backupFirmwareNotif, backupFirmware_nps_},
    {JsonType::startFlashBootloaderNotif, notifPayloadStatusSchema_},
    {JsonType::flashBootloaderNotif, notifPayloadStatusSchema_},
    {JsonType::strataCommand, strataCommandSchema_}
};

const std::map<const CommandValidator::JsonType, const char*> CommandValidator::notifications_ = {
    {JsonType::reqPlatformIdNotif, "platform_id"},
    {JsonType::setPlatformIdNotif, "set_platform_id"},
    {JsonType::getFirmwareInfoNotif, "get_firmware_info"},
    {JsonType::startBootloaderNotif, "start_bootloader"},
    {JsonType::startApplicationNotif, "start_application"},
    {JsonType::startFlashFirmwareNotif, "start_flash_firmware"},
    {JsonType::flashFirmwareNotif, "flash_firmware"},
    {JsonType::startBackupFirmwareNotif, "start_backup_firmware"},
    {JsonType::backupFirmwareNotif, "backup_firmware"},
    {JsonType::startFlashBootloaderNotif, "start_flash_bootloader"},
    {JsonType::flashBootloaderNotif, "flash_bootloader"},
};

rapidjson::SchemaDocument CommandValidator::parseSchema(const QByteArray &schema, bool *isOk) {
    bool ok = true;
    rapidjson::Document sd;
    rapidjson::ParseResult result = sd.Parse(schema.data());
    if (result.IsError()) {
        qCCritical(logCategoryCommandValidator).nospace().noquote() << "JSON parse error at offset " << result.Offset() << ": "
            << rapidjson::GetParseError_En(result.Code()) << " Invalid JSON schema: '" << schema << "'";
        ok = false;
    }

    if (isOk) {
        *isOk = ok;
    }
    return rapidjson::SchemaDocument(sd);
}

bool CommandValidator::validateJsonWithSchema(const rapidjson::SchemaDocument &schema, const rapidjson::Value &json) {
    rapidjson::SchemaValidator validator(schema);

    if (json.Accept(validator) == false) {
        rapidjson::StringBuffer buffer;
        rapidjson::Writer<rapidjson::StringBuffer> writer(buffer);

        json.Accept(writer);
        QByteArray text(buffer.GetString(), static_cast<int>(buffer.GetSize()));

        buffer.Clear();
        writer.Reset(buffer);

        validator.GetError().Accept(writer);

        qCCritical(logCategoryCommandValidator).nospace().noquote() << "JSON '" << text << "' is not valid by required schema: '" << buffer.GetString() << "'";
        return false;
    }

    return true;
}

bool CommandValidator::validate(const QByteArray &command, const JsonType type, rapidjson::Document &doc) {
    if (parseJsonCommand(command, doc) == false) {
        return false;
    }

    return validate(type, doc);
}

bool CommandValidator::validate(const QByteArray &command, const QByteArray& schema, rapidjson::Document &doc) {
    if (parseJsonCommand(command, doc) == false) {
        return false;
    }

    bool isOk = false;
    rapidjson::SchemaDocument schemaDoc = parseSchema(schema, &isOk);
    if (isOk == false) {
        return false;
    }

    return validateJsonWithSchema(schemaDoc, doc);
}

bool CommandValidator::validate(const JsonType type, const rapidjson::Document &doc) {
  const auto it = schemas_.find(type);
  if (it == schemas_.end()) {
      qCCritical(logCategoryCommandValidator).nospace() << "Unknown schema (" << static_cast<int>(type) << ").";
      return false;
  }

  return validateJsonWithSchema(it->second, doc);
}

bool CommandValidator::validateNotification(const JsonType type, const rapidjson::Document &doc) {
    const auto notifIt = notifications_.find(type);
    const auto schemaIt = schemas_.find(type);
    if (notifIt == notifications_.end() || schemaIt == schemas_.end()) {
        qCCritical(logCategoryCommandValidator).nospace() << "Unknown notification (" << static_cast<int>(type) << ").";
        return false;
    }

    if (validate(JsonType::notification, doc) == false) {
        return false;
    }

    const rapidjson::Value& notification = doc["notification"];
    const rapidjson::Value& value = notification["value"];
    const rapidjson::Value& payload = notification["payload"];
    if (notifIt->second != value) {
        return false;
    }

    return validateJsonWithSchema(schemaIt->second, payload);
}

bool CommandValidator::isValidJson(const QByteArray &command) {
    return (rapidjson::Document().Parse(command.data()).HasParseError() == false);
}

bool CommandValidator::parseJsonCommand(const QByteArray &command, rapidjson::Document &doc) {
    rapidjson::ParseResult result = doc.Parse(command.data());
    if (result.IsError()) {
        qCCritical(logCategoryCommandValidator).nospace().noquote() << "JSON parse error at offset " << result.Offset() << ": "
            << rapidjson::GetParseError_En(result.Code()) << " Invalid JSON: '" << command << "'";
        return false;
    }
    if (doc.IsObject() == false) {
        // JSON can contain only a value (e.g. "abc").
        // We require object as a JSON content (Strata JSON commands starts with '{' and ends with '}')
        qCCritical(logCategoryCommandValidator).nospace().noquote() << "Content of JSON is not an object: '" << command << "'.";
        return false;
    }
    return true;
}
