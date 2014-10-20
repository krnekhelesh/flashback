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

import QtQuick 2.3
import Ubuntu.Components 1.1

/*
  Thumbnail wraps up an image in a ubuntu shape container.
  */
UbuntuShape {
    id: carouselThumb
    
    property alias thumbSource: thumbPic.source
    radius: "medium"
    
    image: Image {
        id: thumbPic
        fillMode: Image.PreserveAspectCrop
        smooth: true
    }
    
    ActivityIndicator {
        running: thumbPic.status != Image.Ready
        anchors.centerIn: parent
    }
}
