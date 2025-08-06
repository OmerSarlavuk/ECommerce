import google.generativeai as genai
import json
import base64
import os
import re

base_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
config_path = os.path.join(base_dir, 'appsettings.json')

with open(config_path, 'r') as f:
    settings = json.load(f)

gemini_api_key = settings['gemini']['api_key']
gemini_model_name = settings['gemini']['model_name']

prompt = """
Sen profesyonel bir stil danışmanısın. Kullanıcının görsel olarak sağladığı bir moda ürününü inceleyerek;
- Ürünün tam olarak ne olduğunu belirle (örnek: Kadın turuncu düz tişört)
- Kullanım tarzını açıkla
- Kullanım ortamlarını ("occasions") listele
- Her ortam için bir kombin önerisi ver (top, bottom, shoes)
- Uygun aksesuarları belirt

Önceki kombin örneklerinden öğrenerek benzer stil ve yapı önerileri oluştur.

### Örnek:
{
  "style": "Kadın turuncu düz tişört",
  "occasions": ["Günlük kullanım", "Arkadaşlarla buluşma"],
  "combinations": [
    {
      "occasion_index": 0,
      "top": "Kadın turuncu düz tişört",
      "bottom": "Kadın siyah tayt",
      "shoes": "Kadın siyah spor ayakkabı"
    },
    {
      "occasion_index": 1,
      "top": "Kadın turuncu düz tişört",
      "bottom": "Kadın mavi kot şort",
      "shoes": "Kadın beyaz spor ayakkabı"
    }
  ],
  "accessories": ["Kadın altın kolye", "Kadın siyah güneş gözlüğü"]
}

### Dikkat:
- Çıktın sadece aşağıdaki **JSON** formatında olmalı.
- Cinsiyeti sen tespit et ve ürünlere mutlaka başta ekle (Kadın Beyaz Tişört, Erkek Siyah Kot Pantolon).
- Kombinler ortam (occasion) sayısı kadar olmalı ve sıralaması doğru eşleşmeli (`occasion_index`).
- `accessories` alanında 2-4 adet aksesuar önerisi olmalı.
- Ürünleri sade, kullanıcı odaklı ve kombin önerisi olarak düşünerek açıkla.

### ŞABLON (buna birebir uy):
{
  "style": "ÜRÜNÜN TARZ AÇIKLAMASI",
  "occasions": ["ORTAM 1", "ORTAM 2", "..."],
  "combinations": [
    {
      "occasion_index": 0,
      "top": "ÜST GİYİM",
      "bottom": "ALT GİYİM",
      "shoes": "AYAKKABI"
    },
    {
      "occasion_index": 1,
      "top": "ÜST GİYİM",
      "bottom": "ALT GİYİM",
      "shoes": "AYAKKABI"
    }
  ],
  "accessories": ["AKSESUAR 1", "AKSESUAR 2", "..."]
}

Lütfen sadece yukarıdaki JSON yapısını döndür. Açıklama, yorum, markdown veya başka bilgi ekleme.
"""

genai.configure(api_key=gemini_api_key)
model = genai.GenerativeModel(gemini_model_name)


def encode_image_base64(image_path):
    with open(image_path, "rb") as f:
        return base64.b64encode(f.read()).decode("utf-8")

def comment_image_with_gemini(image_base64):
    if image_base64.startswith("data:image"):
        base64_data = re.sub('^data:image/.+;base64,', '', image_base64)
    else:
        base64_data = image_base64
    response = model.generate_content([
    prompt,
    {"mime_type": "image/jpeg", "data": base64_data}
    ],
    generation_config=genai.types.GenerationConfig(
        stop_sequences=[],
        max_output_tokens=2048,
        temperature=0.7
    ))
    return response.text