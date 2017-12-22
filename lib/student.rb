class Student

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]

    attr_accessor :name, :grade
    attr_reader :id

    def initialize(name, grade, id=nil)
      @name = name
      @id = id
      @grade = grade
    end

    def self.create_table
      sql = <<-SQL
        CREATE TABLE IF NOT EXISTS students (
          id INTEGER PRIMARY KEY,
          name TEXT,
          grade INTEGER
        )
        SQL
        DB[:conn].execute(sql)
    end
  # To "map" our class to a database table,
  # we will create a table with the same name as our class
  # and give that table column names that match the attr_accessors of our class.
    def self.drop_table
      sql = <<-SQL
      DROP TABLE students;
      SQL
      DB[:conn].execute(sql)
    end

    def save
      sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?,?)
      SQL
      DB[:conn].execute(sql, self.name, self.grade)
      @id = DB[:conn].execute("SELECT MAX(id) FROM students")[0][0]
    end

    def self.create(student_hash)
      new_student = Student.new(student_hash[:name], student_hash[:grade]) # instantiate a new Student object with Student.new(name, grade)
      new_student.save #save that new student object via student.save
      new_student #create method should return the student object that it

    end

end
