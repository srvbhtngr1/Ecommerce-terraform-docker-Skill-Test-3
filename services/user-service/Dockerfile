FROM node:18-alpine
WORKDIR /app
COPY package.json ./
COPY server.js ./
ENV PORT=3001
EXPOSE 3001
CMD ["node", "server.js"]
