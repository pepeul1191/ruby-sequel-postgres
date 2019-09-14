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

insert_carrers
