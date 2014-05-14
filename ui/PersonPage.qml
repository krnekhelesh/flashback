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
        contentHeight: personThumb.height + personColumn.height + biographyContainer.height + detailsColumn.height
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

            spacing: units.gu(2)

            Label {
                id: name
                text: person.attributes.name
                fontSize: "large"
                width: personColumn.width
                maximumLineCount: 2
                elide: Text.ElideRight
                wrapMode: Text.WordWrap
            }

            Column {
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
                    elide: Text.ElideRight
                    wrapMode: Text.WordWrap
                    MouseArea {
                        anchors.fill: parent
                        enabled: person.attributes.homepage
                        onClicked: Qt.openUrlExternally(contact.text)
                    }
                }
            }
        }

        Rotater {
            id: biographyContainer

            flipHeight: personPage.height
            anchors {
                top: personColumn.bottom
                left: parent.left
                right: parent.right
                margins: units.gu(2)
            }

            onFlippedChanged: {
                if (!biographyContainer.flipped)
                    flickable.interactive =  flickable.contentHeight > personPage.height
                else
                    flickable.interactive = false
            }

            front: Label {
                id: overview
                text: person.attributes.biography ? person.attributes.biography : i18n.tr("No biography found")
                fontSize: "medium"
                anchors.fill: parent
                elide: Text.ElideRight
                wrapMode: Text.WordWrap

                onTextChanged: biographyContainer.height = text.length < 500 ? overview.implicitHeight : units.gu(20)

                Connections {
                    target: personPage
                    onWidthChanged: biographyContainer.height = overview.text.length < 500 ? overview.implicitHeight : units.gu(20)
                }

                MouseArea {
                    anchors.fill: parent
                    enabled: {
                        if (!biographyContainer.flipped)
                            if(overview.truncated)
                                return true
                            else
                                return false
                        else
                            return false
                    }
                    onClicked: {
                        biographyContainer.flipped = !biographyContainer.flipped

                        if(!flickable.atYBeginning)
                            flickable.contentY = 0
                    }
                }
            }

            back: Rectangle {
                color: UbuntuColors.coolGrey
                anchors {
                    fill: parent
                    leftMargin: units.gu(-2)
                    rightMargin: units.gu(-2)
                }

                Flickable {
                    id: summaryFlickable
                    anchors.fill: parent
                    flickableDirection: Flickable.VerticalFlick
                    contentHeight: mainColumn.height > parent.height ? mainColumn.height + units.gu(5) : parent.height
                    interactive: contentHeight > parent.height

                    Column {
                        id: mainColumn
                        anchors {
                            left: parent.left
                            right: parent.right
                            top: parent.top
                            margins: units.gu(2)
                        }

                        spacing: units.gu(2)

                        Label {
                            id: header
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: i18n.tr("Full Summary")
                            fontSize: "x-large"
                        }

                        Label {
                            id: fullOverview
                            text: person.attributes.biography
                            visible: person.attributes.biography
                            fontSize: "medium"
                            anchors {
                                left: parent.left
                                right: parent.right
                            }

                            elide: Text.ElideRight
                            wrapMode: Text.WordWrap
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        enabled: biographyContainer.flipped
                        onClicked: biographyContainer.flipped = !biographyContainer.flipped
                    }
                }
            }
        }

        Column {
            id: detailsColumn
            anchors {
                top: biographyContainer.bottom
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
            visible: pageStack.depth > 2
            action: returnHomeAction
        }
    }
}
