set shell := ["bash", "-eu", "-o", "pipefail", "-c"]

image_name := "mc-website"

install:
    pnpm install

build: install
    pnpm build

deploy: build docker-build docker-run

start:
    pnpm start

# Launch the development server
# usage: just dev

dev:
    pnpm dev

# Build the Docker image
# usage: just docker-build

docker-build:
    docker build -t {{image_name}} .

# Run the Docker container
# usage: just docker-run

docker-run:
    docker run -p 3000:3000 {{image_name}}
