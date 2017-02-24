from ubuntu:16.04

run apt-get update
run apt-get install -q -y language-pack-ru
run update-locale LANG=ru_RU.UTF-8

run echo wpsite > /etc/hostname
add hosts /etc/hosts
run chown root:root /etc/hosts

run apt-get install -q -y vim

# Install Postfix.
run echo "postfix postfix/main_mailer_type string Internet site" > preseed.txt
run echo "postfix postfix/mailname string wpsite.ru" >> preseed.txt
# Use Mailbox format.
run debconf-set-selections preseed.txt
run DEBIAN_FRONTEND=noninteractive apt-get install -q -y postfix

run postconf -e myhostname=wpsite.ru
run postconf -e mydestination="wpsite.ru, wpsite, localhost.localdomain, localhost"
run postconf -e mail_spool_directory="/var/spool/mail/"
run postconf -e mailbox_command=""

run useradd -s /bin/bash robot
run mkdir /var/spool/mail/robot
run chown robot:mail /var/spool/mail/robot

add aliases /etc/aliases
run chown root:root /etc/aliases
run newaliases

# Use syslog-ng to get Postfix logs (rsyslog uses upstart which does not seem
# to run within Docker).
run apt-get install -q -y syslog-ng

expose 25
cmd ["sh", "-c", "service syslog-ng start ; service postfix start ; tail -F /var/log/mail.log"]
