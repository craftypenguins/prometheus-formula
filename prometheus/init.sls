{% from "prometheus/map.jinja" import prometheus with context %}

prometheus:
  pkg.installed:
    - refresh: True
    - pkgs:
      {{ prometheus.pkgs | yaml(False) | indent(6) }}

prometheus_defaults_config:
  file.managed:
    - name: /etc/default/prometheus
    - source: salt://prometheus/templates/prometheus.default
    - template: jinja
    - require:
      - pkg: prometheus

prometheus_rules_dir:
  file.directory:
    - name: /etc/prometheus/rules.d
    - user: prometheus
    - group: prometheus
    - dirmode: 644
    - require:
      - pkg: prometheus

prometheus_service:
  service.running:
    - name: prometheus
    - enable: True
    - require:
      - pkg: prometheus
    - watch:
      - file: prometheus_defaults_config
      - file: /etc/prometheus/prometheus.yml_file
