/*
 * Copyright (C) 2014 Canonical Ltd
 *
 * This file is part of Ubuntu Clock App
 *
 * Ubuntu Clock App is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 3 as
 * published by the Free Software Foundation.
 *
 * Ubuntu Clock App is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.0
import U1db 1.0 as U1db
import Location 1.0 as UserLocation
import QtPositioning 5.2
import Ubuntu.Components 1.1
import "../components"
import "../upstreamcomponents"
import "../worldclock"
import "../components/Utils.js" as Utils

PageWithBottomEdge {
    id: _clockPage
    objectName: "clockPage"

    /*
      Property to set the minimum drag distance before activating the add
      city signal
    */
    property int _minThreshold: addCityButton.maxThreshold + units.gu(2)

    // Property to keep track of the clock mode
    property alias isDigital: clock.isDigital

    flickable: null

    Component.onCompleted: Utils.log(debugMode, "Clock Page loaded")

    PositionSource {
        id: geoposition
        active: true
        updateInterval: 1000
        Component.onCompleted: {
            console.log("Location source available: " + valid)
        }

        onPositionChanged: {
            var coord = geoposition.position.coordinate

            console.log("Location obtained via geoposition: " + coord)

            if (coord.longitude === userLocationDocument.contents.long ||
                    coord.latitude === userLocationDocument.contents.lat) {
                console.log("Same location as the last known location.")
                return;
            }

            else {
                console.log("New Location detected")
                userLocation.source = String("%1%2%3%4%5")
                .arg("http://api.geonames.org/findNearbyPlaceNameJSON?lat=")
                .arg(coord.latitude)
                .arg("&lng=")
                .arg(coord.longitude)
                .arg("&username=krnekhelesh&style=full")
            }
        }
    }

    UserLocation.Location {
        id: userLocation
        onLocationChanged: {
            location.text = userLocation.location
            console.log("Location:" + userLocation.location)
            var locationData = JSON.parse
                    (JSON.stringify(userLocationDocument.contents))
            locationData.lat = geoposition.position.coordinate.latitude
            locationData.long = geoposition.position.coordinate.longitude
            locationData.location = userLocation.location
            userLocationDocument.contents = locationData
        }
    }

    Flickable {
        id: _flickable

        Component.onCompleted: otherElementsStartUpAnimation.start()

        anchors.fill: parent
        contentWidth: parent.width
        contentHeight: clock.height + date.height + locationRow.height
                       + worldCityColumn.height + units.gu(14)

        PullToAdd {
            id: addCityButton
            objectName: "addCityButton"

            anchors {
                top: parent.top
                topMargin: -labelHeight - units.gu(3)
                horizontalCenter: parent.horizontalCenter
            }

            leftLabel: i18n.tr("Add")
            rightLabel: i18n.tr("City")
        }

        AbstractButton {
            id: settingsIcon
            objectName: "settingsIcon"

            onClicked: {
                mainStack.push(Qt.resolvedUrl("../alarm/AlarmSettingsPage.qml"))
            }

            width: units.gu(3)
            height: width
            opacity: 0

            anchors {
                top: parent.top
                topMargin: units.gu(6)
                right: parent.right
                rightMargin: units.gu(2)
            }

            Icon {
                anchors.fill: parent
                name: "settings"
                color: "Grey"
            }
        }

        MainClock {
            id: clock
            objectName: "clock"

            anchors {
                verticalCenter: parent.top
                verticalCenterOffset: units.gu(20)
                horizontalCenter: parent.horizontalCenter
            }
        }

        Label {
            id: date

            anchors {
                top: parent.top
                topMargin: units.gu(36)
                horizontalCenter: parent.horizontalCenter
            }

            text: clock.analogTime.toLocaleDateString()
            opacity: settingsIcon.opacity
            fontSize: "xx-small"
        }

        Row {
            id: locationRow
            objectName: "locationRow"

            opacity: settingsIcon.opacity
            spacing: units.gu(1)

            anchors {
                top: date.bottom
                topMargin: units.gu(1)
                horizontalCenter: parent.horizontalCenter
            }

            Image {
                id: locationIcon
                source: "../graphics/Location_Pin.png"
                width: units.gu(1.2)
                height: units.gu(2.2)
            }

            Label {
                id: location
                objectName: "location"
                fontSize: "medium"
                anchors.verticalCenter: locationIcon.verticalCenter
                color: UbuntuColors.midAubergine

                text: {
                    if (userLocationDocument.contents.location === "null") {
                        return i18n.tr("Retrieving location...")
                    }

                    else {
                        return userLocationDocument.contents.location
                    }
                }
            }
        }

        UserWorldCityList {
            id: worldCityColumn
            objectName: "worldCityColumn"
            opacity: settingsIcon.opacity
            anchors.top: locationRow.bottom
            anchors.topMargin: units.gu(4)
        }

        onDragEnded: {
            if(contentY < _minThreshold) {
                mainStack.push(Qt.resolvedUrl("../worldclock/WorldCityList.qml"))
            }
        }

        onContentYChanged: {
            if(contentY < 0 && atYBeginning) {
                addCityButton.dragPosition = contentY.toFixed(0)
            }
        }

        ParallelAnimation {
            id: otherElementsStartUpAnimation

            PropertyAnimation {
                target: settingsIcon
                property: "anchors.topMargin"
                from: units.gu(6)
                to: units.gu(2)
                duration: 900
            }

            PropertyAnimation {
                target: settingsIcon
                property: "opacity"
                from: 0
                to: 1
                duration: 900
            }

            PropertyAnimation {
                target: date
                property: "anchors.topMargin"
                from: units.gu(36)
                to: units.gu(40)
                duration: 900
            }
        }
    }
}
