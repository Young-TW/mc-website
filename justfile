set shell := ["bash", "-eu", "-o", "pipefail", "-c"]

image_name := "mc-website"

install:
    pnpm install

build: install
    pnpm build

start: install
    pnpm start

dev: install
    pnpm dev

docker-build:
    docker build -t {{image_name}} .

docker-run:
    docker run -p 3000:3000 {{image_name}}

deploy: build docker-build docker-run
