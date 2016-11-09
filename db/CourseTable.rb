require 'pg'

class PostgresDirect
  # Create the connection instance.
  def connect
    @conn = PG.connect(
        :dbname => 'myapp_development',
        :host => 'localhost',
        :user => 'pguser',
        :password => 'pguser_password')
  end

  # Create our test table (assumes it doesn't already exist)
  def createUserTable(tableName)
    @conn.exec("DROP TABLE IF EXISTS #{tableName}")
    @conn.exec("CREATE TABLE #{tableName} (id SERIAL PRIMARY KEY NOT NULL, course_id character varying(255) NOT NULL, name character varying(255), slug character varying(255), course_site character varying(255), instructors character varying(255000), partners character varying(255000), homepage character varying(255000), counter integer not null default 0, url_photo character varying(255000)) WITH (OIDS=FALSE);");
  end

  # When we're done, we're going to drop our test table.
  def dropUserTable(tableName)
    @conn.exec("DROP TABLE #{tableName}")
  end

  # Prepared statements prevent SQL injection attacks.  However, for the connection, the prepared statements
  # live and apparently cannot be removed, at least not very easily.  There is apparently a significant
  # performance improvement using prepared statements.
  def prepareInsertUserStatement(tableName)
    @conn.prepare("insert_user", "insert into #{tableName} (course_id, name, slug, course_site, instructors, partners, homepage, counter, url_photo) values ($1, $2, $3, $4, $5, $6, $7, $8, $9)")
  end

  # Add a user with the prepared statement.
  def addUser(course_id, name, slug, course_site, instructors, partners, homepage, counter, url_photo)
    @conn.exec_prepared("insert_user", [course_id, name, slug, course_site, instructors, partners, homepage, counter, url_photo])
  end

  # Get our data back
  def queryUserTable(tableName)
    @conn.exec( "SELECT * FROM #{tableName}" ) do |result|
      result.each do |row|
        yield row if block_given?
      end
    end
  end

  # Disconnect the back-end connection.
  def disconnect
    @conn.close
  end
end

# # Test
 def main
   p = PostgresDirect.new()
   p.connect
   begin
    p.createUserTable("catalog")
    p.prepareInsertUserStatement("catalog")
    # p.addUser("test1", "test1", "test1", "test1")
    # p.addUser("test2", "test2", "test2", "test2")
  end
end

main
