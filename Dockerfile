# Use an official Nginx image as the base image
FROM nginx:alpine

# Copy website files to the Nginx web directory
COPY . /usr/share/nginx/html

# Expose port 80 to the outside world
EXPOSE 80

# Start Nginx server
CMD ["nginx", "-g", "daemon off;"]
