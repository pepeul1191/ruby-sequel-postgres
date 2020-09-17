require 'sequel'
require 'sqlite3'

# database and models config

Sequel::Model.plugin :json_serializer

DB = Sequel.connect('sqlite://coa.db')

class Doctor < Sequel::Model(DB[:doctores])

end

class Sede < Sequel::Model(DB[:sedes])

end

class Director < Sequel::Model(DB[:directores])

end

def doctores
  doctores = Doctor.all.to_a
  res = ''
  for d in doctores
    s = '(%d, "%s", %d, %d, "assets/img/default-user.png")' % [
      d.id,
      d.paterno + ' ' + d.materno + ', ' +
      d.nombres,
      d.cop,
      d.rne
    ]
    # puts d.to_json
    # puts s
    res = res + s + ', '
  end
  file = File.open('doctores.txt', 'w')
  file.puts res
  file.close
end



def doctores_sedes
  doctores = Doctor.all.to_a
  res = ''
  for d in doctores
    s = '(%d, %d)' % [d.id, d.sede_id]
    # puts d.to_json
    # puts s
    res = res + s + ', '
  end
  file = File.open('doctores_sedes.txt', 'w')
  file.puts res
  file.close
end

def doctores_especialides
  doctores = Doctor.all.to_a
  res = ''
  for d in doctores
    s = '(%d, %d)' % [d.id, d.especialidad_id]
    # puts d.to_json
    # puts s
    res = res + s + ', '
  end
  file = File.open('doctores_especialides.txt', 'w')
  file.puts res
  file.close
end

def sedes_coa
  sedes = Sede.all.to_a
  res = ''
  for d in sedes
    director = Director.where(
      :sede_id => d.id
    ).first

    if director == nil
      doctor_id = 1
    else
      doctor_id = director.doctor_id
    end
    s = '(%d, "%s", "%s", "%s", "", "", "assets/img/default-branch.png", %d, %d, %d, %d,)' % [
      d.id,
      d.nombre,
      d.direccion,
      d.telefono,
      d.latitud,
      d.longitud,
      d.tipo_sede_id,
      doctor_id
    ]
    res = res + s + ', '
  end
  file = File.open('sedes.txt', 'w')
  file.puts res
  file.close
end

# doctores
# doctores_sedes
# doctores_especialides
sedes_coa
