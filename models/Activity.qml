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
import "../backend/backend.js" as Backend

/*
  Component to keep track of user activity (movies and tv show) and update the document automatically
 */
BasePostModel {
    id: userActivity

    property string username
    property string password
    property var activityDocument

    Component.onCompleted: getUserActivityOnline()
    Component.onDestruction: setDefaultDatabase()

    // Function to get user's movie activity online. It automatically updates the local database if there is user activity
    function getUserActivityOnline() {
        console.log("[LOG]: Checking for user activity")
        source = Backend.userActivity(username)
        createMessage(username, password)
        sendMessage()
    }

    // Function here to set the user movie activity database to defaults.
    function setDefaultDatabase() {
        console.log("[LOG]: Resetting user activity documents")
        activityDocument = {
            type: "default",
            name: "default",
            id: "default",
            imdb: "default",
            runtime: "default",
            trailer: "default",
            year: "default",
            episode_title: "default",
            season: "default",
            number: "default",
            poster: "default",
            fanart: "default"
        }
    }

    function updateJSONModel() {
        if(reply.type === "movie") {
            console.log("[LOG]: User is watching a movie -> " + reply.movie.title)
            activityDocument = {
                type: "movie",
                name: reply.movie.title,
                id: reply.movie.tmdb_id,
                imdb: reply.movie.imdb_id,
                runtime: reply.movie.runtime,
                trailer: reply.movie.trailer,
                year: reply.movie.year,
                poster: get_thumb(reply.movie.images.poster, '-138'),
                fanart: get_thumb(reply.movie.images.fanart, '-940')
            }
        }
        else if(reply.type === "episode") {
            console.log("[LOG]: User is watching a tv show -> " + reply.show.title)
            activityDocument = {
                type: "episode",
                name: reply.show.title,
                id: reply.show.tvdb_id,
                imdb: reply.show.imdb_id,
                episode_title: reply.episode.title,
                season: reply.episode.season,
                number: reply.episode.number,
                poster: get_thumb(reply.show.images.poster, '-138'),
                fanart: get_thumb(reply.show.images.fanart, '-940')
            }
        }
        else {
            console.log("[LOG]: User is not watching anything")
            setDefaultDatabase()
        }
    }
}
