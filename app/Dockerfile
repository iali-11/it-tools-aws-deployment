# Stage 1: Build Stage

FROM node:24-alpine AS build

WORKDIR /app

COPY package.json pnpm-lock.yaml ./

RUN corepack enable     

RUN pnpm install

COPY . .

RUN pnpm build

# Stage 2: Runtime Stage

FROM nginxinc/nginx-unprivileged:alpine AS runtime

WORKDIR /app

COPY --from=build /app/dist /usr/share/nginx/html 

COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 8080

CMD [ "nginx", "-g", "daemon off;" ]