Copy the previously generated key and certificate files to the location where default certificates are saved.
```
cp rui.crt rui.key /opt/vmware-shd/vmware-shd/conf/ssl/
```
Restart the web server by running ```systemctl restart nginx```