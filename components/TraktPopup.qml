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
import Ubuntu.Components.Popups 0.1
import Ubuntu.Components.ListItems 0.1

/*
  Popup component to expose Trakt actions such as check-in, seen and configuring account.
  */
Popover {
    id: popover

    // Property to set the check-in message
    property alias checkInMessage: _checkInAction.text

    // Property to set the seen message
    property alias seenMessage: _seenAction.text

    // Property to set the watchlist message
    property alias watchlistMessage: _watchlistAction.text

    // Properties to set the visibility of the individual actions
    property bool showConfigureAction: traktLogin.contents.status === "disabled"
    property bool showCheckInAction: traktLogin.contents.status !== "disabled"
    property bool showSeenAction: traktLogin.contents.status !== "disabled"
    property bool showWatchlistAction: traktLogin.contents.status !== "disabled"
    property bool showCommentAction: true

    // Signal triggered when the checked-in action is triggered
    signal checkedIn()

    // Signal triggered when the watched action is triggered
    signal watched()

    // Signal triggered when the comments action is triggered
    signal commented()

    // Signal triggered when the watchlist action is triggered
    signal watchlisted()

    Column {
        id: containerLayout
        anchors {
            left: parent.left
            top: parent.top
            right: parent.right
        }

        Standard {
            id: _configureTraktAction
            text: i18n.tr("Authenticate Trakt to perform \ncheck-ins, comment and rating.")
            visible: showConfigureAction
            iconSource: Qt.resolvedUrl("../graphics/trakt_logo.png")
            onClicked: {
                pagestack.push(Qt.resolvedUrl("../ui/Trakt.qml"))
                PopupUtils.close(popover)
            }
        }

        Standard {
            id: _checkInAction
            visible: showCheckInAction
            iconSource: Qt.resolvedUrl("../graphics/checkmark_black.png")
            iconFrame: false
            onClicked: {
                popover.checkedIn()
                PopupUtils.close(popover)
            }
        }

        Standard {
            id: _watchlistAction
            visible: showWatchlistAction
            iconSource: Qt.resolvedUrl("../graphics/watchlist_black.png")
            iconFrame: false
            onClicked: {
                popover.watchlisted()
                PopupUtils.close(popover)
            }
        }

        Standard {
            id: _seenAction
            visible: showSeenAction
            iconSource: Qt.resolvedUrl("../graphics/watched_black.png")
            iconFrame: false
            onClicked: {
                popover.watched()
                PopupUtils.close(popover)
            }
        }

        Standard {
            id: _commentAction
            visible: showCommentAction
            iconSource: Qt.resolvedUrl("../graphics/comment.png")
            text: traktLogin.contents.status !== "disabled" ? i18n.tr("View/Add comments") : i18n.tr("View comments")
            iconFrame: false
            onClicked: {
                popover.commented()
                PopupUtils.close(popover)
            }
        }
    }
}

