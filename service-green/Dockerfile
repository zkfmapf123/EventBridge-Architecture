# syntax=docker/dockerfile:1

ARG NODE_VERSION=18.19.0

FROM node:${NODE_VERSION}-alpine

ENV NODE_ENV production

COPY package*.json .
RUN npm install
COPY . .

# Expose the port that the application listens on.
EXPOSE 3000

# Run the application.
CMD node index.js
