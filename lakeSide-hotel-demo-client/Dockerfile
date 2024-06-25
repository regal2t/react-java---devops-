# Use Node.js version 14 (or a version compatible with your setup)
FROM node:14 as build

# Create app directory
WORKDIR /usr/src/app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy all files (including source code)
COPY . .

# Build your application (assuming it is a Node.js application)
RUN npm run build  # Adjust this command based on how your app is built

# Stage 2: Serve the built app using Nginx
FROM nginx:stable-alpine

# Copy the built app from the previous stage
COPY --from=build /usr/src/app/dist /usr/share/nginx/html

# Expose the port your app runs on (default for Nginx is 80)
EXPOSE 80

# Command to run Nginx (daemon off for Docker)
CMD ["nginx", "-g", "daemon off;"]
