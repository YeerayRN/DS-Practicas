import json
from BasicLLM import BasicLLM
from Decorator import TranslationDecorator, SentimentDecorator

if __name__ == "__main__":
    with open("configuracion.json", "r") as file:
        config = json.load(file)

    texto = config["texto"]

    print(f"===========Texto Original===========\n{texto}")    
    model_llm = config["model_llm"]
    model_translation = config["model_translation"]
    model_sentiment = config["model_sentiment"]
    token = config["huggingface_api_token"]

    print(f"\n===========LLM Básico===========\n")
    llm = BasicLLM(model_llm, token)
    resultado1 = llm.generate_summary(texto)
    print(resultado1)

    print(f"\n===========LLM con Decorator de Traducción===========\n")
    traduccion = TranslationDecorator(llm, model_translation, token)
    resultado2 = traduccion.generate_summary(texto)
    print(resultado2)

    print(f"\n===========LLM con Decorator de Sentimiento===========\n")
    sentimiento = SentimentDecorator(llm, model_sentiment, token)
    resultado3 = sentimiento.generate_summary(texto)
    print(resultado3)

    print(f"\n===========LLM con Decorator de Traducción y Sentimiento===========\n")
    resultado4 = SentimentDecorator(TranslationDecorator(llm, model_translation, token), model_sentiment, token).generate_summary(texto)
    print(resultado4)

    
    