
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

Read more
=========

* http://fuel-ccp.readthedocs.io/en/latest/quickstart.html
