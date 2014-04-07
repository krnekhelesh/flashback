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
import "../backend/backend.js" as Backend

BasePostModel {
    id: shows

    // Property to store the last action performed
    property string lastAction: "default"

    // Property to store the time the model was updated
    property string lastUpdated: "default"

    function fetchData(username, password) {
        source = Backend.userShowWatchlist(username)
        createMessage(username, password)
        sendMessage()
    }

    function updateJSONModel() {
        model.clear()
        for ( var key in reply ) {
            var jo = reply[key];
            model.append({
                'name': jo.title,
                'year': jo.year,
                'id': jo.tvdb_id,
                'imdb_id': jo.imdb_id,
                'watched': jo.watched ? jo.watched.toString() : "",
                'watchlist': jo.in_watchlist ? jo.in_watchlist.toString() : "",
                'thumb_url': jo.images.poster !== "http://slurm.trakt.us/images/poster-dark.jpg" ? get_thumb(jo.images.poster, '-138') : jo.images.poster
            });
        }
    }
}
