from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.chrome.options import Options
from webdriver_manager.chrome import ChromeDriverManager
from selenium.common.exceptions import WebDriverException
from ClaseScrape import Scrape

class StrategySelenium(Scrape):
    def scrape(self, numPages):
        datos = []
        

        print("Driver funcionando correctamente")

        for i in range(1, numPages+1):
            driver.get("https://www.scrapethissite.com/pages/forms/?page_num=" + str(i))

            for fila in driver.find_elements(By.TAG_NAME, value="tr"):
                if(i == 1):
                    for columna in fila.find_elements(By.TAG_NAME, value="th"):
                        datos.append(columna.text)

                for columna in fila.find_elements(By.TAG_NAME, value="td"):
                    datos.append(columna.text)
        driver.quit()

        return datos
