# DS-Practicas
**Grupo de Pablo De la Torre Roldán, Beatriz Ruz Gómez y Yeray Rodríguez Navas**

**HACER MEMORIA EN LATEX** -> [overleaf](https://es.overleaf.com/) (usar main.tex > Some examples to get started > How to include figures) Solamente pueden editar 2 simultáneamente.
                           -> [prism](https://prism.openai.com/) Parece que pueden editar 3 simultáneamente y con chatgpt integrado dentro.

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
Hacer un programa en Python que use una API de [Hugging Face](https://huggingface.co/) para hablar con LLMs

### Ejercicio 3
Queremos scrappear una [página web](https://www.scrapethissite.com/pages/forms/) con las librerías BeautifulSoup y/o Selenium para extraer un .csv. Usaremos el patrón Strategy ()

*  BeautifulSoup funciona para páginas que no cambian dinámicamente [documentación BeautifulSoup](https://www.crummy.com/software/BeautifulSoup/bs4/doc/)
*  Selenium funciona para páginas que cambian dinámicamente (por ejemplo que ejecutan scripts js) [documentación Selenium pagina oficial](https://www.selenium.dev/documentation/) [documentación selenium python](https://selenium-python.readthedocs.io/)

------ Hacer Diagrama de VParadigm --------

Clase abstracta/interface: Scrapper <- Hijas: ScrapperBeautifulSoup y ScrapperSelenium.
Clase Contexto que es una agregación de la clase Scrapper padre 

Usar un fichero de python separado para cada clase
### Ejercicio 4
### Ejercicio 5
