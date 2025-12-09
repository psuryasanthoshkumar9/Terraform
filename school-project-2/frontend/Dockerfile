# Use official Node image
FROM node:20-alpine

# Set working directory
WORKDIR /app

# Copy package.json and install dependencies
COPY package.json package-lock.json* ./
RUN npm install

# Copy all source code (including .env)
COPY . .

# Expose port 3000 for Vite
EXPOSE 3000

# Start Vite preview so it listens on 0.0.0.0
CMD ["npm", "run", "start"]
