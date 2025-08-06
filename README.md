# 🛍️ E-Commerce Application with Fashion Assistant

A modern and intelligent shopping experience in your pocket.

[![Watch the Demo](https://img.youtube.com/vi/w18Gp_AvkXU/0.jpg)](https://www.youtube.com/shorts/w18Gp_AvkXU)

---

## ✨ Overview

This app is a **modern e-commerce platform** that lists a variety of products from different stores.  
Users can:

- Easily browse the latest fashion products.
- Search products **by uploading an image** using advanced AI-powered search.
- Receive **personalized combination suggestions** via the **Fashion Assistant**.

With a sleek and user-friendly design, the app offers an enhanced online shopping experience tailored to individual style preferences.

---

## 🧠 AI-Powered Backend

The backend is developed in **Python**, featuring a powerful AI system that:

- Converts uploaded images into vector representations.
- Performs similarity search using **OpenCLIP** embeddings.
- Sends image context to **Gemini (Google Generative AI)** for combination suggestions.

### 🔧 Backend Technologies & Libraries

- `open_clip_torch`
- `torchvision`
- `Pillow`
- `pymssql`
- `numpy`
- `google-generativeai`

---

## 📱 iOS Mobile App

The iOS client is built with **Swift**, using modern UI tools and networking libraries.

### 🛠️ iOS Dependencies

- [`SnapKit`](https://github.com/SnapKit/SnapKit) – Easy Auto Layout
- [`Alamofire`](https://github.com/Alamofire/Alamofire) – Networking
- [`Then`](https://github.com/devxoul/Then) – Cleaner object initialization
- [`Kingfisher`](https://github.com/onevcat/Kingfisher) – Image downloading and caching
- [`lottie-ios`](https://github.com/airbnb/lottie-ios) – Animation support

---

## 🚀 Getting Started

### Backend Setup

1. Clone the repository:
   ```bash
   git clone https://github.com/OmerSarlavuk/ECommerce.git
   cd "ECOmmerce/E Commerce Backend"
   
2. Install dependencies:
   ```bash
   pip install -r requirements.txt

3. Run the API:
   ```bash
   python app.py

### iOS App Setup

1. Open ECommerceApp.xcworkspace in Xcode.
2. Run pod install to install CocoaPods dependencies.
3. Build and run the app on a simulator or device.


## 🤝 Contributing
We welcome contributions! Please submit issues or pull requests to improve the project.
