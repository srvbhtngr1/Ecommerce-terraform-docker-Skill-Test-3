FROM node:18-alpine
WORKDIR /app
COPY package.json ./
COPY server.js ./
ENV PORT=3004
EXPOSE 3004
CMD ["node", "server.js"]
