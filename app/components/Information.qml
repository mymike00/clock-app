import QtQuick 2.0
import Ubuntu.Components 1.3

Page {

    header: PageHeader {
        id:infoHeader
        title: i18n.tr("Information")

    }

    ListModel {
       id: infoModel
     }

    Component.onCompleted: {
        infoModel.append({ name: i18n.tr("Get the source"), desc: i18n.tr("Source of clock lays here."), url: "https://github.com/ubports/clock-app" })
        infoModel.append({ name: i18n.tr("Report issues"), desc: i18n.tr("Issues you have do you?"), url: "https://github.com/ubports/clock-app/issues" })
        infoModel.append({ name: i18n.tr("Help translate"), desc: i18n.tr("Understand you I am not."), url: "https://translate.ubports.com/projects/ubports/clock-app/" })
    }

    UbuntuListView {
         anchors.fill: parent
         anchors.topMargin: infoHeader.height
         currentIndex: -1

         model :infoModel
         delegate: ListItem {
            ListItemLayout {
             title.text : model.name
             Icon {
                 width:units.gu(2)
                 name:"go-to"
             }
            }
            onClicked: Qt.openUrlExternally(model.url)


         }

    }

}
