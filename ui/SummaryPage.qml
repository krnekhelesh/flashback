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
import "../components"

Page {
    id: summaryPage

    visible: false
    flickable: null
    title: i18n.tr("Full Summary")

    property alias summary: _summary.text

    // Page Background
    Background {}

    Flickable {
        id: flickable

        clip: true
        anchors.fill: parent
        flickableDirection: Flickable.VerticalFlick
        contentHeight: _summary.height + units.gu(5)

        Label {
            id: _summary

            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: units.gu(2)
            wrapMode: Text.WordWrap
        }
    }
}
