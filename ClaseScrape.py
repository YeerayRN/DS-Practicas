from abc import ABC, abstractmethod

class Scrape(ABC):
    @abstractmethod
    def scrape(self):
        pass