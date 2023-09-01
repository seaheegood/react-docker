#Stage 1

# pull official base image
FROM node:19-alpine as builder

# set working directory
WORKDIR /app

# install app dependencies
# I deleted 'package-lock.json' to use yarn
COPY package.json .
COPY yarn.lock .
RUN yarn install

# 현재 디렉토리의 모든 파일을 도커 컨테이너의 워킹 디렉토리에 복사한다.
COPY . .

# start app
RUN yarn build

#Stage 2
FROM nginx:1.19.0
WORKDIR /usr/share/nginx/html
RUN rm -rf ./*
COPY --from=builder /app/build .
ENTRYPOINT [ "nginx", "-g", "daemon off;" ]

