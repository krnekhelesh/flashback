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
    id: traktUserRating

    function createEpisodeMessage(username, password, id, title, year, season, episode, rating) {
        message = JSON.stringify({username: username, password: password, tvdb_id: id, title: title, year: year, season: season, episode: episode, rating: rating})
    }

    function createMovieMessage(username, password, id, title, year, rating) {
        message = JSON.stringify({username: username, password: password, tmdb_id: id, title: title, year: year, rating: rating})
    }

    function createShowMessage(username, password, id, title, year, rating) {
        message = JSON.stringify({username: username, password: password, tvdb_id: id, title: title, year: year, rating: rating})
    }
}
