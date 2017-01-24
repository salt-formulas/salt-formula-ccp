{%- from "ccp/map.jinja" import control with context %}
{%- if control.enabled %}

ccp_packages:
  pkg.installed:
  - names: {{ control.pkgs }}

ccp_user:
  user.present:
  - name: ccp
  - system: true
  - shell: /bin/bash
  - home: {{ control.dir.base }}
  - groups:
    - docker

ccp_dir:
  file.directory:
  - names:
    - /var/log/ccp
  - mode: 700
  - makedirs: true
  - user: ccp
  - require:
    - user: ccp_user

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

ccp_venv:
  virtualenv.manage:
  - name: {{ control.dir.base }}/venv
  - system_site_packages: True
  - requirements: {{ control.dir.base }}/fuel/requirements.txt
  - python: /usr/bin/python3
  - require:
    - git: ccp_source

ccp_install:
  cmd.watch:
  - name: . {{ control.dir.base }}/venv/bin/activate; python setup.py install
  - cwd: {{ control.dir.base }}/fuel
  - require:
    - virtualenv: ccp_venv
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
