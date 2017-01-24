{%- from "ccp/map.jinja" import control with context %}
{%- if control.enabled %}

ccp_packages:
  pkg.installed:
  - names: {{ control.pkgs }}

{{ control.dir.base }}:
  virtualenv.manage:
  - system_site_packages: True
  - requirements: salt://ccp/files/requirements.txt
  - python: /usr/bin/python3
  - require:
    - pkg: ccp_packages

ccp_user:
  user.present:
  - name: ccp
  - system: true
  - shell: /bin/bash
  - home: {{ control.dir.base }}
  - groups:
    - docker
  - require:
    - virtualenv: {{ control.dir.base }}

ccp_dir:
  file.directory:
  - names:
    - /var/log/ccp
  - mode: 700
  - makedirs: true
  - user: ccp
  - require:
    - virtualenv: {{ control.dir.base }}

{%- if control.source.engine == 'git' %}

ccp_source:
  git.latest:
  - name: {{ control.source.address }}
  - target: {{ control.dir.base }}/fuel
  - rev: {{ control.source.revision|default(control.source.branch) }}
  {%- if grains.saltversion >= "2015.8.0" %}
  - branch: {{ control.source.branch|default(control.source.revision) }}
  {%- endif %}
  - force_reset: {{ control.source.force_reset|default(False) }}

ccp_install:
  cmd.watch:
  - name: . {{ control.dir.base }}/bin/activate; python setup.py install
  - cwd: {{ control.dir.base }}/fuel
  - watch:
    - git: ccp_source

{%- endif %}

ccp_config:
  file.managed:
  - name: {{ control.dir.base }}/.ccp.yaml
  - source: salt://ccp/files/ccp.yaml
  - template: jinja
  - user: ccp
  - mode: 600
  - require:
    - file: ccp_dir

{%- endif %}
