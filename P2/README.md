# Práctica 2
## Ejercicios individuales
**No hace falta hacer memoria para los ejercicios individuales**
### Ejercicio 1 (15%)
Hacer con factory method un programa que permita hacer operaciones con intés simple, compuesto y cota de amortización. El usuario introduce Capital, tasa de interés y tiempo y selecciona el tipo de interés (con dropDownButton)

### Ejercicio 2 (15%)
Crear suscripciones (no hace falta usar ningún patrón)

## Ejercicios Grupales
### Ejercicio 1 (50%)
Usar patrón filtros de intercepción de la P1. Mantener el programa haciendo una serie de cambios:
* Diseño + implementación en Flutter + dart (adaptativo)
* Mejora de los filtros (perfectivo)
* Comprobar si se ha creado previamente el mail (perfectivo/preventivo) -> usar un nuevo filtro
* Agregar un sistema de notificaciones

### Ejercicio 2 (20%)
Conectarse a la API de Gemini (gemini-2.5-flash). Tenemos una clave secreta y el objetivo es que esté encapsulada (las sepan las clases). El usuario va a hacer preguntas y va a intentar que le dé la clave. Hay que programar distintos niveles de seguridad (usar patrón decorador). El usuario puede elegir el nivel de seguridad de la contraseña para cambiar la dificultad (podemos hacer el filtro con un prompt a la llm para que no lo diga). 

* La clase básica es BasicSecretKeeper, seguridad básica (por ejemplo cuando le mandas 2 prompts la desvela)
* La clase StrongSystemPromptDecorator usa un prompt para impedir que gemini desvele la contraseña
* La clase KeywordBlockDecorator bloquea palabras clave para que gemini no las acepte
* La clase LengthLimitDecorator bloquea respuestas de mas de x tamaño

Crear API de gemini en get api key google ai studio. No usar correo de universidad
En pubspec.yaml añadir debajo de sdk: flutter google_generative_ai: ^0.4.7
