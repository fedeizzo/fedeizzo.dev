FROM ubuntu:22.10 as sitegenerator

RUN apt update
RUN apt install -y golang-go hugo

COPY . /src
WORKDIR /src

RUN hugo

FROM nginx:stable-alpine

COPY --from=sitegenerator /src/public /usr/share/nginx/html
