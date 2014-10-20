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
    id: show

    property variant attributes: {
      'name': '',
      'year': 0,
      'overview': '',
      'first_air_date': '',
      'air_day_utc': '',
      'air_time_utc': '',
      'episode_run_time': 0,
      'voteAverage': 0.0,
      'voteCount': 0,
      'userVote': 0,
      'in_watchlist': '',
      'number_of_seasons': 0,
      'networks': '',
      'genres': [],
      'thumb_url': ''
    }

    function updateJSONModel() {
        attributes = {
            'name': reply.title,
            'year': reply.year,
            'id': reply.tvdb_id,
            'imdb_id': reply.imdb_id,
            'overview': reply.overview,
            'first_air_date': reply.first_aired_utc,
            'air_day_utc': reply.air_day_utc,
            'air_time_utc': reply.air_time_utc,
            'episode_run_time': parseInt(reply.runtime),
            'voteAverage': parseFloat(reply.ratings.percentage),
            'voteCount': parseInt(reply.ratings.votes),
            'userVote': parseInt(reply.rating_advanced),
            'in_watchlist': reply.in_watchlist ? reply.in_watchlist.toString() : "",
            'in_production': reply.status,
            'networks': reply.network,
            'genres': reply.genres,
            'thumb_url': get_thumb(reply.images.poster, '-138'),
            'creditsJson': JSON.stringify(reply.people.actors || {})
        };
        updated();
    }
}
