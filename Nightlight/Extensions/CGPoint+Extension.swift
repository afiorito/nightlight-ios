import QuartzCore

extension CGPoint {
    public var vector: CGVector {
        return CGVector(dx: x, dy: y)
    }
    
    static public func + (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
}
