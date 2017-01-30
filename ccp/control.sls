{%- from "ccp/map.jinja" import control with context %}
{%- if control.enabled %}

ccp_packages:
  pkg.installed:
  - names: {{ control.pkgs }}

{{ control.dir.base }}:
  virtualenv.manage:
  - python: /usr/bin/python3
  - require:
    - pkg: ccp_packages

ccp_user:
  user.present:
  - name: ccp
  - system: true
  - home: {{ control.dir.base }}
  - groups:
    - docker
  - require:
    - virtualenv: {{ control.dir.base }}

ccp_repos_dir:
  file.directory:
  - names:
    - {{ control.dir.base }}/repos/
  - mode: 755
  - makedirs: true
  - user: ccp
  - require:
    - user: ccp_user

ccp_ssh_dir:
  file.directory:
  - names:
    - {{ control.dir.base }}/.ssh/
  - mode: 700
  - makedirs: true
  - user: ccp
  - require:
    - user: ccp_user

ccp_ssh_key:
  cmd.run:
  - name: ssh-keygen -q -N '' -f /srv/ccp/.ssh/id_rsa
  - user: ccp
  - unless: test -f /srv/ccp/.ssh/id_rsa
  - require:
    - file: ccp_ssh_dir

ccp_log_dir:
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
  - target: {{ control.dir.base }}/fuel_ccp
  - rev: {{ control.source.revision|default(control.source.branch) }}
  {%- if grains.saltversion >= "2015.8.0" %}
  - branch: {{ control.source.branch|default(control.source.revision) }}
  {%- endif %}
  - force_reset: {{ control.source.force_reset|default(False) }}

ccp_install:
  cmd.watch:
  - name: {{ control.dir.base }}/bin/pip install {{ control.dir.base }}/fuel_ccp
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
    - virtualenv: {{ control.dir.base }}

ccp_validate:
  cmd.watch:
  - name: {{ control.dir.base }}/bin/ccp validate
  - user: ccp
  - watch:
    - file: ccp_config
  - require:
    - cmd: ccp_ssh_key

{%- endif %}
