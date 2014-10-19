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
import Ubuntu.Layouts 1.0
import Ubuntu.Components 1.1
import Ubuntu.Components.Themes.Ambiance 1.1
import Ubuntu.Components.ListItems 1.0 as ListItem
import "../backend/backend.js" as Backend
import "../backend/sha1.js" as Encrypt
import "../components"
import "../models"

Page {
    id: traktLoginPage

    visible: false
    flickable: null

    title: isLogin ? i18n.tr("Login") : i18n.tr("Sign up")

    property bool isLogin: true

    // Disable automatic orientation during walkthough and enable it after the login
    Component.onCompleted: mainView.automaticOrientation = false
    Component.onDestruction: mainView.automaticOrientation = true

    // Page Background
    Background {}

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

                loginNotification.isShown = true
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

    /*
      Phone and Tablet UI Definitions
     */
    Layouts {
        id: loginLayout
        anchors.fill: parent

        layouts: [
            TraktLoginTablet {}
        ]

        Flickable {
            id: flickable

            anchors {
                fill: parent
                bottomMargin: units.gu(2)
            }

            clip: true
            contentHeight: detailsColumn.height

            Column {
                id: detailsColumn

                anchors {
                    left: parent.left
                    right: parent.right
                    top: parent.top
                    topMargin: Qt.inputMethod.visible ? units.gu(4) : units.gu(8)
                    margins: units.gu(2)
                }

                height: childrenRect.height
                spacing: Qt.inputMethod.visible ? units.gu(4) : isLogin ? units.gu(8) : units.gu(4)

                Image {
                    id: logo
                    Layouts.item: "logo"
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: traktLoginPage.height > units.gu(60) ? units.gu(20) : isLogin ? units.gu(10) : units.gu(0)
                    source: Qt.resolvedUrl("../graphics/account.png")
                    fillMode: Image.PreserveAspectFit

                    Behavior on width {
                        UbuntuNumberAnimation { duration: UbuntuAnimation.BriskDuration }
                    }
                }

                SettingsItem {
                    id: loginBox
                    Layouts.item: "loginBox"

                    title: isLogin ? i18n.tr("Sign in") : i18n.tr("Create your Trakt Account")
                    contentSpacing: units.gu(0)

                    contents: [
                        TextField {
                            id: username

                            maximumLength: 20
                            placeholderText: i18n.tr("Username")
                            inputMethodHints: Qt.ImhNoAutoUppercase
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.margins: units.gu(2)
                            height: units.gu(5)

                            style: TextFieldStyle {
                                background: Rectangle {
                                    anchors.left: parent.left
                                    anchors.right: parent.right
                                    anchors.margins: -units.gu(2)
                                    color: username.focus ? "White" : Qt.rgba(0,0,0,0)
                                }
                            }

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
                        },

                        ListItem.ThinDivider {},

                        TextField {
                            id: password

                            hasClearButton: false
                            placeholderText: i18n.tr("Password")
                            echoMode: TextInput.Password
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.margins: units.gu(2)
                            height: units.gu(5)
                            onTextChanged: !isLogin ? password_timer.restart() : undefined

                            style: TextFieldStyle {
                                background: Rectangle {
                                    anchors.left: parent.left
                                    anchors.right: parent.right
                                    anchors.margins: -units.gu(2)
                                    color: password.focus ? "White" : Qt.rgba(0,0,0,0)
                                }
                            }

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
                        },

                        ListItem.ThinDivider {
                            visible: !isLogin
                        },

                        TextField {
                            id: confirmPassword

                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.margins: units.gu(2)
                            echoMode: TextInput.Password
                            placeholderText: "confirm password"
                            onTextChanged: password_timer.restart()
                            Component.onCompleted: visible = !isLogin
                            height: units.gu(5)

                            style: TextFieldStyle {
                                background: Rectangle {
                                    anchors.left: parent.left
                                    anchors.right: parent.right
                                    anchors.margins: -units.gu(2)
                                    color: confirmPassword.focus ? "White" : Qt.rgba(0,0,0,0)
                                }
                            }

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
                        },

                        ListItem.ThinDivider {
                            visible: !isLogin
                        },

                        TextField {
                            id: email

                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.margins: units.gu(2)
                            placeholderText: "email address"
                            Component.onCompleted: visible = !isLogin
                            inputMethodHints: Qt.ImhEmailCharactersOnly
                            height: units.gu(5)

                            style: TextFieldStyle {
                                background: Rectangle {
                                    anchors.left: parent.left
                                    anchors.right: parent.right
                                    anchors.margins: -units.gu(2)
                                    color: email.focus ? "White" : Qt.rgba(0,0,0,0)
                                }
                            }

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
                        },

                        Item {
                            width: parent.width
                            height: units.gu(1)
                        }
                    ]
                }
            }
        }
    }

    Action {
        id: createAccountAction
        text: i18n.tr("Account")
        keywords: i18n.tr("Login;Signup;Create;Account")
        description: i18n.tr("Create/Login Trakt Account")
        iconName: "save"
        onTriggered: {
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
                    loginNotification.isShown = true
                }
            }
            traktAccountModel.sendMessage()
        }
    }

    head.actions: [
        createAccountAction
    ]
}
