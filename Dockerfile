FROM busybox

COPY ./entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]

CMD ["sh"]
