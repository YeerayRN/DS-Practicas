from ClaseScrape import Scrape

class EstrategiaContexto:
    def __init__(self, estrategia: Scrape):
        self.estrategia = estrategia

    def ejecutar_estrategia(self, numPages):
        return self.estrategia.scrape(numPages)