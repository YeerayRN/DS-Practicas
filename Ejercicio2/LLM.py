from abc import ABC , abstractmethod
import requests

def query_api(payload: dict, model: str, token: str):
    url = f"https://router.huggingface.co/hf-inference/models/{model}"
    headers = {"Authorization": f"Bearer {token}"}
    response = requests.post(url, headers=headers, json=payload)

    try:
        # Intentamos convertir la respuesta a JSON
        return response.json()
    except requests.exceptions.JSONDecodeError:
        # Si no es JSON (es decir, el servidor devolvió un HTML de error), lo capturamos
        mensaje_error = f"HTTP {response.status_code} - La API no devolvió un JSON válido. Respuesta cruda: {response.text[:150]}..."
        return {"error": mensaje_error}


class LLM(ABC):
    @abstractmethod
    def generate_summary(self, text: str) -> str:
        pass
