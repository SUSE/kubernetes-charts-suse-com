# PostgreSQL database sidecar

This chart has the following set of parameters:

|Name                       |Example        |Description                                           |
|---                        |---            |---                                                   |
|CF_ADMIN_PASSWORD          |hunter2        |SCF cluster admin password                            |
|CF_ADMIN_USER              |admin          |SCF cluster admin user                                |
|CF_CA_CERT                 |----- BEGIN... |The SCF CA cert                                       |
|CF_DOMAIN                  |cf-dev.io      |The SCF base domain                                   |
|SERVICE_LOCATION           |http://...     |URL to Kubernetes service `cf-usb-sidecar-postgresql` |
|SERVICE_POSTGRESQL_HOST    |pg-staging     |The host of the postgres database to use              |
|SERVICE_POSTGRESQL_PORT    |5432           |The port the postgres server listens on               |
|SERVICE_POSTGRESQL_SSLMODE |disable        |Connection to postgres server, one of `disable`, `require`, `verify-ca`, `verify-full`. |
|SERVICE_POSTGRESQL_USER    |root           |User to access the postgres database                  |
|SERVICE_POSTGRESQL_PASS    |hunter2        |Credentials for the user above                        |
|SERVICE_TYPE               |postgres       |The name used to register the sidecar with SCF        |
|SIDECAR_LOG_LEVEL          |debug          |Logging level; more verbose than `info` is not recommended |
|UAA_CA_CERT                |----- BEGIN... |The UAA CA certificate                                |
