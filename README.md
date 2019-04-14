# nginx_errors_sh

example howto run:
```
./nginx50x.sh type 502 /var/log/nginx/access.log servicename

```

howto add cron task(every 5 min):
```
*/5 * * * * /path/to/nginx50x.sh
```
