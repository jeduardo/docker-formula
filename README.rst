======
Docker
======

A simple formula to install and manage the Docker daemon, compatible with the new
way Docker structures their packages. 

.. note::

    See the full `Salt Formulas installation and usage instructions
    <http://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html>`_.

Available states
================

.. contents::
    :local:

``docker``
----------

Install, configure, and run Docker daemon


Compatibility
=============

This formula was developed and tested targeting only Debian Stretch systems.

Testing
=======

Testing is done with `Test Kitchen <http://kitchen.ci/>`_
for machine setup and `testinfra <https://testinfra.readthedocs.io/en/latest/>`_
for integration tests.

Requirements
------------

* Python
* Ruby
* Docker

::

    gem install bundler
    bundle install
    kitchen test
