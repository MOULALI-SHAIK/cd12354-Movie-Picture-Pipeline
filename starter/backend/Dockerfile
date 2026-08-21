FROM public.ecr.aws/docker/library/python:3.10-alpine

WORKDIR /app

# Install build dependencies for compiling Python packages on Alpine
RUN apk update && apk add --no-cache gcc musl-dev libffi-dev python3-dev

# Install Pipenv
RUN pip install --no-cache-dir pipenv

# Copy dependency definition files
COPY Pipfile Pipfile.lock ./

# Install packages into system environment without strict lock abort
RUN pipenv install --system --ignore-pipfile || pipenv install --system

# Copy application source code
COPY . .

EXPOSE 5000

CMD ["python", "app.py"]