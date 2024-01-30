# Stage 1: Build Stage
FROM node:18.16.1 AS builder

# Set the working directory
WORKDIR /app

# Copy package.json and package-lock.json (if exists)
COPY package*.json ./

# Install dependencies
RUN npm install --production

# Copy the rest of the application code
COPY . .

# Stage 2: Final Stage
FROM node:18.16.1-alpine

# Create a non-root user and group
RUN addgroup -g 1002 nodee \
    && adduser -u 1002 -G nodee -s /bin/sh -D nodee

# Set the working directory
WORKDIR /app

# Copy files from the build stage
COPY --from=builder /app .

# Expose the port the app runs on
EXPOSE 3000

# Specify the non-root user to use when running the container
USER node

# Specify the command to run on container start
CMD ["node", "app.js"]


