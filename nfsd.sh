#!/usr/bin/env bash

set -euo pipefail

trap stop SIGTERM SIGINT

stop()
{
  echo "Terminating NFS process(es)..."
  /usr/sbin/exportfs -uav
  /usr/sbin/exportfs -fv
  /usr/sbin/rpc.nfsd 0

  kill -TERM $(pidof rpc.mountd) >/dev/null 2>&1
  exit 0
}

while ! pidof rpc.mountd >/dev/null; do
  cat /etc/exports

  echo "Starting Mountd in the background..."
  /usr/sbin/rpc.mountd

  echo "Starting NFS in the background..."
  /usr/sbin/rpc.nfsd

  echo "Exporting File System..."
  if /usr/sbin/exportfs -rv; then
    /usr/sbin/exportfs
  else
    echo "Export validation failed, exiting..."
    exit 1
  fi

  if ! pidof rpc.mountd >/dev/null; then
    echo "Startup of NFS failed, sleeping for 2s, then retrying..."
    sleep 2
  fi

done

while true; do
  if ! pidof rpc.mountd >/dev/null; then
    echo "NFS has failed, exiting, so Docker can restart the container..."
    exit 1
  fi

  sleep 1
done
