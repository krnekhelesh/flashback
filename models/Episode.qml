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

BasePostModel {
    id: episodeDetails

    property variant attributes: {
      'name': '',
      'year': 0,
      'episode_name': '',
      'overview': '',
      'episode_air_date': '',
      'voteAverage': 0.0,
      'voteCount': 0,
      'userVote': 0,
      'thumb_url': ''
    }

    function updateJSONModel() {
        attributes = {
            'name': reply.show.title,
            'year': parseInt(reply.show.year),
            'id': reply.show.tvdb_id,
            'imdb_id': reply.show.imdb_id,
            'season': parseInt(reply.episode.season),
            'episode': parseInt(reply.episode.number),
            'episode_name': reply.episode.title,
            'overview': reply.episode.overview,
            'episode_air_date': reply.episode.first_aired_utc,
            'voteAverage': parseFloat(reply.episode.ratings.percentage),
            'voteCount': parseInt(reply.episode.ratings.votes),
            'userVote': parseInt(reply.episode.rating_advanced),
            'watched': reply.episode.watched ? reply.episode.watched.toString() : "",
            'thumb_url': reply.episode.images.screen
        };
        updated()
    }
}
