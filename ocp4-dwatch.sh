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
	PROCPATH="/hostproc"
	INTERVAL="10"
	HOST=$(uname -n)
	KERNEL_HUNG_TASK_WARNINGS=50
	KERNEL_HUNG_TASK_TIMEOUT=10

	check_for_kmsg
	setup_sysctls

	echo "Watching for D-state pids in kernel ring buffer..."
	parse_dmesg
}

function check_for_kmsg()
{
	if [ ! -z /dev/kmsg ]
	then
		echo "No /dev/kmsg exposed to container, exiting."
		exit
	fi
}

function setup_sysctls()
{
	echo $KERNEL_HUNG_TASK_WARNINGS > $PROCPATH/sys/kernel/hung_task_warnings
	if [ $? != 0 ]
	then
		echo "Failed to set $PROCPATH/sys/kernel/hung_task_warnings, exiting."
		echo "Is the procMount applied properly to the container?"
		exit
	fi

	echo $KERNEL_HUNG_TASK_TIMEOUT=10
	if [ $? != 0 ]
	then
		echo "Failed to set $PROCPATH/sys/kernel/hung_task_timeout, exiting."
		echo "Is the procMount applied properly to the container?"
		exit
	fi
}

function parse_dmesg()
{
	while true
	do
		# this clears the buffer!!!
		dmesg -cT | while read LINE
		do
			if [ -z "$LINE" ]
			then
				continue
			fi

			echo "$(date) - $HOST"
			echo "$LINE"
		done	
		sleep $INTERVAL
	done
}

main
