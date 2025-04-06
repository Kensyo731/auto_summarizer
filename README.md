# 自動要約＆キーワード抽出アプリ

自然言語処理を活用して、入力テキストから要約とキーワードを自動抽出するWebアプリです。  
バックエンドは FastAPI、フロントエンドは Flutter（Web対応）で構築しています。

---

## 🚀 使用技術

- **フロントエンド**：Flutter (Dart)
- **バックエンド**：FastAPI (Python)
- **LLM**：OpenAI API (gpt-3.5-turbo)
- **要約＆キーワード抽出**：LangChain + Chat Model

---

## 📂 フォルダ構成

auto_summarizer/ 
├── backend/ # FastAPIアプリ 
├── frontend/ # Flutter Webアプリ 
└── README.md

---

## 💻 起動方法

### バックエンド（FastAPI）

```bash
cd backend
python -m venv venv
venv\Scripts\activate
pip install -r requirements.txt
uvicorn main:app --reload
※ .env ファイルに OpenAI の API キーを設定する必要があります。

フロントエンド（Flutter Web）
bash
コピーする
編集する
cd frontend
flutter pub get
flutter run -d chrome
✨ 今後の改善案
URL入力による自動要約

キーワードのコピー・検索機能

モバイル対応UI

PDFやWebページのインポート

📜 ライセンス
MIT

🙋‍♀️ 開発者
Kensyo731