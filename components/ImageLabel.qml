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

import QtQuick 2.4
import Ubuntu.Components 1.2

/*
  Generic component to display an icon and text side by side
  */
Item {
    id: imageLabel

    // Public Properties

    property alias image: icon.source
    property alias label: iconText.text
    property alias size: icon.width

    height: childrenRect.height
    width: childrenRect.width

    Row {
        spacing: units.gu(0.5)
        Image{
            id: icon
            width: units.gu(4)
            fillMode: Image.PreserveAspectFit
            smooth: true
        }

        Label {
            id: iconText
            anchors.verticalCenter: icon.verticalCenter
        }
    }
}
