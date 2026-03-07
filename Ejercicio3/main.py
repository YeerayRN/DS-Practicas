from ClaseContexto import EstrategiaContexto
import csv
from ClaseSelenium import StrategySelenium
from ClaseBeautifulSoup import StrategyBeautifulSoup

def generarCSV(resultado, scraper):
    if isinstance(scraper.estrategia, StrategyBeautifulSoup):
        archivo = "equiposBS.csv"
    
    if isinstance(scraper.estrategia, StrategySelenium):
        archivo = "equiposSelenium.csv"

    with open(archivo, mode='w', newline='', encoding='utf-8') as file:
        writer = csv.writer(file)
        for i in range(0, len(resultado), 9):
            writer.writerow(resultado[i:i+9])


if __name__ == "__main__":
    print("Ejercicio 3: Scraping Web\nSeleccione una opción:")
    print("1. Scraping con BeautifulSoup")
    print("2. Scraping con Selenium")

    opcion = input("Ingrese el número de la opción deseada: ").strip()

    numPages = input("Ingrese el número de páginas a scrappear: ")

    if opcion == "1":
        scraper = EstrategiaContexto(StrategyBeautifulSoup())
    elif opcion == "2":
        scraper = EstrategiaContexto(StrategySelenium())
    else:        
        print("Opción no válida. Por favor, seleccione 1 o 2.")
        exit(1)

    resultado = scraper.ejecutar_estrategia(int(numPages))
    generarCSV(resultado, scraper)