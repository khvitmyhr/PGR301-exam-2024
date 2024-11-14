name: Build and Push Docker Image

on:
  push:
    branches:
      - main  # Workflowen trigges når det pushes til main-branchen

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
    - name: Checkout code
      uses: actions/checkout@v3  # Sjekker ut koden fra GitHub-repoet

    - name: Set up Docker Buildx
      uses: docker/setup-buildx-action@v2  # Konfigurerer Buildx for bygging

    - name: Log in to Docker Hub
      uses: docker/login-action@v2  # Logger inn på Docker Hub
      with:
        username: ${{ secrets.DOCKER_USERNAME }}  # Docker Hub-brukernavn lagret i Secrets
        password: ${{ secrets.DOCKER_PASSWORD }}  # Docker Hub-passord (eller token) lagret i Secrets

    - name: Build Docker image
      run: |
        docker build -t ${{ secrets.DOCKER_USERNAME }}/java-sqs-client:latest .  # Bygger Docker-imaget

    - name: Push Docker image
      run: |
        docker push ${{ secrets.DOCKER_USERNAME }}/java-sqs-client:latest  # Pusher imaget til Docker Hub
