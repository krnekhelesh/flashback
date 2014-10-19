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
import Ubuntu.Components.ListItems 1.0 as ListItem
import "../backend/backend.js" as Backend
import "../models"

Rectangle {
    id: ratingsChoice

    // Public properties required for submitting a user rating to Trakt
    property string type
    property string type_id
    property string name
    property string year
    property int season
    property int episode

    // Property to hold the user rating.
    property int ratings: 0

    // Signal triggered when ratings is successfully submitted
    signal ratingClicked()

    TraktUserRating {
        id: traktUserRating
        function updateJSONModel() {
            if(reply.status === "success") {
                console.log("[LOG]: " + type + " ratings success")
                ratingsChoice.ratings = ratingListModel.get(ratingList.currentIndex).rating
                ratingsChoice.ratingClicked()
            }
        }
    }

    color: "Black"
    visible: false
    radius: units.gu(2)
    width: parent.width/1.6
    height: parent.height/1.2

    TraktRatingModel { id: ratingListModel }

    ListView {
        id: ratingList

        clip: true
        currentIndex: -1
        model: ratingListModel
        spacing: units.gu(1)
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            bottom: cancelButton.top
            margins: units.gu(2)
        }

        delegate: ListItem.Standard {
            text: ratingDescription
            iconFrame: false
            iconSource: Qt.resolvedUrl(thumb_url)
            onClicked: {
                ratingList.currentIndex = index
                ratingsChoice.visible = false
                traktUserRating.source = Backend.traktAddRatingUrl(type)
                if(type === "movie")
                    traktUserRating.createMovieMessage(traktLogin.contents.username, traktLogin.contents.password, type_id, name, year, rating)
                else if(type === "episode")
                    traktUserRating.createEpisodeMessage(traktLogin.contents.username, traktLogin.contents.password, type_id, name, year, season, episode, rating)
                else if(type === "show")
                    traktUserRating.createShowMessage(traktLogin.contents.username, traktLogin.contents.password, type_id, name, year, rating)
                traktUserRating.sendMessage()
            }
        }
    }

    Button {
        id: cancelButton
        width: parent.width/2
        text: i18n.tr("Cancel")
        onClicked: ratingsChoice.visible = false
        anchors {
            horizontalCenter: parent.horizontalCenter
            bottom: parent.bottom
            bottomMargin: units.gu(2)
        }
    }
}
