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
import Ubuntu.Layouts 1.0
import Ubuntu.Components 1.1

ConditionalLayout {
    id: tabletConditionalLayout

    name: "tablet"
    when: tabletLandscapeForm || tabletPortraitForm

    Item {
        anchors.fill: parent

        Label {
            id: introText

            fontSize: "x-large"
            width: parent.width
            wrapMode: Text.WordWrap
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter

            text: i18n.tr("Access a whole array of features with a Trakt Account!")

            anchors {
                bottom: loginBoxTablet.top
                left: parent.left
                right: parent.right
                top: parent.top
                margins: units.gu(2)
                bottomMargin: units.gu(5)
            }
        }

        Row {
            id: loginBoxTablet

            anchors.centerIn: parent
            anchors.margins: units.gu(2)
            spacing: units.gu(5)

            ItemLayout {
                id: logoTablet
                item: "logo"
                width: traktLoginPage.width/5
                height: 1.1 * width
                anchors.verticalCenter: parent.verticalCenter

                Behavior on width {
                    UbuntuNumberAnimation { duration: UbuntuAnimation.BriskDuration }
                }
            }

            ItemLayout {
                item: "loginBox"
                width: traktLoginPage.width/2
                height: loginBox.height
                anchors.verticalCenter: logoTablet.verticalCenter
            }
        }
    }
}
