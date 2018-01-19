#!/bin/bash

function exit_error() {
    exit 1
}

function usage() {
    echo "usage:  `basename "$0"` <options>"
    echo "  -b              S3 bucket name"
    echo "  -h              Print this usage and exit"

  if [[ $# == 0 ]]; then exit 1;
  else exit $1
  fi
}

# Read cmd line arguments
while [ $# -gt 0 ]; do
    case "$1" in
        -b)
            bucket=$2
            shift 2
            ;;
        -h)
          usage 0
          ;;
        *)
        usage
        ;;
    esac
done

if [[ "$bucket" == "" ]]
then
  usage
  exit_error
fi

# check for local changes
if [[ "`git status -s | grep -v scripts | wc -l`" -ne "0" ]]
then
  echo "Error: commit local changes first"
  exit 1
fi

aws s3 sync service-init-scripts s3://${bucket}/
aws s3 sync bootstrap-scripts s3://${bucket}/
