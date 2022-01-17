import Cocoa
import Foundation

class CanvasView: NSView {
    let onDraw: () -> Void
    
    init(frame frameRect: NSRect, onDraw: @escaping () -> Void) {
        self.onDraw = onDraw
        super.init(frame: frameRect)
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("Why are u calling this initializer???")
    }
    
    override var isFlipped: Bool {
        true
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        onDraw()
    }
}
