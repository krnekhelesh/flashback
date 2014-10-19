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
import Ubuntu.Components 1.1
import Ubuntu.Components.ListItems 1.0 as ListItem
import "../backend/backend.js" as Backend
import "../components"
import "../models"

Page {
    id: commentsPage

    title: i18n.tr("Comments")
    visible: false
    flickable: null

    property string id
    property string type
    property string name
    property string year
    property string season
    property string episode

    // Page Background
    Background {}

    TraktUserComment {
        id: usercomments
        function updateJSONModel() {
            if(reply.status === "success") {
                console.log("[LOG]: User comment posted successfully")
                comments.model.insert(0, {"comment": userComment.text, "inserted": parseInt(new Date().getTime()/1000), "username": traktLogin.contents.username, "thumb_url": "../graphics/user.png"})
                commentsLoading.isShown = false
                noCommentsMessages.visible = false
                addCommentBox.visible = false
                userComment.text = ""
                commentsList.state = ""
            }
        }
    }

    TraktComments {
        id: comments
        Component.onCompleted: {
            if(type === "Movie")
                source = Backend.traktCommentsUrl("movie", id)
            else if(type === "Show")
                source = Backend.traktCommentsUrl("show", id)
            else if(type === "Episode")
                source = Backend.traktEpisodeCommentsUrl(id, season, episode)
        }
    }

    LoadingIndicator {
        id: commentsLoading
        isShown: comments.loading
    }

    EmptyState {
        id: noCommentsMessages
        visible: comments.loading ? false : comments.model.count === 0 ? true : false
        logo: Qt.resolvedUrl("../graphics/emptyComment.png")
        header: i18n.tr("No Comments Yet")
        message: i18n.tr("This space feels empty. Be the first to comment!")
    }

    ListView {
        id: commentsList

        model: comments.model
        spacing: units.gu(2)
        clip: true

        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            margins: units.gu(2)
        }

        states: [
            State {
                name: "addcomment"
                AnchorChanges {
                    target: commentsList
                    anchors.bottom: addCommentBox.top
                }
            }
        ]

        delegate: UbuntuShape {
            color: "White"
            width: parent.width
            height: commentColumn.height + units.gu(3)

            Column {
                id: commentColumn
                spacing: units.gu(1)
                anchors {
                    top: parent.top
                    left: parent.left
                    right: parent.right
                    margins: units.gu(1)
                }

                Row {
                    id: commentDetailsRow
                    spacing: units.gu(1)
                    anchors {
                        left: parent.left
                        right: parent.right
                    }

                    Thumbnail {
                        id: userAvatar
                        width: units.gu(5)
                        height: width
                        thumbSource: thumb_url
                    }

                    Column {
                        id: userDetailsColumn
                        anchors.verticalCenter: userAvatar.verticalCenter

                        Label {
                            id: commenter
                            text: username
                            font.bold: true
                            color: "Black"
                        }

                        Label {
                            id: commentDate
                            color: "Black"
                            text: Qt.formatDate(new Date(inserted*1000), 'dd MMMM, yyyy')
                            fontSize: "small"
                        }
                    }
                }

                Image {
                    id: spoilerStatus
                    visible: spoiler
                    source: Qt.resolvedUrl("../graphics/spoiler.png")
                    anchors.horizontalCenter: parent.horizontalCenter
                    MouseArea {
                        anchors.fill: parent
                        onClicked: spoilerStatus.visible = false
                    }
                }

                Label {
                    id: commentText
                    text: comment
                    visible: !spoilerStatus.visible
                    color: UbuntuColors.coolGrey
                    elide: Text.ElideRight
                    wrapMode: Text.WordWrap
                    anchors {
                        right: parent.right
                        left: parent.left
                    }
                }
            }
        }
    }

    Item {
        id: addCommentBox
        anchors {
            bottom: parent.bottom
            left: parent.left
            right: parent.right
            bottomMargin: units.gu(2)
        }

        height: userComment.height + buttonRow.height + units.gu(4)
        visible: false

        ListItem.ThinDivider {
            anchors {
                left: parent.left
                right: parent.right
                bottom: userComment.top
                bottomMargin: units.gu(2)
            }
        }

        TextArea {
            id: userComment
            placeholderText: "Enter comment.."
            autoSize: true
            maximumLineCount: 4
            width: parent.width
            anchors {
                left: parent.left
                right: parent.right
                bottom: buttonRow.top
                margins: units.gu(2)
            }
        }

        Row {
            id: spoilerRow
            spacing: units.gu(1)
            anchors {
                bottom: parent.bottom
                left: parent.left
                leftMargin: units.gu(2)
            }
            CheckBox {
                id: isSpoiler
                checked: false
            }
            Label {
                text: "Spoiler Alert"
                opacity: isSpoiler.checked ? 1.0 : 0.3
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        Row {
            id: buttonRow
            spacing: units.gu(1)
            anchors {
                bottom: parent.bottom
                right: parent.right
                rightMargin: units.gu(2)
            }

            Button {
                text: "Cancel"
                color: UbuntuColors.warmGrey
                height: spoilerRow.height
                onClicked: {
                    addCommentBox.visible = false
                    userComment.text = ""
                    commentsList.state = ""
                }
            }

            Button {
                text: "Comment"
                color: "Green"
                height: spoilerRow.height
                onClicked: {
                    commentsLoading.loadingText = i18n.tr("Submitting comment.\nPlease wait..")
                    commentsLoading.isShown = true
                    if(type === "Episode") {
                        usercomments.source = Backend.traktAddCommentUrl("episode")
                        usercomments.createEpisodeMessage(traktLogin.contents.username, traktLogin.contents.password, id, name, year, season, episode, userComment.text, isSpoiler.checked)
                    }
                    else if(type === "Movie") {
                        usercomments.source = Backend.traktAddCommentUrl("movie")
                        usercomments.createMovieMessage(traktLogin.contents.username, traktLogin.contents.password, id, name, year, userComment.text, isSpoiler.checked)
                    }
                    else if(type === "Show") {
                        usercomments.source = Backend.traktAddCommentUrl("show")
                        usercomments.createShowMessage(traktLogin.contents.username, traktLogin.contents.password, id, name, year, userComment.text, isSpoiler.checked)
                    }
                    usercomments.sendMessage()
                }
            }
        }
    }

    Action {
        id: commentAction
        text: i18n.tr("Comment")
        visible: traktLogin.contents.status !== "disabled"
        keywords: i18n.tr("Add;Comment;Comments;Submit")
        description: i18n.tr("Add comment")
        iconName: "add"
        onTriggered: {
            commentsList.state = "addcomment"
            addCommentBox.visible = true
            userComment.forceActiveFocus()
        }
    }

    head.actions: [
        returnHomeAction,
        commentAction
    ]
}
