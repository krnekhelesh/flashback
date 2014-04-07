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

/*
  Trakt Rating Model. Rating Advanced from 1-10. Set as 0 to remove rating
 */
ListModel {
    id: ratingModel

    ListElement {
        rating: 10
        thumb_url: "../graphics/heart-10.png"
        ratingDescription: "Totally Ninja!"
    }
    ListElement {
        rating: 9
        thumb_url: "../graphics/heart-9.png"
        ratingDescription: "Superb"
    }
    ListElement {
        rating: 8
        thumb_url: "../graphics/heart-8.png"
        ratingDescription: "Great"
    }
    ListElement {
        rating: 7
        thumb_url: "../graphics/heart-7.png"
        ratingDescription: "Good"
    }
    ListElement {
        rating: 6
        thumb_url: "../graphics/heart-6.png"
        ratingDescription: "Fair"
    }
    ListElement {
        rating: 5
        thumb_url: "../graphics/heart-5.png"
        ratingDescription: "Meh"
    }
    ListElement {
        rating: 4
        thumb_url: "../graphics/heart-4.png"
        ratingDescription: "Poor"
    }
    ListElement {
        rating: 3
        thumb_url: "../graphics/heart-3.png"
        ratingDescription: "Bad"
    }
    ListElement {
        rating: 2
        thumb_url: "../graphics/heart-2.png"
        ratingDescription: "Terrible"
    }
    ListElement {
        rating: 1
        thumb_url: "../graphics/heart-1.png"
        ratingDescription: "Weak Sauce :("
    }
    ListElement {
        rating: 0
        thumb_url: "../graphics/heart-0.png"
        ratingDescription: "Remove rating"
    }
}
