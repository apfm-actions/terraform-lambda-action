FROM apfm/terraform-action-base:latest
WORKDIR /app
COPY *.tf /app/
COPY *.zip /app/
