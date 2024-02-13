FROM nginx:latest

# Remove default configuration file
RUN rm /etc/nginx/conf.d/default.conf

# Copy custom configuration file
COPY nginx.conf /etc/nginx/conf.d/

# Copy static.json file to serve
COPY static.json /usr/share/nginx/html/static.json
