FROM python:3.7-slim-buster

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
sudo apt install unzip -y
unzip awscliv2.zip
sudo ./aws/installWORKDIR /app

COPY . /app
RUN pip install -r requirements.txt

CMD ["python3", "app.py"]
