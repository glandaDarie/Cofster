FROM python:3.11
WORKDIR /usr/src/app/cup_detection/messaging
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
CMD ["python", "questionnaire_llm_updater_mqtt_subscriber.py"]