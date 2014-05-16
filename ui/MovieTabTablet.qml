/*
 * Flashback - Entertainment app for Ubuntu
 * Copyright (C) 2014 Nekhelesh Ramananthan <nik90@ubuntu.com>
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
import Ubuntu.Layouts 1.0
import Ubuntu.Components 1.1
import "../components"
import "../models"
import "../backend/backend.js" as Backend

ConditionalLayout {
    id: tabletConditionalLayout

    name: "tablet"
    when: tabletLandscapeForm || tabletPortraitForm

    Row {
        anchors.fill: parent

        // Function to mark a listitem in the sidebar as selected and deselect the other items
        function selectListItem(item) {
            var sidebarList = [trendingMoviesTablet, nowPlayingTablet, upcomingMoviesTablet, filterRating, filterRecommended]
            for (var i=0; i<sidebarList.length; i++) {
                if(item.menuLabel === sidebarList[i].menuLabel)
                    sidebarList[i].isSelected = true
                else
                    sidebarList[i].isSelected = false
            }
        }

        // Sidebar Component
        TabletSidebar {
            id: sidebar

            TraktRecommendedMovies {
                id: recommendedMoviesModel
                // FIXME: Only load this data model when the user has logged into trakt
                Component.onCompleted: {
                    createMessage(traktLogin.contents.username, traktLogin.contents.password)
                    sendMessage()
                }
            }

            Movies {
                id: topRatedMovieModel
                source: Backend.topRatedMoviesUrl()
            }

            Column {
                id: sidebarColumn
                anchors.fill: parent

                SidebarMenuItem {
                    id: trendingMoviesTablet
                    shortenedMenuLabel: i18n.tr("Trending")
                    menuLabel: i18n.tr("Trending Movies")
                    menuIcon: Qt.resolvedUrl("../graphics/trending_icon.png")
                    isSelected: true
                    onClicked: {
                        selectListItem(trendingMoviesTablet)
                        movieList.dataModel = trendingMoviesModel.model
                    }
                }

                SidebarMenuItem {
                    id: nowPlayingTablet
                    shortenedMenuLabel: i18n.tr("Now")
                    menuLabel: i18n.tr("Now Playing Movies")
                    menuIcon: Qt.resolvedUrl("../graphics/now_playing.png")
                    onClicked: {
                        selectListItem(nowPlayingTablet)
                        movieList.dataModel = nowPlayingMoviesModel.model
                    }
                }

                SidebarMenuItem {
                    id: upcomingMoviesTablet
                    shortenedMenuLabel: i18n.tr("Upcoming")
                    menuLabel: i18n.tr("Upcoming Movies")
                    menuIcon: Qt.resolvedUrl("../graphics/upcoming.png")
                    onClicked: {
                        selectListItem(upcomingMoviesTablet)
                        movieList.dataModel = upcomingMoviesModel.model
                    }
                }

                ItemLayout {
                    item: "filter-header"
                    width: parent.width
                    height: filterHeader.height
                    visible: !tabletPortraitForm
                }

                SidebarMenuItem {
                    id: filterRating
                    shortenedMenuLabel: i18n.tr("Top")
                    menuLabel: i18n.tr("Top Rated")
                    menuIcon: Qt.resolvedUrl("../graphics/top_rated.png")
                    onClicked: {
                        selectListItem(filterRating)
                        movieList.dataModel = topRatedMovieModel.model
                    }
                }

                SidebarMenuItem {
                    id: filterRecommended
                    shortenedMenuLabel: i18n.tr("Recommended")
                    visible: traktLogin.contents.status !== "disabled"
                    menuLabel: i18n.tr("Recommended")
                    menuIcon: Qt.resolvedUrl("../graphics/recommended.png")
                    onClicked: {
                        selectListItem(filterRecommended)
                        movieList.dataModel = recommendedMoviesModel.model
                    }
                }
            }
        }

        Item {
            id: mainContentContainer

            width: parent.width - sidebar.width
            anchors {
                top: parent.top
                bottom: parent.bottom
            }

            LoadingIndicator {
                id: _loadingIndicator
                isShown: !movieList.dataModel.count > 0
            }

            Grid {
                id: movieList
                anchors.fill: parent
                anchors.topMargin: units.gu(1)
                dataModel: trendingMoviesModel.model
                onThumbClicked: pageStack.push(Qt.resolvedUrl("MoviePage.qml"), {"movie_id": model.id})
            }
        }
    }
}
