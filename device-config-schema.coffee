module.exports = {
  title: "pimatic-nut device config schemas"
  NutSensor: {
    title: "NutSensor config options"
    type: "object"
    properties:
      nuthost:
        description: "NUT server address"
        type: "string"
      nutport:
        description: "NUT server port"
        type: "number"
      upsid:
        description: "UPS ID"
        type: "string"
      attributes:
        description: "Attributes of the device"
        type: "array"
  }
}
