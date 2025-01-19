# # Stage 1: Build
# FROM node:14-alpine AS build
# WORKDIR /app

# # Copy only package files to install dependencies
# COPY package*.json ./
# RUN npm install -g nodemon
# RUN npm install

# # Copy the rest of the application code
# COPY . .

# # Stage 2: Run
# FROM node:14-alpine
# WORKDIR /app

# # Copy the production build from the build stage
# COPY --from=build /app /app

# # Expose the application port
# EXPOSE 5000

# # Start the application
# CMD ["npm", "start"]

# # Stage 1: Build
# FROM node:16-alpine AS build
# WORKDIR /app

# # Copy package files and install only production dependencies
# COPY package.json ./
# RUN npm i
# RUN npm i nodemon

# # Copy the rest of the application code
# COPY . .

# # Stage 2: Run
# FROM node:16-alpine
# WORKDIR /app

# # Copy dependencies and application code from build stage
# COPY --from=build /app .

# # Expose the application port
# EXPOSE 5000

# # Add environment variable support (optional)
# # ENV NODE_ENV=production

# # Start the application
# CMD ["node", "server.js"]

# Stage 1: Build
FROM node:16-alpine AS build
WORKDIR /app

# Copy package files dan install dependencies
COPY package*.json ./
RUN npm i
RUN npm i nodemon

# Copy semua kode aplikasi
COPY . .

# Install Sequelize CLI secara global
RUN npm install -g sequelize-cli

# Jalankan migrasi database (production)
RUN NODE_ENV=development npx sequelize-cli db:migrate

# Stage 2: Run
FROM node:16-alpine
WORKDIR /app

# Copy aplikasi dari tahap build
COPY --from=build /app .

# Expose port aplikasi
EXPOSE 5000

# Jalankan aplikasi
CMD ["npm", "start"]
