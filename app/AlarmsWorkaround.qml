import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.ListItems 1.3

Page {

    header: PageHeader {
        id:alarmsHeader
        title: i18n.tr("Alarms")

    }

//    ListView {
//        model: AlarmModel{
//            id: alarmModel
//        }
//        delegate: Standard {
//            text: message
//            control: Switch {
//                checked: model.enabled
//                onCheckedChanged: {
//                    if (checked != model.enabled) {
//                        model.enabled = checked;
//                        model.save();
//                    }
//                }
//            }
//        }
//    }

    Rectangle {
        width: units.gu(40)
        height: units.gu(20)
        Alarm{
            id: alarm
        }
        Column {
            spacing: units.gu(1)
            Row {
                spacing: units.gu(1)
                Label {
                    id: date
                    text: "Date:"
                    anchors.verticalCenter: parent.verticalCenter
                }
                TextField {
                    text: alarm.date.toString()
                    onAccepted: alarm.date = new Date(text)
                }
            }
            Row {
                spacing: units.gu(1)
                Label {
                    id: msg
                    text: "Message:"
                    anchors.verticalCenter: parent.verticalCenter
                }
                TextField {
                    text: alarm.message
                    onAccepted: alarm.message = text
                }
            }
            Button {
                text: "Save"
                onClicked: {
                    alarm.save();
                    if (alarm.error != Alarm.NoError)
                        print("Error saving alarm, code: " + alarm.error);
                }
            }
        }
    }
}
