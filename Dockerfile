# base image
FROM node:16-alpine AS base
WORKDIR /app

# dependencies
FROM base AS dependencies
COPY ./package*.json .
RUN npm install && npm cache clean --force

# copy & build
FROM dependencies AS build
WORKDIR /app
COPY src /app
RUN npm run build

# production
FROM base 
WORKDIR /app
COPY --from=dependencies /app/package*.json .
RUN npm install --production
COPY --from=build /app ./

USER node
EXPOSE 4000
ENTRYPOINT ["node", "dist/main.js"]
