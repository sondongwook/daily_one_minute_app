import requests
import html
import json
import random
from datetime import datetime, timedelta

# 세션 토큰 요청
token_resp = requests.get("https://opentdb.com/api_token.php?command=request")
token = token_resp.json().get("token")

# 퀴즈 수집 설정
num_questions = 10
batch_size = 50
total_batches = (num_questions + batch_size - 1) // batch_size
api_url = "https://opentdb.com/api.php"

all_quizzes = []
for _ in range(total_batches):
    params = {
        "amount": min(batch_size, num_questions - len(all_quizzes)),
        "type": "multiple",
        "difficulty": "medium",
        "token": token
    }
    r = requests.get(api_url, params=params)
    data = r.json()
    
    # ✅ 응답 코드 체크
    if data["response_code"] != 0:
        print(f"API 오류 발생: code {data['response_code']}, 메시지 생략하고 다음으로 진행")
        continue
    
    for item in data["results"]:
        q = html.unescape(item["question"])
        correct = html.unescape(item["correct_answer"])
        incorrect = [html.unescape(x) for x in item["incorrect_answers"]]
        options = incorrect + [correct]
        random.shuffle(options)
        all_quizzes.append({
            "question": q,
            "options": options,
            "answer": correct
        })

# 날짜별 JSON 저장
start_date = datetime.strptime("2026-10-04", "%Y-%m-%d")
quiz_output = {}

for i, quiz in enumerate(all_quizzes):
    date = (start_date + timedelta(days=i)).strftime("%Y-%m-%d")
    quiz_output[date] = {
        "date": date,
        "question": quiz["question"],
        "options": quiz["options"],
        "answer": quiz["answer"]
    }

with open("daily_quiz_en_365_2.json", "w", encoding="utf-8") as f:
    json.dump(quiz_output, f, ensure_ascii=False, indent=2)
