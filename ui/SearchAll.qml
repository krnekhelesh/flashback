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

import QtQuick 2.3
import Ubuntu.Components 1.1
import Ubuntu.Components.ListItems 1.0 as ListItem
import "../backend/backend.js" as Backend
import "../components"
import "../models"

// Page to search for movies, tv shows and actors
Item {
    id: searchAllPage

    property alias showSearchResults: show_search_results
    property alias movieSearchResults: movie_search_results
    property alias personSearchResults: person_search_results

    Shows  { id: show_search_results   }
    Movies { id: movie_search_results  }
    People { id: person_search_results }

    LoadingIndicator {
        id: loadingIndicator
        loadingText: i18n.tr("Searching...")
        isShown: show_search_results.loading || movie_search_results.loading || person_search_results.loading
    }

    Flickable {
        id: mainFlickable
        clip: true
        anchors.fill: parent
        contentHeight: search_results.height + units.gu(10)

        Column {
            id: search_results

            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
            }

            ListViewExpandable {
                id: movieExpandable
                model: movie_search_results.model
                count: movie_search_results.model.count
                header: "Movies (%1)".arg(count)
                delegateItem: ListItem.Standard {
                    text: name
                    iconSource: thumb_url
                    onClicked: pageStack.push(Qt.resolvedUrl("MoviePage.qml"), {"movie_id": model.id})
                }
            }

            ListViewExpandable {
                id: showExpandable
                model: show_search_results.model
                count: show_search_results.model.count
                header: "TV Shows (%1)".arg(count)
                delegateItem: ListItem.Standard {
                    text: name
                    iconSource: thumb_url
                    onClicked: pageStack.push(Qt.resolvedUrl("TvPage.qml"), {"tv_id": model.id})
                }
            }

            ListViewExpandable {
                id: personExpandable
                model: person_search_results.model
                count: person_search_results.model.count
                header: "Celebs (%1)".arg(count)
                delegateItem: ListItem.Standard {
                    text: name
                    iconSource: thumb_url
                    onClicked: pageStack.push(Qt.resolvedUrl("PersonPage.qml"), {"person_id": model.id, "type": "person"})
                }
            }
        }
    }
}
