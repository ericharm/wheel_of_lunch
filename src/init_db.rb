require 'sqlite3'

class DatabaseInitializer

  def self.initialize_db(filename)
    unless File.exists?("#{filename}") 
      self.create_db(filename)
    end
  end

  def self.reset(filename)
    db = SQLite3::Database.new(filename)
    ["options"].each do |table|
      db.execute("delete from #{table};")
      db.execute("delete from sqlite_sequence where name='#{table}';")
    end
  end

    private

    def self.create_db(filename)
      db = SQLite3::Database.new(filename)
      self.add_tables(db)
      # puts "Database created"
    end

    def self.add_tables(db)
      create_options_table = db.execute("create table options (
        id integer primary key autoincrement,
        name varchar(64),
        default_on integer,
        ip varchar(64)
      );")
    end

end

