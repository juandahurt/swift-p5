import Foundation

Sketch.create(
    setup: {
        createCanvas(500, 500)
    },
    draw: {
        background(0.2)
        fill()
        rect(200, 100, 100, 100)
        fill(1)
        point(50, 50)
    }
)
