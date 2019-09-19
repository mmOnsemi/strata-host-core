import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Window 2.3
import "qrc:/js/core_platform_interface.js" as CorePlatformInterface

Item {
    id: platformInterface

    // -------------------------------------------------------------------
    // UI Control States
    //

    property var get_clk_freqs: {
        "clk":[10,50,100,500,1000,32000]
    }

    property var get_power: {
        "avdd_uA":20,
        "dvdd_uA":31.2,
        "avdd_power_uW":50.3,
        "dvdd_power_uW":44.5,
        "total_power_uW":41.3

    }

    property var status: {
        "status": ""
    }

    property var get_data: {
        "packet": 1,
        "data": ""
    }





    // -------------------------------------------------------------------
    // Outgoing Commands
    //
    // Define and document platform commands here.
    //
    // Built-in functions:
    //   update(): sets properties and sends command in one call
    //   set():    can set single or multiple properties before sending to platform
    //   send():   sends current command
    //   show():   console logs current command and properties

    // @command: set_adc_supply
    // @description: sends ADC Supply command to platform
    //
    property var set_adc_supply : ({
                                       "cmd" : "set_adc_supply",
                                       "payload": {
                                           "dvdd":3.3,
                                           "avdd":1.8
                                       },

                                       update: function (dvdd,avdd) {
                                           this.set(dvdd,avdd)
                                           this.send(this)
                                       },
                                       set: function (dvdd,avdd) {
                                           this.payload.dvdd = dvdd
                                           this.payload.avdd = avdd
                                       },
                                       send: function () { CorePlatformInterface.send(this) },
                                       show: function () { CorePlatformInterface.show(this) }
                                   })

    // @command: get_clk_freqs
    // @description: sends get_clk_freqs command to platform
    //

    property var get_clk_freqs_values: ({ "cmd" : "get_clk_freqs",
                                            update: function () {
                                                CorePlatformInterface.send(this)
                                            },
                                            send: function () { CorePlatformInterface.send(this) },
                                            show: function () { CorePlatformInterface.show(this) }

                                        })

    // @command: set_adc_supply
    // @description: sends ADC Supply command to platform
    //
    property var set_clk : ({
                                "cmd" : "set_clk",
                                "payload": {
                                    "clk":50
                                },
                                update: function (clk) {
                                    this.set(clk)
                                    this.send(this)
                                },
                                set: function (clk) {
                                    this.payload.clk = clk
                                },
                                send: function () { CorePlatformInterface.send(this) },
                                show: function () { CorePlatformInterface.show(this) }
                            })


    // @command: get_clk_freqs
    // @description: sends get_clk_freqs command to platform
    //

    property var get_power_value: ({ "cmd" : "get_power",
                                       update: function () {
                                           CorePlatformInterface.send(this)
                                       },
                                       send: function () { CorePlatformInterface.send(this) },
                                       show: function () { CorePlatformInterface.show(this) }

                                   })

    // @command: get_data
    // @description: sends get_data command to platform
    property var get_data_value : ({
                                       "cmd" : "get_data",
                                       "payload": {
                                           "packets":200
                                       },
                                       update: function (packets) {
                                           this.set(packets)
                                           this.send(this)
                                       },
                                       set: function (packets) {
                                           this.payload.packets = packets
                                       },
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

    //    Window {
    //        id: debug
    //        visible: true
    //        width: 200
    //        height: 200

    //        Button {
    //            id: button2
    //              anchors { top: button1.bottom }
    //            text: "get power"
    //            onClicked: {
    //                CorePlatformInterface.data_source_handler('{
    //                        "value":"get_power",
    //                        "payload":{
    //                                    "AVDD":'+ (Math.random()*5+10).toFixed(2) +',
    //                                    "DVDD": '+ (Math.random()*5+10).toFixed(2) +',
    //                                    "Total": '+ (Math.random()*5+10).toFixed(2) +'
    //                                   }
    //                                 }')
    //            }
    //        }

    //    }
}
