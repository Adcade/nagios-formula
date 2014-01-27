{% from "nagios/nrpe/map.jinja" import map with context %}

{{ map.pkg_name }}:
  pkg:
    - installed
    - pkgs: {{ map.pkgs|json }}
  service:
    - running
    - name: {{ map.service }}
    - enable: true
{% if not grains['os_family'] == 'Debian' %}
  group:
    - present
    - name: {{ map.user_name }}
    - gid: {{ map.gid }}
    - system: true
  user:
    - present
    - name: {{ map.user_name }}
    - shell: /bin/false
    - home: {{ map.user_home }}
    - uid: {{ map.uid }}
    - guid: {{ map.gid }}
    - groups:
      - {{ map.user_name }}
{% endif %}

/etc/{{ map.pkg_name }}:
  file:
    - recurse
    - source: salt://nagios/nrpe/files
    - template: jinja
    - watch_in:
      - service: {{ map.service }}
    - user: {{ map.user_name }}
    - group: {{ map.user_name }}
