FROM node:20

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .

EXPOSE 8545

CMD ["sh", "-c", "npx hardhat node --hostname 0.0.0.0"]