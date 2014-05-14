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
  Generic component to provide the capability to truncate text or data when space is limited and yet provide
  allow viewing of lengthy text or data when required without using a page.
  */
Flipable {
    id: _rotater

    // Property to flip the component to view the full extensive text or data
    property bool flipped: false

    // Property to hold the height of the flipped component
    property real flipHeight

    z: parent.z + 1

    transform: Rotation {
        id: _rotation
        origin { x: _rotater.width/2; y: _rotater.height/2 }
        axis { x: 0; y: 1; z: 0 }
        angle: 0
    }

    states: State {
        name: "back"
        PropertyChanges { target: _rotation; angle: 180 }
        PropertyChanges { target: _rotater; height: flipHeight }
        PropertyChanges { target: _rotater; anchors.topMargin: units.gu(0) }

        AnchorChanges {
            target: _rotater
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
        }

        when: _rotater.flipped
    }

    transitions: Transition {
        ParallelAnimation {
            UbuntuNumberAnimation { target: _rotation; property: "angle"; duration: UbuntuAnimation.SlowDuration }
            AnchorAnimation {}
        }
    }
}
