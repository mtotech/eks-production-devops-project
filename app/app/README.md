# Flask Application

## Overview

This application is a sample production-ready Flask API deployed on Amazon EKS.

The application demonstrates:

- Docker Containerization
- Kubernetes Deployment
- Helm Packaging
- Monitoring Integration
- CI/CD Deployment

---

## Application Architecture

Client

↓

AWS ALB

↓

Kubernetes Service

↓

Flask Pods

---

## API Endpoint

GET /

Response:

{
  "Application": "Production Flask App",
  "Platform": "Amazon EKS",
  "Status": "Running"
}

---

## Local Execution

pip install -r requirements.txt

python app.py

---

## Docker Build

docker build -t flask-app .

---

## Validation

curl http://localhost:5000

---

## Learning Outcomes

- Flask API Development
- Dockerization
- Kubernetes Workloads
- Container Best Practices

---

## Screenshots

- flask-local.png
- flask-api-response.png
- docker-build.png
