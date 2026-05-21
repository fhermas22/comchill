import os
import re
import logging
from dotenv import load_dotenv
from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from google import genai
from google.genai import types

# Configuration des logs
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger("ComChillAPI")

load_dotenv()

app = FastAPI(
    title="ComChill AI - Core API", 
    version="1.3.0",
    description="Moteur API pur avec tolérance aux pannes et rotation automatique."
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Chargement dynamique des clés disponibles dans le .env
LISTE_CLES = [os.getenv(f"GEMINI_API_KEY_{i}") for i in range(1, 6) if os.getenv(f"GEMINI_API_KEY_{i}")]

if not LISTE_CLES:
    raise ValueError("Erreur : Aucune clé API trouvée dans le fichier .env")

logger.info(f"🔑 Pool initialisé avec {len(LISTE_CLES)} clé(s) API.")

# Dictionnaire pour mémoriser l'index de la clé par session utilisateur
session_key_index = {}

class MessageInput(BaseModel):
    session_id: str
    message: str

@app.post("/chat")
async def discuter(data: MessageInput):
    # Initialiser l'index de clé pour cette session si inexistante
    if data.session_id not in session_key_index:
        session_key_index[data.session_id] = 0
        
    nombre_de_cles = len(LISTE_CLES)
    
    # Tentative d'appel avec mécanisme de secours (failover)
    for _ in range(nombre_de_cles):
        index_actuel = session_key_index[data.session_id]
        cle_active = LISTE_CLES[index_actuel]
        
        try:
            # On instancie un client frais à chaque requête pour éliminer le bug "client closed"
            client = genai.Client(api_key=cle_active)
            
            consigne_systeme = (
                "Tu es ComChill, un assistant intelligent. Réponds de manière fluide. "
                "Ajoute obligatoirement à la fin : [SENTIMENT: Positif], [SENTIMENT: Négatif] ou [SENTIMENT: Neutre]"
            )
            
            response = client.models.generate_content(
                model="gemini-2.5-flash",
                contents=data.message,
                config=types.GenerateContentConfig(system_instruction=consigne_systeme)
            )
            
            texte_brut = response.text if response.text else ""
            
            # Extraction du sentiment
            match = re.search(r"SENTIMENT:\s*(\w+)", texte_brut, re.IGNORECASE)
            sentiment = "neutre"
            if match:
                sentiment_brut = match.group(1).lower()
                if "pos" in sentiment_brut:
                    sentiment = "positif"
                elif "nég" in sentiment_brut or "neg" in sentiment_brut:
                    sentiment = "negatif"
            
            # Nettoyage du texte renvoyé
            texte_nettoye = re.sub(r"\[?SENTIMENT:.*?\]?", "", texte_brut, flags=re.IGNORECASE).strip()
            
            return {
                "response": texte_nettoye,
                "sentiment": sentiment
            }
            
        except Exception as e:
            logger.warning(f"⚠️ Échec avec la clé {index_actuel + 1}. Erreur: {str(e)}")
            # Rotation circulaire de la clé en cas d'échec
            prochain_index = (index_actuel + 1) % nombre_de_cles
            session_key_index[data.session_id] = prochain_index
            logger.info(f"🔄 Basculement automatique vers la clé API {prochain_index + 1}...")
            
    return {
        "response": "Désolé, toutes nos lignes de serveurs sont actuellement surchargées. Veuillez réessayer dans quelques instants.",
        "sentiment": "neutre"
    }