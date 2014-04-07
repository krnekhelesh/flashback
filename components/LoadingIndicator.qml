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
  Generic loading indicator component to provide user feedback
  */
Rectangle {
    id: loadingContainer

    property alias loadingText: _loadingLabel.text

    width: units.gu(30)
    height: units.gu(10)    
    radius: units.gu(0.5)

    opacity: 0.7
    color: "Black"

    anchors.centerIn: parent
    z: parent.z + 1

    Row {
        anchors.centerIn: parent
        spacing: units.gu(2)

        ActivityIndicator {
            id: _indicator
            running: true
        }

        Label {
            id: _loadingLabel
            text: i18n.tr("Loading...")
            anchors.verticalCenter: _indicator.verticalCenter
        }
    }
}
