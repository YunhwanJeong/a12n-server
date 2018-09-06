PATH:=./node_modules/.bin:$(PATH)
SOURCE_FILES:=./src/*.ts

PORT:=8502
MYSQL_HOST:=127.0.0.1
MYSQL_PASSWORD:=
MYSQL_USER:=savearth
MYSQL_DATABASE:=auth

export PORT
export MYSQL_HOST
export MYSQL_USER
export MYSQL_DATABASE
export MYSQL_PASSWORD

.PHONY:start run build test lint lint-fix start-dev watch inspect deploy
start: build
	node dist/app.js

run: start

build: dist/build

docker-build: build
	docker build -t market-api .

docker-run:
	docker run -it --rm --name market-api-01 market-api

docker-push: docker-build
	docker tag market-api:latest 934324510302.dkr.ecr.us-east-1.amazonaws.com/market-api:latest
	docker push 934324510302.dkr.ecr.us-east-1.amazonaws.com/market-api:latest

test:
	nyc mocha

lint:
	tslint -p .

lint-fix:
	tslint -p . --fix

start-dev:
	ts-node src/app.js

watch:
	tsc --watch

dist/build: $(SOURCE_FILES)
	tsc
	@# Touching this file so Makefile knows when it was last built.
	touch dist/build

inspect: build
	node --inspect dist/app.js

deploy: build
	gcloud app deploy