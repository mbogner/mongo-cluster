#!/bin/bash
docker stop `docker ps | awk '{print $1}' | grep -v CONTAINER` >>/dev/null 2>&1
docker system prune -f --volumes >>/dev/null 2>&1