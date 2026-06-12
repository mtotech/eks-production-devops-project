# GitHub Actions CI/CD Pipeline

## Overview

This pipeline automates application delivery to Amazon EKS.

---

## Pipeline Stages

Source Code
↓

GitHub Actions
↓

Pytest
↓

SonarQube Scan
↓

Trivy Scan
↓

Docker Build
↓

Docker Push
↓

Helm Deployment
↓

Amazon EKS

---

## Workflow Features

- Automated Testing
- SonarQube Code Analysis
- Trivy Vulnerability Scanning
- Docker Build
- Docker Push
- Helm Deployment

---

## Trigger

Push to Main Branch

```yaml
on:
  push:
    branches:
      - main
