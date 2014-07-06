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
import QtGraphicalEffects 1.0

Rectangle {
    id: blurredBackground

    property alias background: backgroundImage.source

    anchors.fill: parent
    z: -1

    // Background Image
    Image {
        id: backgroundImage
        anchors.fill: parent
    }

    // Element to blur the background image
    FastBlur {
        anchors.fill: backgroundImage
        source: backgroundImage
        radius: units.gu(8)
    }

    // Element to add a black curtain (dimmer) to increase the readiblity of the text
    Rectangle {
        color: "black"
        opacity: 0.7
        anchors.fill: parent
    }
}
