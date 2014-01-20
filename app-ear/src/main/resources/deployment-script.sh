#!/bin/sh

#--------------------------------------------------------------------------------------------------------------
#----- Deployment from scratch
#----- Used to deploy app on remote server. For dev local server, please, use maven-glassfish-plugin
#----- Script creates work folder, new Glassfish domain and deploys ear artifact
#--------------------------------------------------------------------------------------------------------------

#--------------------------------------------------
#----- Settings
#--------------------------------------------------
EARPATH='/home/${project.settings.ear.finalName}'           #Set path to the ear file
GFADMINPASS='qwerty'                                        #Set glassfish admin password

DOMAINNAME='${project.settings.glassfish.domainName}'
GFAPPNAME='${project.settings.ear.applicationName}'

LOGFOLDER='${project.settings.logger.folder}'

GFHOME='${project.settings.glassfish.homeDir}'
ASADMIN="${project.settings.glassfish.homeDir}/bin/asadmin"
DOMAINDIR="${project.settings.glassfish.homeDir}/domains"
PASSFILE="${project.settings.glassfish.passwordFile}"

PORTADMIN='${project.settings.glassfish.adminPort}'
PORTHTTP='${project.settings.glassfish.httpPort}'
PORTHTTPS='${project.settings.glassfish.httpsPort}'
PORTJMS='${project.settings.glassfish.jmsPort}'
PORTIIOP='${project.settings.glassfish.iiopPort}'
PORTIIOPSSL='${project.settings.glassfish.iiopSslPort}'
PORTIIOPMUTUALAUTH='${project.settings.glassfish.iiopMutualauthPort}'
PORTJMX='${project.settings.glassfish.jmxAdminPort}'
PORTOSGISHELL='${project.settings.glassfish.osgiShellPort}'
PORTDEBUGGER='${project.settings.glassfish.javaDebuggerPort}'

DBNAME='${project.settings.jdbc.databaseName}'
DBUSER='${project.settings.jdbc.user}'
DBPASS='${project.settings.jdbc.password}'

DATASOURCE='${project.settings.jdbc.dataSource.name}'
POOLNAME='${project.settings.jdbc.dataSource.poolName}'
POOLDESCRIPTION='${project.settings.jdbc.dataSource.description}'

#--------------------------------------------------
#----- Create log folder
#--------------------------------------------------
mkdir -p $LOGFOLDER

#--------------------------------------------------
#----- Create Glassfish passwordfile
#--------------------------------------------------
if [ ! -f $PASSFILE ]; then
echo "AS_ADMIN_MASTERPASSWORD=changeit
AS_ADMIN_PASSWORD=$GFADMINPASS" > $PASSFILE
fi

#--------------------------------------------------
#----- Create domain
#----- http://docs.oracle.com/cd/E19575-01/821-0179/create-domain-1/index.html
#--------------------------------------------------
$ASADMIN --host localhost --port 4848 --user admin --passwordfile $PASSFILE --interactive=false --echo=true --terse=true create-domain --domaindir $DOMAINDIR --savemasterpassword=false --usemasterpassword=false --adminport $PORTADMIN --instanceport $PORTHTTP --domainproperties http.ssl.port=$PORTHTTPS:java.debugger.port=$PORTDEBUGGER:jms.port=$PORTJMS:domain.jmxPort=$PORTJMX:orb.listener.port=$PORTIIOP:orb.mutualauth.port=$PORTIIOPMUTUALAUTH:orb.ssl.port=$PORTIIOPSSL:osgi.shell.telnet.port=$PORTOSGISHELL --savelogin=false --nopassword=false --checkports=true $DOMAINNAME
echo ""

#Start domain
$ASADMIN --host localhost --port 4848 --user admin --passwordfile $PASSFILE --interactive=false --echo=true --terse=true start-domain --verbose=false --upgrade=false --debug=true --_dry-run=false --domaindir $DOMAINDIR $DOMAINNAME
echo ""

#--------------------------------------------------
#----- Add JVM option to domain
#----- http://docs.oracle.com/cd/E18930_01/html/821-2433/create-jvm-options-1.html
#--------------------------------------------------
$ASADMIN --host localhost --port $PORTADMIN --user admin --passwordfile $PASSFILE --interactive=false --echo=true --terse=true create-jvm-options --target server "\\-Dcom.sun.jersey.server.impl.cdi.lookupExtensionInBeanManager=true"
echo ""

#Restart domain
$ASADMIN --host localhost --port 4848 --interactive=false --echo=true --terse=true restart-domain --force=true --kill=false --domaindir $DOMAINDIR $DOMAINNAME
echo ""

#--------------------------------------------------
#----- Configure DB Resources
#----- http://docs.oracle.com/cd/E19683-01/816-6443/6mch3fo6p/index.html
#----- http://docs.oracle.com/cd/E19776-01/820-4497/6nfv6jlj0/index.html
#--------------------------------------------------
#Create JDBC connection pool
$ASADMIN --host localhost --port $PORTADMIN --user admin --passwordfile $PASSFILE --interactive=false --echo=true --terse=true create-jdbc-connection-pool --datasourceclassname com.mysql.jdbc.jdbc2.optional.MysqlConnectionPoolDataSource --restype javax.sql.ConnectionPoolDataSource --steadypoolsize 5 --maxpoolsize 50 --maxwait 60000 --poolresize 2 --idletimeout 300 --isisolationguaranteed=true --isconnectvalidatereq=true --validationmethod meta-data --failconnection=false --allownoncomponentcallers=false --nontransactionalconnections=false --validateatmostonceperiod 0 --leaktimeout 0 --leakreclaim=false --creationretryattempts 0 --creationretryinterval 10 --statementtimeout -1 --statementleaktimeout 0 --statementleakreclaim=false --lazyconnectionenlistment=false --lazyconnectionassociation=false --associatewiththread=false --matchconnections=false --maxconnectionusagecount 0 --ping=false --pooling=true --statementcachesize 0 --wrapjdbcobjects=true --description "$POOLDESCRIPTION" --property databaseName=$DBNAME:serverName=localhost:portNumber=3306:password=$DBPASS:user=$DBUSER $POOLNAME
echo ""

#Create JDBC resource
$ASADMIN --host localhost --port $PORTADMIN --user admin --passwordfile $PASSFILE --interactive=false --echo=true --terse=true create-jdbc-resource --connectionpoolid $POOLNAME --enabled=true $DATASOURCE
echo ""

#Restart domain
$ASADMIN --host localhost --port 4848 --interactive=false --echo=true --terse=true restart-domain --force=true --kill=false --domaindir $DOMAINDIR $DOMAINNAME
echo ""

#--------------------------------------------------
#----- Deploy ear file
#----- http://docs.oracle.com/cd/E18930_01/html/821-2433/deploy-1.html
#--------------------------------------------------
$ASADMIN --host localhost --port $PORTADMIN --user admin --passwordfile $PASSFILE --interactive=false --echo=true --terse=true deploy --name $GFAPPNAME --force=false --precompilejsp=false --verify=false --generatermistubs=false --availabilityenabled=false --asyncreplication=true --keepreposdir=false --keepfailedstubs=false --isredeploy=false --logreportederrors=true --upload=false $EARPATH
