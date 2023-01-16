```
server  {
  listen 443 ssl http2;
  server_name  tqazsvlubnagw.tqcorp.com;

  location ^~ /api/v1/healthcheck {
        proxy_pass http://tqazsvlubnagw.tqcorp.com:9211/api/v1/healthcheck;
    }

  location ^~ /api/v1/tokens {
        proxy_pass http://tqazsvlubnagw.tqcorp.com:9211/api/v1/tokens;
    }

  location ^~ /api/v1/instore/external/resolve {
        proxy_pass http://tqazsvlubnagw.tqcorp.com:9231/api/v1/instore/external/resolve;
    }

  location ^~ /api/v2/link/payment_options {
        proxy_pass http://tqazsvlubnagw.tqcorp.com:9211/api/v2/link/payment_options;
    }

  location ^~ /api/v1/payments {
        proxy_pass http://tqazsvlubnagw.tqcorp.com:9211/api/v1/payments;
    }

### SSL cert files

    ssl_certificate /etc/ssl/certs/certificate.crt;
    ssl_certificate_key /etc/ssl/certs/private.key;

}
```