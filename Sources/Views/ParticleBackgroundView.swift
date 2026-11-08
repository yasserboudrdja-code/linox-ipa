import UIKit
class ParticleBackgroundView: UIView {
    private var particles: [CAShapeLayer] = []
    override func didMoveToWindow() {
        super.didMoveToWindow()
        guard window != nil, particles.isEmpty else { return }
        let w = UIScreen.main.bounds.width, h = UIScreen.main.bounds.height
        (0..<25).forEach { _ in
            let p = CAShapeLayer()
            let size = CGFloat.random(in: 1.5...4)
            p.path = UIBezierPath(ovalIn: CGRect(x:0,y:0,width:size,height:size)).cgPath
            p.fillColor = UIColor(hex:"#FF6B00").withAlphaComponent(CGFloat.random(in:0.08...0.35)).cgColor
            p.position = CGPoint(x:CGFloat.random(in:0...w), y:CGFloat.random(in:0...h))
            layer.addSublayer(p); particles.append(p)
            let pa = CABasicAnimation(keyPath:"position.y")
            pa.fromValue = p.position.y; pa.toValue = p.position.y - CGFloat.random(in:60...220)
            pa.duration = Double.random(in:4...10); pa.repeatCount = .infinity; pa.autoreverses = true
            pa.beginTime = CACurrentMediaTime() + Double.random(in:0...3)
            p.add(pa, forKey:"float")
            let fa = CABasicAnimation(keyPath:"opacity")
            fa.fromValue = 0.05; fa.toValue = 0.5
            fa.duration = Double.random(in:2...6); fa.repeatCount = .infinity; fa.autoreverses = true
            fa.beginTime = CACurrentMediaTime() + Double.random(in:0...2)
            p.add(fa, forKey:"fade")
        }
    }
}
