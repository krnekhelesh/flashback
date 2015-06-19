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
import QtGraphicalEffects 1.0

/*
  Component to wrap up an image in a ubuntu shape container and desaturate it. This is very similar to the
  Thumbnail component except with the desaturation.
  */
UbuntuShape {
    id: desaturatedThumb

    property alias thumbSource: thumbPic.source
    property alias ready: loading.running

    radius: "medium"

    image: Image {
        id: thumbPic
        fillMode: Image.PreserveAspectFit
        visible: false
    }

    HueSaturation {
        id: saturated
        anchors.fill: parent
        source: thumbPic
        hue: 0
        saturation: -1.0
        lightness: 0
        visible: false
    }

    OpacityMask {
        anchors.fill: saturated
        source: saturated
        maskSource: desaturatedThumb
    }

    ActivityIndicator {
        id: loading
        running: thumbPic.status != Image.Ready
        anchors.centerIn: parent
    }
}
