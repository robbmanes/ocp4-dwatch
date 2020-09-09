# ocp4-dwatch
Watch for D-State process on Red Hat OpenShift 4 clusters and log them

# About
The ocp4-dwatch utility runs as a DaemonSet across your OpenShift 4.X cluster, and logs any occurances of D-state processes by monitoring /proc/sched_debug.  It prints stacks and wait channels as appropriate to the container logs.

This is a debugging tool provided without warranty.  It offers no support from Red Hat or any other official source.  Please use at your own risk.

# Deploy on a Red Hat OpenShift 4.X cluster
- Create a new security context:
```
$ oc create -f dwatch-scc.yaml
securitycontextconstraints.security.openshift.io/ocp4-dwatch created
```

- Create the hostPath PV:
```
$ oc create -f proc_pv.yaml
persistentvolume/ocp4-dwatch-pv created
```

- Create the hostPath PVC:
```
$ oc create -f proc_pvc.yaml
persistentvolumeclaim/ocp4-dwatch-proc-pvc created
```

- Create the DaemonSet:
```
$ oc create -f dwatch-daemonset.yaml
daemonset.apps/ocp4-dwatch created
```

# License
    Copyright 2020 Robert Thomas Manes <robbmanes@protonmail.com>

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

      http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
