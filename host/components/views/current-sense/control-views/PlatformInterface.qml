import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Window 2.3
import "qrc:/js/core_platform_interface.js" as CorePlatformInterface

Item {
    id: platformInterface

    property var periodic_status: {
        "ADC_210": 0.10000,        //current reading of NCS210R in mA (from 0 to 100.00)
        "ADC_211": 0.002000,       //current reading of NCS211R in mA (from 0 to 2.000)
        "ADC_213": 30.00,          //current reading of NCS213R in A (from 0 to 30.00)
        "ADC_214": 1.000,          //current reading of NCS214R in A (from 0 to 1.000)
        "ADC_333": 0.0001000,      //current reading of NCS333R in uA (from 0 to 100.0)
        "ADC_VIN": 26.00           //current reading of Vin in V (from 0 to 26.0)
    }

    property var switch_enable_status: {
        "en_210": "off",        //on or off
        "en_211": "off",       //on or off
        "en_213": "off",       //on or off
        "en_214": "off",       //on or off
        "en_333": "off"        //on or off
    }

    property var load_enable_status: {
        "low_load_en": "on",                  //on or off
        "mid_load_en": "off",                 //on or off
        "high_load_en": "off",                //on or off
        "load_setting_min": "1µA",            //min value for load setting slider
        "load_setting_max": "100µA",          //max value for load setting slider
        "load_setting_from": 0.000001,        //min value for load setting slider as a float
        "load_setting_to": 0.0001,            //max value for load setting slider as a float
        "load_setting_step": 0.000001,        //step value for the slider
        "load_setting_state": 0.000001        //starting value for the slider
    }

    property var current_sense_interrupt: {
        "value":"no"
    }

    property var voltage_sense_interrupt: {
        "value": "no"
    }

    property var i_in_interrupt: {
        "value": "no"
    }

    property var config_running: {
        "value" : false
    }

    property var cp_test_invalid: {
        "value" : false
    }

    property var initial_status: {
        "en_210": "on",                   //on or off
        "en_211": "off",                  //on or off
        "en_213": "off",                  //on or off
        "en_214": "off",                  //on or off
        "en_333": "off",                  //on or off
        "manual_mode": "auto",            //auto or manual
        "max_input_current": 30,          //float
        "max_input_voltage": 26,          //float
        "low_load_en": "off",             //on or off
        "mid_load_en": "off",             //on or off
        "high_load_en": "off",            //on or off
    }

    property var set_initial_state_UI : ({
                                             "cmd" : "set_initial_state_UI",
                                             update: function () {
                                                 CorePlatformInterface.send(this)
                                             },

                                             set: function (enable) {
                                                 this.payload.enable = enable
                                             },
                                             send: function () { CorePlatformInterface.send(this) },
                                             show: function () { CorePlatformInterface.show(this) }
                                         })

    property var switch_enables : ({
                                       "cmd" : "set_switch_enables",
                                       "payload": {
                                           "enable": "210_on"	// default value
                                       },

                                       update: function (enable) {
                                           this.set(enable)
                                           this.send(this)
                                       },
                                       set: function (enable) {
                                           this.payload.enable = enable
                                       },
                                       send: function () { CorePlatformInterface.send(this) },
                                       show: function () { CorePlatformInterface.show(this) }
                                   })

    property var load_enables : ({
                                     "cmd" : "set_load_enables",
                                     "payload": {
                                         "enable": "low_load_on"	// default value
                                     },

                                     update: function (enable) {
                                         this.set(enable)
                                         this.send(this)
                                     },
                                     set: function (enable) {
                                         this.payload.enable = enable
                                     },
                                     send: function () { CorePlatformInterface.send(this) },
                                     show: function () { CorePlatformInterface.show(this) }
                                 })

    property var set_load_dac_load : ({
                                     "cmd" : "set_load_dac",
                                     "payload": {
                                         "load": "0"	// default value
                                     },

                                     update: function (load) {
                                         this.set(load)
                                         this.send(this)
                                     },
                                     set: function (load) {
                                         this.payload.load = load
                                     },
                                     send: function () { CorePlatformInterface.send(this) },
                                     show: function () { CorePlatformInterface.show(this) }
                                 })

    property var set_mode : ({
                                 "cmd" : "set_mode",
                                 "payload": {
                                     "mode": "auto"		// default value
                                 },

                                 update: function (mode) {
                                     this.set(mode)
                                     this.send(this)
                                 },
                                 set: function (mode) {
                                     this.payload.mode = mode
                                 },
                                 send: function () { CorePlatformInterface.send(this) },
                                 show: function () { CorePlatformInterface.show(this) }
                             })

    property var set_v_set : ({
                                  "cmd" : "set_v_set",
                                  "payload": {
                                      "voltage_set": "0"		// default value
                                  },

                                  update: function (voltage_set) {
                                      this.set(voltage_set)
                                      this.send(this)
                                  },
                                  set: function (voltage_set) {
                                      this.payload.voltage_set = voltage_set
                                  },
                                  send: function () { CorePlatformInterface.send(this) },
                                  show: function () { CorePlatformInterface.show(this) }
                              })

    property var set_i_in_dac : ({
                                     "cmd" : "set_i_in_dac",
                                     "payload": {
                                         "i_in": "0"		// default value
                                     },

                                     update: function (i_in) {
                                         this.set(i_in)
                                         this.send(this)
                                     },
                                     set: function (i_in) {
                                         this.payload.i_in = i_in
                                     },
                                     send: function () { CorePlatformInterface.send(this) },
                                     show: function () { CorePlatformInterface.show(this) }
                                 })

    property var set_recalibrate : ({
                                        "cmd" : "recalibrate",
                                        "payload": { },

                                        send: function () { CorePlatformInterface.send(this) },
                                        show: function () { CorePlatformInterface.show(this) }
                                    })

    property var reset_board : ({
                                    "cmd" : "reset_board",
                                    "payload": { },

                                    send: function () { CorePlatformInterface.send(this) },
                                    show: function () { CorePlatformInterface.show(this) }
                                })



    // -------------------------------------------------------------------
    // Listens to message notifications coming from CoreInterface.cpp
    // Forward messages to core_platform_interface.js to process

    Connections {
        target: coreInterface
        onNotification: {
            CorePlatformInterface.data_source_handler(payload)
        }
    }
}
