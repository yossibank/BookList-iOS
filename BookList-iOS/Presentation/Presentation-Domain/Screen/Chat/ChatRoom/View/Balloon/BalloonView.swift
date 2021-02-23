import UIKit

final class BalloonView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func draw(_ rect: CGRect) {
        let bezierPath = UIBezierPath()
        UIColor.white.setFill()
        UIColor.clear.setStroke()
        bezierPath.move(to: CGPoint(x: 15, y: 10))
        bezierPath.addQuadCurve(to: CGPoint(x: 5, y: 5), controlPoint: CGPoint(x: 5, y: 10))
        bezierPath.addQuadCurve(to: CGPoint(x: 10, y: 20), controlPoint: CGPoint(x: 0, y: 10))
        bezierPath.close()
        bezierPath.fill()
        bezierPath.stroke()
    }
}
