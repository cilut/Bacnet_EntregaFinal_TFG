# Bacnet_EntregaFinal_TFG
- Modificar los ficheros:
	- docker-entrypoint.sh: para añadir el correo del usuario administrador 
	- Dockerfile: con la ip da nuestro servidor externo en la linea 22
	- bacnetweb.service: Añadir el usuario y la contraseña de nuestra cuenta que va a enviar los correos de 
recuperación
- Ejecutar debemos crear el container:
	- sudo docker build -t contenedor_bacnetweb .
	- sudo docker run -p 0.0.0.0:22:22 0.0.0.0:80:80 contenedor_bacnetweb -it docker_bacnetweb /bin/bash
