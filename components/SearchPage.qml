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

import QtQuick 2.4
import Ubuntu.Components 1.2
import Ubuntu.Components.ListItems 1.0 as ListItem
import "../backend/backend.js" as Backend

Item {
    id: _searchTemplate

    // Public Properties
    property string type
    property variant search_model
    signal resultClicked(var model)

    LoadingIndicator {
        id: loadingIndicator
        loadingText: i18n.tr("Searching...")
        isShown: search_model.loading
    }

    ListView {
        id: _searchResultsList
        clip: true
        anchors.fill: parent

        model: search_model.model

        delegate: ListItem.Standard {
            text: name
            iconSource: thumb_url
            onClicked: _searchTemplate.resultClicked(model)
        }
    }
}
