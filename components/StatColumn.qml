import QtQuick 2.4
import Ubuntu.Components 1.2

Column {
    id: _statColumn

    property alias value: _statValue.text
    property alias category: _statHeader.text

    width: parent.width/3
    anchors.verticalCenter: parent.verticalCenter

    Label {
        id: _statValue
        fontSize: "large"
        font.bold: true
        width: parent.width
        horizontalAlignment: Text.AlignHCenter
    }
    
    Label {
        id: _statHeader
        width: parent.width
        fontSize: "small"
        horizontalAlignment: Text.AlignHCenter
    }
}
