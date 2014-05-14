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
import Ubuntu.Components.Popups 1.0
import Ubuntu.Components.ListItems 1.0
import "../components"
import "../models"
import "../backend/backend.js" as Backend

Page {
    id: moviePage

    visible: false
    flickable: null

    property string movie_id
    property bool isMovieSeen
    property bool isMovieWatchlisted

    property int voteCount: 0
    property double averageVote: 0
    property int userVote: 0

    Cast { id: movieCast }
    Crew { id: movieCrew }
    Trailer { id: movieTrailer }
    Movies { id: similarMoviesModel }

    // Page Background
    Background {}

    Movie {
        id: movie
        source: Backend.movieUrl(movie_id, {appendToResponse: ['credits', 'similar_movies', 'trailers']})

        onUpdated: {
            movieCast.json = movie.attributes.creditsJson;
            movieCrew.json = movie.attributes.creditsJson;
            movieTrailer.json = movie.attributes.trailersJson;
            similarMoviesModel.json = movie.attributes.similarMoviesJson;
        }
    }

    BasePostModel {
        id: traktMovieDetails
        username: traktLogin.contents.username
        password: traktLogin.contents.password
        onPasswordChanged: {
            source = Backend.traktMovieUrl(movie_id)
            createMessage(username, password)
            sendMessage()
        }
        function updateJSONModel() {
            voteCount = reply.ratings.votes
            averageVote = reply.ratings.percentage
            if (traktLogin.contents.status !== "disabled") {
                isMovieSeen = reply.watched
                isMovieWatchlisted = reply.in_watchlist
                userVote = reply.rating_advanced
            }
        }
    }

    RatingChooser {
        id: userRatingDialog
        z: movieThumb.z + 1
        type: "movie"
        type_id: movie_id
        name: movie.attributes.title
        year: movie.attributes.releaseDate.split('-')[0]
        onRatingClicked: userVote = ratings
        anchors.centerIn: parent
    }

    LoadingIndicator {
        id: loadingIndicator
        isShown: movie.loading ||
                 traktMovieDetails.loading ||
                 similarMoviesModel.loading ||
                 movieCast.loading ||
                 movieCrew.loading ||
                 movieTrailer.loading
    }

    BasePostModel {
        id: cancelCheckIn
        function updateJSONModel() {
            if(reply.status === "success") {
                console.log("[LOG]: Movie Check-in cancelled")
                isMovieSeen = false
                userActivityLoader.item.setDefaultDatabase()
                userActivityLoader.item.getUserActivityOnline()
            }
        }
    }

    TraktSeen {
        id: movieSee
        function updateJSONModel() {
            if(reply.status === "success") {
                loadingIndicator.isShown = false
                console.log("[LOG]: Movie watch success")
                isMovieSeen = true
            }
        }
    }

    TraktSeen {
        id: movieUnsee
        function updateJSONModel() {
            if(reply.status === "success") {
                loadingIndicator.isShown = false
                console.log("[LOG]: Movie unwatch success")
                isMovieSeen = false
            }
        }
    }

    TraktWatchlist {
        id: movieWatchlist
        function updateJSONModel() {
            if(reply.status === "success") {
                loadingIndicator.isShown = false
                var tempData = watchlistActivityDocument.contents
                if(!isMovieWatchlisted) {
                    console.log("[LOG]: Movie watchlist success")
                    isMovieWatchlisted = true
                    tempData.movie = "Added->" + movie.attributes.title
                }
                else {
                    console.log("[LOG]: Movie Unwatchlist success")
                    isMovieWatchlisted = false
                    tempData.movie = "Removed->" + movie.attributes.title
                }
                watchlistActivityDocument.contents = tempData
            }
        }
    }

    Component {
        id: sharePopoverComponent
        TraktPopup {
            checkInMessage: movieActivityDocument.contents.name !== "default" ? i18n.tr("Cancel current movie check-in") : i18n.tr("Check-in movie into Trakt")
            watchlistMessage: isMovieWatchlisted ? i18n.tr("Remove movie from watchlist") : i18n.tr("Add movie to watchlist")
            seenMessage: isMovieSeen ? i18n.tr("Mark movie as unseen") : i18n.tr("Mark movie as seen")
            onCheckedIn: {
                if(movieActivityDocument.contents.name !== "default") {
                    cancelCheckIn.source = Backend.cancelTraktCheckIn("movie")
                    cancelCheckIn.createMessage(traktLogin.contents.username, traktLogin.contents.password)
                    cancelCheckIn.sendMessage()
                }
                else
                    pagestack.push(Qt.resolvedUrl("TraktCheckIn.qml"), {moviePage: moviePage, type: "Movie", id: movie.attributes.imdb_id, movieTitle: movie.attributes.title, year: movie.attributes.releaseDate.split('-')[0]})
            }
            onWatched: {
                loadingIndicator.loadingText = !isMovieSeen ? i18n.tr("Marking movie as seen") : i18n.tr("Marking movie as unseen")
                loadingIndicator.isShown = true
                if(!isMovieSeen) {
                    movieSee.source = Backend.traktSeenUrl("movie")
                    movieSee.createMovieMessage(traktLogin.contents.username, traktLogin.contents.password, movie.attributes.imdb_id, movie.attributes.title, movie.attributes.releaseDate.split('-')[0])
                    movieSee.sendMessage()
                }
                else {
                    movieUnsee.source = Backend.cancelTraktSeen("movie")
                    movieUnsee.createMovieMessage(traktLogin.contents.username, traktLogin.contents.password, movie.attributes.imdb_id, movie.attributes.title, movie.attributes.releaseDate.split('-')[0])
                    movieUnsee.sendMessage()
                }
            }
            onWatchlisted:  {
                loadingIndicator.loadingText = !isMovieWatchlisted ? i18n.tr("Adding movie to watchlist") : i18n.tr("Removing movie from watchlist")
                loadingIndicator.isShown = true
                if(!isMovieWatchlisted) {
                    movieWatchlist.source = Backend.traktWatchlistUrl("movie")
                    movieWatchlist.createMovieMessage(traktLogin.contents.username, traktLogin.contents.password, movie.attributes.imdb_id, movie.attributes.title, movie.attributes.releaseDate.split('-')[0])
                }
                else {
                    movieWatchlist.source = Backend.traktUnwatchlistUrl("movie")
                    movieWatchlist.createMovieMessage(traktLogin.contents.username, traktLogin.contents.password, movie.attributes.imdb_id, movie.attributes.title, movie.attributes.releaseDate.split('-')[0])
                }
                movieWatchlist.sendMessage()
            }
            onCommented: pagestack.push(Qt.resolvedUrl("CommentsPage.qml"), {id: movie_id, type: "Movie", name: movie.attributes.title, year: movie.attributes.releaseDate.split('-')[0]})
        }
    }

    Component {
        id: trailerPopoverComponent
        Popover {
            id: popover
            Column {
                id: containerLayout
                anchors {
                    left: parent.left
                    top: parent.top
                    right: parent.right
                }
                Repeater {
                    model: movieTrailer.model.count
                    delegate: Subtitled {
                        text: movieTrailer.model.get(index).name
                        iconSource: Qt.resolvedUrl("../graphics/trailer2.png")
                        iconFrame: true
                        subText: movieTrailer.model.get(index).type
                        onClicked: {
                            Qt.openUrlExternally("http://www.youtube.com/watch?v=" + movieTrailer.model.get(index).url)
                            PopupUtils.close(popover)
                        }
                    }
                }
            }
        }
    }

    actions: [
        Action {
            id: playMovieTrailerAction
            text: i18n.tr("Trailer")
            keywords: i18n.tr("Play;Watch;Trailer;Preview")
            description: i18n.tr("Play Movie Trailer")
            enabled: movieTrailer.model.count > 0
            iconSource: Qt.resolvedUrl("../graphics/play.svg")
            onTriggered: PopupUtils.open(trailerPopoverComponent, playTrailer)
        },

        TraktAction {
            id: shareMovieAction
            onTriggered: PopupUtils.open(sharePopoverComponent, shareMovie)
        }
    ]

    Flickable {
        id: flickable
        anchors.fill: parent
        flickableDirection: Flickable.VerticalFlick
        contentHeight: movieThumb.height + ratingsRow.height + detailsColumn.height + units.gu(10)

        Behavior on contentY {
            UbuntuNumberAnimation { target: flickable; property: "contentY"; duration: UbuntuAnimation.SlowDuration }
        }

        Thumbnail {
            id: movieThumb
            width: units.gu(18)
            height: width + units.gu(10)
            thumbSource: movie.attributes.thumb_url

            anchors {
                top: parent.top
                left: parent.left
                margins: units.gu(2)
            }
        }

        Label {
            id: title
            text: movie.attributes.title
            fontSize: "large"
            maximumLineCount: 2
            elide: Text.ElideRight
            wrapMode: Text.WordWrap
            anchors {
                top: parent.top
                left: movieThumb.right
                right: parent.right
                leftMargin: units.gu(2)
                rightMargin: units.gu(2)
                topMargin: units.gu(2)
            }
        }

        Rotater {
            id: overviewContainer

            flipHeight: moviePage.height
            height: movieThumb.height/2
            anchors {
                top: title.bottom
                left: title.left
                right: title.right
                topMargin: units.gu(2)
            }

            visible: movie.attributes.overview

            onFlippedChanged: {
                if (!overviewContainer.flipped)
                    flickable.interactive =  flickable.contentHeight > moviePage.height
                else
                    flickable.interactive = false
            }

            front: Label {
                id: overview
                text: movie.attributes.overview
                visible: movie.attributes.overview
                fontSize: "medium"
                anchors.fill: parent
                elide: Text.ElideRight
                wrapMode: Text.WordWrap

                MouseArea {
                    anchors.fill: parent
                    enabled: {
                        if (!overviewContainer.flipped)
                            if(overview.truncated)
                                return true
                            else
                                return false
                        else
                            return false
                    }
                    onClicked: {
                        overviewContainer.flipped = !overviewContainer.flipped

                        if(!flickable.atYBeginning)
                            flickable.contentY = 0
                    }
                }
            }

            back: Rectangle {
                color: "Transparent"
                anchors.fill: parent

                Background{}

                Flickable {
                    id: summaryFlickable
                    anchors.fill: parent
                    flickableDirection: Flickable.VerticalFlick
                    contentHeight: mainColumn.height > parent.height ? mainColumn.height + units.gu(10) : parent.height
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
                            text: movie.attributes.overview
                            visible: movie.attributes.overview
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
                        enabled: overviewContainer.flipped
                        onClicked: overviewContainer.flipped = !overviewContainer.flipped
                    }
                }
            }
        }

        Column {
            id: movieColumn
            anchors {
                left: title.left
                right: title.right
                bottom: movieThumb.bottom
            }
            spacing: units.gu(1)
            ImageLabel {
                image: Qt.resolvedUrl("../graphics/calendar.png")
                size: units.gu(2)
                label: movie.attributes.releaseDate.split('-')[0]
                visible: movie.attributes.releaseDate
            }

            ImageLabel {
                image: Qt.resolvedUrl("../graphics/duration.png")
                size: units.gu(2)
                label: formatDuration(movie.attributes.runtime)
                visible: movie.attributes.runtime > 0

                function formatDuration(time) {
                    var hours = Math.floor(time / 60)
                    var minutes = time % 60
                    if (hours === 0)
                        return minutes + " minutes"
                    else if (hours === 1 && minutes === 0)
                        return hours + " hour"
                    else if (hours > 1 && minutes === 0)
                        return hours + " hours"
                    else if(hours === 1 && minutes !== 0)
                        return hours + " hr " + minutes + " mins"
                    else
                        return hours + " hrs " + minutes + " mins"
                }
            }
        }

        // Ratings Row
        TraktRating {
            id: ratingsRow
            visible: voteCount > 0
            rating: "%1%\n%2 votes".arg(averageVote).arg(voteCount)
            personalIcon: Qt.resolvedUrl("../graphics/heart-" + userVote + ".png")
            personal: traktLogin.contents.status !== "disabled" ? (userVote !== 0 ? userVote + "/10" : i18n.tr("Rate This")) : i18n.tr("Authenticate\nTrakt to rate")
            onClicked: traktLogin.contents.status !== "disabled" ? userRatingDialog.visible = true : pagestack.push(Qt.resolvedUrl("../ui/Trakt.qml"))
            anchors {
                top: movieColumn.bottom
                left: parent.left
                right: parent.right
                topMargin: units.gu(4)
                margins: units.gu(2)
            }
        }

        // Movie Details - Release dates, genre, movie theme etc.
        Column {
            id: detailsColumn
            anchors {
                left: parent.left
                right: parent.right
                top: ratingsRow.bottom
                topMargin: units.gu(2)
            }

            Header { text: i18n.tr("Details") }

            MultiValue {
                id: genres
                text: i18n.tr("Genres")
                values: movie.attributes.genres.map(function(o) { return o.name })
                visible: movie.attributes.genres.length > 0
            }

            Subtitled {
                id: releaseDate
                text: i18n.tr("Release Date")
                subText: Qt.formatDate(new Date(movie.attributes.releaseDate), 'dd MMMM yyyy')
                visible: movie.attributes.releaseDate
            }

            Subtitled {
                id: theme
                text: i18n.tr("Tagline")
                subText: movie.attributes.tagline
                visible: movie.attributes.tagline
            }

            Header { text: i18n.tr("Casts") }

            Repeater {
                model: (movieCast.count > 3 ? 3 : movieCast.count)
                delegate: Subtitled {
                    text: movieCast.model.get(index).name
                    iconSource: movieCast.model.get(index).thumb_url
                    progression: true
                    subText: movieCast.model.get(index).character
                    onClicked: pagestack.push(Qt.resolvedUrl("PersonPage.qml"), {"person_id": movieCast.model.get(index).id})
                }
            }

            Standard {
                id: allCast
                text: i18n.tr("Full Cast")
                progression: true
                onClicked: pageStack.push(Qt.resolvedUrl("CastPage.qml"), {"title": i18n.tr("Full Cast"), "dataModel": movieCast.model})
            }

            Header { text: i18n.tr("Production Crew") }

            Repeater {
                model: (movieCrew.count > 3 ? 3 : movieCrew.count)
                delegate: Subtitled {
                    text: movieCrew.model.get(index).name
                    progression: true
                    subText: movieCrew.model.get(index).department
                    onClicked: pagestack.push(Qt.resolvedUrl("PersonPage.qml"), {"person_id": movieCrew.model.get(index).id})
                }
            }

            Standard {
                id: fullCrew
                text: i18n.tr("Full Crew")
                progression: true
                onClicked: pageStack.push(Qt.resolvedUrl("CrewPage.qml"), {"title": i18n.tr("Full Crew"), "dataModel": movieCrew.model})
            }

            Carousel {
                id: similarMovies
                dataModel: similarMoviesModel.model
                visible: similarMoviesModel.count > 0
                header: i18n.tr("Similar Movies")
                onThumbClicked: pageStack.push(Qt.resolvedUrl("MoviePage.qml"), {"movie_id": model.id})
            }
        }
    }

    tools: ToolbarItems {
        id: toolbarMovie

        ToolbarButton {
            id: returnHome
            visible: pageStack.depth > 2
            action: returnHomeAction
        }

        ToolbarButton {
            id: shareMovie
            action: shareMovieAction
        }

        ToolbarButton {
            id: playTrailer
            action: playMovieTrailerAction
        }
    }
}


