#!/bin/bash


mkdir CA
# Create a private key
#
openssl genrsa -out CA/mydomain.key 2048

# Create a self-signed certificate
openssl req -new -x509 -key CA/mydomain.key -out CA/mydomain.crt -days 365 -subj "/CN=www.domain.com"

