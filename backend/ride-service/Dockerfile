# Base image
FROM node:18

# Set working directory
WORKDIR /app

# Copy package files
COPY package*.json ./
# COPY ../shared ./shared

# Install dependencies
RUN npm install

# Copy all code
COPY . .

# Expose port
EXPOSE 4009

# Start app
CMD ["npm", "run", "dev"]