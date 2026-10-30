# SQLite has no UUID type. A column declared as "uuid" is created fine, but the
# adapter reads it back with no type, so db/schema.rb can't be dumped and
# fixtures write integer IDs into it. Registering "uuid" as a string column of
# type :uuid fixes both: the schema dumps `id: :uuid`, and fixtures derive a
# UUID from each label. The values themselves are UUIDv7 strings assigned in
# ApplicationRecord.
module SQLiteUuid
  class Type < ActiveRecord::Type::String
    def type
      :uuid
    end
  end

  module ColumnMethods
    def uuid(*names, **options)
      names.each { |name| column(name, :uuid, **options) }
    end
  end
end

ActiveSupport.on_load(:active_record_sqlite3adapter) do
  self::NATIVE_DATABASE_TYPES[:uuid] = { name: "uuid" }
  self::TYPE_MAP.register_type "uuid", SQLiteUuid::Type.new

  ActiveRecord::ConnectionAdapters::SQLite3::TableDefinition.include SQLiteUuid::ColumnMethods
end
