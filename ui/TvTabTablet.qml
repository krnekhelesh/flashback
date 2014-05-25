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
                isShown: !tvList.dataModel.count > 0
            }

            Grid {
                id: tvList
                anchors.fill: parent
                anchors.topMargin: units.gu(1)
                dataModel: trendingShowsModel.model
                onThumbClicked: gridType === "gridCarousel" ? pageStack.push(Qt.resolvedUrl("TvPage.qml"), {"tv_id": model.id})
                                                            : pageStack.push(Qt.resolvedUrl("EpisodePage.qml"), {"tv_id": model.id, "season_number": model.season, "episode_number": model.episode, "watched": model.watched})
            }
        }
    }
}
