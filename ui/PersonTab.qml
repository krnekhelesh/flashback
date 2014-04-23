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
import "../components"
import "../models"
import "../backend/backend.js" as Backend

Page {
    id: personPage

    Component.onCompleted: console.log("[LOG]: People Tab Loaded")

    People {
        id: popularPeople
        source: Backend.popularPeopleUrl()
    }

    actions: [
        Action {
            id: searchPersonAction
            text: i18n.tr("Celeb")
            keywords: i18n.tr("Search;Person;Actor;Actors;Actress;Cast;Crew;Find")
            description: i18n.tr("Search for Actors, Actress and Crew")
            iconSource: Qt.resolvedUrl("../graphics/find.svg")
            onTriggered: pageStack.push(Qt.resolvedUrl("SearchPerson.qml"))
        }
    ]

    LoadingIndicator {
        isShown: !popularPeople.count > 0
    }

    Grid {
        id: popular
        dataModel: popularPeople.model
        header: i18n.tr("Popular")
        anchors {
            fill: parent
            margins: units.gu(2)
        }
        onThumbClicked: pageStack.push(Qt.resolvedUrl("PersonPage.qml"), {"person_id": model.id})
    }

    tools: ToolbarItems {
        id: toolbarPerson

        ToolbarButton {
            id: settings
            action: appSettingsAction
        }

        ToolbarButton {
            id: searchPersons
            action: searchPersonAction
        }
    }
}
