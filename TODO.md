# TODO:

- Check if redis /var/run dir is being created on system reboot.
- Create a Debian/Ubuntu branch
- Azuracast currently have about 4 instances of the base path for the url hardcoded to /var/azuracast, this could be solved pretty easily with enviroment variables.
- Figure out how to properly provide an upgrade route.
- Make sure that the following paths are created on startup:
/tmp/nginx_client
/tmp/nginx_fastcgi
/tmp/nginx_cache
