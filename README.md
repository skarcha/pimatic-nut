pimatic-nut
=======================

A pimatic plugin for displaying info from a [NUT (Network UPS Tools)](http://www.networkupstools.org/) server.

### Supported values:

There are four predefined values:

* Status of the UPS: `"status"`
* Input Voltage: `"inputVoltage"`
* Charge of the battery: `"batteryCharge"`
* Load supported by the UPS: `"load"`

But you can define your own, using a variable name returned by the NUT server. In that case, the attribute should be defined using this params:

* Attribute name: `"name"`
* Variable name: `"var"`
* Type of the attribute: `"type"`
* Unit: `"unit"`
* Acronym: `"acronym"`
* Discrete: `"discrete"`

### NUT variables

if you want to define your own attribute using a NUT variable, you should do this to get the list of available variables for your UPS:

```
$ echo "LIST VAR myups" | nc localhost 3493
BEGIN LIST VAR myups
VAR myups battery.charge "100"
VAR myups battery.voltage "13.50"
VAR myups battery.voltage.high "13.00"
VAR myups battery.voltage.low "10.40"
VAR myups battery.voltage.nominal "12.0"
VAR myups device.type "ups"
VAR myups driver.name "blazer_usb"
VAR myups driver.parameter.pollinterval "2"
VAR myups driver.parameter.port "auto"
VAR myups driver.version "2.7.1"
VAR myups driver.version.internal "0.10"
VAR myups input.current.nominal "1.0"
VAR myups input.frequency "50.1"
VAR myups input.frequency.nominal "50"
VAR myups input.voltage "212.6"
VAR myups input.voltage.fault "212.2"
VAR myups input.voltage.nominal "230"
VAR myups output.voltage "212.6"
VAR myups ups.beeper.status "enabled"
VAR myups ups.delay.shutdown "30"
VAR myups ups.delay.start "180"
VAR myups ups.load "5"
VAR myups ups.productid "5161"
VAR myups ups.status "OL"
VAR myups ups.type "offline / line interactive"
VAR myups ups.vendorid "0665"
END LIST VAR myups
```

### Configuration

Add this to your `config.json`:

```
{
    "plugin": "nut"
}
```

### Examples:

```json
{
    "class": "NutSensor",
    "id": "nutsensor1",
    "name": "UPS 1",
    "nuthost": "localhost",
    "nutport": 3493,
    "upsid": "myups1",
    "attributes": [
        {"
          "name": "status"
        },
        {
          "name": "inputVoltage",
          "interval": 30000
        },
        {
          "name": "batteryCharge"
        },
        {
          "name": "load"
        },
        {
          "name": "batteryVoltage",
          "var": "battery.voltage",
          "type": "number",
          "unit": "V",
          "acronym": "B.Volt",
        }
    ]
}
```



```json
{
    "class": "NutSensor",
    "id": "nutsensor 2",
    "name": "UPS 2",
    "nuthost": "localhost",
    "nutport": 3493,
    "upsid": "myups2",
    "attributes": [
        {"
          "name": "status"
        },
        {
          "name": "inputVoltage"
        }
    ]
}
```
