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

import QtQuick 2.4
import Ubuntu.Layouts 1.0
import Ubuntu.Components 1.2
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
                    if(traktLogin.contents.status !== "disabled") {
                        createMessage(traktLogin.contents.username, traktLogin.contents.password)
                        sendMessage()
                    } else {
                        loading = false
                    }
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
                        if (movieTab.state === "search") {
                            movieTab.setDefaultState()
                        }
                        selectListItem(trendingMoviesTablet)
                        movieList.dataModel = trendingMoviesModel.model
                        movieList.loading = trendingMoviesModel.loading
                    }
                }

                SidebarMenuItem {
                    id: nowPlayingTablet
                    shortenedMenuLabel: i18n.tr("Theatres")
                    menuLabel: i18n.tr("Playing in Theatres")
                    menuIcon: Qt.resolvedUrl("../graphics/now_playing.png")
                    onClicked: {
                        if (movieTab.state === "search") {
                            movieTab.setDefaultState()
                        }
                        selectListItem(nowPlayingTablet)
                        movieList.dataModel = nowPlayingMoviesModel.model
                        movieList.loading = nowPlayingMoviesModel.loading
                    }
                }

                SidebarMenuItem {
                    id: upcomingMoviesTablet
                    shortenedMenuLabel: i18n.tr("Upcoming")
                    menuLabel: i18n.tr("Upcoming Movies")
                    menuIcon: Qt.resolvedUrl("../graphics/upcoming.png")
                    onClicked: {
                        if (movieTab.state === "search") {
                            movieTab.setDefaultState()
                        }
                        selectListItem(upcomingMoviesTablet)
                        movieList.dataModel = upcomingMoviesModel.model
                        movieList.loading = upcomingMoviesModel.loading
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
                        if (movieTab.state === "search") {
                            movieTab.setDefaultState()
                        }
                        selectListItem(filterRating)
                        movieList.dataModel = topRatedMovieModel.model
                        movieList.loading = topRatedMovieModel.loading
                    }
                }

                SidebarMenuItem {
                    id: filterRecommended
                    shortenedMenuLabel: i18n.tr("Recommended")
                    menuLabel: i18n.tr("Recommended")
                    menuIcon: Qt.resolvedUrl("../graphics/recommended.png")
                    onClicked: {
                        if (movieTab.state === "search") {
                            movieTab.setDefaultState()
                        }
                        selectListItem(filterRecommended)
                        movieList.dataModel = recommendedMoviesModel.model
                        movieList.loading = recommendedMoviesModel.loading
                    }
                }
            }

            NowWatchingTablet {
                id: nowWatchingShowTablet

                anchors {
                    left: parent.left
                    bottom: parent.bottom
                }

                backgroundFanArt: showActivityDocument.contents.name !== "default" ? showActivityDocument.contents.fanart : ""
                posterArt: showActivityDocument.contents.name !== "default" ? showActivityDocument.contents.poster : ""
                subtitle: showActivityDocument.contents.name !== "default" ? showActivityDocument.contents.name : ""
                title: showActivityDocument.contents.name !== "default" ? showActivityDocument.contents.episode_title : ""
                extra: showActivityDocument.contents.name !== "default" ? "S" + showActivityDocument.contents.season + "E" + showActivityDocument.contents.number : ""
                visible: showActivityDocument.contents.name !== "default" && tabletLandscapeForm

                onThumbClicked: pageStack.push(Qt.resolvedUrl("EpisodePage.qml"), {"tv_id": showActivityDocument.contents.id, "season_number": showActivityDocument.contents.season, "episode_number": showActivityDocument.contents.number, "episode_name": showActivityDocument.contents.episode_title})
            }

            NowWatchingTablet {
                id: nowWatchingMovieTablet

                anchors {
                    left: parent.left
                    bottom: parent.bottom
                }

                backgroundFanArt: movieActivityDocument.contents.name !== "default" ? movieActivityDocument.contents.fanart : ""
                posterArt: movieActivityDocument.contents.name !== "default" ? movieActivityDocument.contents.poster : ""
                subtitle: movieActivityDocument.contents.name !== "default" ? "Length: " + movieActivityDocument.contents.runtime + " mins" : ""
                extra: movieActivityDocument.contents.name !== "default" ? "Year: " + movieActivityDocument.contents.year : ""
                title: movieActivityDocument.contents.name !== "default" ? movieActivityDocument.contents.name : ""

                visible: movieActivityDocument.contents.name !== "default" && tabletLandscapeForm

                onThumbClicked: pageStack.push(Qt.resolvedUrl("MoviePage.qml"), {"movie_id": movieActivityDocument.contents.id})
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
                visible: !movieList.loading && movieList.dataModel.count === 0 && movieTab.state !== "search"
                logo: !filterRecommended.isSelected || traktLogin.contents.status !== "disabled" ? Qt.resolvedUrl("../graphics/empty_content.png") : Qt.resolvedUrl("../graphics/account.png")
                header: !filterRecommended.isSelected || traktLogin.contents.status !== "disabled" ? i18n.tr("No Content Yet") : i18n.tr("No Trakt Account")
                message: !filterRecommended.isSelected || traktLogin.contents.status !== "disabled" ? i18n.tr("This space feels empty. Watch some movies!") : i18n.tr("Please set up an account using the add \"Accounts\" button to use this feature")
            }

            LoadingIndicator {
                id: _loadingIndicator
                isShown: movieList.loading && movieTab.state !== "search"
            }

            Grid {
                id: movieList

                property bool loading

                anchors.fill: parent
                anchors.topMargin: units.gu(1)
                dataModel: trendingMoviesModel.model
                loading: trendingMoviesModel.loading

                visible: movieTab.state !== "search"

                onThumbClicked: pageStack.push(Qt.resolvedUrl("MoviePage.qml"), {"movie_id": model.id})
            }

            ItemLayout {
                anchors.fill: parent
                item: "searchPageLoader"
            }
        }
    }
}
