module.exports = (env) ->

  # Require the  bluebird promise library
  Promise = env.require 'bluebird'

 # Require sensors.js library (https://www.npmjs.com/package/sensors.js).
  Nut = require 'node-nut'


  class NutPlugin extends env.plugins.Plugin

    init: (app, @framework, @config) =>
      deviceConfigDef = require("./device-config-schema")

      @framework.deviceManager.registerDeviceClass("NutSensor", {
        configDef: deviceConfigDef.NutSensor,
        createCallback: (config) => return new NutSensor(config)
      })


  class NutSensor extends env.devices.Sensor

    constructor: (@config) ->
      @name = config.name
      @id = config.id

      @attributes = {}
      @upsvars = []
      min_interval = default_interval = 60000

      for attr, i in @config.attributes
        do (attr) =>
          name = attr.name
          interval = attr.interval or default_interval

          if interval < min_interval
            min_interval = interval

          @attributes[name] = {
            description: name
          }
 
          switch name
            when 'batteryCharge'
              getter = ( =>
                value = Number(@upsvars['battery.charge'])
                Promise.resolve(value)
              )
              @attributes[name].type = 'number'
              @attributes[name].unit = '%'
              @attributes[name].acronym = 'BAT'

            when 'inputVoltage'
              getter = ( =>
                value = Number(@upsvars['input.voltage'])
                Promise.resolve(value)
              )
              @attributes[name].type = 'number'
              @attributes[name].unit = 'V'
              @attributes[name].acronym = 'IN'

            when 'load'
              getter = ( =>
                value = Number(@upsvars['ups.load'])
                Promise.resolve(value)
              )
              @attributes[name].type = 'number'
              @attributes[name].unit = '%'
              @attributes[name].acronym = 'LOAD'

            when 'status'
              getter = ( =>
                status = @upsvars['ups.status'] or ""
                if status.substring(0, 2) == 'OL'
                  value = true
                else
                  value = false
                Promise.resolve(value)
              )

              @attributes[name].type = 'boolean'
              @attributes[name].discrete = true
              @attributes[name].labels = ['on line', 'on battery']

            else
              @attributes[name].description = name
              @attributes[name].type = attr.type
              @attributes[name].unit = attr.unit or ''
              @attributes[name].discrete = attr.discrete or false
              @attributes[name].acronym = attr.acronym or null

              getter = ( =>
                if attr.type == 'number'
                  value = Number(@upsvars[attr.var])
                else
                  value = @upsvars[attr.var]
                Promise.resolve(value)
              )

          @_createGetter(name, getter)
          setInterval( (=>
            getter().then( (value) =>
              @emit name, value
            ).catch ( (error) =>
              env.logger.error "error updating NutSensor value for #{name}:", error.message
              env.logger.debug error.stack
            )
          ), interval)


      if @attributes
        setInterval( ( =>
          @readUPSData(config.nutport or 3493, config.nuthost or 'localhost', config.upsid)
        ), min_interval)

      super()

    readUPSData: (port, host, upsid) ->
      oNut = new Nut(port, host)

      get_data = (data) =>
        @upsvars = data
        oNut.close()

      oNut.on('ready', () ->
          this.GetUPSVars(upsid, get_data)
      )
      oNut.start()

  # ###Finally
  # Create a instance of my plugin
  nutPlugin = new NutPlugin
  # and return it to the framework.
  return nutPlugin
