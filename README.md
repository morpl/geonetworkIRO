# GeoNetwork customizations to manage International Reporting Obligations

## Database configuration

The database connection should be configured in the file `web/src/main/webapp/WEB-INF/config-overrides-geodata-props.xml`

An example, to define a database connection to a Postgres database instead of the default H2, should be changed these values in the file:

```
 <db.user>USERNAME</db.user>
 <db.pass>PASSWORD</db.pass>
 <db.driver>org.postgresql.Driver</db.driver>
 <db.url>jdbc:postgresql://localhost:5432/DATABASE_NAME</db.url>
```

Set the fields USERNAME, PASSWORD and DATABASE_NAME to your custom configuration values.


## Checkout the code


```
$ mkdir $HOME
$ git clone https://github.com/morpl/geonetworkIRO.git
$ cd geonetworkIRO
$ git submodule update --init
```

## Requirements to build GeoNetwork

* Maven 3.X
* Git
* Java JDK 1.6+

To build the documentation are required:

* Sphinx
* TeX live
* JSTools

See [additional info](http://geonetwork-opensource.org/manuals/2.10.3/eng/developer/development/index.html#user-developer-and-widget-api-documentation) to setup the tools to build the documentation.


Build GeoNetwork
================

### Without documentation

```
$ cd $HOME/geonetworkIRO
$ mvn clean install -Pgeodata
```

### With documentation

Edit the file `web/pom.xml` to uncomment the following section:

```
<!--
<resource>
  <directory>../docs/eng/users/build/html</directory>
  <targetPath>docs/eng/users</targetPath>
</resource>
<resource>
  <directory>../docs/eng/users/build/latex</directory>
  <targetPath>docs/eng/users</targetPath>
   <includes>
    <include>GeoNetworkUserManual.pdf</include>
  </includes>
</resource>
<resource>
<directory>../docs/eng/developer/build/html</directory>
  <targetPath>docs/eng/developer</targetPath>
</resource>  
<resource>
  <directory>../docs</directory>
  <targetPath>docs</targetPath>
   <includes>
	<include>changes.txt</include>
	<include>license*.html</include>
	<include>readme*.html</include>
  </includes>
</resource>
<resource>
  <directory>../docs/eng/developer/build/latex</directory>
  <targetPath>docs/eng/developer</targetPath>
	<includes>
	  <include>GeoNetworkDeveloperManual.pdf</include>
	</includes>
</resource>-->        
```


```
$ cd $HOME/geonetworkIRO
$ mvn clean install -Pgeodata,with-doc
```
