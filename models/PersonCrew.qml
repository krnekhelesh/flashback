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

BaseModel {
    id: personCrew
    function updateJSONModel() {
        model.clear();

        var objectArray = JSON.parse(json).crew;
        for ( var key in objectArray ) {
            var jo = objectArray[key];
            model.append({
                'id': jo.id,
                'title': jo.title || jo.name || "",
                'department': jo.department || "",
                'job': jo.job || "",
                'releaseDate': jo.release_date || "",
                'mediaType': jo.media_type,
                'thumb_url': thumbnail_url(jo.poster_path, "person")
            });
        }
    }
}
