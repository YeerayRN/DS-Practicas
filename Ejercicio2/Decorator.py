from LLM import LLM, query_api

class Decorator(LLM):
    def __init__(self,wrappedllm):
        self.wrappedllm = wrappedllm

    def generate_summary(self, text: str):
        return self.wrappedllm.generate_summary(text)

class TranslationDecorator(Decorator):
    def __init__(self, wrappedllm: LLM, model_translation: str, token: str):
        super().__init__(wrappedllm)
        self.model_translation = model_translation
        self.token = token

    def generate_summary(self, text: str):
        result = super().generate_summary(text)

        if(result.startswith("Error:")):
            return result
        
        print(f"Traduciendo usando el modelo {self.model_translation}\n")
        payload = {"inputs": result}
        final_result = query_api(payload, self.model_translation, self.token)

        if(isinstance(final_result, dict) and "error" in final_result):
            return f"Error: {final_result['error']}"
        
        return final_result[0]['translation_text']
    
class SentimentDecorator(Decorator):
    def __init__(self, wrappedllm : LLM, model_sentiment: str, token: str):
        super().__init__(wrappedllm)
        self.model_sentiment = model_sentiment
        self.token = token

    def generate_summary(self, text: str):
        result = super().generate_summary(text)

        if(result.startswith("Error:\n")):
            return result
        
        print(f"Generando analisis de sentimientos con el modelo {self.model_sentiment}\n")

        payload = {"inputs": result}
        final_result = query_api(payload, self.model_sentiment, self.token)

        if(isinstance(final_result, dict) and "error" in final_result):
            return f"Error: {final_result['error']}"
        
        return f"{result}\n[Sentimiento: {final_result[0][0]['label']}]\n"