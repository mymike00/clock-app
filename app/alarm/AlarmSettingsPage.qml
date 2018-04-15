import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.ListItems 1.3
import "components"

Page {

        header: PageHeader {
            id:alarmsHeader
            title: i18n.tr("Alarms")
        }
        Alarm{
            id: alarm
        }
        Column {
            id: addAlarm
            anchors.top: alarmsHeader.bottom
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
                        print("Error saving" + alarm.date + ", code: " + alarm.error);
                }
            }

            Button {
                text: "Cancel"
                onClicked: {
                    alarm.cancel();
                    //if (alarm.error != Alarm.NoError)
                    //    print("Error saving alarm, code: " + alarm.error);
                }
            }
        }


            ExpandableListItem {
                anchors.top: addAlarm.bottom
                id: _selectedTheme

                property QtObject selectedItem: null

                listViewHeight: units.gu(6) + (model.count * units.gu(5))
                titleText.text:(theme.name == selectedItem.value || !clockAppSettings.theme ) ?
                                   (clockAppSettings.theme ? i18n.tr("Theme") : i18n.tr("Theme (system theme on App start)") ):
                                   i18n.tr("Theme (will apply after App restart)");
                subText.textSize: Label.Medium

                //TODO This list should be retrived form the system/UITK but I couldn't find a way to do that elegently
                //     so it`s currently hard coded with the themes that Ubuntu SDK docs says are available by default.
                model: ListModel {
                        ListElement {name: "System Theme"; value : "" }
                        ListElement {name: "Ambiance"; value : "Ubuntu.Components.Themes.Ambiance"}
                        ListElement {name: "Suru Dark"; value : "Ubuntu.Components.Themes.SuruDark"}
                }

                onSelectedItemChanged:  {
                    if(clockAppSettings.theme !== selectedItem.value  ) {
                        clockAppSettings.theme = _selectedTheme.selectedItem.value;
                    }

                    subText.text = selectedItem.name;
                }

                function updateSelectedItem(itemValue) {
                    for(var i=0; i < model.count;i++) {
                        if(model.get(i).value == itemValue) {
                            selectedItem = model.get(i);
                            break;
                        }
                    }
                }

                Component.onCompleted: updateSelectedItem(clockAppSettings.theme);

                delegate: ListItem {
                    ListItemLayout {
                        title.text: model.name

                        Icon {
                            SlotsLayout.position: SlotsLayout.Trailing
                            width: units.gu(2)
                            height: width
                            name: "tick"
                            visible: model.value == clockAppSettings.theme
                            asynchronous: true
                        }
                    }

                    onClicked: {
                        _selectedTheme.updateSelectedItem(model.value)
                        _selectedTheme.expansion.expanded = false
                    }
                }
            }
}
