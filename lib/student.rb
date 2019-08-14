class Student
  attr_accessor :name, :grade
  attr_reader :id

  def initialize(name, grade, id=nil)
    @name = name
    @grade = grade
  end

  def self.create_table
    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS students(
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
      )
      SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = <<-SQL
      DROP TABLE IF EXISTS students
      SQL

    DB[:conn].execute(sql)
  end

  def save
    sql = <<-SQL
    INSERT INTO students (name, grade) VALUES (?, ?)
    SQL

    pull_id = <<-SQL
    SELECT last_insert_rowid() FROM students
    SQL

    new = DB[:conn].execute(sql, self.name, self.grade)
    @id = DB[:conn].execute(pull_id).join.to_i
  end

  def self.create(attributes)
    new = Student.new(attributes[:name], attributes[:grade])
    new.save
    new
  end

end
