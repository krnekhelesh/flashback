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
import Ubuntu.Components.ListItems 1.0 as ListItem
import "../components"

Page {
    id: aboutPage

    title: i18n.tr("Credits")

    visible: false
    flickable: null

    // Page Background
    Background {}

    Flickable {
        clip: true
        anchors.fill: parent
        contentHeight: mainColumn.height + units.gu(5)

        Column {
            id: mainColumn
            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
                margins: units.gu(2)
            }

            height: childrenRect.height
            spacing: units.gu(1)

            ListItem.Subtitled {
                text: "Nekhelesh Ramananthan"
                subText: i18n.tr("Author, Developer")
                iconSource: Qt.resolvedUrl("../graphics/author.jpg")
                showDivider: false
            }

            ListItem.Subtitled {
                text: "Arash Badie Modiri"
                subText: i18n.tr("Developer")
                iconSource: Qt.resolvedUrl("../graphics/no-passport.png")
                showDivider: false
            }

            ListItem.Subtitled {
                text: "Lucas Romero Di Benedetto"
                subText: i18n.tr("UI Designer")
                iconSource: Qt.resolvedUrl("../graphics/designer.jpg")
                showDivider: false
            }

            ListItem.Subtitled {
                text: "Andrea Del Sarto"
                subText: i18n.tr("Assets Designer")
                iconSource: Qt.resolvedUrl("../graphics/icon_designer.jpg")
                showDivider: false
            }

            // Add more contributors below as required.
        }
    }
}
