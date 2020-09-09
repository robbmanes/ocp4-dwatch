FROM registry.fedoraproject.org/fedora-minimal
COPY ocp4-dwatch.sh /root/ocp4-dwatch.sh
CMD ["/root/ocp4-dwatch.sh"]
