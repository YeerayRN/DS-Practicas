# Práctica 4
App con Backend (Ruby on Rails) y Frontend (FLutter)

## Necesidad de la práctica
Cuando se termina un programa, toda la información guardada durante la ejecución se pierde. Para que los datos se mantengan al cerrar la aplicación se utiliza una API Restful de Ruby on Rails.

## Overview
Se debe hacer una aplicación que englobe todo lo visto en la asignatura hasta ahora
* Lista de requisitos
* Diseño de diagrama de clases
* 2 Patrones de diseño juntos (en el UML)
* Código
* Interfaz
* Pruebas unitarias de la lógica de negocio
* Pruebas unitarias de integración (para ver si funciona el get, post, update, delete...)
* No hace falta hacer memoria. Se presentará al profesor

Se utiliza Ruby on Rails para implementar una API Restful con operaciones CRUD. Necesitaremos crear el código necesario para que cuando ocurra una acción en flutter, se guarde en la BD con Ruby on Rails.
Se utilizará HTTP para comunicar Flutter con Ruby on Rails.
Ruby on Rails funciona con JSON. Hace falta adaptar el HTTP a JSON (Flutter->Ruby on Rails) y viceversa.  

## Backend
* Buscar en Prado tutorial P4 para descargar todo lo necesario para Ruby on Rails (adaptar el ejemplo al propio programa)
* Utilizar 4 operaciones para cada objeto de la base de datos (1 por cada operacion). Si tenemos tareas y pedidos, 4 operaciones CRUD poara las tareas y 4 para los pedidos...
* Se puede cambiar el puerto en puma.rb

## Frontend
* Debemos enviar datos con HTTP y recibirlos desde JSON
* Flutter se conecta a la url de la API
* La clase tarea tendrá un método toJSON() que convierte los datos de la tarea en formato JSON (return {'id': id, ...})
* La clase tarea también tendrá un método fromJSON() que convierte los datos JSON a datos de tarea (return Tarea (id: json['id'] as int?, ... ))
* Se consiguen datos del servidor haciendo json.decode(response.body). Se obtienen en JSON 
* Luego se pasan de JSON a objeto (Tarea) con el método fromJSON()
