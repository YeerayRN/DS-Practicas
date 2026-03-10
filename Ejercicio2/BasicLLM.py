from LLM import LLM

class BasicLLM(LLM):
    def __init__(model,token):
        self.model = model
        self.token = token

    def generate_summary(self, text: str):
        

        return f"Summary of '{text}' using model {self.model} with token {self.token}"