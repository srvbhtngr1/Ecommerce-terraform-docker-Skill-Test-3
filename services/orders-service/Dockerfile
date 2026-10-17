FROM node:18-alpine
WORKDIR /app
COPY package.json ./
COPY server.js ./
ENV PORT=3003
EXPOSE 3003
CMD ["node", "server.js"]
