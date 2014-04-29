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
import Ubuntu.Components.ListItems 0.1
import "../backend/backend.js" as Backend

Item {
    id: _searchTemplate

    // Public Properties
    property alias searchBoxText: _searchBox.defaultText
    property string type
    property variant search_model
    signal resultClicked(var model)

    // Search Box to enter search query along with the search button
    SearchBox {
        id: _searchBox
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            margins: units.gu(2)
        }
        onSearchTriggered: {
            search_model.model.clear();
            search_model.source = Backend.searchUrl(type, _searchBox.search_term);
            if (type == "tv") {
                search_model.createMessage(traktLogin.contents.username, traktLogin.contents.password)
                search_model.sendMessage()
            }
        }
    }

    LoadingIndicator {
        id: loadingIndicator
        loadingText: i18n.tr("Searching...")
        isShown: search_model.loading
    }

    ListView {
        id: _searchResultsList
        clip: true
        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            top: _searchBox.bottom
            leftMargin: units.gu(2)
            rightMargin: units.gu(2)
            bottomMargin: units.gu(2)
            topMargin: units.gu(5)
        }

        model: search_model.model

        delegate: Standard {
            text: name
            iconSource: thumb_url
            onClicked: _searchTemplate.resultClicked(model)
        }
    }
}
