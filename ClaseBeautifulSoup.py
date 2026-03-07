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
        
    def scrape(self):
        html = self.sacar_html("https://www.scrapethissite.com/pages/forms/")
        bs = BeautifulSoup(html, "html.parser")

        equipos = bs.find_all("tr", class_="team").__str__()
        años = bs.find_all("td", class_="year")
        victorias = bs.find_all("td", class_="wins")
        derrotas = bs.find_all("td", class_="losses")
        overtime = bs.find_all("td", class_="overtime-losses")
        porcentajes = bs.find_all("td", class_="pct text-danger")
        golesfavor = bs.find_all("td", class_="gf")
        golescontra = bs.find_all("td", class_="ga")
        diferencia = bs.find_all("td", class_="diff text-danger")


        return equipos ##Completar según documentación oficial de BeautifulSoup
