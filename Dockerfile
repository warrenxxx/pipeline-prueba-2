FROM node:alpine as builder
WORKDIR /usr/src/app
COPY . .
RUN npm install
RUN npm run build --prod

FROM nginx:latest
COPY --from=builder /usr/src/app/dist /usr/share/nginx/html
