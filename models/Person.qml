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
    id: person

    property variant attributes: {
      'name': '',
      'biography': '',
      'birthday': '',
      'deathday': '',
      'homepage': '',
      'placeOfBirth': '',
      'thumb_url': ''
    }

    function updateJSONModel() {
        var ob = JSON.parse(json);
        attributes = {
            'id': ob.id,
            'name': ob.name,
            'biography': ob.biography || "",
            'birthday': ob.birthday || "",
            'deathday': ob.deathday || "",
            'homepage': ob.homepage || "",
            'placeOfBirth': ob.place_of_birth || "",
            'thumb_url': thumbnail_url(ob.profile_path, "person"),
            'combinedCreditsJson': JSON.stringify(ob.combined_credits || {})
        };
    }
}
