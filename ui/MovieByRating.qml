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
import "../components"
import "../models"
import "../backend/backend.js" as Backend

Page {
    id: movieByRatingPage

    title: i18n.tr("Top Rated Movies")
    visible: false
    flickable: null

    // Page Background
    Background {}

    Movies {
        id: topRatedMovieModel
        source: Backend.topRatedMoviesUrl()
    }

    LoadingIndicator {
        isShown: topRatedMovieModel.loading
    }

    Grid {
        id: movieList
        dataModel: topRatedMovieModel.model
        anchors {
            fill: parent
            margins: units.gu(2)
        }
        onThumbClicked: pageStack.push(Qt.resolvedUrl("MoviePage.qml"), {"movie_id": model.id})
    }
}
