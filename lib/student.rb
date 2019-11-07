class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    id = row[0]
    name = row[1]
    grade = row[2]
    s = Student.new
    s.id = id
    s.name = name
    s.grade = grade
    s
  end

  def self.all
    sql = "SELECT * FROM students;"
    DB[:conn].execute(sql).map {|row| self.new_from_db(row)}
  end

  def self.find_by_name(name)
    sql = "SELECT * FROM students WHERE students.name = ? LIMIT 1;"
    Student.new_from_db(DB[:conn].execute(sql, name)[0])
  end
  
  def save
    sql = <<-SQL
      INSERT INTO students (name, grade) 
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end
  
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

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end

  def self.all_students_in_grade_9
    sql = "SELECT * FROM students WHERE students.grade = 9;"

    DB[:conn].execute(sql).map {|row| Student.new_from_db(row)}
    
  end

  def self.students_below_12th_grade
    sql = "SELECT * FROM students WHERE students.grade < 12;"

    DB[:conn].execute(sql).map {|row| Student.new_from_db(row)}
    
  end

  def self.first_X_students_in_grade_10(x)
    sql = "SELECT * FROM students WHERE students.grade = 10 LIMIT ?;"

    DB[:conn].execute(sql, x).map {|row| Student.new_from_db(row)}
    
  end

  def self.first_student_in_grade_10
    sql = "SELECT * FROM students WHERE students.grade = 10 LIMIT 1;"

    Student.new_from_db(DB[:conn].execute(sql)[0])
  end

  def self.all_students_in_grade_X(x)
    sql = "SELECT * FROM students WHERE students.grade = ?;"

    DB[:conn].execute(sql, x).map {|row| Student.new_from_db(row)}
  end
end
