[buildout]
extends =
    config/base.cfg
    custom.cfg
[instance]
http-address = 8120

[settings]
solr_port = 8131
zeo_address = ${buildout:directory}/components/zeo/var/zeo.socket
