import QtQuick 2.0
import Ubuntu.Layouts 1.0
import Ubuntu.Components 1.1
import "../components"

ConditionalLayout {
    id: tabletConditionalLayout

    name: "tablet"
    when: tabletPortraitForm || tabletLandscapeForm

    Row {
        anchors.fill: parent

        // Function to mark a listitem in the sidebar as selected and deselect the other items
        function selectListItem(item) {
            var sidebarList = [trendingTablet, userLibraryTablet, airingShowsTablet]
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
                    id: trendingTablet
                    shortenedMenuLabel: i18n.tr("Trending")
                    menuLabel: i18n.tr("Trending TV Shows")
                    menuIcon: Qt.resolvedUrl("../graphics/trending_icon.png")
                    isSelected: true
                    onClicked: {
                        selectListItem(trendingTablet)
                        tvList.gridType = "gridCarousel"
                        tvList.dataModel = trendingShowsModel.model
                        tvList.loading = trendingShowsModel.loading
                    }
                }

                SidebarMenuItem {
                    id: userLibraryTablet
                    shortenedMenuLabel: i18n.tr("Watchlist")
                    menuLabel: i18n.tr("TV Show Watchlist")
                    menuIcon: Qt.resolvedUrl("../graphics/watchlist_sidebar.png")
                    onClicked: {
                        selectListItem(userLibraryTablet)
                        tvList.gridType = "gridCarousel"
                        tvList.dataModel = userWatchlistShowsModel.model
                        tvList.loading = userWatchlistShowsModel.loading
                    }
                }

                SidebarMenuItem {
                    id: airingShowsTablet
                    menuCount: airingShowsModel.model.count
                    shortenedMenuLabel: i18n.tr("Upcoming")
                    menuLabel: i18n.tr("Episodes Upcoming")
                    menuIcon: Qt.resolvedUrl("../graphics/upcoming.png")
                    onClicked: {
                        selectListItem(airingShowsTablet)
                        tvList.dataModel = airingShowsModel.model
                        tvList.showDate = true
                        tvList.gridType = "gridDetailedCarousel"
                        tvList.loading = airingShowsModel.loading
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
                visible: !tvList.loading && tvList.dataModel.count === 0
                logo: trendingTablet.isSelected || traktLogin.contents.status !== "disabled" ? Qt.resolvedUrl("../graphics/empty_content.png") : Qt.resolvedUrl("../graphics/account.png")
                header: trendingTablet.isSelected || traktLogin.contents.status !== "disabled" ? i18n.tr("No Content Yet") : i18n.tr("No Trakt Account")
                message: trendingTablet.isSelected || traktLogin.contents.status !== "disabled" ? i18n.tr("This space feels empty. Follow some tv shows!") : i18n.tr("Please set up an account using the add \"Accounts\" button to use this feature")
            }

            LoadingIndicator {
                id: _loadingIndicator
                isShown: tvList.loading
            }

            Grid {
                id: tvList

                property bool loading

                anchors.fill: parent
                anchors.topMargin: units.gu(1)
                dataModel: trendingShowsModel.model
                loading: trendingShowsModel.loading

                onThumbClicked: gridType === "gridCarousel" ? pageStack.push(Qt.resolvedUrl("TvPage.qml"), {"tv_id": model.id})
                                                            : pageStack.push(Qt.resolvedUrl("EpisodePage.qml"), {"tv_id": model.id, "season_number": model.season, "episode_number": model.episode, "watched": model.watched})
            }
        }
    }
}
