require 'csv'
require 'sequel'

# database and models config

Sequel::Model.plugin :json_serializer

DB = Sequel.connect('postgres://localhost/local?user=root&password=123')

class Carrer < Sequel::Model(DB[:carrers])

end

class Teacher < Sequel::Model(DB[:teachers])

end

class TeacherCarrer < Sequel::Model(DB[:teachers_carrers])

end

# functions

def insert_carrers
  carrers = []
  CSV.foreach(
    'data/carrers.csv',
    quote_char: '"',
    col_sep: '|',
    row_sep: :auto,
    headers: true,
  ) do |row|
    t = Hash.new
    t[:id] = row['id']
    t[:name] = row['name']
    carrers.push(t)
  end
  DB.transaction do
    begin
      # inserts
      carrers.each do |carrer|
        puts carrer[:name]
        n = Carrer.new(
            :name => carrer[:name],
          )
        n.save
      end
    rescue Exception => e
      Sequel::Rollback
      puts e
    end
  end
end

def insert_teachers
  teachers = []
  CSV.foreach(
    'data/teachers.csv',
    quote_char: '"',
    col_sep: '|',
    row_sep: :auto,
    headers: true,
  ) do |row|
    t = Hash.new
    t[:id] = row['id']
    t[:names] = row['names']
    t[:last_names] = row['last_names']
    t[:img] = row['img']
    teachers.push(t)
  end
  DB.transaction do
    begin
      # inserts
      teachers.each do |teacher|
        n = Teacher.new(
          :names => teacher[:names],
          :last_names => teacher[:last_names],
          :img => teacher[:img],
        )
        n.save
      end
    rescue Exception => e
      Sequel::Rollback
      puts e
    end
  end
end

def insert_teachers_carrers
  teachers = []
  CSV.foreach(
    'data/teachers_carrers.csv',
    quote_char: '"',
    col_sep: '|',
    row_sep: :auto,
    headers: true,
  ) do |row|
    t = Hash.new
    t[:id] = row['id']
    t[:teacher_id] = row['teacher_id']
    t[:carrer_id] = row['carrer_id']
    teachers.push(t)
  end
  DB.transaction do
    begin
      # inserts
      teachers.each do |teacher|
        n = TeacherCarrer.new(
          :teacher_id => teacher[:teacher_id],
          :carrer_id => teacher[:carrer_id],
        )
        n.save
      end
    rescue Exception => e
      Sequel::Rollback
      puts e
    end
  end
end

# insert_teachers
# insert_carrers
insert_teachers_carrers
