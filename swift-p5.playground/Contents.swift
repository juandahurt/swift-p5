import Foundation
import CoreGraphics

struct Particle {
    var partOfExplosion = false
    var pos = CGVector(dx: CGFloat.random(in: 0..<500), dy: 500)
    var vel = CGVector(dx: 0, dy: -5)
    var acc = CGVector(dx: 0, dy: 0)
    var gravity = CGVector(dx: 0, dy: 0.001)
    
    init(partOfExplosion: Bool = false, headPos: CGVector? = nil) {
        self.partOfExplosion = partOfExplosion
        if partOfExplosion, let headPos = headPos {
            let minVel: CGFloat = -1
            let maxVel: CGFloat = 1
            vel = CGVector(dx: CGFloat.random(in: minVel...maxVel), dy: CGFloat.random(in: minVel...maxVel))
            pos = headPos
        }
    }
    
    func show(opacity: Double = 1) {
        fill(1, alpha: opacity)
        point(pos.dx, pos.dy)
    }
    
    mutating func update() {
        vel += acc
        pos += vel
        acc += gravity
    }
}

class Framework {
    var head = Particle()
    var particles = [Particle]()
    var hasExploded = false
    var opacity: Double = 1
    
    func show() {
        fill(1)
        if !hasExploded {
            point(head.pos.dx, head.pos.dy)
        }
        for index in particles.indices {
            particles[index].show(opacity: opacity)
        }
    }
    
    func update() {
        head.update()
        for index in particles.indices {
            particles[index].update()
        }
        if hasExploded && opacity > 0 {
            opacity -= 0.010
        }
    }
    
    func explode() {
        hasExploded = true
        for _ in 0...60 {
            particles.append(
                Particle(
                    partOfExplosion: true,
                    headPos: head.pos
                )
            )
        }
    }
}

var frameworks = [Framework]()

Sketch.create(
    setup: {
        createCanvas(500, 500)
    },
    draw: {
        background(0.2)
        let alpha = Double.random(in: 0...1)
        
        if alpha <= 0.005 {
            frameworks.append(Framework())
        }
        for framework in frameworks {
            if framework.head.vel.dy >= 0.01 && !framework.hasExploded {
                framework.explode()
            }
            framework.show()
            framework.update()
        }
        
        frameworks.removeAll(where: { $0.opacity <= 0 })
    }
)
