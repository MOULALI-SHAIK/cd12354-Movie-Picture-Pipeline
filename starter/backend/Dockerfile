FROM public.ecr.aws/docker/library/python:3.10-slim-bookworm
ENV FLASK_RUN_HOST=0.0.0.0

WORKDIR /app

RUN useradd --uid 1000 --create-home app
RUN apt-get update \
    && apt-get install -y --no-install-recommends build-essential libpcre3-dev \
    && rm -rf /var/lib/apt/lists/* \
    && pip install --no-cache-dir pipenv

COPY Pipfile Pipfile.lock ./
RUN pipenv install --system --deploy

COPY . ./backend/

RUN mkdir -p /var/www/app

EXPOSE 5000

CMD ["uwsgi", "--http", ":5000", "--master", "--enable-threads", "-s", "/var/www/app/app.sock", "--manage-script-name", "--mount", "/=backend:app"]