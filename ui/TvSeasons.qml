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
import Ubuntu.Components 0.1
import Ubuntu.Components.ListItems 0.1
import "../components"

Page {
    id: tvSeasonPage

    visible: false
    title: i18n.tr("Default")

    property alias dataModel: list.model
    property string tv_id
    property string imdb_id
    property string name
    property string year

    // Season List
    ListView {
        id: list

        clip: true
        anchors.fill: parent

        delegate: Standard {
            text: season == 0 ? i18n.tr("Season Specials") : i18n.tr("Season") + " " + season
            iconSource: thumb_url
            onClicked: pageStack.push(Qt.resolvedUrl("SeasonPage.qml"), {"tv_id": tv_id, "imdb_id": imdb_id, "name": name, "year": year, "season_number": season, "season_poster": thumb_url})
        }
    }

    tools: ToolbarItems {
        id: toolbarSeasons

        ToolbarButton {
            id: returnHome
            visible: pageStack.depth > 2
            action: returnHomeAction
        }
    }
}
