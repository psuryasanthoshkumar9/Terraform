FROM node:18-alpine
WORKDIR /app

# install build deps for mysql2 binary if needed
RUN apk add --no-cache python3 make g++ 

COPY package.json package-lock.json* ./
RUN npm ci --production

COPY . .

EXPOSE 5000
CMD ["npm", "start"]
