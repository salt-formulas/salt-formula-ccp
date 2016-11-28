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
  - watch:
    - git: ccp_source

{%- endif %}

{%- load_yaml as base_config %}
configs:
  cron:
    rotate:
      days: 6
      interval: daily
      maxsize: 100M
      minsize: 1M
  ingress:
    domain: external
    enabled: false
    port: 8443
  k8s_external_ip: {{ control.kubernetes.external_address }}
  namespace: {{ control.get('namespace', 'ccp') }}
  openstack:
    project_name: admin
    role_name: admin
    user_name: admin
    user_password: {{ control.identity.admin_password }}
  private_interface: {{ control.private_interface }}
  public_interface: {{ control.public_interface }}
  snap:
    log_level: 3
{%- endload %}

{%- set configs = base_config.configs %}
{%- set files = {} %}
{%- set repos = {} %}
{%- set url = {} %}

{%- for service in control.services %}

{%- set fragment_file = 'ccp/files/configs/'+service_name+'/.yml' %}
{%- macro load_grains_file() %}{% include fragment_file ignore missing %}{% endmacro %}
{%- set service_yaml = load_grains_file()|load_yaml %}

{%- if service_yaml.configs is defined and service_yaml.configs is mapping %}
{%- do configs.update(service_yaml.configs) %}
{%- endif %}

{%- if service_yaml.repos is defined and service_yaml.repos is mapping %}
{%- do repos.update(service_yaml.repos) %}
{%- endif %}

{%- if service_yaml.files is defined and service_yaml.files is mapping %}
{%- do files.update(service_yaml.files) %}
{%- endif %}

{%- if service_yaml.url is defined and service_yaml.url is mapping %}
{%- do url.update(service_yaml.url) %}
{%- endif %}

{%- endfor %}

ccp_config:
  file.managed:
  - name: {{ control.dir.base }}/.ccp.yaml
  - source: salt://ccp/files/ccp.yaml
  - template: jinja
  - user: ccp
  - mode: 600
  - defaults:
      configs: {{ configs }}
      files: {{ files }}
      repos: {{ repos }}
      url: {{ url }}
  - require:
    - file: ccp_config_dir

{%- endif %}
x