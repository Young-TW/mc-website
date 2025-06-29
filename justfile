set shell := ["bash", "-eu", "-o", "pipefail", "-c"]

image_name := "mc-website"

install:
    npm install

build: install
    npm run build

deploy: build docker-build docker-run

start:
    npm start

# Launch the development server
# usage: just dev

dev:
    npm run dev

# Build the Docker image
# usage: just docker-build

docker-build:
    docker build -t {{image_name}} .

# Run the Docker container
# usage: just docker-run

docker-run:
    docker run -p 3000:3000 {{image_name}}
