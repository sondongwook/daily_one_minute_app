import json
from deep_translator import GoogleTranslator

# 영어 퀴즈 파일 경로
with open("daily_quiz_en_365_2.json", "r", encoding="utf-8") as f:
    data = json.load(f)

translated_data = {}

for date, quiz in data.items():
    try:
        question_ko = GoogleTranslator(source='en', target='ko').translate(quiz['question'])
        options_ko = [GoogleTranslator(source='en', target='ko').translate(opt) for opt in quiz['options']]
        answer_ko = GoogleTranslator(source='en', target='ko').translate(quiz['answer'])

        translated_data[date] = {
            "date": date,
            "question": question_ko,
            "options": options_ko,
            "answer": answer_ko
        }

    except Exception as e:
        print(f"[{date}] 번역 실패: {e}")
        continue

# 저장
with open("daily_quiz_ko_365.json", "w", encoding="utf-8") as f:
    json.dump(translated_data, f, ensure_ascii=False, indent=2)

print("✅ 한글 번역 완료: daily_quiz_ko_365.json 생성됨")
