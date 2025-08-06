import open_clip
import torch
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

device = "cuda" if torch.cuda.is_available() else "cpu"
model, _, preprocess = open_clip.create_model_and_transforms(
    'ViT-L-14',
    pretrained='laion2b_s32b_b82k'
)
tokenizer = open_clip.get_tokenizer('ViT-L-14')
model.eval().to(device)

def get_text_embedding(text):
    with torch.no_grad():
        tokenized = tokenizer([text]).to(device)
        text_features = model.encode_text(tokenized)
        text_features /= text_features.norm(dim=-1, keepdim=True)
    return text_features.squeeze().cpu().numpy().tolist()

def create_and_save_text_embeddings():
    product_embeddings = {}

    # SQL bağlantısı
    conn = pymssql.connect(DB_SERVER, DB_USER, DB_PASSWORD, DB_NAME, DB_PORT)
    cursor = conn.cursor(as_dict=True)
    cursor.execute('SELECT Id, ProductName FROM Products')
    rows = cursor.fetchall()
    conn.close()

    print(f"\n🎯 Toplam {len(rows)} ürün metni işlenecek...\n")

    for row in tqdm(rows):
        product_id = row['Id']
        product_name = row['ProductName']

        if not product_name:
            continue

        embedding = get_text_embedding(product_name)

        if embedding:
            product_embeddings[product_id] = embedding

        time.sleep(0.05)

    np.save('product_text_embeddings_full.npy', product_embeddings)

if __name__ == '__main__':
    create_and_save_text_embeddings()