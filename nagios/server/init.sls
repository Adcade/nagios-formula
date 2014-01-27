{% from "nagios/server/map.jinja" import map with context %}

{{ map.pkg_name }}:
  pkg:
    - installed
    - pkgs: {{ map.pkgs }}
  service:
    - running
    - name: {{ map.service }}
    - enable: true

/etc/{{ map.pkg_name }}:
  file:
    - recurse
    - source: salt://nagios/server/files
    - template: jinja
    - watch_in:
      - service: {{ map.service }}
    - user: {{ map.user_name }}
    - group: {{ map.user_name }}

/var/nagios/nagios.log:
  file.managed:
    - user: root
    - group: {{ map.user_name }}
    - mode: 660

