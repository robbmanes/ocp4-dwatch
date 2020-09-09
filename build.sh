#!/bin/bash
REGISTRY=quay.io
REPO=robbmanes
IMAGE_NAME=rhcos-dwatch
VERSION=v1


COMMAND=""

if ! command -v buildah &> /dev/null
then
	if ! command -v podman &> /dev/null
	then
		if ! command -v docker &> /dev/null
		then
			echo "No buildah, podman, or Docker present for build.  Exiting."
			exit
		else
			COMMAND="docker"
		fi
	else
		COMMAND="podman"
	fi
else
	COMMAND="buildah"
fi

if [ $COMMAND == "buildah" ]
then
	$COMMAND bud -t $REGISTRY/$REPO/$IMAGE_NAME:$VERSION .
elif [ $COMMAND == "podman" || $COMMAND == "docker" ]
then
	$COMMAND build -t $REGISTRY/$REPO/$IMAGE_NAME:$VERSION .
fi
