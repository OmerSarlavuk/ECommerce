from PIL import Image
import io
import base64
import re
import torch
import open_clip
import requests
import os
import json

base_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
config_path = os.path.join(base_dir, 'appsettings.json')

with open(config_path, 'r') as f:
    settings = json.load(f)

#-----------------SETTINGS_MODEL-------------------------
device = "cuda" if torch.cuda.is_available() else "cpu"
model_name = 'ViT-L-14'
pretrained_name = 'laion2b_s32b_b82k'
tokenizer = open_clip.get_tokenizer(model_name)
model, _, preprocess = open_clip.create_model_and_transforms(model_name, pretrained=pretrained_name)
model.eval().to(device)

# image embedding method
def get_clip_embedding_from_base64(image_input_str, isBase64=True):
    try:
        if isBase64:
            base64_data = re.sub('^data:image/.+;base64,', '', image_input_str)
            image_bytes = base64.b64decode(base64_data)
            image = Image.open(io.BytesIO(image_bytes)).convert("RGB")
        else:
            base_url = settings['products']['image_base_url']#"https://cdn.dsmcdn.com"
            image_url = f"{base_url}{image_input_str}"
            response = requests.get(image_url)
            response.raise_for_status()
            image = Image.open(io.BytesIO(response.content)).convert("RGB")

        image_input = preprocess(image).unsqueeze(0).to(device)

        with torch.no_grad():
            image_features = model.encode_image(image_input)
            image_features /= image_features.norm(dim=-1, keepdim=True)

        return image_features.squeeze().cpu().numpy().tolist()

    except Exception as e:
        print(f"Hata: Görsel işlenemedi. Sebep: {e}")
        return None

# text embedding method
def get_text_embedding(text):
    with torch.no_grad():
        tokens = tokenizer([text]).to(device)
        text_features = model.encode_text(tokens)
        text_features /= text_features.norm(dim=-1, keepdim=True)
    return text_features.squeeze().cpu().numpy().tolist()