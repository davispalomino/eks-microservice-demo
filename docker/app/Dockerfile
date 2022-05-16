FROM python:3.8

# RUN apk update && apk add gcc
WORKDIR app
COPY ./app .
RUN pip install -r requirements.txt

CMD ["gunicorn", "-b", "0.0.0.0:80","-w","1","--log-level","DEBUG","-t","800","wsgi:app"]