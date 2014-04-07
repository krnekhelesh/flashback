/*
 * Flashback - Entertainment app for Ubuntu
 * Copyright (C) 2013, 2014 Nekhelesh Ramananthan <nik90@ubuntu.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 3 as
 * published by the Free Software Foundation.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 */

import QtQuick 2.0
import Ubuntu.Components 0.1

/*
  Component to show user notification about an activity
  Behavior: Hidden after 10 seconds automatically or when the user clicks the close button
  */
Rectangle {
    id: _notificationContainer

    // Property to set the notification title
    property alias messageTitle: _notificationTitle.text

    // Property to set the notification message
    property alias message: _notificationMessage.text

    // Property to set the notification icon (By default shows the error icon since it is the common case)
    property alias messageIcon: _notificationIcon.source

    // Property to set the notification timeout (in seconds). By default set to 10 seconds
    property int timeout: 10

    //

    height: _mainColumn.height + units.gu(5)
    anchors.centerIn: parent
    width: parent.width/1.2
    radius: units.gu(0.5)
    z: parent.z + 1
    visible: false
    opacity: 0.8
    color: "Black"

    // When notification is visible, start the internal timer
    onVisibleChanged: visible == true ? _countDownTimer.restart() : undefined

    Behavior on width {
        UbuntuNumberAnimation { duration: UbuntuAnimation.BriskDuration }
    }

    Behavior on height {
        UbuntuNumberAnimation { duration: UbuntuAnimation.BriskDuration }
    }

    // Timer to show the time countdown to the user (updated every second)
    Timer {
        id: _countDownTimer

        property int _countDown: timeout

        repeat: true
        interval: 1000

        onTriggered: {
            _visualCountDownAnimation.start()
            _countDown = _countDown - 1
            if(_countDown == 0) {
                _countDownTimer.stop()
                _visualCountDownAnimation.complete()
                _notificationContainer.visible = false
                _countDown = timeout
            }
        }
    }

    // Notification Icon
    Image {
        id: _notificationIcon

        width: units.gu(5)
        height: width
        anchors {
            verticalCenter: _mainColumn.verticalCenter
            left: parent.left
            margins: units.gu(2)
        }

        source: Qt.resolvedUrl("../graphics/error.png")
        fillMode: Image.PreserveAspectFit
        smooth: true
    }

    // GUI consisting of the notification message. The string shows a custom message
    Column {
        id: _mainColumn
        anchors {
            left: _notificationIcon.right
            right: parent.right
            top: parent.top
            margins: units.gu(2)
        }

        spacing: units.gu(1)

        Label {
            id: _notificationTitle

            text: i18n.tr("Default")
            font.bold: true
            elide: Text.ElideRight
            wrapMode: Text.WordWrap
            anchors {
                left: parent.left
                right: parent.right
            }

        }

        Label {
            id: _notificationMessage

            text: i18n.tr("Default")
            elide: Text.ElideRight
            wrapMode: Text.WordWrap
            anchors {
                left: parent.left
                right: parent.right
            }

        }
    }

    // Visual count down animation (shown at the top)
    Rectangle {
        id: _visualCountDown

        color: UbuntuColors.orange
        height: units.gu(0.4)
        anchors {
            top: parent.top
            left: _closeIcon.right
        }

        SequentialAnimation on width {
            id: _visualCountDownAnimation
            running: false
            NumberAnimation {
                from: _notificationContainer.width - units.gu(2)
                to: 0
                duration: (timeout*1000) - 1000
            }
            PauseAnimation {duration: 1000}
        }
    }

    // Icon to close the notification bubble (shown at the top left corner)
    Image {
        id: _closeIcon

        width: units.gu(3)
        height: width
        anchors {
            bottom: parent.top
            right: parent.left
            margins: units.gu(-2)
        }

        source: Qt.resolvedUrl("../graphics/close.png")
        fillMode: Image.PreserveAspectFit
        smooth: true

        MouseArea {
            anchors.fill: parent
            onClicked: {
                _countDownTimer.stop()
                _visualCountDownAnimation.complete()
                _notificationContainer.visible = false
                _countDownTimer._countDown = timeout
            }
        }
    }
}
