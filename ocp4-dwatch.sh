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
	get_options
	check_for_kmsg
	setup_sysctls

	echo "Watching for D-state pids in kernel ring buffer..."
	parse_dmesg
}

function get_options()
{
	if [ -z "$PROCPATH" ]
	then
		PROCPATH="/hostproc"
	fi

	if [ -z "$INTERVAL" ]
	then
		INTERVAL="10"
	fi

	if [ -z "$KERNEL_HUNG_TASK_WARNINGS" ]
	then
		KERNEL_HUNG_TASK_WARNINGS=50
	fi

	if [ -z "$KERNEL_HUNG_TASK_TIMEOUT" ]
	then
		KERNEL_HUNG_TASK_TIMEOUT=10
	fi
}

function check_for_kmsg()
{
	if [ -f "/dev/kmsg" ]
	then
		echo "No /dev/kmsg exposed to container, exiting."
		exit
	fi
}

function setup_sysctls()
{
	echo "Setting kernel.hung_task_warnings to $KERNEL_HUNG_TASK_WARNINGS..."
	echo "$KERNEL_HUNG_TASK_WARNINGS" > $PROCPATH/sys/kernel/hung_task_warnings
	if [ $? != 0 ]
	then
		echo "Failed to set $PROCPATH/sys/kernel/hung_task_warnings, exiting."
		echo "Is the procMount applied properly to the container?"
		exit
	fi

	echo "Setting kernel.hung_task_timeout_secs to $KERNEL_HUNG_TASK_TIMEOUT..."
	echo "$KERNEL_HUNG_TASK_TIMEOUT" > $PROCPATH/sys/kernel/hung_task_timeout_secs
	if [ $? != 0 ]
	then
		echo "Failed to set $PROCPATH/sys/kernel/hung_task_timeout_secs, exiting."
		echo "Is the procMount applied properly to the container?"
		exit
	fi
}

function parse_dmesg()
{
        OLDEST_DATE="0"
        while true
        do
                DMESG=$(dmesg --time-format iso)

		# Avoid subprocess piping here to preserve variables
                while read LINE
                do
                        # Ignore empty lines
                        if [ -z "$LINE" ]
                        then
                                break
                        fi

                        # Get the date of the current line
                        NEWER_DATE="$(date --date="$(echo "$LINE" | cut -d\  -f1)" +%s.%N)"

                        # Check if the new timestamp of logs is greater than the old one
                        if [ 1 -eq "$(echo "${OLDEST_DATE} < ${NEWER_DATE}" | bc)" ]
                        then
                                # Make sure it's a hung task
                                #if [ ]
                                #then
                                #        echo "$LINE"
                                #fi
                                echo "$LINE"
                                # Set the current oldest date to this line
                                OLDEST_DATE="$NEWER_DATE"
                        fi
                done < <(echo "$DMESG")

                sleep $INTERVAL
        done
}

main
