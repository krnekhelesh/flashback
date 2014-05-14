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
import Ubuntu.Components 1.1
import Ubuntu.Components.ListItems 1.0 as ListItem
import "../backend/backend.js" as Backend
import "../components"
import "../models"

// Page to search for movies, tv shows and actors
Page {
    id: searchAllPage

    visible: false
    flickable: null
    title: i18n.tr("Search All")

    Shows  { id: show_search_results   }
    Movies { id: movie_search_results  }
    People { id: person_search_results }

    // Page Background
    Background {}

    LoadingIndicator {
        id: loadingIndicator
        loadingText: i18n.tr("Searching...")
        isShown: show_search_results.loading || movie_search_results.loading || person_search_results.loading
    }

    Flickable {
        id: mainFlickable
        clip: true
        anchors.fill: parent
        contentHeight: _searchBox.height + search_results.height + units.gu(10)

        // Search Box to enter search query along with the search button
        SearchBox {
            id: _searchBox
            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
                margins: units.gu(2)
            }
            onSearchTriggered: {
                show_search_results.model.clear()
                movie_search_results.model.clear()
                person_search_results.model.clear()
                if(_searchBox.search_term !== "") {
                    show_search_results.source = Backend.searchUrl("tv", _searchBox.search_term)
                    movie_search_results.source = Backend.searchUrl("movie", _searchBox.search_term)
                    person_search_results.source = Backend.searchUrl("person", _searchBox.search_term)
                    show_search_results.createMessage(traktLogin.contents.username, traktLogin.contents.password)
                    show_search_results.sendMessage()
                }
            }
        }

        Column {
            id: search_results

            anchors {
                top: _searchBox.bottom
                left: parent.left
                right: parent.right
                topMargin: units.gu(4)
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
