class EstrategiaContexto:
    def __init__(self, estrategia: Scrape):
        self.estrategia = estrategia

    def ejecutar_estrategia(self):
        return self.estrategia.scrape()