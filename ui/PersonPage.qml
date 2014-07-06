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
import Ubuntu.Components.ListItems 1.0 as ListItem
import '../models'
import '../components'
import '../backend/backend.js' as Backend

Page {
    id: personPage

    visible: false
    flickable: null
    title: person.attributes.name ? person.attributes.name : "Celeb"

    property string person_id

    PersonCast { id: personCast }
    PersonCrew { id: personCrew }

    // Page Background
    Background {}

    Person {
        id: person
        source: Backend.personUrl(person_id, {appendToResponse: ['combined_credits']})
        onUpdated: {
            personCast.json = person.attributes.combinedCreditsJson;
            personCrew.json = person.attributes.combinedCreditsJson;
        }
    }

    LoadingIndicator {
        id: loadingIndicator
        isShown: personCast.loading ||
                 personCrew.loading ||
                 person.loading
    }

    Flickable {
        id: flickable

        clip: true
        anchors.fill: parent
        contentHeight: personThumb.height + personColumn.height + summary.height + detailsColumn.height
        interactive: contentHeight > parent.height

        Thumbnail {
            id: personThumb
            width: units.gu(20)
            height: width + units.gu(8)
            thumbSource: person.attributes.thumb_url
            anchors {
                top: parent.top
                left: parent.left
                margins: units.gu(2)
            }
        }

        Column {
            id: personColumn

            height: personThumb.height
            width: parent.width - personThumb.width
            anchors {
                top: parent.top
                left: personThumb.right
                right: parent.right
                margins: units.gu(2)
            }

            Label {
                id: birthPlace
                text: person.attributes.placeOfBirth
                visible: person.attributes.placeOfBirth
                fontSize: "medium"
                width: personColumn.width
                elide: Text.ElideRight
                wrapMode: Text.WordWrap
            }

            Label {
                id: birthYear
                text: i18n.tr("Birth") + ": " + person.attributes.birthday.split('-')[0]
                fontSize: "medium"
                visible: person.attributes.birthday
                width: personColumn.width
                elide: Text.ElideRight
                wrapMode: Text.WordWrap
            }

            Label {
                id: deathYear
                text: i18n.tr("Death") + ": " + person.attributes.deathday.split('-')[0]
                fontSize: "medium"
                visible: person.attributes.deathday
                width: personColumn.width
                elide: Text.ElideRight
                wrapMode: Text.WordWrap
            }

            Label {
                id: contact
                text: person.attributes.homepage
                visible: person.attributes.homepage
                fontSize: "medium"
                width: personColumn.width
                wrapMode: Text.WrapAnywhere
                MouseArea {
                    anchors.fill: parent
                    enabled: person.attributes.homepage
                    onClicked: Qt.openUrlExternally(contact.text)
                }
            }
        }

        Label {
            id: summary

            anchors {
                top: personColumn.bottom
                left: parent.left
                right: parent.right
                margins: units.gu(2)
            }

            elide: Text.ElideRight
            wrapMode: Text.WordWrap
            text: person.attributes.biography ? person.attributes.biography : i18n.tr("No biography found")

            onTextChanged: summary.height = text.length < 500 ? summary.implicitHeight : units.gu(20)

            Connections {
                target: personPage
                onWidthChanged: summary.height = summary.text.length < 500 ? summary.implicitHeight : units.gu(20)
            }

            MouseArea {
                anchors.fill: parent
                enabled: summary.truncated
                onClicked: pagestack.push(Qt.resolvedUrl("SummaryPage.qml"), {"summary": person.attributes.biography})
            }
        }

        Column {
            id: detailsColumn
            anchors {
                top: summary.bottom
                left: parent.left
                right: parent.right
                margins: units.gu(2)
            }

            ListViewExpandable {
                id: actingExpandable
                model: personCast.model
                count: personCast.model.count
                header: "Acting (%1)".arg(count)
                delegateItem: ListItem.Subtitled {
                    iconSource: thumb_url
                    text: title
                    subText: character
                    onClicked: mediaType == "movie" ? pageStack.push(Qt.resolvedUrl("MoviePage.qml"), {"movie_id": id}) : undefined
                }
                anchors {
                    left: parent.left
                    right: parent.right
                    margins: -detailsColumn.anchors.margins
                }
            }

            ListViewExpandable {
                id: productionExpandable
                model: personCrew.model
                count: personCrew.model.count
                header: "Production (%1)".arg(count)
                delegateItem: ListItem.Subtitled {
                    iconSource: thumb_url
                    text: title
                    subText: department
                    onClicked: mediaType == "movie" ? pageStack.push(Qt.resolvedUrl("MoviePage.qml"), {"movie_id": id}) : undefined
                }
                anchors {
                    left: parent.left
                    right: parent.right
                    margins: -detailsColumn.anchors.margins
                }
            }
        }
    }

    tools: ToolbarItems {
        id: toolbarPerson

        ToolbarButton {
            id: returnHome
            action: returnHomeAction
        }
    }
}
