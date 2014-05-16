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

import QtQuick 2.0
import Ubuntu.Layouts 0.1
import Ubuntu.Components 0.1
import Ubuntu.Components.ListItems 0.1 as ListItem

/*
  Menu item component for the Sidebar. It should ideally be used in
  conjunction with the tablet sidebar component. It also had two
  modes depending on the tablet form factor (portrait, landscape).
 */
ListItem.Empty {
    id: _sidebarMenuItem

    // Property to set the label of the menu item in tablet portrait form
    property string shortenedMenuLabel

    // Property to set the label of the menu item in tablet landscape form
    property string menuLabel

    // Property to set the icon of the menu item
    property alias menuIcon: _menuIcon.source

    // Property to set the menu status (selected or not selected)
    property bool isSelected: false

    // Property to show menu item count
    property string menuCount: "0"

    width: parent.width
    height: tabletPortraitForm ? units.gu(8) : units.gu(6)

    Rectangle {
        id: _indicator

        color: UbuntuColors.orange
        anchors {
            left: parent.left
            top: parent.top
            bottom: parent.bottom
        }

        states: State {
            name: "selected"
            when: isSelected
            PropertyChanges { target: _indicator; width: units.gu(0.6) }
        }

        transitions: Transition {
            PropertyAnimation { target: _indicator; property: "width"; duration: UbuntuAnimation.FastDuration }
        }
    }

    Layouts {
        anchors.fill: parent
        anchors.leftMargin: tabletPortraitForm ? units.gu(0) : units.gu(3)

        layouts: [
            ConditionalLayout {
                name: "IconForm"
                when: tabletPortraitForm

                Column {
                    anchors.fill: parent
                    anchors.margins: units.gu(1.5)
                    spacing: units.gu(0.5)

                    ItemLayout {
                        item: "_menuIconItem"
                        width: units.gu(3)
                        height: units.gu(3)
                        anchors.horizontalCenter: parent.horizontalCenter

                        ItemLayout {
                            item: "_menuCountItem"
                            width: units.gu(3.5)
                            height: units.gu(3)
                            anchors.top: parent.top
                            anchors.topMargin: -units.gu(0.5)
                            anchors.left: parent.right
                            anchors.leftMargin: units.gu(1)
                        }
                    }

                    ItemLayout {
                        item: "_menuLabelItem"
                        width: _menuLabel.width
                        height: _menuLabel.height
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }
            }
        ]

        Row {
            anchors.fill: parent
            spacing: units.gu(2)

            Image {
                id: _menuIcon
                Layouts.item: "_menuIconItem"
                antialiasing: true
                height: parent.height/2.5
                fillMode: Image.PreserveAspectFit
                anchors.verticalCenter: parent.verticalCenter
            }

            Label {
                id: _menuLabel
                Layouts.item: "_menuLabelItem"
                width: units.gu(18)
                anchors.verticalCenter: parent.verticalCenter
                color: isSelected ? UbuntuColors.orange : "White"
                text: tabletPortraitForm ? shortenedMenuLabel : menuLabel
                horizontalAlignment: tabletPortraitForm ? Text.AlignHCenter : 0

            }

            Rectangle {
                id: _menuCount
                Layouts.item: "_menuCountItem"
                opacity: menuCount !== "0" ? 1 : 0
                color: UbuntuColors.orange
                width: units.gu(3.5)
                height: units.gu(3)
                radius: height
                anchors.verticalCenter: parent.verticalCenter

                Behavior on opacity {
                    UbuntuNumberAnimation {}
                }

                Label {
                    id: _count
                    text: menuCount
                    width: parent.width/1.1
                    elide: Text.ElideRight
                    horizontalAlignment: Text.AlignHCenter
                    anchors.centerIn: parent
                }
            }
        }
    }
}
