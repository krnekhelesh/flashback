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
  Component to show movie/show status icons such as watched status, watchlist, etc.
  */
Rectangle {
    id: _statusIconsContainer

    property real iconWidth: units.gu(2)
    property bool showWatchedIcon: false
    property bool showWatchListIcon: false
    
    color: "black"
    opacity: 0.7
    smooth: true
    z: parent.z + 1
    radius: units.gu(0.5)
    width: _iconColumn.width + units.gu(0.5)
    height: showWatchedIcon || showWatchListIcon ? _iconColumn.height + units.gu(0.5) : 0
    
    Column {
        id: _iconColumn
        anchors {
            top: parent.top
            left: parent.left
            margins: units.gu(0.2)
        }
        
        spacing: units.gu(0.2)
        
        Image {
            id: _watchPic
            source: Qt.resolvedUrl("../graphics/watched.png")
            fillMode: Image.PreserveAspectFit
            visible: showWatchedIcon
            width: iconWidth
            smooth: true
        }
        
        Image {
            id: _watchListPic
            source: Qt.resolvedUrl("../graphics/watchlist.png")
            fillMode: Image.PreserveAspectFit
            visible: showWatchListIcon
            width: iconWidth
            smooth: true
        }
    }
}
