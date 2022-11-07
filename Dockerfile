# base image
FROM node:16-alpine AS base
WORKDIR /app
COPY . .

# dependencies
FROM base AS dependencies
RUN npm install && npm cache clean --force

# copy & build
FROM dependencies AS build
COPY --from=dependencies ./app/node_modules ./node_modules
RUN npm run build

# production
FROM base AS release
RUN npm install --production
COPY --from=build ./app/dist ./dist

USER node
EXPOSE 4000
ENTRYPOINT ["node", "dist/main.js"]

