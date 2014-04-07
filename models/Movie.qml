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

BaseModel {
    id: movie

    property variant attributes: {
      'title': '',
      'homepage': '',
      'tagline': '',
      'overview': '',
      'releaseDate': '',
      'runtime': 0,
      'voteAverage': 0.0,
      'voteCount': 0,
      'genres': [],
      'thumb_url': ''
    }

    function updateJSONModel() {
        var ob = JSON.parse(json);
        attributes = {
            'id': ob.id,
            'imdb_id': ob.imdb_id,
            'title': ob.title,
            'homepage': (ob.homepage || "") ,
            'tagline': (ob.tagline || ""),
            'overview': (ob.overview || ""),
            'releaseDate': (ob.release_date || ""),
            'runtime': parseInt(ob.runtime),
            'voteAverage': parseFloat(ob.vote_average),
            'voteCount': parseInt(ob.vote_count),
            'genres': ob.genres,
            'thumb_url': thumbnail_url(ob.poster_path, "movie"),
            'creditsJson': JSON.stringify(ob.credits || {}),
            'trailersJson': JSON.stringify(ob.trailers || {}),
            'similarMoviesJson': JSON.stringify(ob.similar_movies || {})
        };
    }
}
