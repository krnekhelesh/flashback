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
import "../backend/backend.js" as Backend
import "../backend/sha1.js" as Encrypt
import "../components"
import "../models"

Page {
    id: traktLoginPage

    visible: false
    flickable: null

    property bool isLogin: true

    TraktAccount {
        id: traktAccountModel

        function updateJSONModel() {
            accountIndicator.visible = false
            if (reply.status === "success") {
                traktLogin.contents = {
                    username: username.text,
                    password: Encrypt.sha1(password.text),
                    status: "active"
                }

                if(pageStack.depth === 3) {
                    while(pageStack.depth !== 1)
                        pageStack.pop()
                }
                else {
                    pagestack.pop()
                }
            }
            else if (reply.status === "failure"){
                if(isLogin) {
                    loginNotification.messageTitle = i18n.tr("Authentication Error")
                    loginNotification.message = i18n.tr("Invalid user account. Please check your username and password.")
                }
                else {
                    loginNotification.messageTitle = i18n.tr("Account Error")
                    loginNotification.message = username.text + i18n.tr(" is already a registered username")
                }

                loginNotification.visible = true
            }
        }
    }

    LoadingIndicator {
        id: accountIndicator
        loadingText: isLogin ? i18n.tr("Logging in...") : i18n.tr("Creating account...")
        visible: false
    }

    Notification { id: loginNotification }

    Timer {
        id: password_timer
        interval: 600
        repeat: false
        onTriggered: {
            if(confirmPassword.text === password.text)
                confirmPassword.color = "Green"
            else
                confirmPassword.color = "Red"
        }
    }

    Flickable {
        id: flickable
        anchors {
            top: parent.top
            bottom: buttonRow.top
            left: parent.left
            right: parent.right
            bottomMargin: units.gu(2)
        }

        contentHeight: detailsColumn.height + units.gu(10)

        Column {
            id: detailsColumn
            anchors {
                left: parent.left
                right: parent.right
                top: parent.top
                margins: units.gu(4)
            }
            height: childrenRect.height
            spacing: units.gu(2)

            UbuntuShape {
                id: logo
                width: traktLoginPage.height > units.gu(60) ? units.gu(20) : units.gu(10)
                height: width
                anchors.horizontalCenter: parent.horizontalCenter
                image: Image {
                    source: Qt.resolvedUrl("../graphics/trakt_logo.png")
                    fillMode: Image.PreserveAspectFit
                }

                Behavior on width {
                    UbuntuNumberAnimation { duration: UbuntuAnimation.BriskDuration }
                }
            }

            Label {
                text: "Trakt"
                fontSize: "x-large"
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Column {
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: units.gu(1)

                TextField {
                    id: username
                    maximumLength: 20
                    placeholderText: i18n.tr("Username")
                    inputMethodHints: Qt.ImhNoAutoUppercase
                    onFocusChanged: {
                        if(!focus && username.length < 3)
                            color = "Red"
                        else
                            color = "Grey"
                    }
                    primaryItem: Image {
                        height: parent.height/2;
                        fillMode: Image.PreserveAspectFit
                        source: Qt.resolvedUrl("../graphics/user.png")
                    }
                }

                TextField {
                    id: password
                    hasClearButton: false
                    placeholderText: i18n.tr("Password")
                    echoMode: TextInput.Password
                    onTextChanged: !isLogin ? password_timer.restart() : undefined
                    primaryItem: Image {
                        height: parent.height/2;
                        fillMode: Image.PreserveAspectFit
                        source: Qt.resolvedUrl("../graphics/password.png")
                    }
                    secondaryItem: Image {
                        visible: password.text !== ""
                        height: parent.height/1.5;
                        fillMode: Image.PreserveAspectFit
                        source: password.echoMode === TextInput.Password ? Qt.resolvedUrl("../graphics/watched_gray.png") : Qt.resolvedUrl("../graphics/unwatched_gray.png")
                        MouseArea {
                            anchors.fill: parent
                            onClicked: password.echoMode = password.echoMode === TextInput.Password ? TextInput.Normal : TextInput.Password
                        }
                    }
                }

                TextField {
                    id: confirmPassword

                    width: parent.width
                    echoMode: TextInput.Password
                    placeholderText: "confirm password"
                    onTextChanged: password_timer.restart()
                    Component.onCompleted: visible = !isLogin

                    primaryItem: Image {
                        height: parent.height/2;
                        fillMode: Image.PreserveAspectFit
                        source: Qt.resolvedUrl("../graphics/password.png")
                    }

                    onFocusChanged: {
                        if(focus)
                            confirmPassword.color = "Grey"
                        else {
                            if(confirmPassword.text === password.text)
                                confirmPassword.color = "Green"
                            else
                                confirmPassword.color = "Red"
                        }
                    }
                }

                TextField {
                    id: email
                    width: parent.width
                    placeholderText: "email address"
                    Component.onCompleted: visible = !isLogin
                    inputMethodHints: Qt.ImhEmailCharactersOnly

                    primaryItem: Image {
                        height: parent.height/2;
                        fillMode: Image.PreserveAspectFit
                        source: Qt.resolvedUrl("../graphics/email.png")
                    }

                    onFocusChanged: {
                        if(!focus && email.length < 6)
                            email.color = "Red"
                        else
                            email.color = "Grey"
                    }
                }
            }
        }
    }

    Row {
        id: buttonRow
        anchors {
            horizontalCenter: parent.horizontalCenter
            bottom: parent.bottom
            bottomMargin: traktLoginPage.height > units.gu(60) ? units.gu(10) : units.gu(2)
        }

        spacing: units.gu(2)
        width: childrenRect.width
        height: childrenRect.height

        Button {
            id: cancelButton
            color: UbuntuColors.warmGrey
            height: units.gu(5)
            width: loginButton.width
            text: i18n.tr("Cancel")
            onClicked: pageStack.pop()
        }

        Button {
            id: loginButton
            color: "green"
            height: units.gu(5)
            width: units.gu(15)
            text: isLogin ? i18n.tr("Login") : i18n.tr("Create Account")
            onClicked: {
                accountIndicator.visible = true
                if(isLogin) {
                    traktAccountModel.source = Backend.traktVerifyUrl()
                    traktAccountModel.createMessage(username.text, Encrypt.sha1(password.text))
                }
                else {
                    if(password.text === confirmPassword.text && password.text !== "" && username.length >= 3 && email.length >= 6) {
                        traktAccountModel.source = Backend.traktCreateAccount()
                        traktAccountModel.createAccountMessage(username.text, Encrypt.sha1(password.text), email.text)
                    }
                    else {
                        loginNotification.messageTitle = i18n.tr("Invalid Input")
                        loginNotification.message = i18n.tr("Please ensure that all fields are filled correctly before proceeding")
                        accountIndicator.visible = false
                        loginNotification.visible = true
                    }
                }
                traktAccountModel.sendMessage()
            }
        }        
    }

    // A custom toolbar is used in this page
    tools: ToolbarItems {
        locked: true
        opened: false
    }
}
