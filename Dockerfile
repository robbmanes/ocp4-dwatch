FROM registry.fedoraproject.org/fedora-minimal
RUN microdnf install bc -y && microdnf clean all
COPY ocp4-dwatch.sh /root/ocp4-dwatch.sh
CMD ["/root/ocp4-dwatch.sh"]
