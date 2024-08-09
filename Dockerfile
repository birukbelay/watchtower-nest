# Stage 1: Build the NestJS application
FROM node:18-alpine AS builder

# Set the working directory inside the container
WORKDIR /app

# Copy the package.json and package-lock.json files
COPY package*.json ./

# Install the dependencies
RUN npm install

# Copy the rest of the application code
COPY . .

# Build the application
RUN npm run build

# Stage 2: Run the application in a smaller, production-ready image
FROM node:18-alpine

# Set the working directory inside the container
WORKDIR /app

# Copy the built application from the previous stage
COPY --from=builder /app/dist ./dist

# Copy the package.json and install only production dependencies
COPY package*.json ./
RUN npm install --omit=dev

# Expose the application port
EXPOSE 3000

# Define the command to start the application
CMD ["node", "dist/main"]