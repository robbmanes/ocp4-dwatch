# rhcos-dwatch
Watch for D-State process on Red Hat CoreOS nodes running OpenShift 4

# About
The rhcos-dwatch container runs as a DaemonSet across your OpenShift 4.X cluster, and logs any occurances of D-state processes by monitoring /proc/sched_debug.  It prints stacks and wait channels as appropriate to the container logs.

This is a debugging tool provided without warranty.  It offers no support from Red Hat or any other official source.  Please use at your own risk.

# Deploy on a Red Hat OpenShift 4.X cluster
- Create a new security context:
```
$ oc create -f dwatch-scc.yaml
securitycontextconstraints.security.openshift.io/rhcos-dwatch created
```

- Create the hostPath PV:
```
$ oc create -f proc_pv.yaml
persistentvolume/rhcos-dwatch-pv created
```

- Create the hostPath PVC:
```
$ oc create -f proc_pvc.yaml
persistentvolumeclaim/rhcos-dwatch-proc-pvc created
```

- Create the DaemonSet:
```
$ oc create -f dwatch-daemonset.yaml
daemonset.apps/rhcos-dwatch created
```
