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
        format: "table"
        default: [{name: "status"}]
        items:
          type: "object"
          properties:
            name:
              type: "string"
              description: "The name of the attribute"
            interval:
              type: "number"
              description: "The update interval in ms"
              default: 60000
            var:
              type: "string"
              description: "Required if an attribute is defined other than batteryCharge, inputVoltage, load, or status"
              required: false
            type:
              description: "The type of the value"
              type: "string"
              required: false
            description:
              description: "A description provided for the attribute"
              type: "string"
              required: false
            acronym:
              description: "Acronym to show as value label in the frontend"
              type: "string"
              required: false
            unit:
              description: "The unit to show in the frontend"
              type: "string"
              required: false
            discrete:
              description: "Set to true if the value does not change continuously over time"
              type: "boolean"
              required: false
            labels:
              description: "Labels assigned to attribute values"
              type: "boolean"
              required: false
  }
}
