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

# add app
COPY . .

# start app
RUN yarn build

#Stage 2
FROM nginx:1.19.0
WORKDIR /usr/share/nginx/html
RUN rm -rf ./*
COPY --from=builder /app/build .
ENTRYPOINT [ "nginx", "-g", "daemon off;" ]

