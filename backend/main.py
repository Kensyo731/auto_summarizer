from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse
from pydantic import BaseModel
from summarize import summarize_text
import os
from dotenv import load_dotenv

load_dotenv()

app = FastAPI(openapi_version="3.0.0")

# CORS設定（フロントエンドからの通信を許可）
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# リクエストモデル
class TextRequest(BaseModel):
    text: str

# 要約エンドポイント
@app.post("/summarize")
async def summarize(request: TextRequest):
    summary, keywords = summarize_text(request.text)
    return JSONResponse(
        content={
            "summary": summary,
            "keywords": keywords
        },
        headers={"Content-Type": "application/json; charset=utf-8"}  # ✅ 文字化け対策
    )
