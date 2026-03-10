import json
from BasicLLM import BasicLLM
from Decorator import TranslationDecorator, SentimentDecorator

if name == "__main__":
    with open("configuracion.json", "r") as file:
        config = json.load(file)

    texto = config["texto"]
    
    model_llm = config["model_llm"]
    model_translation = config["model_translation"]
    model_sentiment = config["model_sentiment"]

    llm = BasicLLM(model_llm, "token123")
    resultado1 = llm.generate_summary(texto)
    print(resultado1)

    traduccion = TranslationDecorator(model_translation)
    resultado2 = traduccion.decorate(texto)
    print(resultado2)

    sentimiento = SentimentDecorator(model_sentiment)
    resultado3 = sentimiento.decorate(texto)
    print(resultado3)

    resultado4 = sentimiento.decorate(traduccion.decorate(llm.generate_summary(texto)))
    print(resultado4)

    
    