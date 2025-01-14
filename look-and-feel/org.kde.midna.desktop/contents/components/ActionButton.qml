/*
    SPDX-FileCopyrightText: 2016 David Edmundson <davidedmundson@kde.org>

    SPDX-License-Identifier: LGPL-2.0-or-later
*/

import QtQuick 2.15

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 3.0 as PlasmaComponents3

Item {
    id: root
    property alias text: label.text
    property alias iconSource: icon.source
    property alias containsMouse: mouseArea.containsMouse
    property alias font: label.font
    property alias labelRendering: label.renderType
    property alias circleOpacity: iconCircle.opacity
    property alias circleVisiblity: iconCircle.visible
    property alias border_color: iconCircle.border.color
    property int fontSize: 12
    readonly property bool softwareRendering: GraphicsInfo.api === GraphicsInfo.Software
    signal clicked

    activeFocusOnTab: true

    property int iconSize: PlasmaCore.Units.gridUnit * 3

    implicitWidth: Math.max(iconSize + PlasmaCore.Units.largeSpacing * 2, label.contentWidth)
    implicitHeight: iconSize + PlasmaCore.Units.smallSpacing + label.implicitHeight

    opacity: activeFocus || containsMouse ? 1 : 0.85
        Behavior on opacity {
            PropertyAnimation { // OpacityAnimator makes it turn black at random intervals
                duration: PlasmaCore.Units.longDuration
                easing.type: Easing.InOutQuad
            }
    }

    Rectangle {
        id: iconCircle
        anchors.centerIn: icon
        width: iconSize + PlasmaCore.Units.largeSpacing
        height: width
        radius: width / 2
        color: "#08080C"
        border.color: "#3498db"
        border.width: 1
        opacity: activeFocus || containsMouse ? (softwareRendering ? 0.8 : 0.15) : (softwareRendering ? 0.6 : 0)
        Behavior on opacity {
                PropertyAnimation { // OpacityAnimator makes it turn black at random intervals
                    duration: PlasmaCore.Units.longDuration
                    easing.type: Easing.InOutQuad
                }
        }
    }

    Rectangle {
        anchors.centerIn: iconCircle
        width: iconCircle.width
        height: width
        radius: width / 2
        scale: mouseArea.containsPress ? 1 : 0
        color: PlasmaCore.ColorScope.textColor
        opacity: 0.15
        Behavior on scale {
                PropertyAnimation {
                    duration: PlasmaCore.Units.shortDuration
                    easing.type: Easing.InOutQuart
                }
        }
    }

    PlasmaCore.IconItem {
        id: icon
        anchors {
            top: parent.top
            horizontalCenter: parent.horizontalCenter
        }
        width: iconSize
        height: iconSize

        colorGroup: PlasmaCore.ColorScope.colorGroup
        active: mouseArea.containsMouse || root.activeFocus
    }

    PlasmaComponents3.Label {
        id: label
        font.pointSize: Math.max(fontSize + 1,theme.defaultFont.pointSize + 1)
        color: "#B7B7B7"
        anchors {
            top: icon.bottom
            topMargin: (softwareRendering ? 1.5 : 1) * PlasmaCore.Units.smallSpacing
            left: parent.left
            right: parent.right
        }
        style: softwareRendering ? Text.Outline : Text.Normal
        styleColor: softwareRendering ? PlasmaCore.ColorScope.backgroundColor : "transparent" //no outline, doesn't matter
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignTop
        wrapMode: Text.WordWrap
        font.underline: root.activeFocus
    }

    MouseArea {
        id: mouseArea
        hoverEnabled: true
        onClicked: root.clicked()
        anchors.fill: parent
    }

    Keys.onEnterPressed: clicked()
    Keys.onReturnPressed: clicked()
    Keys.onSpacePressed: clicked()

    Accessible.onPressAction: clicked()
    Accessible.role: Accessible.Button
    Accessible.name: label.text
}
