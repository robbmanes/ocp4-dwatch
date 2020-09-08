FROM registry.fedoraproject.org/fedora-minimal
COPY rhcos-dwatch.sh /root/rhcos-dwatch.sh
CMD ["/root/rhcos-dwatch.sh"]
