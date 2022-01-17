import Foundation
import AppKit
import PlaygroundSupport

// MARK: Canvas dimension
private(set) var canvasWidth: Double = 0
private(set) var canvasHeight: Double = 0

public func createCanvas(_ w: Double, _ h: Double) {
    canvasWidth = w
    canvasHeight = h
}

var ctx: CGContext {
    guard let c = NSGraphicsContext.current?.cgContext else {
        fatalError("No graphics context")
    }
    return c
}

public func background(_ white: CGFloat) {
    ctx.setFillColor(gray: white, alpha: 1)
    let rect = CGRect(x: 0, y: 0, width: canvasWidth, height: canvasHeight)
    ctx.fill(rect)
}

public func rect(_ x: Double, _ y: Double, _ w: Double, _ h: Double) {
    let rect = CGRect(x: x, y: y, width: w, height: h)
    ctx.fill(rect)
}

public func fill(_ gray: Double = 0) {
    ctx.setFillColor(gray: gray, alpha: 1)
}

public func point(_ x: Double, _ y: Double) {
    let rect = CGRect(x: x, y: y, width: 5, height: 5)
    ctx.fillEllipse(in: rect)
}

private var displayLink: CVDisplayLink?

public func noLoop() {
    CVDisplayLinkStop(displayLink!)
}

open class Sketch {
    private let view: CanvasView
    
    private init(_ w: Double, _ h: Double, onDraw: @escaping () -> Void) {
        let viewFrame = NSRect(x: 0, y: 0, width: w, height: h)
        view = CanvasView(frame: viewFrame, onDraw: onDraw)
        
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
    }
    
    public static func create(setup: @escaping () -> Void, draw: @escaping () -> Void) {
        setup()
        
        let _ = Sketch(canvasWidth, canvasHeight, onDraw: draw)
    }
}
