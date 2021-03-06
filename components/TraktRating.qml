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
import "../components"

Item {
    id: ratings

    property alias rating: _rating.label
    property alias personal: _personalRating.label
    property alias personalIcon: _personalRating.image

    height: _overallRating.height

    signal clicked()

    Row {
        id: _overallRating

        spacing: units.gu(2)
        anchors {
            horizontalCenter: parent.horizontalCenter
            verticalCenter: parent.verticalCenter
        }

        ImageLabel {
            id: _rating
            image: Qt.resolvedUrl("../graphics/star.png")
        }

        ImageLabel {
            id: _personalRating
            MouseArea {
                anchors.fill: parent
                onClicked: ratings.clicked()
            }
        }
    }
}
