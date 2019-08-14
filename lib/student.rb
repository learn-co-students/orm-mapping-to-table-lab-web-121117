class Student

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]

  attr_accessor :name, :grade
  attr_reader :id

  def initialize(name, grade, id=nil)
    @id = id
    @name = name
    @grade = grade
  end

  # creates a DB table
  def self.create_table
    sql = <<-SQL
          CREATE TABLE IF NOT EXISTS students (
            id INTEGER PRIMARY KEY,
            name TEXT,
            grade TEXT
          )
          SQL

      DB[:conn].execute(sql)
  end

  # drops DB table
  def self.drop_table
    sql = <<-SQL
          DROP TABLE IF EXISTS students
          SQL

    DB[:conn].execute(sql)
  end

  # saves instance to a DB
  def save
    sql = <<-SQL
          INSERT INTO students (name, grade)
          VALUES (?, ?)
          SQL

    DB[:conn].execute(sql, self.name, self.grade)

    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
  end

  # creates instance and saves it to DB
  def self.create(name:, grade:)
    student = Student.new(name, grade)
    student.save
    student
  end

end
