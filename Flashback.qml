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
import U1db 1.0 as U1db
import Ubuntu.Components 1.1
import "backend/backend.js" as Backend
import "models"
import "ui"

MainView {
    id: mainView

    // objectName for functional testing purposes (autopilot-qt5)
    objectName: "mainView"

    // Note! applicationName needs to match the "name" field of the click manifest
    applicationName: "com.ubuntu.developer.nik90.flashback"

    /*
     This property enables the application to change orientation
     when the device is rotated. The default is false.
    */
    automaticOrientation: true

    /*
      This property is to ensure that the input text fields are not hidden
      by the on-screen keyboard
    */
    anchorToKeyboard: true

    /*
      This property enabled the new header and disables the old toolbar
    */
    useDeprecatedToolbar: false

    width: units.gu(150)
    height: units.gu(100)

    /*
      The background is now a image texture file. The background color is used to
      set the color of the text.
     */
    backgroundColor: UbuntuColors.coolGrey

    // Property to store the aspect ratio of the device
    property double aspectRatio: (mainView.width/mainView.height).toFixed(1)

    // Property to determine if the tablet view should be shown
    property bool tabletLandscapeForm: aspectRatio >= 1.3
    property bool tabletPortraitForm: aspectRatio >= 0.8 && aspectRatio < 1.3

    onAspectRatioChanged: console.log("[LOG]: Aspect Ratio: " + aspectRatio)

    actions: [
        Action {
            id: appSettingsAction
            text: i18n.tr("Settings")
            keywords: i18n.tr("Settings;Setting;Configuration;Account;Authenticate")
            description: i18n.tr("Application Settings")
            iconName: "settings"
            onTriggered: pagestack.push(Qt.resolvedUrl("ui/SettingPage.qml"))
        },
        Action {
            id: returnHomeAction
            text: i18n.tr("Home")
            visible: pagestack.depth > 2
            keywords: i18n.tr("Return;Navigate;Home;Page;Tab")
            description: i18n.tr("Get back to the first page")
            iconSource: Qt.resolvedUrl("graphics/home.png")
            onTriggered: {
                while(pagestack.depth !== 1)
                    pagestack.pop()
            }
        }
    ]

    // Database to store app data locally
    U1db.Database {
        id: db
        path: "settings"
    }

    // Document to store the firstrun value of the app
    U1db.Document {
        id: firstRunDocument
        database: db
        docId: "firstRun"
        create: true
        defaults: { "firstrun": "true" }
    }

    // Document to store user's Trakt account credentials (password encrypted before storage)
    U1db.Document {
        id: traktLogin
        database: db
        docId: "traktLoginCredentials"
        create: true
        defaults: { "username": "johnDoe", "password": "password", "status": "disabled" }
        Component.onCompleted: pagestack.account_status = contents.status
        onContentsChanged: {
            if(traktLogin.contents.status === "disabled")
                userActivityLoader.sourceComponent = undefined;
            else
                userActivityLoader.sourceComponent = userActivity
        }
    }

    // Document to store the user's movie activity on Trakt
    U1db.Document {
        id: movieActivityDocument
        database: db
        docId: "traktMovieActivity"
        create: true
        defaults: { "name": "default", "id": "default", "imdb": "default", "runtime": "default", "year": "default", "trailer": "default","poster": "default", "fanart": "default" }
        function setValues(Name, Id, Imdb, Runtime, Year, Trailer, Poster, Fanart) {
            movieActivityDocument.contents = {
                name: Name,
                id: Id,
                imdb: Imdb,
                runtime: Runtime,
                year: Year,
                trailer: Trailer,
                poster: Poster,
                fanart: Fanart
            }
        }
    }

    // Document to store the user's tv activity on Trakt
    U1db.Document {
        id: showActivityDocument
        database: db
        docId: "traktShowActivity"
        create: true
        defaults: { "name": "default", "id": "default", "imdb": "default", "episode_title": "default", "season": "default", "number": "default" ,"poster": "default", "fanart": "default" }
        function setValues(Name, Id, Imdb, Episode_title, Season, number, Poster, Fanart) {
            showActivityDocument.contents = {
                name: Name,
                id: Id,
                imdb: Imdb,
                episode_title: Episode_title,
                season: Season,
                number: number,
                poster: Poster,
                fanart: Fanart
            }
        }
    }

    // Document to store the user's watchlist activity on Trakt
    U1db.Document {
        id: watchlistActivityDocument
        database: db
        docId: "traktWatchlistActivity"
        create: true
        defaults: { "movie": "default", "show": "default" }
    }

    // Document to track user show's episode seen/unseen activity on Trakt
    U1db.Document {
        id: episodeSeenActivityDocument
        database: db
        docId: "traktEpisodeSeenActivity"
        create: true
        defaults: { "episode": "default" }
    }

    Loader { id: userActivityLoader }

    Component {
        id: userActivity
        Activity {
            id: _userActivity

            username: traktLogin.contents.username
            password: traktLogin.contents.password

            onActivityDocumentChanged: {
                if(activityDocument.type === "movie") {
                    showActivityDocument.setValues("default", "default", "default", "default", "default", "default", "default", "default")
                    movieActivityDocument.setValues(activityDocument.name, activityDocument.id, activityDocument.imdb, activityDocument.runtime, activityDocument.year, activityDocument.trailer, activityDocument.poster, activityDocument.fanart)
                }
                else if(activityDocument.type === "episode") {
                    movieActivityDocument.setValues("default", "default", "default", "default", "default", "default", "default", "default")
                    showActivityDocument.setValues(activityDocument.name, activityDocument.id, activityDocument.imdb, activityDocument.episode_title, activityDocument.season, activityDocument.number, activityDocument.poster, activityDocument.fanart)
                }
                // If user is not watching anything, set both documents to default
                else if(activityDocument.type === "default") {
                    movieActivityDocument.setValues("default", "default", "default", "default", "default", "default", "default", "default")
                    showActivityDocument.setValues("default", "default", "default", "default", "default", "default", "default", "default")
                }
            }
        }
    }

    PageStack {
        id: pagestack

        // Properties to hold the application details which are then used throughout the application for consistency
        property string app_version: "@APP_VERSION@"
        property string app_name: "Flashback"
        property string last_updated: "23 April 2014"

        // Property to hold the trakt account status to allow for detecting account changes after the app is open
        property string account_status

        // Property to hold the user movie/show status to allow for activity changes after the app is open
        property string movieName
        property string showName

        Component.onCompleted: {
            if(String(firstRunDocument.contents.firstrun) === "true") {
                console.log("[LOG]: Running app for the first time. Opening Walkthrough: " + firstRunDocument.contents.firstrun)
                push(Qt.resolvedUrl("walkthrough/FirstRunWalkthrough.qml"));
            }
            else
                push(rootComponent);
        }

        Component {
            id: rootComponent
            Tabs {
                id: root

                Tab {
                    id: homeTab
                    title: i18n.tr("Home")
                    page: HomeTab {}
                }

                Tab {
                    id: moviesTab
                    title: i18n.tr("Movies")
                    onActiveChanged: movieLoader.source = Qt.resolvedUrl("ui/MovieTab.qml")
                    page: Loader {
                        id: movieLoader
                        parent: moviesTab
                        anchors {
                            left: parent.left
                            right: parent.right
                            bottom: parent.bottom
                        }
                    }
                }

                Tab {
                    id: tvTab
                    title: i18n.tr("TV")
                    onActiveChanged: tvLoader.source = Qt.resolvedUrl("ui/TvTab.qml")
                    page: Loader {
                        id: tvLoader
                        parent: tvTab
                        anchors {
                            left: parent.left
                            right: parent.right
                            bottom: parent.bottom
                        }
                    }
                }

                Tab {
                    id: peopleTab
                    title: i18n.tr("Celeb")
                    onActiveChanged: peopleLoader.source = Qt.resolvedUrl("ui/PersonTab.qml")
                    page: Loader {
                        id: peopleLoader
                        parent: peopleTab
                        anchors {
                            left: parent.left
                            right: parent.right
                            bottom: parent.bottom
                        }
                    }
                }

                Tab {
                    id: youTab
                    title: i18n.tr("You")
                    onActiveChanged: userLoader.source = Qt.resolvedUrl("ui/UserTab.qml")
                    page: Loader {
                        id: userLoader
                        parent: youTab
                        anchors {
                            left: parent.left
                            right: parent.right
                            bottom: parent.bottom
                        }
                    }
                }
            }
        }
    }
}
