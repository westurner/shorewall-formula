
{% from "shorewall/map.jinja" import shorewall with context %}

shorewall:
  pkg:
    - installed
    - name: {{ shorewall.pkg }}
  service:
    - running
    - name: {{ shorewall.service }}
    - enable: True
    - require:
      - file: /etc/shorewall

{% set filenames = [
    'shorewall.conf',
    'zones',
    'interfaces',
    'policy',
    'rules',
    'masq',
] %}

/etc/shorewall:
  file.directory:
    - user: root
    - group: root
    - dir_mode: 0755

{% for filename in filenames %}
{% set salt_path="salt://shorewall/templates/{0}.jinja2".format(filename) %}
{% set file_src=salt['pillar.get']('shorewall:conf_paths:{0}'.format(filename), salt_path) %}
/etc/shorewall/{{ filename }}:
  file.managed:
    - source: {{ file_src }}
    - user: root
    - group: root
    - mode: 0644
    - template: jinja
    - context: {{ salt['pillar.get']('shorewall') }}
    - require:
      - file: /etc/shorewall
    # Restart shorewall when config files change
    - onchanges:
      - service: shorewall
{% endfor %}


{% from "shorewall/map.jinja" import shorewall6 with context %}
{# Reference:
  - http://shorewall.net/IPv6Support.html
#}
shorewall6:
  pkg:
    - installed
    - name: {{ shorewall6.pkg }}
  service:
    - running
    - name: {{ shorewall6.service }}
    - enable: True

/etc/shorewall6:
  file.directory:
    - user: root
    - group: root
    - dir_mode: 0755

{% for filename in filenames %}
/etc/shorewall6/{{ filename }}:
  file.managed:
    - source: salt://shorewall/templates/{{ filename }}.jinja2
    - user: root
    - group: root
    - mode: 0644
    - template: jinja
    - context: {{ salt['pillar.get']('shorewall') }}
    - require:
      - file: /etc/shorewall6
    - onchanges:
      - service: shorewall
{% endfor %}
