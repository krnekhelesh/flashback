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
    id: traktLoginModel

    source: Backend.trendingMoviesUrl()

    function updateJSONModel() {
        model.clear()
        for ( var key in reply ) {
            var jo = reply[key];
            model.append({
                'name': jo.title,
                'id': jo.tmdb_id,
                'watched': jo.watched ? jo.watched.toString() : "",
                'watchlist': jo.in_watchlist ? jo.in_watchlist.toString() : "",
                'thumb_url': get_thumb(jo.images.poster, '-138')
            });
        }
    }
}
