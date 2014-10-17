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
import "../components"
import "../models"
import "../backend/backend.js" as Backend

Page {
    id: personTab

    Component.onCompleted: console.log("[LOG]: People Tab Loaded")

    // Tab Background
    Background {}

    People {
        id: popularPeople
        source: Backend.popularPeopleUrl()
    }

    LoadingIndicator {
        isShown: popularPeople.loading && personTab.state !== "search"
    }

    Grid {
        id: popular
        dataModel: popularPeople.model
        header: i18n.tr("Popular")
        anchors.fill: parent
        onThumbClicked: pageStack.push(Qt.resolvedUrl("PersonPage.qml"), {"person_id": model.id})
    }

    Loader {
        id: searchPageLoader
        anchors.fill: parent
    }

    Component {
        id: searchPageComponent
        SearchPage {
            id: searchPage

            type: "person"
            search_model: search_results
            onResultClicked: pageStack.push(Qt.resolvedUrl("PersonPage.qml"), {"person_id": model.id, "type": "person"})

            People {
                id: search_results
            }
        }
    }


    Action {
        id: searchPersonAction
        text: i18n.tr("Celeb")
        keywords: i18n.tr("Search;Person;Actor;Actors;Actress;Cast;Crew;Find")
        description: i18n.tr("Search for Actors, Actress and Crew")
        iconName: "search"
        onTriggered: {
            personTab.state = "search"
            searchField.forceActiveFocus()
            popular.visible = false
            searchPageLoader.sourceComponent = searchPageComponent
        }
    }

    state: "default"
    states: [
        PageHeadState {
            name: "default"
            head: personTab.head
            actions: [
                searchPersonAction,
                appSettingsAction
            ]
        },

        PageHeadState {
            name: "search"
            head: personTab.head
            backAction: Action {
                iconName: "back"
                text: i18n.tr("Back")
                onTriggered: {
                    personTab.state = "default"
                    popular.visible = true
                    searchField.text = ""
                    searchPageLoader.sourceComponent = undefined
                }
            }

            contents: SearchBox {
                id: searchField
                defaultText: i18n.tr("Search Celeb")
                anchors {
                    left: parent ? parent.left : undefined
                    right: parent ? parent.right : undefined
                    rightMargin: units.gu(2)
                }

                onSearchTriggered: {
                    if (searchPageLoader.status === Loader.Ready) {
                        searchPageLoader.item.search_model.model.clear();
                    }
                    if (searchField.text !== "") {
                        searchPageLoader.item.search_model.source = Backend.searchUrl(searchPageLoader.item.type, searchField.search_term);
                    }
                }
            }
        }
    ]
}
