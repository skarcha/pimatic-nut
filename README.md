pimatic-nut
=======================

A pimatic plugin for displaying info from a [NUT (Network UPS Tools)](http://www.networkupstools.org/) server.

### Supported values:

There are four predefined values:

* Status of the UPS: `"status"`
* Input Voltage: `"inputVoltage"`
* Charge of the battery: `"batteryCharge"`
* Load supported by the UPS: `"load"`

But you can define your own, using a variable name returned by de NUT server. In that case, the attribute should be defined using this params:

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
VAR misai battery.charge "100"
VAR misai battery.voltage "13.50"
VAR misai battery.voltage.high "13.00"
VAR misai battery.voltage.low "10.40"
VAR misai battery.voltage.nominal "12.0"
VAR misai device.type "ups"
VAR misai driver.name "blazer_usb"
VAR misai driver.parameter.pollinterval "2"
VAR misai driver.parameter.port "auto"
VAR misai driver.version "2.7.1"
VAR misai driver.version.internal "0.10"
VAR misai input.current.nominal "1.0"
VAR misai input.frequency "50.1"
VAR misai input.frequency.nominal "50"
VAR misai input.voltage "212.6"
VAR misai input.voltage.fault "212.2"
VAR misai input.voltage.nominal "230"
VAR misai output.voltage "212.6"
VAR misai ups.beeper.status "enabled"
VAR misai ups.delay.shutdown "30"
VAR misai ups.delay.start "180"
VAR misai ups.load "5"
VAR misai ups.productid "5161"
VAR misai ups.status "OL"
VAR misai ups.type "offline / line interactive"
VAR misai ups.vendorid "0665"
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
