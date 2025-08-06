import open_clip
import torch
from PIL import Image
import requests
import io
import pymssql
import numpy as np
import json
import time
from tqdm import tqdm

with open('appsettings.json', 'r') as f:
    settings = json.load(f)

DB_SERVER = settings['database']['server']
DB_PORT = settings['database']['port']
DB_USER = settings['database']['user']
DB_PASSWORD = settings['database']['password']
DB_NAME = settings['database']['db_name']
IMAGE_BASE_URL = settings['products']['image_base_url']

device = "cuda" if torch.cuda.is_available() else "cpu"
model, _, preprocess = open_clip.create_model_and_transforms(
    'ViT-L-14',
    pretrained='laion2b_s32b_b82k'
)
model.eval().to(device)

def get_image_embedding(image_url):
    try:
        response = requests.get(image_url, timeout=10)
        response.raise_for_status()

        image = Image.open(io.BytesIO(response.content)).convert("RGB")
        image_input = preprocess(image).unsqueeze(0).to(device)

        with torch.no_grad():
            features = model.encode_image(image_input)
            features /= features.norm(dim=-1, keepdim=True)

        return features.squeeze().cpu().numpy().tolist()
    except Exception as e:
        print(f"[HATA] {image_url} işlenemedi → {e}")
        return None

def create_and_save_embeddings():
    product_embeddings = {}

    conn = pymssql.connect(DB_SERVER, DB_USER, DB_PASSWORD, DB_NAME, DB_PORT)
    cursor = conn.cursor(as_dict=True)
    cursor.execute('SELECT Id, ImageUrl FROM Products')
    rows = cursor.fetchall()
    conn.close()

    print(f"\n🎯 Toplam {len(rows)} ürün işlenecek...\n")

    for row in tqdm(rows):
        product_id = row['Id']
        image_path = row['ImageUrl']

        if not image_path:
            continue

        image_url = f"{IMAGE_BASE_URL}{image_path}"
        embedding = get_image_embedding(image_url)

        if embedding:
            product_embeddings[product_id] = embedding
        time.sleep(0.1)

    np.save('product_embeddings_image_full.npy', product_embeddings)

if __name__ == '__main__':
    create_and_save_embeddings()