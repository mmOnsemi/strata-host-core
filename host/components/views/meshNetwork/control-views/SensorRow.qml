import QtQuick 2.12
import QtQuick.Controls 2.5

Item {
    id: sensorRowRoot
    width: sensorRow.width


    signal showAmbientLightValue()
    signal hideAmbientLightValue()
    signal showBatteryCharge()
    signal hideBatteryCharge()
    signal showTemperature()
    signal hideTemperature()
    signal showSignalStrength()
    signal hideSignalStrength()
    signal showMesh()
    signal hideMesh()
    signal showPairing()
    signal hidePairing()



    ButtonGroup{
        id:sensorButtonGroup
        exclusive: true
    }

    Row{
        id:sensorRow
        height:parent.height
        spacing: 20.0


        Button{
            id:signalStrengthButton
            height:parent.height
            width:height
            checkable:true
            ButtonGroup.group: sensorButtonGroup

            background: Rectangle {
                    color:"transparent"
                    radius: height/10
                }

            onCheckedChanged: {
                if (checked){
                    //ask the platform for the signal strength of each node
                    platformInterface.get_sensor_data.update(0xFFFF,"strata");
                    sensorRowRoot.showSignalStrength();
                }
                  else
                    sensorRowRoot.hideSignalStrength();
            }

            Image{
                id:signalStrengthImage
                source:"../images/wifiIcon.svg"
                fillMode: Image.PreserveAspectFit
                height:parent.height
                mipmap:true
                opacity:signalStrengthButton.checked ? .75 : .2
            }
        }

        Button{
            id:ambientLightButton
            height:parent.height
            width:height
            checkable:true
            ButtonGroup.group: sensorButtonGroup

            background: Rectangle {
                    color:"transparent"
                    radius: height/10
                }

            onCheckedChanged: {
                if (checked){
                        for (var alpha=1; alpha <= numberOfNodes; alpha++){
                            sleep(500).then(() => {
                                platformInterface.get_sensor_data.update(alpha,"ambient_light");
                            });
                        //platformInterface.get_sensor_data.update(alpha,"ambient_light");
                    }
                    sensorRowRoot.showAmbientLightValue();
                }
                  else
                    sensorRowRoot.hideAmbientLightValue();
            }

            Image{
                id:ambientLightImage
                source:"../images/ambientLightIcon.svg"
                fillMode: Image.PreserveAspectFit
                height:parent.height
                mipmap:true
                opacity:ambientLightButton.checked ? .75 : .2
            }
        }

        Button{
            id:batteryChargeButton
            height:parent.height
            width:height
            checkable:true
            ButtonGroup.group: sensorButtonGroup

            background: Rectangle {
                    color:"transparent"
                    radius: height/10
                }

            onCheckedChanged: {
                if (checked){
                    for (var alpha=1; alpha <= numberOfNodes; alpha++){
                        sleep(500).then(() => {
                            platformInterface.get_battery_level.update(alpha);
                        });
                        //platformInterface.get_battery_level.update(alpha);
                    }
                    sensorRowRoot.showBatteryCharge();
                }
                  else{
                    sensorRowRoot.hideBatteryCharge();
                    console.log("hiding battery level ")
                }
            }

            Image{
                id:batteryChargeImage
                source:"../images/batteryChargeIcon.svg"
                fillMode: Image.PreserveAspectFit
                height:parent.height
                mipmap:true
                opacity:batteryChargeButton.checked ? .75 : .2
            }
        }

        Button{
            id:temperatureButton
            height:parent.height
            width:height
            checkable:true
            ButtonGroup.group: sensorButtonGroup

            background: Rectangle {
                    color:"transparent"
                    radius: height/10
                }

            onCheckedChanged: {
                if (checked){
                    for (var alpha=0; alpha <= numberOfNodes; alpha++){
                        sleep(500).then(() => {
                            platformInterface.get_sensor_data.update(alpha,"temperature");
                        });
                        //platformInterface.get_sensor_data.update(alpha,"temperature");
                    }
                    sensorRowRoot.showTemperature();
                }
                  else
                    sensorRowRoot.hideTemperature();
            }

            Image{
                id:temperatureImage
                source:"../images/temperatureIcon.svg"
                fillMode: Image.PreserveAspectFit
                height:parent.height
                mipmap:true
                opacity:temperatureButton.checked ? .75 : .2
            }
        }

        Button{
            id:meshButton
            height:parent.height
            width:height
            checkable:true
            ButtonGroup.group: sensorButtonGroup

            background: Rectangle {
                    color:"transparent"
                    radius: height/10
                }

            onCheckedChanged: {
                if (checked)
                    sensorRowRoot.showMesh();
                  else
                    sensorRowRoot.hideMesh();
            }

            Image{
                id:meshImage
                source:"../images/meshIcon.svg"
                fillMode: Image.PreserveAspectFit
                height:parent.height
                mipmap:true
                opacity:meshButton.checked ? .75 : .2
            }
        }

        Button{
            id:clearButton
            height:parent.height
            width:height
            checkable:true
            checked:true
            ButtonGroup.group: sensorButtonGroup

            background: Rectangle {
                    color:"transparent"
                    radius: height/10
                }

            onCheckedChanged: {
                if (checked){
                    sensorRowRoot.hideSignalStrength();
                    sensorRowRoot.hideAmbientLightValue();
                    sensorRowRoot.hideBatteryCharge();
                    sensorRowRoot.hideTemperature();
                    sensorRowRoot.showPairing();
                    }
                  else{
                    sensorRowRoot.hidePairing();
                    }


            }

            Image{
                id:clearImage
                source:"../images/clearIcon.svg"
                fillMode: Image.PreserveAspectFit
                height:parent.height
                mipmap:true
                opacity:clearButton.checked ? .75 : .2
            }
        }


    }

}
