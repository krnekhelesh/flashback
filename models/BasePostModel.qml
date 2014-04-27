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

Item {
    id: basePostModel
    property string source: ""
    property string json: ""
    property int status: XMLHttpRequest.UNSENT

    property var reply
    property var message

    property string username
    property string password

    property ListModel model: ListModel { id: model }
    property alias count: model.count

    property bool loading: false

    signal updated()

    function createMessage(username, password) {
        message = JSON.stringify({username: username, password: password})
    }

    function get_thumb(thumb_url, size) {
        return thumb_url.split('.jpg')[0] + size + '.jpg'
    }

    function sendMessage() {
        loading = true
        var xhr = new XMLHttpRequest();
        xhr.open("POST", source);

        xhr.onreadystatechange = function() {
            status = xhr.readyState;
            if (xhr.readyState == XMLHttpRequest.DONE)
                getReply(json = xhr.responseText);
        }
        xhr.send(message);
    }

    function getReply(json) {
        if ( json != "" ) {
            reply = JSON.parse(json)
            updateJSONModel();
        }
        loading = false
    }
}
