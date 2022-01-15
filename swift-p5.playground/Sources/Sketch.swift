import Foundation
import AppKit
import PlaygroundSupport

open class Sketch {
    private let view: CanvasView
    private var displayLink: CVDisplayLink?
    private var rect: NSRect = .zero
    
    private var ctx: CGContext {
        guard let c = NSGraphicsContext.current?.cgContext else {
            fatalError("No graphics context")
        }
        return c
    }
    
    public init(_ w: Double, _ h: Double) {
        let viewFrame = NSRect(x: 0, y: 0, width: w, height: h)
        view = CanvasView(frame: viewFrame)
        view.delegate = self
        
        PlaygroundPage.current.liveView = view
        PlaygroundPage.current.needsIndefiniteExecution = true
        
        let displayLinkOutputCallback: CVDisplayLinkOutputCallback = {(displayLink: CVDisplayLink, inNow: UnsafePointer<CVTimeStamp>, inOutputTime: UnsafePointer<CVTimeStamp>, flagsIn: CVOptionFlags, flagsOut: UnsafeMutablePointer<CVOptionFlags>, displayLinkContext: UnsafeMutableRawPointer?) -> CVReturn in
            DispatchQueue.main.sync {
                let view = unsafeBitCast(displayLinkContext, to: CanvasView.self)
                view.setNeedsDisplay(view.bounds)
                view.displayIfNeeded()
            }
            return kCVReturnSuccess
        }
        
        CVDisplayLinkCreateWithActiveCGDisplays(&displayLink)
        CVDisplayLinkSetOutputCallback(displayLink!, displayLinkOutputCallback, UnsafeMutableRawPointer(Unmanaged.passUnretained(view).toOpaque()))
        CVDisplayLinkStart(displayLink!)
        
        setup()
    }
    
    public func noLoop() {
        CVDisplayLinkStop(displayLink!)
    }
    
    open func setup() {}
    
    open func draw() {}
    
    public func background(_ white: CGFloat) {
        ctx.setFillColor(gray: white, alpha: 1)
        ctx.fill(rect)
    }
}

extension Sketch: CanvasViewDelegate {
    func canvasJustDraw(_ dirtyRect: NSRect) {
        rect = dirtyRect
        draw()
    }
}
