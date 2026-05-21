import os
import re
import logging
from dotenv import load_dotenv
from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import HTMLResponse
from pydantic import BaseModel
from google import genai
from google.genai import types

# =========================================================
# CONFIGURATION DU JOURNAL DE LOGS (LOGGING)
# =========================================================
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger("ComChillAPI")

# Chargement des variables d'environnement depuis le fichier .env
load_dotenv()

# =========================================================
# CONFIGURATION DE L'APPLICATION FASTAPI
# =========================================================
app = FastAPI(
    title="ComChill AI API", 
    version="1.2.0",
    description="API pour le chatbot ComChill avec gestion de tolérance aux pannes sur 5 clés API."
)

# Configuration du Middleware CORS pour autoriser l'interface web à communiquer avec l'API
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"], 
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# =========================================================
# CONSIGNES SYSTÈME ET RECRUTEMENT DES CLÉS API
# =========================================================
consigne_systeme = """
Tu es ComChill, un assistant IA intelligent, amical et professionnel.
Réponds de manière fluide, naturelle et chaleureuse pour aider au mieux l'utilisateur.

Tu devez IMPÉRATIVEMENT ajouter à la toute fin de ta réponse, sur une nouvelle ligne exacte, la mention suivante :
[SENTIMENT: Positif] ou [SENTIMENT: Négatif] ou [SENTIMENT: Neutre] en fonction de la tonalité émotionnelle du dernier message reçu.
"""

# Récupération et filtrage des clés valides présentes dans le fichier .env
LISTE_CLES = []
for i in range(1, 6):
    cle = os.getenv(f"GEMINI_API_KEY_{i}")
    if cle:
        LISTE_CLES.append(cle)

# Vérification de sécurité critique au démarrage
if not LISTE_CLES:
    raise ValueError(
        "Erreur critique : Aucune clé API valide (GEMINI_API_KEY_1 à GEMINI_API_KEY_5) "
        "n'a été trouvée dans votre fichier .env.\n"
        "Veuillez vérifier l'emplacement de votre fichier .env ou son contenu."
    )

logger.info(f"🔑 {len(LISTE_CLES)} clé(s) API Gemini détectée(s) et prête(s) pour le pool de secours.")

# =========================================================
# GESTION DES CHATS ET PERSISTANCE DES CLIENTS (POOL DE CHATS)
# =========================================================
# Dictionnaire pour stocker les sessions de chat de chaque utilisateur de manière isolée
dictionnaire_chats = {}

def creer_pool_chats_pour_session():
    """
    Initialise à l'avance les clients et instances de chat pour chacune des 5 clés.
    Cela évite la fermeture précoce des connexions par le SDK google-genai.
    """
    pool = {}
    for index, cle_api in enumerate(LISTE_CLES):
        try:
            # Création du client persistant lié à la clé spécifique
            client_instance = genai.Client(api_key=cle_api)
            # Création de l'objet chat persistant
            pool[index] = client_instance.chats.create(
                model="gemini-2.5-flash",
                config=types.GenerateContentConfig(system_instruction=consigne_systeme)
            )
        except Exception as e:
            logger.error(f"❌ Impossible de pré-initialiser le client pour la clé API {index + 1}: {str(e)}")
    return pool

# Modèle de données pour la validation des requêtes entrantes (Pydantic)
class MessageInput(BaseModel):
    session_id: str
    message: str

