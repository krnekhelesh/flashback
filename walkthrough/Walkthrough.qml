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
import Ubuntu.Components.ListItems 0.1

//
Page {
    id: walkthrough

    // Default slide to start on loading
    state: "Slide 1"

    // Property to hold the number of states (slides)
    readonly property int slidesCount: states.length

    property bool isFirstRun: true

    // Property to check if the user is moving forward or backward in the walkthrough
    property bool isForward: true

    // Property to hold the current slide number
    property int currentSlide: parseInt(walkthrough.state.split(" ")[1])

    // Disable automatic orientation during walkthough and enable it after the walkthrough.
    Component.onCompleted: mainView.automaticOrientation = false
    Component.onDestruction: mainView.automaticOrientation = true

    // Each state is a slide. The state naming format must be "Slide #" where # is the slide number
    states: [
        State {
            name: "Slide 1"
            PropertyChanges { target: slideLoader; sourceComponent: slide1 }
        },

        State {
            name: "Slide 2"
            PropertyChanges { target: slideLoader; sourceComponent: slide2 }
        },

        State {
            name: "Slide 3"
            PropertyChanges { target: slideLoader; sourceComponent: slide3 }
        },

        State {
            name: "Slide 4"
            PropertyChanges { target: slideLoader; sourceComponent: slide4 }
        },

        State {
            name: "Slide 5"
            PropertyChanges { target: slideLoader; sourceComponent: slide5 }
        },

        State {
            name: "Slide 6"
            PropertyChanges { target: slideLoader; sourceComponent: slide6 }
        },

        State {
            name: "Slide 7"
            PropertyChanges { target: slideLoader; sourceComponent: slide7 }
        }
    ]

    // Loader to load a single slide at a time
    Loader {
        id: slideLoader
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            bottom: separator.top
        }
    }

    // Walkthrough slides (each is a component dynamically loaded only when necessary)
    Slide1 { id: slide1 }
    Slide2 { id: slide2 }
    Slide3 { id: slide3 }
    Slide4 { id: slide4 }
    Slide5 { id: slide5 }
    Slide6 { id: slide6 }
    Slide7 { id: slide7 }

    MouseArea {
        id: pageDragArea

        property int orgMouseX

        z: -1
        anchors.fill: parent

        onPressed: orgMouseX = mouseX
        onReleased:  {
            if(mouseX > orgMouseX && mouseX - orgMouseX > units.gu(10) && currentSlide !== 1) {
                isForward = false
                walkthrough.state = "Slide " + (currentSlide-1)
            }
            else if(mouseX < orgMouseX && orgMouseX - mouseX > units.gu(10) && currentSlide !== slidesCount) {
                isForward = true
                walkthrough.state = "Slide " + (currentSlide+1)
            }
        }
    }

    // Label to skip the walkthrough. Only visible on the first slide
    Label {
        id: skipLabel

        color: "grey"
        fontSize: "small"
        width: contentWidth
        text: currentSlide === 1 ? "Already used Flashback? <b>Skip the tutorial</b>" : "Skip"

        anchors {
            top: parent.top
            left: parent.left
            margins: units.gu(2)
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                if(isFirstRun) {
                    firstRunDocument.contents = {
                        firstrun: "false"
                    }
                    pageStack.pop()
                    pageStack.push(rootComponent)
                }
                else {
                    while(pageStack.depth !== 2)
                        pageStack.pop()
                }
            }
        }
    }

    // Separator between walkthrough slides and slide indicator
    ThinDivider {
        id: separator
        anchors {
            bottom: slideIndicator.top
            bottomMargin: units.gu(3)
        }
    }

    // Indicator element to represent the current slide of the walkthrough
    Row {
        id: slideIndicator
        spacing: units.gu(2)
        anchors {
            bottom: parent.bottom
            bottomMargin: units.gu(3)
            horizontalCenter: parent.horizontalCenter
        }

        Repeater {
            model: walkthrough.slidesCount
            delegate: Rectangle {
                height: width
                radius: width/2
                width: units.gu(2)
                antialiasing: true
                color: currentSlide > index ? "green" : "white"
            }
        }
    }
}
