FROM python:3.11
RUN apt-get update \
    && apt-get install -y vim \
    && apt-get install -y ant \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/ \
    && rm -rf /var/cache/oracle-jdk8-installer
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64
RUN export JAVA_HOME
WORKDIR /usr/src/app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
CMD ["python", "mqtt_subscriber.py"]