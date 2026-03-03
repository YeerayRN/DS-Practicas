from ClaseScrape import Scrape

if __name__ == "__main__":
    print("Ejercicio 3: Scraping Web\nSeleccione una opción:")
    print("1. Scraping con BeautifulSoup")
    print("2. Scraping con Selenium")

    opcion = input("Ingrese el número de la opción deseada: ")

    if opcion == "1":
        from ClaseBeautifulSoup import BeautifulSoup
        scraper = BeautifulSoup()
        resultado = scraper.scrape()
        print(resultado)
    elif opcion == "2":
        from ClaseSelenium import Selenium
        scraper = Selenium()
        resultado = scraper.scrape()
        print(resultado)
    else:        
        print("Opción no válida. Por favor, seleccione 1 o 2.")