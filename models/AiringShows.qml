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
import "../backend/backend.js" as Backend

BasePostModel {
    id: airingShowsModel

    // Property to store the time when the model was updated
    property string lastUpdated: "default"

    // Property to store the last action performed
    property string lastAction: "default"

    // Property to control if watched episodes should be hidden or not
    property bool hideWatched: false

    function fetchData(username, password, date, days) {
        source = Backend.userShows(username, date, days)
        createMessage(username, password)
        sendMessage()
    }

    function updateJSONModel() {
        model.clear()
        for ( var key in reply ) {
            var jo = reply[key];
            for( var innerkey in jo.episodes ) {
                var mo = jo.episodes[innerkey]
                if (hideWatched && mo.episode.watched == true)
                    continue
                // Only show episodes airing of tv shows that are watchlisted by the user
                if (mo.show.in_watchlist == true) {
                    model.append({
                        'name': mo.show.title,
                        'year': mo.show.year,
                        'id': mo.show.tvdb_id,
                        'imdb_id': mo.show.imdb_id,
                        'season': mo.episode.season,
                        'episode': mo.episode.number,
                        'episode_name': mo.episode.title,
                        'episode_air_date': mo.episode.first_aired_iso,
                        'watched': mo.episode.watched ? mo.episode.watched.toString() : "",
                        'thumb_url': get_thumb(mo.show.images.poster, '-300')
                    });
                }
            }
        }
    }
}
