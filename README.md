# ocp4-dwatch
Watch for D-State process on Red Hat OpenShift 4 clusters and log them

# About
The ocp4-dwatch utility runs as a DaemonSet across your OpenShift 4.X cluster, and logs any occurances of D-state processes by monitoring `/dev/kmsg` as well as setting sysctls appropriate for produccing more logging.  It prints stacks and logs as appropriate to the pod logs.

If you have other tools watching `dmesg` or `/dev/kmsg`, this tool clears the kernel ring buffer and likely will produce erratic results to other log aggregators.  It runs as a privelged container, with full access to /proc and /dev/kmsg, and with root access to the node.

This is a debugging tool provided without warranty.  It offers no support from Red Hat or any other official source.  Please use at your own risk.

# Deploy on a Red Hat OpenShift 4.X cluster
- Assuming you have set values as desired in the `ocp4-dwatch-deploy.yaml` file, create resources with:
```
$ oc create -f ocp4-dwatch-deploy.yaml
namespace/ocp4-dwatch created
serviceaccount/ocp4-dwatch-sa created
securitycontextconstraints.security.openshift.io/ocp4-dwatch-scc created
daemonset.apps/ocp4-dwatch-ds created
```

# Remove from a Red Hat OpenShift 4.X cluster
- To remove all resources relating to `ocp4-dwatch` on your cluster, assuming you deployed with the above instructions, run:
```
$ oc delete all -l=app=ocp4-dwatch; oc delete scc ocp4-dwatch-scc; oc delete sa ocp4-dwatch-sa; oc delete project ocp4-dwatch
pod "ocp4-dwatch-ds-2q9c4" deleted
pod "ocp4-dwatch-ds-nc74k" deleted
securitycontextconstraints.security.openshift.io "ocp4-dwatch-scc" deleted
serviceaccount "ocp4-dwatch-sa" deleted
project.project.openshift.io "ocp4-dwatch" deleted
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
