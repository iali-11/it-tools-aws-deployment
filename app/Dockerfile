FROM node:24-alpine

WORKDIR /app

COPY package.json pnpm-lock.yaml ./

# Bundled with pnpm, therefore to make pnpm available, corepack is enable
RUN corepack enable     
RUN pnpm install

COPY . .

RUN pnpm build

EXPOSE 5173

CMD [ "pnpm", "dev", "--host", "0.0.0.0" ]