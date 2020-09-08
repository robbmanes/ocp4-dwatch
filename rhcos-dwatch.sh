#!/bin/bash

trap signal EXIT
trap signal SIGINT

function signal()
{
	echo "Exited due to signal recieved."
	exit
}

function main()
{
	HOST=$(hostname)
	echo "Watching for D-state pids in /proc/sched_debug..."
	while true
	do
		check_sched_debug
		parse_sched_debug		
		sleep 10
	done
}

function check_sched_debug()
{
	if [ ! -f /proc/sched_debug ]
	then
		echo "/proc/sched_debug is not accessible, exiting."
		exit
	fi
	if ! cat /proc/sched_debug >> /dev/null
	then
		echo "Cannot read /proc/sched_debug, exiting."
		exit
	fi
}

function parse_sched_debug()
{
	echo "$(date) - $HOST"
	/usr/bin/awk '/^\ D/' /proc/sched_debug | while read LINE
	do
		# do this ASAP, the condition may clear!
		PID=$(echo $LINE | awk '{print $3}')
		STACK=$(cat /proc/$PID/stack)
		WCHAN=$(cat /proc/$PID/wchan)

		# the rest is less pressing
		COMM=$(echo $LINE | awk '{print $2}')
		echo "comm=$COMM, pid=$PID, wchan=$WCHAN"
		while IFS= read line
		do
			echo "	$line"
		done < <(printf '%s\n' "$STACK")
	done	
	echo ""
}

main