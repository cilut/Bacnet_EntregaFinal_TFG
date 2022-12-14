#  BacnetWeb 

FROM ubuntu:latest
MAINTAINER Ciprian Ilut "ciutp@gmail.com"

#
# Instalacion:
#		- SSH 		
#		- postgreSQL server
#		- librerías Python
#		- Nginx
#		- Gunicorn
#

RUN apt-get update && apt-get install -y --no-install-recommends \
	openssh-server --yes

#Configuración ssh 
RUN {\
	echo 'root:root' | chpasswd; \
    echo "PermitRootLogin yes" >> /etc/ssh/sshd_config; \
	echo "10.0.0.5   avoid_error" >> /etc/hosts; \
	}

#Configuracion postgreSQL server
ENV TZ=Europe/Madrid
ADD db_tfg.tar.gz /
RUN {\
	ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone;\
	apt-get install -y --no-install-recommends postgresql postgresql-contrib;\
	service postgresql restart;\
	}

#Ins librerías Python

RUN {\
	apt-get install python3-pip -y;\
	apt install libpq-dev python3-dev -y;\
	pip3 install psycopg2-binary;\
	
}
ADD BacnetWeb.tar.gz /
RUN pip3 install -r /BacnetWeb/requirements.txt;

#Configuración de Nginx
RUN {\
	apt-get install nginx -y ;\
	rm /etc/nginx/sites-enabled/default;\
	}

ADD bacnetweb /etc/nginx/sites-enabled/



#Configuración de Gunicorn 
RUN pip3 install gunicorn; 
ADD bacnetweb.service /etc/systemd/system/
RUN apt-get install systemctl -y;


RUN {\
	systemctl daemon-reload;\
	systemctl enable bacnetweb;\
}

RUN PATH="$PATH:docker-entrypoint.sh"
COPY docker-entrypoint.sh /
RUN chmod +x docker-entrypoint.sh
ENTRYPOINT ["./docker-entrypoint.sh"]

