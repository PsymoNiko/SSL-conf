# HTTP Server Block (Redirects to HTTPS)
server {
    listen 80;
    server_name local.domain.com;

    # Redirect all HTTP requests to HTTPS
    return 301 https://$host$request_uri;
}

# HTTPS Server Block
server {
    listen 443 ssl;
    server_name local.domain.com;

    # SSL Certificate and Key
    ssl_certificate /etc/ssl/certs/local.domain.com.crt;
    ssl_certificate_key /etc/ssl/private/local.domain.com.key;

    # SSL Protocols and Ciphers
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers HIGH:!aNULL:!MD5;
    ssl_prefer_server_ciphers on;

    # Root directory for the site
    root /var/www/local.domain.com;
    index index.html;

    # Logging (optional)
    access_log /var/log/nginx/local.domain.com.access.log;
    error_log /var/log/nginx/local.domain.com.error.log;

    # Serve static files
    location / {
        try_files $uri $uri/ =404;
    }

    # Additional security headers (optional)
    add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;
    add_header X-Content-Type-Options nosniff;
    add_header X-Frame-Options DENY;
    add_header X-XSS-Protection "1; mode=block";
}
