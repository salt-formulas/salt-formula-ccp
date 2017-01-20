
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
        nodes:
          'ctl':
            roles:
            - controller
            - openvswitch
          ctl0[2-3]:
            roles:
            - compute
            - openvswitch

Read more
=========

* http://fuel-ccp.readthedocs.io/en/latest/quickstart.html
