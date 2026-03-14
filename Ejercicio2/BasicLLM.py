from LLM import LLM, query_api

class BasicLLM(LLM):
    def __init__(self, model, token):
        self.model = model
        self.token = token

    def generate_summary(self, text: str) -> str:
        print(f"Generating summary for '{text}' using model {self.model}")
        payload = {"inputs": text}
        response = query_api(payload, self.model, self.token)
        
        if("error" in response):
            return f"Error: {response['error']}"
        else:
            return response[0]['summary_text']