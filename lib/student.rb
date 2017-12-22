class Student

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]

  attr_accessor :name, :grade
  attr_reader :id

  def initialize(name, grade, id=nil)
    @name = name
    @grade = grade
    @id = id
  end

  def save
    sql = <<-SQL
    INSERT INTO students (name, grade) VALUES (?, ?)
    SQL
    DB[:conn].execute(sql, self.name, self.grade)

    @id = DB[:conn].execute("SELECT id FROM students ORDER BY id DESC LIMIT 1")[0][0]
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
        id INTEGER PRIMARY KEY,
        name TEXT,
        grade TEXT)
    SQL
    DB[:conn].execute(sql)
  end

  def self.create(attr_hash)
    new_student = Student.new(attr_hash[:name], new_student = attr_hash[:grade])
    new_student.save
    new_student
  end


  def self.drop_table
    sql = <<-SQL
    DROP TABLE students
    SQL
    DB[:conn].execute(sql)
  end


end
