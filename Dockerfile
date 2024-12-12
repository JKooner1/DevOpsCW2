FROM node:14
COPY server.js /app/
WORKDIR /app
RUN npm install
CMD ["node", "server.js"]
EXPOSE 8080
