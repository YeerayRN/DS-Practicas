# DS-Practicas
**Grupo de Pablo De la Torre Roldán, Beatriz Ruz Gómez y Yeray Rodríguez Navas**

[**HACER MEMORIA EN LATEX**](https://prism.openai.com/?u=28601317-80e9-4603-961a-25cd74cbfabc&pg=1&m=main.tex)

* Título en la primera página con los integrantes del grupo
* Índice en la segunda página
* Luego cada ejercicio

## Práctica 1
### Ejercicio 1
Programar una simulación de partidas multijugador multihebra que tengan el mismo número inicial N de jugadores implementada en Java. N no se conocerá hasta que comience la partida.
* En las partidas competitivas el 20% de los jugadores abandona la partida
* En las partidas casuales el 10% de los jugadores se desconectan
* El tiempo de cada partida son 60 segundos
* Todos los abandonos de los jugadores se producen al mismo tiempo  

Para la parte multihebra: utilizar implements runnable o extends threads (usando interfaz runnable o heredando de threads)

**Se pueden agrupar las clases en 3 ficheros según sus funcionalidades**

La clase padre factoría es FactoriaPartidaYJugador con los métodos crearPartida y crearJugador. Heredan de ella:
* FactoriaCompetitiva
* FactoriaCasual

Los productos (heredan de Jugador y Partida - clases abstractas o interfaces):
* JugadorCompetitivo
* JugadorCasual
* PartidaCompetitiva
* ParticaCasual


### Ejercicio 2
Hacer un programa en Python que use una API de [Hugging Face](https://huggingface.co/) para hablar con LLMs. Implementarlo con el patrón decorador. 

Se debe configurar el programa con un archivo JSON en e que se especifica los parámetros:
* texto: texto de entrada original a resumir (en inglés)
* model_llm: modelo de LLM que se va a usar para la generación del resumen
* model_translation: modelo de LLM que va a implementar la traducción
* model_sentiment: modelo de LLM que va a implementar el análisis de sentimientos
* huggingface_api_token: token de la API de huggingface

Utilizar los modelos de generación de texto:
* facebook/bart-large-cm
* Hellsinki-NLP/opus-mt-en-es
* nlptown/bert-base-multilingual-uncased-sentiment

Para el token de huggingface primero crear una cuenta y luego crearse un nuevo token (marcar las 3 casillas de inference). Documentación de hugging face en api_reference.

------ Hacer Diagrama de VParadigm --------
Primero hay una clase interfaz (LLM) con el método generate_summary que será implementado por BasicLLM y la clase decorador.
La base del patrón decorador es el resumen (clase BasicLLM). Las demás funcionalidades son la traducción (TranslationDecorator), el modelo de sentimientos (SentimentDecorator) y cualquier otra que se quiera implementar. Tanto TranslationDecorator como SentimentDecorator son hijas de Decorator.
 Las demás funcionalidades son la traducción

### Ejercicio 3
Queremos scrappear una [página web](https://www.scrapethissite.com/pages/forms/) con las librerías BeautifulSoup y/o Selenium para extraer un .csv. Usaremos el patrón Strategy

*  BeautifulSoup funciona para páginas que no cambian dinámicamente [documentación BeautifulSoup](https://www.crummy.com/software/BeautifulSoup/bs4/doc/)
*  Selenium funciona para páginas que cambian dinámicamente (por ejemplo que ejecutan scripts js) [documentación Selenium pagina oficial](https://www.selenium.dev/documentation/) [documentación selenium python](https://selenium-python.readthedocs.io/)

------ Hacer Diagrama de VParadigm --------

Clase abstracta/interface: Scrapper <- Hijas: ScrapperBeautifulSoup y ScrapperSelenium.
Clase Contexto que es una agregación de la clase Scrapper padre 

Usar un fichero de python separado para cada clase


### Ejercicio 4


### Ejercicio 5
