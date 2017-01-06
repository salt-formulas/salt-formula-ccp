
=====================
Fuel CCP Salt Formula
=====================

Fuel Container based OpenStack service controller.

Sample pillars
==============

Single ccp service

.. code-block:: yaml

    ccp:
      control:
        namespace: ccp
        registry:
          enabled: true
          host: localhost:5000
          insecure: false
          password: "''"
          username: "''"
        private_interface: eth0
        public_interface: eth1
        database:
          engine: galera
          root_password: password
          xtrabackup_password: password
          monitor_password: password
        identity:
          admin_password: password
        kubernetes:
          host: api.kubernetes
          port: 8080
          #user: admin
          #password: password
          external_address: 10.50.12.21
        images:
          base_distro: debian
          base_images:
          - base
          - opencontrail-base
          base_tag: jessie
          image_specs: {}
          maintainer: MOS Microservices <mos-microservices@mirantis.com>
          namespace: ccp
          tag: newton
        services:
        - ceph
        - cinder
        - elasticsearch
        - etcd
        - galera
        - glance
        - grafana
        - heat
        - heka
        - horizon
        - influxdb
        - ironic
        - keystone
        - kibana
        - linux
        - memcached
        - murano
        - neutron
        - nova
        - opencontrail
        - openvswitch
        - rabbitmq
        - radosgw
        - sahara
        roles:
          openstack-compute:
          - nova-compute
          - nova-libvirt
          openstack-controller:
          - etcd
          - glance-api
          - glance-registry
          - heat-api
          - heat-engine
          - horizon
          - keystone
          - mariadb
          - memcached
          - neutron-dhcp-agent
          - neutron-l3-agent
          - neutron-metadata-agent
          - neutron-server
          - nova-api
          - nova-conductor
          - nova-consoleauth
          - nova-novncproxy
          - nova-scheduler
          - rabbitmq
          openvswitch:
          - neutron-openvswitch-agent
          - openvswitch-db
          - openvswitch-vswitchd
        versions:
          elasticsearch_curator_version: 4.1.0
          elasticsearch_version: 2.4.0
          etcd_version: v3.0.12
          grafana_version: 3.0.3-1463994644
          influxdb_version: 0.13.0
          kibana_version: 4.6.1

Read more
=========

* http://fuel-ccp.readthedocs.io/en/latest/quickstart.html
