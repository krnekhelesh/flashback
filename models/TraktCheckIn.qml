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

BasePostModel {
    id: traktLoginModel

    // Function to create a JSON String with movie information
    function createMovieMessage(username, password, imdb_id, title, year, checkinmessage, app_version, app_date) {
        if (checkinmessage !== "")
            message = JSON.stringify({username: username, password: password, imdb_id: imdb_id, title: title, year: year, message: checkinmessage, app_version: app_version, app_date: app_date})
        else
            message = JSON.stringify({username: username, password: password, imdb_id: imdb_id, title: title, year: year, app_version: app_version, app_date: app_date})
    }

    // Function to create a JSON String with episode information
    function createEpisodeMessage(username, password, id, title, year, season, episode, checkinmessage, app_version, app_date) {
        if (checkinmessage !== "")
            message = JSON.stringify({username: username, password: password, tvdb_id: id, title: title, year: year, season: season, episode: episode, message: checkinmessage, app_version: app_version, app_date: app_date})
        else
            message = JSON.stringify({username: username, password: password, tvdb_id: id, title: title, year: year, season: season, episode: episode, app_version: app_version, app_date: app_date})
    }
}
