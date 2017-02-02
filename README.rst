
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

Documentation and Bugs
======================

To learn how to install and update salt-formulas, consult the documentation
available online at:

    http://salt-formulas.readthedocs.io/

In the unfortunate event that bugs are discovered, they should be reported to
the appropriate issue tracker. Use Github issue tracker for specific salt
formula:

    https://github.com/salt-formulas/salt-formula-ccp/issues

For feature requests, bug reports or blueprints affecting entire ecosystem,
use Launchpad salt-formulas project:

    https://launchpad.net/salt-formulas

You can also join salt-formulas-users team and subscribe to mailing list:

    https://launchpad.net/~salt-formulas-users

Developers wishing to work on the salt-formulas projects should always base
their work on master branch and submit pull request against specific formula.

    https://github.com/salt-formulas/salt-formula-ccp

Any questions or feedback is always welcome so feel free to join our IRC
channel:

    #salt-formulas @ irc.freenode.net
