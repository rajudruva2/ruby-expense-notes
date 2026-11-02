# Expense Notes API

{
  "description": "Expense Notes API is a small Ruby/Sinatra JSON API for DevOps practice."
}

## Features
- Health endpoint: `GET /health`
- List and search records: `GET /expenses` or `GET /expenses?q=term`
- Get one record: `GET /expenses/:id`
- Create a record: `POST /expenses`
- Delete a record: `DELETE /expenses/:id`
- `GET /summary` — total count and amount

- Dockerfile and GitHub Actions CI workflow

Data is stored in memory for demo simplicity and resets when the process restarts. Do not use this demo storage pattern for production data.

## Run locally
Requires Ruby 3.3+ and Bundler.
```bash
bundle install
bundle exec ruby app.rb
```

Try:
```bash
curl http://localhost:4571/health
curl http://localhost:4571/expenses
curl -X POST http://localhost:4571/expenses \
  -H 'Content-Type: application/json' \
  -d '{"description":"Lunch","amount":180.0,"category":"food"}'
```

## Run with Docker
```bash
docker build -t ruby-expense-notes .
docker run --rm -p 4571:4571 ruby-expense-notes
```

## CI pipeline
GitHub Actions runs Ruby syntax checks, Minitest smoke tests, and a Docker image build on pushes and pull requests to `main`.

## DevOps practice
Use this repo to practise CI, Docker builds, image tagging, registry publishing, deployment to EC2/Kubernetes, environment variables, approvals, health checks, and rollback.
