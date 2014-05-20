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

ConditionalLayout {
    id: tabletConditionalLayout

    name: "tablet"
    when: (tabletPortraitForm || tabletLandscapeForm) && traktLogin.contents.status !== "disabled"

    Row {
        anchors.fill: parent

        // Function to mark a listitem in the sidebar as selected and deselect the other items
        function selectListItem(item) {
            var sidebarList = [nowPlayingTablet, userWatchlistTablet, airingShowsTablet, airedShowsTablet]
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

            Column {
                id: sidebarColumn
                anchors.fill: parent

                SidebarMenuItem {
                    id: nowPlayingTablet
                    shortenedMenuLabel: i18n.tr("Theatres")
                    menuLabel: i18n.tr("Playing in Theatres")
                    menuIcon: Qt.resolvedUrl("../graphics/now_playing.png")
                    isSelected: true
                    onClicked: {
                        selectListItem(nowPlayingTablet)
                        movieList.gridType = "gridCarousel"
                        movieList.dataModel = nowPlayingMoviesModel.model
                        movieList.loading = nowPlayingMoviesModel.loading
                    }
                }

                SidebarMenuItem {
                    id: airingShowsTablet
                    menuCount: airingShowsModel.model.count
                    shortenedMenuLabel: i18n.tr("Airing Today")
                    menuLabel: i18n.tr("Episodes Airing Today")
                    menuIcon: Qt.resolvedUrl("../graphics/today_sidebar.png")
                    onClicked: {
                        selectListItem(airingShowsTablet)
                        movieList.dataModel = airingShowsModel.model
                        movieList.showDate = false
                        movieList.gridType = "gridDetailedCarousel"
                        movieList.loading = airedShowsModel.loading
                    }
                }

                SidebarMenuItem {
                    id: airedShowsTablet
                    menuCount: airedShowsModel.model.count
                    shortenedMenuLabel: i18n.tr("Unwatched")
                    menuLabel: i18n.tr("Unwatched Episodes")
                    menuIcon: Qt.resolvedUrl("../graphics/unwatched_sidebar.png")
                    onClicked: {
                        selectListItem(airedShowsTablet)
                        movieList.dataModel = airedShowsModel.model
                        movieList.showDate = true
                        movieList.gridType = "gridDetailedCarousel"
                    }
                }

                SidebarMenuItem {
                    id: userWatchlistTablet
                    menuCount: userWatchlistModel.model.count
                    shortenedMenuLabel: i18n.tr("Watchlist")
                    menuLabel: i18n.tr("Movie Watchlist")
                    menuIcon: Qt.resolvedUrl("../graphics/watchlist_sidebar.png")
                    onClicked: {
                        selectListItem(userWatchlistTablet)
                        movieList.gridType = "gridCarousel"
                        movieList.dataModel = userWatchlistModel.model
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

            EmptyState {
                id: noContentMessage
                visible: !movieList.loading && !movieList.dataModel.count > 0
                logo: Qt.resolvedUrl("../graphics/empty_content.png")
                header: i18n.tr("No Content Yet")
                message: i18n.tr("This space feels empty. Watch some movies or follow a tv show!")
            }

            LoadingIndicator {
                id: _loadingIndicator
                isShown: movieList.loading
            }

            Grid {
                id: movieList

                property bool loading

                anchors.fill: parent
                anchors.topMargin: units.gu(1)
                dataModel: nowPlayingMoviesModel.model

                onThumbClicked: gridType === "gridCarousel" ? pageStack.push(Qt.resolvedUrl("MoviePage.qml"), {"movie_id": model.id})
                                                            : pageStack.push(Qt.resolvedUrl("EpisodePage.qml"), {"tv_id": model.id, "season_number": model.season, "episode_number": model.episode, "watched": model.watched})
            }
        }
    }
}
