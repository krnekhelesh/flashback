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
import Ubuntu.Components.Popups 1.0
import Ubuntu.Components.ListItems 1.0 as ListItem
import "../components"
import "../models"
import "../backend/backend.js" as Backend

Page {
    id: moviePage

    visible: false
    flickable: null
    title: i18n.tr("Movie")

    property string movie_id
    property bool isMovieSeen
    property bool isMovieWatchlisted

    property int voteCount: 0
    property double averageVote: 0
    property int userVote: 0

    property bool isAuthenticated: traktLogin.contents.status !== "disabled"

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
                loadingIndicator.isShown = false
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

    Notification { id: checkInNotification }

    TraktCheckIn {
        id: movieCheckIn
        function updateJSONModel() {
            loadingIndicator.visible = false
            if (reply.status === "success") {
                isMovieSeen = true
                userActivityLoader.item.getUserActivityOnline()
            }
            else if (reply.status === "failure"){
                checkInNotification.messageTitle = i18n.tr("Movie Check-in Failed")
                checkInNotification.message = reply.error
                checkInNotification.visible = true
            }
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
                    delegate: ListItem.Subtitled {
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

    head.contents: Label {
        width: parent ? parent.width : undefined
        anchors.verticalCenter: parent ? parent.verticalCenter : undefined
        text: movie.attributes.title ? movie.attributes.title : i18n.tr("Movie")
        fontSize: "x-large"
        maximumLineCount: fontSize === "large" ? 2 : 1
        wrapMode: Text.WordWrap
        elide: Text.ElideRight
        onTruncatedChanged: {
            if (truncated) {
                fontSize = "large"
            }
        }
    }

    Action {
        id: authenticateAction
        text: i18n.tr("Login into Trakt")
        visible: !isAuthenticated
        iconSource: Qt.resolvedUrl("../graphics/user_white.png")
        onTriggered: pagestack.push(Qt.resolvedUrl("Trakt.qml"))
    }

    Action {
        id: playMovieTrailerAction
        text: i18n.tr("Trailer")
        keywords: i18n.tr("Play;Watch;Trailer;Preview")
        description: i18n.tr("Play Movie Trailer")
        enabled: movieTrailer.model.count > 0
        iconName: "media-playback-start"
        onTriggered: PopupUtils.open(trailerPopoverComponent, null)
    }

    Action {
        id: checkInAction
        visible: isAuthenticated
        text: movieActivityDocument.contents.name !== "default" ? i18n.tr("Cancel Check-in") : i18n.tr("Check-in Movie")
        iconSource: Qt.resolvedUrl("../graphics/checkmark.png")
        onTriggered: {
            loadingIndicator.loadingText = movieActivityDocument.contents.name === "default" ? i18n.tr("Checking-in movie") : i18n.tr("Cancelling movie check-in")
            loadingIndicator.isShown = true
            if(movieActivityDocument.contents.name !== "default") {
                cancelCheckIn.source = Backend.cancelTraktCheckIn("movie")
                cancelCheckIn.createMessage(traktLogin.contents.username, traktLogin.contents.password)
                cancelCheckIn.sendMessage()
            }
            else {
                movieCheckIn.source = Backend.traktCheckInUrl("movie")
                movieCheckIn.createMovieMessage(traktLogin.contents.username, traktLogin.contents.password, movie.attributes.imdb_id, movie.attributes.title, movie.attributes.releaseDate.split('-')[0], "Check-in using Flashback (Ubuntu Touch)", pagestack.app_version, pagestack.last_updated)
                movieCheckIn.sendMessage()
            }
        }
    }

    Action {
        id: watchlistAction
        visible: isAuthenticated
        text: isMovieWatchlisted ? i18n.tr("Remove from watchlist") : i18n.tr("Add to watchlist")
        iconSource: Qt.resolvedUrl("../graphics/watchlist.png")
        onTriggered: {
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
    }

    Action {
        id: watchedAction
        visible: isAuthenticated
        text: isMovieSeen ? i18n.tr("Mark unseen") : i18n.tr("Mark seen")
        iconSource: Qt.resolvedUrl("../graphics/watched.png")
        onTriggered: {
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
    }

    Action {
        id: commentAction
        text: i18n.tr("View comments")
        iconSource: Qt.resolvedUrl("../graphics/comment_white.png")
        onTriggered: {
            pagestack.push(Qt.resolvedUrl("CommentsPage.qml"), {id: movie_id, type: "Movie", name: movie.attributes.title, year: movie.attributes.releaseDate.split('-')[0]})
        }
    }

    head.actions: [
        returnHomeAction,
        playMovieTrailerAction,
        authenticateAction,
        checkInAction,
        watchlistAction,
        watchedAction,
        commentAction
    ]

    Flickable {
        id: flickable
        clip: true
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
            id: summary

            anchors {
                top: parent.top
                left: movieThumb.right
                right: parent.right
                leftMargin: units.gu(2)
                rightMargin: units.gu(2)
                topMargin: units.gu(2)
            }

            elide: Text.ElideRight
            wrapMode: Text.WordWrap
            visible: movie.attributes.overview
            text: movie.attributes.overview
            height: movieThumb.height/1.3

            MouseArea {
                anchors.fill: parent
                enabled: summary.truncated
                onClicked: pagestack.push(Qt.resolvedUrl("SummaryPage.qml"), {"summary": movie.attributes.overview})
            }
        }

        Column {
            id: movieColumn
            anchors {
                left: movieThumb.right
                right: parent.right
                leftMargin: units.gu(2)
                rightMargin: units.gu(2)
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

            ListItem.Header { text: i18n.tr("Details") }

            ListItem.MultiValue {
                id: genres
                text: i18n.tr("Genres")
                values: movie.attributes.genres.map(function(o) { return o.name })
                visible: movie.attributes.genres.length > 0
            }

            ListItem. Subtitled {
                id: releaseDate
                text: i18n.tr("Release Date")
                subText: Qt.formatDate(new Date(movie.attributes.releaseDate), 'dd MMMM yyyy')
                visible: movie.attributes.releaseDate
            }

            ListItem.Subtitled {
                id: theme
                text: i18n.tr("Tagline")
                subText: movie.attributes.tagline
                visible: movie.attributes.tagline
            }

            ListItem.Header { text: i18n.tr("Casts") }

            Repeater {
                model: (movieCast.count > 3 ? 3 : movieCast.count)
                delegate: ListItem.Subtitled {
                    text: movieCast.model.get(index).name
                    iconSource: movieCast.model.get(index).thumb_url
                    progression: true
                    subText: movieCast.model.get(index).character
                    onClicked: pagestack.push(Qt.resolvedUrl("PersonPage.qml"), {"person_id": movieCast.model.get(index).id})
                }
            }

            ListItem.Standard {
                id: allCast
                text: i18n.tr("Full Cast")
                progression: true
                onClicked: pageStack.push(Qt.resolvedUrl("CastPage.qml"), {"title": i18n.tr("Full Cast"), "dataModel": movieCast.model})
            }

            ListItem.Header { text: i18n.tr("Production Crew") }

            Repeater {
                model: (movieCrew.count > 3 ? 3 : movieCrew.count)
                delegate: ListItem.Subtitled {
                    text: movieCrew.model.get(index).name
                    progression: true
                    subText: movieCrew.model.get(index).department
                    onClicked: pagestack.push(Qt.resolvedUrl("PersonPage.qml"), {"person_id": movieCrew.model.get(index).id})
                }
            }

            ListItem.Standard {
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
}


