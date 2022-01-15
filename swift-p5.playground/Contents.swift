import Foundation

class Demo: Sketch {
    override func setup() {
        print("setup")
    }
    
    override func draw() {
        print("draw")
        background(255)
//        noLoop()
    }
}

let demo = Demo(400, 400)
