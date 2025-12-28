# Step 1: Use a lightweight Nginx image
FROM nginx:alpine

# Step 2: Copy our HTML file to the Nginx server folder
COPY index.html /usr/share/nginx/html/index.html

# Step 3: Open port 80 for traffic
EXPOSE 80