# Makefile for Flask Application

.PHONY: help install test lint run docker-build docker-run clean

help:
	@echo "Available commands:"
	@echo "  install      - Install Python dependencies"
	@echo "  test         - Run tests"
	@echo "  lint         - Run linting"
	@echo "  run          - Run the Flask application"
	@echo "  docker-build - Build Docker image"
	@echo "  docker-run   - Run Docker container"
	@echo "  clean        - Clean up temporary files"

install:
	pip install -r requirements.txt

test:
	python -m pytest test_app.py -v --cov=app --cov-report=term-missing

lint:
	python -m pylint app.py

run:
	python app.py

docker-build:
	docker build -t python-flask-app .

docker-run:
	docker run -p 8080:8080 python-flask-app

clean:
	find . -type f -name "*.pyc" -delete
	find . -type d -name "__pycache__" -delete
	find . -type f -name "*.coverage" -delete
	find . -type d -name "*.egg-info" -exec rm -rf {} +
	find . -type d -name ".pytest_cache" -exec rm -rf {} +
