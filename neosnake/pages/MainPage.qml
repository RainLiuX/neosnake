import QtQuick 2.0
import Ubuntu.Components 1.3
import"../components"

Page{
    property alias score: snake.score
    property alias timeLeft: countdown.left
    property alias showAnimation: showAnimation
    property alias popAnimation: popAnimation
    property alias side: calculator.side
    SideCalculator{
        id:calculator
    }

    Control{
        z:1
        id:leftControl
        height:parent.height
        width:parent.width/2
        anchors{ left:parent.left; top: parent.top}
        imageAnchors.left: leftControl.left
        imageSource: "../images/turnLeft.png"
        text:"Turn LEFT"
        MouseArea{
            anchors.fill: parent
            onClicked: {
                snake.turnLeft()
                parent.fadeAway.start()
                rightControl.fadeAway.start()
            }
        }
    }

    Control{
        z:1
        id:rightControl
        height:parent.height
        width:parent.width/2
        anchors{ right:parent.right; top:parent.top}
        imageAnchors.right:rightControl.right
        imageSource: "../images/turnRight.png"
        text:"Turn RIGHT"
        MouseArea{
            anchors.fill: parent
            onClicked: {
                snake.turnRight()
                parent.fadeAway.start()
                leftControl.fadeAway.start()
            }
        }
    }

    Rectangle{
        id:frontground
        z:2
        anchors.fill: parent
        color:"white"
        opacity: 0
        PropertyAnimation{
            id:showAnimation
            target:frontground
            property:"opacity"
            to:0.7
            duration:300
        }
        PropertyAnimation{
            id:popAnimation
            target:frontground
            property:"opacity"
            to:0
            duration:300
        }
    }
    Rectangle{
        z:-2
        anchors.fill: parent
        color:"black"
    }
    Rectangle{
        id:background
        z:-1
        anchors.fill:snake
        Image{
            anchors.fill: parent
            source:"../images/background.jpg"
            fillMode: Image.Stretch
        }
    }
    Rectangle{
        id:colorbar
        width:parent.width
        height:units.gu(0.7)
        anchors.top: parent.top
        color:"#8b0024"
    }

    Food{
        id:food
        height:boardHeight*calculator.side
        width:boardWidth*calculator.side
        anchors.centerIn: parent
        Display{
            id:foodDisp
            side:calculator.side
            anchors.fill: parent
            dispX: parent.xPos;
            dispY: parent.yPos;
            dispColor: "orange"
        }
    }

    Hinder{
        id:hinder
        height:boardHeight*calculator.side
        width:boardWidth*calculator.side
        anchors.centerIn: parent
        Display{
            id:hinderDisp
            side:calculator.side
            anchors.fill: parent;
            dispX: parent.xPos;
            dispY: parent.yPos;
            dispColor: "purple"
        }
    }

    Snake{
        id:snake
        height:boardHeight*calculator.side
        width:boardWidth*calculator.side
        anchors.centerIn: parent
        Component.onCompleted: {
            snake.init();
        }
        onDead: {
            panel.open()
            panel.swapButton()
        }

        SnakeDisp{
            id:snakeDisp
            side:calculator.side
            dispX: parent.xPos;
            dispY: parent.yPos;
            anchors.fill: parent;
        }
    }

    Timer{
        id:timer;
        repeat:true;
        interval: 150;
        Component.onCompleted: {
            timer.start();
        }
        onTriggered: {
            foodDisp.requestPaint();
            hinderDisp.requestPaint();
            snake.eat(food.xPos[0], food.yPos[0]);
            snake.move();
            snake.crash(hinder.xPos, hinder.yPos);
            snakeDisp.requestPaint();
        }
    }

    Timer{
        id:countdown;
        property var left: 7
        interval: 1000;
        repeat: true;
        Component.onCompleted: {
            countdown.start();
        }
        onTriggered: {
            left --;
            if (left==0){
                food.newFood(snake.xPos,snake.yPos,hinder.xPos,hinder.yPos)
            }
        }
    }

    function pause(){
        timer.stop()
        countdown.stop()
    }
    function conti(){
        timer.start()
        countdown.start()
    }
    function restart(){
        snake.init()
        hinder.newHinder(snake.xPos, snake.yPos)
        food.newFood(snake.xPos, snake.yPos, hinder.xPos ,hinder.yPos)
        timer.restart()
        countdown.restart(); countdown.left=7
    }

}


