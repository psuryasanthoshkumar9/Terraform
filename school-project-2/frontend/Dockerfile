FROM node:20-alpine

WORKDIR /app

# Copy package.json first for caching dependencies
COPY package.json package-lock.json* ./

RUN npm install

# Copy all source code
COPY . .

# Build React app
RUN npm run build

# Expose port 3000
EXPOSE 3000

# Run Vite preview
CMD ["npm", "run", "start"]
