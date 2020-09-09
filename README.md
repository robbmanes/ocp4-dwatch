# ocp4-dwatch
Watch for D-State process on Red Hat OpenShift 4 clusters and log them

# About
The ocp4-dwatch utility runs as a DaemonSet across your OpenShift 4.X cluster, and logs any occurances of D-state processes by monitoring `/dev/kmsg` as well as setting sysctls appropriate for produccing more logging.  It prints stacks and logs as appropriate to the pod logs.

If you have other tools watching `dmesg` or `/dev/kmsg`, this tool clears the kernel ring buffer and likely will produce erratic results to other log aggregators.  It runs as a privelged container, with full access to /proc and /dev/kmsg, and with root access to the node.

This is a debugging tool provided without warranty.  It offers no support from Red Hat or any other official source.  Please use at your own risk.

# Deploy on a Red Hat OpenShift 4.X cluster
- Create the namespace:
```
$ oc create -f ocp4-dwatch-namespace.yaml
namespace/ocp4-dwatch created
```

- Create a new ServiceAccount:
```
$ oc create serviceaccount ocp4-dwatch -n ocp4-dwatch
```

- Grant priveleges to the ServiceAccount:
```
$ oc adm policy add-scc-to-user privileged -z ocp4-dwatch -n ocp4-dwatch
```

- Create the hostPath PV's required:
```
$ oc create -f ocp4-dwatch-pv.yaml
persistentvolume/ocp4-dwatch-pv created
```

- Create the hostPath PVC's required:
```
$ oc create -f ocp4-dwatch-pvc.yaml
persistentvolumeclaim/ocp4-dwatch-proc-pvc created
```

- Create the DaemonSet:
```
$ oc create -f ocp4-dwatch-daemonset.yaml
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
