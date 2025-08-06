from DataAccess.BaseRepository import read_data
from Helper.helper_methods import get_clip_embedding_from_base64, get_text_embedding
from Gemini.handle_product import comment_image_with_gemini
import Utils.Messages as ms
import numpy as np
from sklearn.metrics.pairwise import cosine_similarity
import json
import re
#---------------------------------Load_Image_Model-------------------------------------------------------
product_image_embeddings_data = np.load('EmbeddingModel/product_image_embedding_model.npy', allow_pickle=True).item()
product_image_ids = list(product_image_embeddings_data.keys())
product_image_vectors = np.array(list(product_image_embeddings_data.values())).squeeze()
#---------------------------------Load_Text_Model-------------------------------------------------------
product_text_embeddings_data = np.load('EmbeddingModel/product_text_embedding_model.npy', allow_pickle=True).item()
product_text_ids = list(product_text_embeddings_data.keys())
product_text_vectors = np.array(list(product_text_embeddings_data.values())).squeeze()

# Kademeli olarak threshold değerini günceller en az bir veri bulana kadar.
def find_similar_indices(similarities, ids, initial_threshold, min_threshold=0.50, step=0.05):
    threshold = initial_threshold
    while threshold >= min_threshold:
        top_indices = [i for i, sim in enumerate(similarities) if sim >= threshold]
        if top_indices:
            top_indices.sort(key=lambda i: similarities[i], reverse=True)

            print(f"\nThreshold: {threshold:.2f}")
            for i in top_indices:
                print(f"  ID: {ids[i]}, Similarity: {similarities[i]:.4f}")
            return top_indices
        threshold -= step

    top_index = int(np.argmax(similarities))
    print(f"\nHiçbir threshold eşleşmedi, en benzer 1 sonuç seçildi.")
    print(f"  ID: {ids[top_index]}, Similarity: {similarities[top_index]:.4f}")
    return [top_index]

# image embedd and process business logic
def search_by_image_business(image, isBase64):
    query_vector = get_clip_embedding_from_base64(image, isBase64)

    if query_vector is None:
        return {
            "data": None,
            "message": "Görsel işlenirken hata oluştu.",
            "code": 400
        }

    query_vector = np.array(query_vector).reshape(1, -1)
    similarities = cosine_similarity(query_vector, product_image_vectors)[0]

    top_indices = find_similar_indices(similarities, product_image_ids, initial_threshold=0.80)
    similar_product_ids = [product_image_ids[i] for i in top_indices]

    id_list_str = ','.join(map(str, similar_product_ids))
    query = f"SELECT * FROM Products WHERE Id IN ({id_list_str})"
    results, message = read_data(query)

    if results is None:
        return {
            "data": None,
            "message": f"Ürünler listelenemedi. -> {message}",
            "code": 400
        }

    sorted_results = sorted(results, key=lambda x: similar_product_ids.index(x['Id']))
    return {
        "data": sorted_results,
        "message": ms.success_data,
        "code": 200
    }

# ---------------------- Text Search Business Fonksiyonu ----------------------
def search_by_text_business(text):
    if not text:
        return {
            "data": None,
            "message": "Metin boş olamaz.",
            "code": 400
        }

    query_vector = get_text_embedding(text)
    query_vector = np.array(query_vector).reshape(1, -1)
    similarities = cosine_similarity(query_vector, product_text_vectors)[0]

    top_indices = find_similar_indices(similarities, product_text_ids, initial_threshold=0.85)
    similar_product_ids = [product_text_ids[i] for i in top_indices]

    id_list_str = ','.join(map(str, similar_product_ids))
    query = f"SELECT * FROM Products WHERE Id IN ({id_list_str})"
    results, message = read_data(query)

    if results is None:
        return {
            "data": None,
            "message": f"Ürünler listelenemedi. -> {message}",
            "code": 400
        }

    sorted_results = sorted(results, key=lambda x: similar_product_ids.index(x['Id']))
    return {
        "data": sorted_results,
        "message": ms.success_data,
        "code": 200
    }


def get_products_business(start, stop, isMan):
    query = f"SELECT * FROM Products WHERE IsMan = {isMan} ORDER BY Id OFFSET {start} ROWS FETCH NEXT {stop} ROWS ONLY;"
    results, message = read_data(query)

    if results is None:
        return {
            "data": None,
            "message": f"Ürünler listelenemedi. -> {message}",
            "code": 400
        }
    
    return {
        "data": results,
        "message": ms.success_data,
        "code": 200
    }


def extract_json_from_text(text):
    match = re.search(r'\{.*\}', text, re.DOTALL)
    if match:
        return match.group(0)
    return None

def only_product_get_embedding(text):
    query_vector = get_text_embedding(text)
    query_vector = np.array(query_vector).reshape(1, -1)
    similarities = cosine_similarity(query_vector, product_text_vectors)[0]

    top_indices = find_similar_indices(similarities, product_text_ids, initial_threshold=0.85)
    first_value_id = product_text_ids[top_indices[0]]

    query = f"SELECT * FROM Products WHERE Id = {first_value_id}"
    results, message = read_data(query)
    print(f'only get embedding method -> {results}')
    return results

def only_product_get_embedding_image(image):
    query_vector = get_clip_embedding_from_base64(image)

    if query_vector is None:
        return None

    query_vector = np.array(query_vector).reshape(1, -1)
    similarities = cosine_similarity(query_vector, product_image_vectors)[0]

    top_indices = find_similar_indices(similarities, product_image_ids, initial_threshold=0.80)
    first_value_id = product_image_ids[top_indices[0]]

    query = f"SELECT * FROM Products WHERE Id = {first_value_id}"
    results, message = read_data(query)
    print(f'only get embedding method -> {results}')
    return results

def suggess_combination_business(image):
    response = comment_image_with_gemini(image)
    print(f'GEMINI_RESPONSE_DATA -> {response}')

    if not response:
        return {
            "data": None,
            "message": "Gemini'den boş yanıt geldi",
            "code": 400
        }

    json_str = extract_json_from_text(response)
    if not json_str:
        return {
            "data": response,
            "message": "JSON formatı tespit edilemedi",
            "code": 400
        }

    try:
        response_text = json.loads(json_str)
    except json.JSONDecodeError as e:
        print(f"[!] JSON parse hatası: {e}")
        return {
            "data": json_str,
            "message": "Yanıt JSON formatında değil",
            "code": 400
        }
    
    top_product = only_product_get_embedding_image(image)
    
    style = response_text.get("style", "")
    occasions = response_text.get("occasions", [])
    accessories = response_text.get("accessories", [])
    combinations = response_text.get("combinations", [])

    for combination in combinations:
        bottom = combination['bottom']
        bottom_product = only_product_get_embedding(bottom)

        combination["top_product"] = top_product[0]
        combination["bottom_product"] = bottom_product[0]

    response_data = {
        "style": style,
        "occasions": occasions,
        "accessories": accessories,
        "combinations": combinations
    }

    return {
        "data": response_data,
        "message": "Başarılı",
        "code": 200
    }