import os
from dotenv import load_dotenv
from langchain_community.chat_models import ChatOpenAI
from langchain.schema import HumanMessage, SystemMessage

load_dotenv()

def summarize_text(text: str):
    llm = ChatOpenAI(
        temperature=0.5,
        model="gpt-3.5-turbo",
        openai_api_key=os.getenv("OPENAI_API_KEY")
    )

    prompt = (
        "以下の文章を日本語で要約し、重要なキーワードを5つ抽出してください。\n"
        "出力形式:\n"
        "【要約】\n"
        "...\n"
        "【キーワード】\n"
        "・...\n"
        "・...\n"
        "\n"
        f"文章:\n{text}"
    )

    response = llm([
        SystemMessage(content="あなたは文章の要約とキーワード抽出をするアシスタントです。"),
        HumanMessage(content=prompt)
    ])

    content = response.content
    if "【要約】" in content and "【キーワード】" in content:
        summary = content.split("【キーワード】")[0].replace("【要約】", "").strip()
        keywords_block = content.split("【キーワード】")[1].strip()
        keywords = [kw.replace("・", "").strip() for kw in keywords_block.split("\n") if kw]
    else:
        summary = content
        keywords = []

    return summary, keywords
