#!/bin/sh -e

mysql(){
  host=`echo $1 | cut -d '/' -f 3 | cut -d '@' -f 2`
  wait_for_service $host '3306'
}

wait_for_service(){
  SERVICE=`echo $1 | grep ':' || echo $1:$2 `
  until nc -vz $SERVICE > /dev/null; do
    >&2 echo "$SERVICE is unavailable"
    sleep 2
  done
  >&2 echo "$SERVICE is available"
}

wait_for(){
  for var in "$@"
  do
    service_name=`echo $var | cut -d ':' -f1`
    service_url_var=`echo $var | cut -d ':' -f2`
    service_url=`printenv | grep $service_url_var | cut -d '=' -f2-`
    if [ -z $service_url ]; then
      echo "skipping wait for $service_name due to missing configs"
    else
      case $service_name in
        mysql) mysql $service_url ;;
      esac
    fi
  done
}

case $1 in
  wait_for)
    shift
    wait_for "$@"
  ;;

  *) exec "$@" ;;
esac

exit 0
