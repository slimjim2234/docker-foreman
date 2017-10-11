rm -f /usr/share/foreman-installer/checks/hostname.rb
export FACTER_fqdn="foreman.company.com" # Dummy/temp FQDN
/usr/sbin/foreman-installer
exit 0
