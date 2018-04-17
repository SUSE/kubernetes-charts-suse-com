# MySQL database sidecar

This chart has the following set of parameters:

|Name			|Example	|Description					|
|---			|---		|---						|
|CF_ADMIN_PASSWORD	|?		|SCF cluster admin password			|
|CF_ADMIN_USER		|admin		|SCF cluster admin user				|
|CF_CA_CERT		|?		|The SCF CA cert				|
|CF_DOMAIN		|cf-dev.io	|The SCF base domain				|
|SERVICE_LOCATION	|http://...	|Url to kube service `cf-usb-sidecar-mysql`	|
|SERVICE_MYSQL_HOST	|mysql		|The host of the mysql database to use		|
|SERVICE_MYSQL_PASS	|?		|Credentials for the user above			|
|SERVICE_MYSQL_PORT	|3306		|The port the mysql server listens on		|
|SERVICE_MYSQL_USER	|root		|User to access the mysql database		|
|SERVICE_TYPE		|mysql		|The name used to register the sidecar with SCF	|
|UAA_CA_CERT		|?		|The UAA CA cert   				|
