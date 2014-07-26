
{% from "shorewall/map.jinja" import shorewall with context %}

shorewall:
  pkg:
    - installed
    - name: {{ shorewall.pkg }}
  service:
    - running
    - name: {{ shorewall.service }}
    - enable: True

{% set filenames = [
    'shorewall.conf',
    'zones',
    'interfaces',
    'policy',
    'rules',
    'masq',
] %}

{% for filename in filenames %}
/etc/shorewall/{{ filename }}:
  file.managed:
    - source: salt://shorewall/templates/{{ filename }}.jinja2
    - user: root
    - group: root
    - mode: 0644
    - template: jinja
    - context: {{ salt['pillar.get']('shorewall') }}

{% endfor %}

{% from "shorewall/map.jinja" import shorewall6 with context %}

shorewall6:
  pkg:
    - installed
    - name: {{ shorewall6.pkg }}
  service:
    - running
    - name: {{ shorewall6.service }}
    - enable: True
