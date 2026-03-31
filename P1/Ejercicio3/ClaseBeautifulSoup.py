from ClaseScrape import Scrape
from bs4 import BeautifulSoup
from requests import get

class StrategyBeautifulSoup(Scrape):
    
    def sacar_html(self, url):        
        respuesta = get(url)

        if respuesta.status_code == 200:
            return respuesta.text 
        else:
            print("Error al sacar HTML")
            return None
    
    def scrape(self, numPages):
        datos = []
        
        for i in range(1, numPages+1):
            html = self.sacar_html("https://www.scrapethissite.com/pages/forms/?page_num=" + str(i))
            bs = BeautifulSoup(html, "html.parser")

            for fila in bs.find_all("tr"):
                if(i == 1):
                    for columna in fila.find_all("th"):
                        datos.append(columna.text.strip())

                for columna in fila.find_all("td"):
                    datos.append(columna.text.strip())

        return datos ##Completar según documentación oficial de BeautifulSoup
