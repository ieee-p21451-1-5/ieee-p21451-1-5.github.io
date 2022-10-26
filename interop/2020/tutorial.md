# Interoperability Tests with Our Demonstration System

## 1. Get Your Hands Dirty!

To get started, choose an SNMP client and install it. In this article, [`net-snmp`](http://www.net-snmp.org/) is used as the example.

### Linux

For some distros, try installing `net-snmp` (or the client only) with the native package manger:

```shell
# On Debian-based systems:
sudo apt install snmp
# On RHEL-based systems:
sudo yum install net-snmp-utils
```

Otherwise, you should, unfortunately, build it from source following the steps in [this page](http://www.net-snmp.org/docs/INSTALL.html).

You may want to verify your installation by running:

```shell
snmpget --version
```

Run the following command as the hello-world routine:

```shell
snmpget -v 2c -c public 47.88.61.169 1.3.6.1.2.1.1.1.0
```

If you see something like this:

```
iso.3.6.1.2.1.1.1.0 = STRING: "Greetings from IEEE P21451-1-5 Working Group, Shanghai Jiao Tong University, Shanghai, China"
```

Congratulations! Your machine is now fired up.

> **Update of 09/30/20**
>
> We have also opened a non-default port `10010` for testing. If you have trouble sending the above message, try this:
>
> ```shell
> snmpget -v 2c -c public 47.88.61.169:10010 1.3.6.1.2.1.1.1.0
> ```

### Windows

(...)

## 2. Access Our Demo Remotely

### Description of the Demonstration System

We expose the following sensors and actuators to remote testers:

- A temperature sensor
- A photosensitive sensor
- A humidifier
- A lamp
- An LCD screen

Here is a picture of the system:

<img src="/image/demo-full.jpg" alt="demo-full.jpg" width="400">

From the standpoint of SNMP programs, each of these transducers is seen as a *variable*, either read-only or read/write. Each variable has a unique identifier, called [OID](https://en.wikipedia.org/wiki/Object_identifier). In our example, we put all these variables under a certain subtree. Thus, their OIDs have a common prefix: `1.3.6.1.4.1`, which is named `enterprise` and is the parent node of most enterprises and organizations.

The reset part of these OIDs are illustrated with this tree view:

```shell
# Output of `snmptranslate -Tp IEEE-P1451-SIMPLE-DEMO-MIB::sjtu'
+--sjtu(7934)
   |
   +--ieeeP1451Project(1451)
      |
      +--ieeeP1451Sensor(1)
      |  |
      |  +-- -R-- INTEGER   seTemperature(1)
      |  |        Range: 0..255
      |  +-- -R-- INTEGER   seLight(2)
      |           Range: 0..255
      |
      +--ieeeP1451Actuator(2)
         |
         +-- -RW- EnumVal   acLamp(1)
         |        Values: off(0), on(1)
         +-- -RW- EnumVal   acHumidifier(2)
         |        Values: off(0), on(1)
         +-- -RW- String    acLcd(3)

```

For example, `acLamp` is the variable standing for the lamp in our demonstration system. It is the first child node (`.1`) of `ieeeP1451Actuator`, who in turn is the second child node (`.2`) of `ieeeP1451Project`, who again is the 1451st child node (`.1451`) of `sjtu`, who is the 7934th child node (`.7934`) of `enterprise` (`1.3.6.1.4.1`). Therefore, the complete OID of `acLamp` is `1.3.6.1.4.1.7934.1451.2.1`.

OIDs, among other attributes of these variables, are specified in the MIB file [IEEE-P1451-SIMPLE-DEMO-MIB.txt](/file/IEEE-P1451-SIMPLE-DEMO-MIB.txt).

Having known the OIDs, we are now able to access the corresponding transducers using SNMP SET/GET messages.

### Sensors (Read-Only)

```shell
# Read the current value of the temperature sensor
snmpget -v2c -c public 47.88.61.169 1.3.6.1.4.1.7934.1451.1.1.0
# Read the current value of the photosensitive sensor
snmpget -v2c -c public 47.88.61.169 1.3.6.1.4.1.7934.1451.1.2.0
```

### Actuators (Read/Write)

```shell
# Read the current on/off status of the lamp
snmpget -v2c -c public 47.88.61.169 1.3.6.1.4.1.7934.1451.2.1.0
# Turn on the lamp
snmpset -v2c -c public 47.88.61.169 1.3.6.1.4.1.7934.1451.2.1.0 i 1
# Turn off the lamp
snmpset -v2c -c public 47.88.61.169 1.3.6.1.4.1.7934.1451.2.1.0 i 0

# Read the current on/off status of the humidifier
snmpget -v2c -c public 47.88.61.169 1.3.6.1.4.1.7934.1451.2.2.0
# Turn on the humidifier
snmpset -v2c -c public 47.88.61.169 1.3.6.1.4.1.7934.1451.2.2.0 i 1
# Turn off the humidifier
snmpset -v2c -c public 47.88.61.169 1.3.6.1.4.1.7934.1451.2.2.0 i 0

# Read the current content on the LCD screen
snmpget -v2c -c public 47.88.61.169 1.3.6.1.4.1.7934.1451.2.3.0
# Change the display content on the LCD screen
# (It is appreciated if you can leave a message here telling us where you are conducting this test!)
snmpset -v2c -c public 47.88.61.169 1.3.6.1.4.1.7934.1451.2.3.0 s "Hi, I am Rick from universe C-137."
```

> **Update of 09/30/20**
>
> We have also opened a non-default port `10010` for testing. If you have trouble sending the above messages, try replacing the `47.88.61.169` part with `47.88.61.169:10010`.
