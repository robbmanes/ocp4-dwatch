FROM registry.fedoraproject.org/fedora-minimal
COPY rhcos-dwatch.sh /root/rhcos-dwatch
CMD ["/root/rhcos-dwatch.sh"]
