from LLM import LLM
class Decorator(LLM):
    def __init__(self):
        super().__init__(self, wrappedllm: LLM)
        self.wrappedllm = wrappedllm
    def generate_summary(self, text: str):
        return self.wrappedllm.generate_summary(text)

class TranslationDecorator(Decorator):
    def __init__(self, wrappedllm: LLM, model_translation: str):
        super().__init__(self, wrappedllm)
        self.model_translation = model_translation
    def generate_summary(self, text: str):
        result = super().generate_summary(text)
        return f"Translation of '{result}' using model {self.model_translation}"
    
class SentimentDecorator(Decorator):
    def __init__(self, wrappedllm : LLM, model_sentiment: str):
        super().__init__(self,wrappedllm)
        self.model_sentiment = model_sentiment
    def generate_summary(self, text: str):
        result = super().generate_summary(text)
        return f"Sentiment analysis of '{result}' using model {self.model_sentiment}"