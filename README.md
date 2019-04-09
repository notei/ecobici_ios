## Aplicación en Swift para Ecobici

# Alberto Farías

# Descripción
La aplicación se conecta al servicio de open data de ecobici, cuenta con la pantalla de consulta de estaciones a modo de lista, donde es posible filtrar por el nombre de la estación, en el listado muestra el nombre de la estacio la cantidad de bicicletas y estaciones disponbles.

Al seleccionar una estación muestra el detalle de la estación así como un mapa con los pines de las estaciones cercanas, al seleccionar un pin mostrará el detalle de la estación correspondiente.


# Notas para la instalación
La aplicación utiliza el API de ecobici, para poder aceder a él se requiere indicar las credenciales CLIENT_ID y CLIENT_SECRET, en el archivo AppConstantes.

Adicionalmente se requiere indicar las credenciales para visualización del mapa de google en el archivo AppDelegate, en el método didFinishLaunchingWithOptions.

Por ultimo hay que ejecutar el comando de pod install, para actualizar las librerias.



