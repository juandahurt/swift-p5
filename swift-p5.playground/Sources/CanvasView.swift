import Cocoa
import Foundation

protocol CanvasViewDelegate: AnyObject {
    func canvasJustDraw(_ dirtyRect: NSRect)
}

class CanvasView: NSView {
    weak var delegate: CanvasViewDelegate?
    
    override init(frame frameRect: NSRect) {
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
        
        delegate?.canvasJustDraw(dirtyRect)
    }
}
