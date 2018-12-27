{% from slspath + "/map.jinja" import docker %}

deploy required packages for docker:
  pkg.installed:
  - names:
    - apt-transport-https

deploy docker repository:
  pkgrepo.managed:
    - humanname: Docker Package Repository
    - name: deb [arch={{ grains['osarch'] }}] https://download.docker.com/linux/debian {{ grains['oscodename'] }} stable
    - dist: {{ grains['oscodename'] }}
    - file: /etc/apt/sources.list.d/docker.list
    - key_url: https://download.docker.com/linux/debian/gpg
    - require:
      - pkg: deploy required packages for docker

deploy docker daemon:
  pkg.installed:
    - name: {{ docker.package.name }}
    {%- if docker.package.version == 'latest' %}
    {# Do not specify a version and make sure the repository is refreshed #}
    - refresh: True
    {%- else %}
    - version: "{{ docker.package.version }}"
    {%- endif %}
    - require:
      - pkgrepo: deploy docker repository

adjust systemd service to allow parameters:
  file.replace:
    - name: /lib/systemd/system/docker.service
    - pattern: ExecStart=/usr/bin/dockerd -H fd://$
    - repl: |
        ExecStart=/usr/bin/dockerd $DOCKER_OPTS
        EnvironmentFile=/etc/default/docker
  module.run:
    - name: service.systemctl_reload
    - onchanges:
      - file: /lib/systemd/system/docker.service

deploy docker daemon config flags:
  file.managed:
    - name: /etc/default/docker
    - contents: |
      {%- for name, content in docker.environment.items() %}
        {{ name }}={{ content }}
      {%- endfor %}

restart docker daemon in case of changes:
  service.running:
    - name: docker
    - restart: True
    - watch: 
      - file: adjust systemd service to allow parameters
      - file: /etc/default/docker
    - require:
      - pkg: deploy docker daemon
