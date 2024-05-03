FROM python:3.11 

WORKDIR /usr/src/app 
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
WORKDIR /usr/src/app/classifier

EXPOSE 8000
CMD ["python", "server.py"]