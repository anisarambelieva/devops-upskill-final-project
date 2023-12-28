FROM ubuntu:22.04

RUN apt-get update \
      && apt-get install -y --no-install-recommends \
       python3 \
       python3-pip \
      && mkdir -p /app \
      && mkdir -p /app/templates \
      && mkdir -p /app/static \
      && useradd -d /app -s /bin/bash app \
      && chown -R app:app /app

COPY requirements.txt /app/requirements.txt
RUN pip3 install -r /app/requirements.txt

COPY static/newsletter.png /app/static
COPY templates/index.html /app/templates
COPY app.py /app

WORKDIR /app

USER app

EXPOSE 5000

CMD ["python3", "app.py"]