# =========================================================
# INTERFACE GRAPHIQUE INTÉGRÉE (COMMUNICATION PORT 8080)
# =========================================================
html_content = """
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ComChill AI - Assistant intelligent</title>
    <style>
        * { box-sizing: border-box; }
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #f4f6f9; margin: 0; padding: 0; }
        .header { background-color: #e65c2e; color: white; text-align: center; padding: 18px; font-size: 24px; font-weight: bold; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        .chat-container { max-width: 850px; margin: 30px auto; background: white; border-radius: 12px; box-shadow: 0 4px 20px rgba(0,0,0,0.08); display: flex; flex-direction: column; height: 75vh; overflow: hidden; }
        .messages { flex: 1; padding: 25px; overflow-y: auto; display: flex; flex-direction: column; gap: 14px; background-color: #fafbfc; }
        .message { padding: 14px 18px; border-radius: 20px; max-width: 75%; line-height: 1.5; font-size: 15px; word-wrap: break-word; }
        .bot { background-color: #f0f2f5; color: #1c1e21; align-self: flex-start; border-top-left-radius: 3px; white-space: pre-wrap; }
        .user { background-color: #e65c2e; color: white; align-self: flex-end; border-top-right-radius: 3px; }
        .sentiment-badge { display: inline-block; margin-top: 8px; font-size: 11px; font-weight: bold; padding: 4px 10px; border-radius: 12px; text-transform: uppercase; letter-spacing: 0.5px; }
        .badge-positif { background-color: #e6f4ea; color: #137333; }
        .badge-negatif { background-color: #fce8e6; color: #c5221f; }
        .badge-neutre { background-color: #f1f3f4; color: #5f6368; }
        .input-area { padding: 20px; border-top: 1px solid #e4e6eb; display: flex; gap: 12px; background: white; }
        input { flex: 1; padding: 14px 20px; border: 1px solid #ccd0d5; border-radius: 28px; font-size: 15px; outline: none; transition: border 0.2s; }
        input:focus { border-color: #e65c2e; }
        button { background-color: #e65c2e; color: white; border: none; padding: 14px 28px; border-radius: 28px; font-size: 15px; font-weight: bold; cursor: pointer; transition: background 0.2s; }
        button:hover { background-color: #d14d22; }
        button:disabled { background-color: #ccd0d5; cursor: not-allowed; }
    </style>
</head>
<body>
    <div class="header">ComChill AI — Interface de Test</div>
    <div class="chat-container">
        <div class="messages" id="chat-messages">
            <div class="message bot">Bonjour ! Je suis l'assistant ComChill. Comment puis-je vous aider aujourd'hui ?</div>
        </div>
        <div class="input-area">
            <input type="text" id="user-input" placeholder="Écrivez votre message ici..." onkeypress="if(event.key === 'Enter') sendMessage()">
            <button id="send-btn" onclick="sendMessage()">Envoyer</button>
        </div>
    </div>

    <script>
        const sessionId = "session_" + Math.random().toString(36).slice(2, 9);
        
        async function sendMessage() {
            const inputField = document.getElementById('user-input');
            const sendBtn = document.getElementById('send-btn');
            const messageText = inputField.value.trim();
            
            if (!messageText) return;

            inputField.disabled = true;
            sendBtn.disabled = true;
            appendMessage(messageText, 'user');
            inputField.value = '';

            try {
                // Configuration ciblée sur le port local 8080
                const response = await fetch('http://127.0.0.1:8080/chat', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({ session_id: sessionId, message: messageText })
                });

                if (!response.ok) throw new Error("Erreur réseau");

                const data = await response.json();
                appendBotResponse(data.response, data.sentiment);
            } catch (error) {
                appendMessage("⚠️ Une erreur est survenue lors de la communication avec le serveur local. Assurez-vous que le serveur tourne sur le port 8080.", 'bot');
            } finally {
                inputField.disabled = false;
                sendBtn.disabled = false;
                inputField.focus();
            }
        }

        function appendMessage(text, sender) {
            const container = document.getElementById('chat-messages');
            const msgDiv = document.createElement('div');
            msgDiv.className = 'message ' + sender;
            msgDiv.textContent = text;
            container.appendChild(msgDiv);
            container.scrollTop = container.scrollHeight;
        }

        function appendBotResponse(text, sentiment) {
            const container = document.getElementById('chat-messages');
            const wrapperDiv = document.createElement('div');
            wrapperDiv.style.display = 'flex';
            wrapperDiv.style.flexDirection = 'column';
            wrapperDiv.style.alignItems = 'flex-start';
            wrapperDiv.style.gap = '2px';
            
            const msgDiv = document.createElement('div');
            msgDiv.className = 'message bot';
            msgDiv.textContent = text;
            wrapperDiv.appendChild(msgDiv);
            
            if (sentiment) {
                const badge = document.createElement('span');
                const cleanSentiment = sentiment.toLowerCase().trim();
                badge.className = 'sentiment-badge badge-' + cleanSentiment;
                badge.textContent = '💡 HUMEUR DÉDUITE : ' + sentiment.toUpperCase();
                wrapperDiv.appendChild(badge);
            }
            
            container.appendChild(wrapperDiv);
            container.scrollTop = container.scrollHeight;
        }
    </script>
</body>
</html>
"""

@app.get("/", response_class=HTMLResponse)
async def home():
    return html_content

# =========================================================
# ROUTE API PRINCIPALE AVEC TOLÉRANCE AUX PANNES ET ROTATION
# =========================================================
@app.post("/chat")
async def discuter(data: MessageInput):
    # 1. Vérification ou création de la session utilisateur avec son pool de chats persistants
    if data.session_id not in dictionnaire_chats:
        dictionnaire_chats[data.session_id] = {
            "index_cle_actuelle": 0,
            "pool_chats": creer_pool_chats_pour_session()
        }
    
    session = dictionnaire_chats[data.session_id]
    nombre_de_cles = len(LISTE_CLES)
    
    # 2. Boucle d'essais sur les clés disponibles (Tolérance maximale aux pannes)
    for tentative in range(nombre_de_cles):
        index_actuel = session["index_cle_actuelle"]
        
        if index_actuel not in session["pool_chats"]:
            session["index_cle_actuelle"] = (index_actuel + 1) % nombre_de_cles
            continue
            
        try:
            # Récupération du chat ouvert persistant
            chat = session["pool_chats"][index_actuel]
            response = chat.send_message(data.message)
            texte_final = response.text if response.text else ""

            # 3. Extraction de l'analyse de sentiment (Regex)
            match = re.search(r"SENTIMENT:\s*(\w+)", texte_final, re.IGNORECASE)
            sentiment = "neutre"

            if match:
                sentiment_brut = match.group(1).lower()
                if "pos" in sentiment_brut:
                    sentiment = "positif"
                elif "nég" in sentiment_brut or "neg" in sentiment_brut:
                    sentiment = "negatif"
                
                texte_final = re.sub(r"\[?SENTIMENT:.*?\]?", "", texte_final, flags=re.IGNORECASE).strip()

            return {
                "response": texte_final,
                "sentiment": sentiment
            }

        except Exception as e:
            logger.warning(f"⚠️ Échec d'appel avec la clé API {index_actuel + 1}. Erreur rencontrée : {str(e)}")
            
            # Calcul circulaire pour passer à la clé suivante
            prochain_index = (index_actuel + 1) % nombre_de_cles
            session["index_cle_actuelle"] = prochain_index
            
            logger.info(f"🔄 Basculement automatique transparent vers la clé API {prochain_index + 1}...")
            
    return {
        "response": "Désolé, toutes nos lignes de serveurs sont actuellement surchargées. Veuillez réenvoyer votre message dans quelques secondes.",
        "sentiment": "neutre"
    }