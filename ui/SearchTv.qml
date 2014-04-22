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
import Ubuntu.Components 0.1
import "../components"
import "../models"

// Page to search for tv shows
Page {
    id: searchMoviePage

    visible: false
    title: i18n.tr("Search TV Show")

    Shows {
      id: search_results
    }

    SearchPage {
        anchors.fill: parent
        type: "tv"
        search_model: search_results 
        onResultClicked: pageStack.push(Qt.resolvedUrl("TvPage.qml"), {"tv_id": model.id})
    }
}