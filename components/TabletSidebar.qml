/*
 * Flashback - Entertainment app for Ubuntu
 * Copyright (C) 2014 Nekhelesh Ramananthan <nik90@ubuntu.com>
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

import QtQuick 2.3
import Ubuntu.Components 0.1
import Ubuntu.Components.ListItems 0.1 as ListItem

/*
  Sidebar Component shown on the left side (Tablet Mode) and can be used to house various options.
  It has two layouts IconForm and FullForm which are activated based on the tablet form factor.
  In tablet portrait form, the icon form is used. While in the tablet landscape mode, the full
  form is used.

  Based on the form, the sidebar width adjusts automatically.
*/
Rectangle {
    id: sidebar

    color: Qt.rgba(0,0,0,0.4)
    anchors.top: parent.top
    anchors.bottom: parent.bottom

    states: [
        State {
            name: "IconForm"
            when: tabletPortraitForm
            PropertyChanges { target: sidebar; width: units.gu(15) }
        },

        State {
            name: "FullForm"
            when: tabletLandscapeForm
            PropertyChanges { target: sidebar; width: units.gu(35) }
        }
    ]

    transitions: Transition {
        PropertyAnimation { target: sidebar; property: "width"; duration: UbuntuAnimation.FastDuration }
    }

    Item {
        width: divider.height
        anchors {
            top: parent.top
            bottom: parent.bottom
            right: parent.right
            rightMargin: -1
        }

        ListItem.ThinDivider {
            id: divider
            rotation: -90
            width: parent.height
            anchors.centerIn: parent
        }
    }
}
