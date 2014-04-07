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
import Ubuntu.Components 0.1
import Ubuntu.Components.ListItems 0.1

// Expandable List Element
Expandable {
    id: listviewExpandable

    // Property to set the model of the search results listview
    property alias model: _resultsList.model

    // Property to set the label of the search category header
    property alias header: _header.text

    // Property to store the number of the search results
    property int count

    // Property to set the listitem delegate
    property alias delegateItem: _resultsList.delegate

    collapseOnClick: true
    enabled: count !== 0
    visible: count !== 0
    onClicked: expanded = true
    expandedHeight: _contentColumn.height + units.gu(1)

    Column {
        id: _contentColumn
        anchors {
            left: parent.left
            right: parent.right
        }

        Item {
            anchors {
                left: parent.left
                right: parent.right
            }

            height: listviewExpandable.collapsedHeight

            Label {
                id: _header
                anchors {
                    left: parent.left
                    right: parent.right
                    verticalCenter: parent.verticalCenter
                }
            }
        }

        ListView {
            id: _resultsList
            clip: true
            height: count > 5 ? 5 * units.gu(6) : count * units.gu(6)
            anchors {
                left: parent.left
                right: parent.right
            }
        }
    }
}
