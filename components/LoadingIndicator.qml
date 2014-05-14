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
import Ubuntu.Components 1.1

/*
  Generic loading indicator component to provide user feedback
  */
Rectangle {
    id: loadingContainer

    // Property to set the loading message
    property alias loadingText: _loadingLabel.text

    // Property to show/hide the indicator
    property bool isShown: false

    width: _dataRow.width + units.gu(8)
    height: _dataRow.height + units.gu(3)
    radius: units.gu(15)

    z: parent.z + 1
    anchors.centerIn: parent

    opacity: isShown ? 1 : 0
    color: Qt.rgba(0,0,0,0.9)

    Behavior on opacity {
        UbuntuNumberAnimation {}
    }

    Row {
        id: _dataRow

        width: childrenRect.width
        anchors.centerIn: parent
        spacing: units.gu(2)

        ActivityIndicator {
            id: _indicator
            running: isShown
        }

        Label {
            id: _loadingLabel
            text: i18n.tr("Loading...")
            anchors.verticalCenter: _indicator.verticalCenter
        }
    }
}
