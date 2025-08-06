from flask import Flask, request, json, Response
from Business.ProductBusiness import search_by_image_business, get_products_business, search_by_text_business, suggess_combination_business

app = Flask(__name__)
ensure_ascii=False
mimetype='application/json'

@app.route('/api/search_by_image', methods=['POST'])
def search_by_image():
    body = request.json
    image = body.get('image')

    response = search_by_image_business(image, True)
    return Response(json.dumps(response, ensure_ascii=ensure_ascii), mimetype=mimetype)

@app.route('/api/search_by_image_url', methods=['GET'])
def search_by_image_url():
    image_url = request.args.get("imageUrl")

    response = search_by_image_business(image_url, False)
    return Response(json.dumps(response, ensure_ascii=ensure_ascii), mimetype=mimetype)

@app.route('/api/search_by_text', methods=['POST'])
def search_by_text():
    body = request.json
    text = body.get('text')

    response = search_by_text_business(text)
    return Response(json.dumps(response, ensure_ascii=ensure_ascii), mimetype=mimetype)

@app.route('/api/get_products', methods=['GET'])
def get_products():
    start_row = request.args.get("start"); stop_row = request.args.get("stop"); is_man = request.args.get("isMan")
  
    response = get_products_business(start_row, stop_row, is_man)
    return Response(json.dumps(response, ensure_ascii=ensure_ascii), mimetype=mimetype)

@app.route('/api/combination', methods=['POST'])
def suggess_combiation():
    body = request.json
    image = body.get('image')
    
    response = suggess_combination_business(image)
    return Response(json.dumps(response, ensure_ascii=ensure_ascii), mimetype=mimetype)

@app.route('/api/search_text_image', methods=['POST'])
def search_text_image():
    body = request.json

    image = body.get('image')
    text = body.get('text')

    response_image = search_by_image_business(image, True)
    response_text = search_by_text_business(text)

    combination_data = response_image['data'] + response_text['data']
    combination_response = {
        "data": combination_data,
        "code": 200,
        "message": "Başarılı"
    }

    return Response(json.dumps(combination_response, ensure_ascii=ensure_ascii), mimetype=mimetype)

if __name__ == '__main__':
    app.run(host='0.0.0.0', debug=True, port=8002)