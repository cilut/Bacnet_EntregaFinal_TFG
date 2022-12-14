#!/bin/bash

service ssh start
service nginx start
service postgresql start
systemctl start bacnetweb 
 


if runuser -l postgres -c "echo \"\du\" | psql -t|cut -d \| -f 1 |grep -qw tfg"; then 
	# Usuario root creado pasamos a comprobar si esta la DB
	echo "Usuario existe."
else 
	runuser -l postgres -c "echo \"CREATE USER tfg PASSWORD 'tfg';\" |psql " &> /dev/null;
	echo "Usuario creado satisfactoriamente.";
fi

if runuser -l postgres -c "psql -lqt | cut -d \| -f 1 | grep -qw tfg"; then
    # DB existe no  creaemos otra
    echo "Base de datos existe."
else
    
	runuser -l postgres -c "echo \"CREATE DATABASE tfg;\" |psql" &> /dev/null;
	runuser -l postgres -c "echo \"GRANT ALL PRIVILEGES ON DATABASE tfg to tfg;\" |psql " &> /dev/null;
	psql postgres://tfg:tfg@localhost:5432/tfg < /db_tfg.tar &> /dev/null;
	echo "INSERT INTO users (usr, password, email, admin) VALUES ('root', 'root', 'CORREO_A_MODIFICAR.com', 't');" | psql postgres://tfg:tfg@localhost:5432/tfg &> /dev/null;
	echo "Base de datos y permisos asignados satisfactoriamente.";
fi


#Comprobacion existencia https://stackoverflow.com/questions/14549270/check-if-database-exists-in-postgresql-using-shell
/bin/bash
