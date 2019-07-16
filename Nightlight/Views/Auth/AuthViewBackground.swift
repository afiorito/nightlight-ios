import UIKit

public class AuthViewBackground: UIView {

    public enum ShapeType {
        case signIn, signUp
    }
    
    public var shapeType: ShapeType = .signIn {
        didSet {
            setNeedsDisplay()
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func draw(_ rect: CGRect) {
        let size = self.bounds.size
        
        let topLeft = self.bounds.origin
        let bottomLeft = CGPoint(x: topLeft.x, y: size.height)
        let highPoint = CGPoint(x: size.width, y: size.height * 0.8)
        let topRight = CGPoint(x: size.width, y: topLeft.y)
        
        let path = UIBezierPath()
        path.move(to: topLeft)
        
        switch shapeType {
        case .signIn:
            let offset = size.width * 0.15
            path.addLine(to: bottomLeft)
            path.addCurve(to: highPoint,
                          controlPoint1: CGPoint(x: bottomLeft.x + offset, y: bottomLeft.y - offset),
                          controlPoint2: CGPoint(x: highPoint.x - offset, y: highPoint.y + offset))
        case .signUp:
            let quarterWidth = size.width / 4
            path.addLine(to: CGPoint(x: bottomLeft.x, y: bottomLeft.y * 0.9))
            path.addCurve(to: highPoint,
                          controlPoint1: CGPoint(x: quarterWidth, y: bottomLeft.y),
                          controlPoint2: CGPoint(x: highPoint.x - quarterWidth, y: bottomLeft.y))
        }
        
        path.addLine(to: topRight)
        path.close()
        
        UIColor.brand.set()
        path.fill()
    }
    
}
