template-javaee
===============


This is the simple template for Java EE project that uses maven, EJB, JPA, JAX-RS, MySQL 5.6, GlassFish4.0.
The template focuses on organizing files and configuring project using xml files.


# Tested environment
- Ubuntu 12.10
- Glassfish 4.0 build 86
- Mysql 5.6.13
- Mysql db: Character set - utf8, collation - utf8-unicode-ci

Preferable, but not mandatory: put into the GF4.0 folder latest stable JPA Eclipse libraries


# How to use
To apply template you need:
- checkout project
- check all //todo
- create file "glassfishpass"
- create database and database user
- execute "mvn package" inside folder "app-aggreagtor"
- execute "mvn glassfish:create-domain" inside folder "app-ear"
- execute "mvn glassfish:start-domain" inside folder "app-ear"
- execute "mvn glassfish:deploy" inside folder "app-ear"


# IntelliJ IDEA settings
If you use IntelliJ IDEA you need to setup JPA for module "controller":
- open project settings
- add facet "JPA" to the module "controller"
- configure new facet: add "persistence.xml" from the module "app-config"


# How to
To deal with service make POST request:
- add header "Content-Type application/json"
- add body {"firstName":"Jack","lastName":"Smith"}
- send call to http://localhost:7080/rest/api/user/persist
