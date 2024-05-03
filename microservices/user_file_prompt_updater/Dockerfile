# Set the baseImage to Python 3.11
FROM python:3.11

# Set working directory, copy application files and install libraries
WORKDIR /usr/src/app
COPY requirements.txt . 
RUN pip install --no-cache-dir -r requirements.txt
COPY . .

# Command to run the application
CMD ["python", "-u", "prompt_job.py"]