import UIKit
class GlowButton: UIButton {
    override init(frame: CGRect) { super.init(frame:frame); setup() }
    required init?(coder: NSCoder) { fatalError() }
    private func setup() {
        backgroundColor=UIColor(hex:"#FF6B00"); setTitleColor(.white,for:.normal)
        titleLabel?.font=UIFont(name:"AvenirNext-Heavy",size:15) ?? .boldSystemFont(ofSize:15)
        layer.cornerRadius=16; layer.shadowColor=UIColor(hex:"#FF6B00").cgColor
        layer.shadowOffset = .zero; layer.shadowRadius=14; layer.shadowOpacity=0.55
        addTarget(self,action:#selector(pressed),for:.touchDown)
        addTarget(self,action:#selector(released),for:[.touchUpInside,.touchUpOutside,.touchCancel])
    }
    @objc private func pressed() { UIView.animate(withDuration:0.1){self.transform=CGAffineTransform(scaleX:0.97,y:0.97);self.layer.shadowOpacity=0.9} }
    @objc private func released() { UIView.animate(withDuration:0.3,delay:0,usingSpringWithDamping:0.5,initialSpringVelocity:0.5){self.transform = .identity;self.layer.shadowOpacity=0.55} }
}
