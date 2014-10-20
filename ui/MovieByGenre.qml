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
    id: movieByGenrePage

    title: i18n.tr("Genre")
    visible: false
    flickable: null

    // Page Background
    Background {}

    property string genre_id

    Movies {
        id: genreMoviesModel
    }

    Genres {
        id: genreListModel
        source: Backend.genreUrl()
    }

    Flickable {
        clip: true
        anchors.fill: parent
        contentHeight: mainColumn.height + units.gu(5)
        interactive: contentHeight > parent.height

        Column {
            id: mainColumn

            anchors {
                left: parent.left;
                right: parent.right;
                top: parent.top;
                margins: units.gu(2)
            }

            spacing: units.gu(2)

            OptionSelector {
                id: genreList
                text: genreListModel.model.count != 0 ? i18n.tr("Choose movie genre") : i18n.tr("Loading movie genre list...")
                model: genreListModel.model
                delegate: genreDelegate
                onDelegateClicked: {
                    genre_id = genreListModel.model.get(index).id
                    genreMoviesModel.source = Backend.filterByGenreUrl(genre_id)
                }
            }

            Component {
                id: genreDelegate
                OptionSelectorDelegate { text: name }
            }

            Grid {
                id: movieList
                dataModel: genreMoviesModel.model
                visible: genreMoviesModel.model.count != 0
                height: movieByGenrePage.height - genreList.height - units.gu(5)
                onThumbClicked: pageStack.push(Qt.resolvedUrl("MoviePage.qml"), {"movie_id": model.id})
            }
        }
    }
}
