# Base image
FROM node:18

# Set working directory
WORKDIR /app

# Copy package filess
# COPY ../shared ./shared
COPY package*.json ./


# Install dependencies
RUN npm install

# Copy all code
COPY . .

# Expose port
EXPOSE 4007

# Start app
CMD ["npm", "run", "dev"]