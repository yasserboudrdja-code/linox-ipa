import UIKit
enum LoaderStatus { case idle, active, error }
class StatusBadgeView: UIView {
    private let dot: UIView = { let v=UIView(); v.backgroundColor=UIColor.white.withAlphaComponent(0.3); v.layer.cornerRadius=4; v.translatesAutoresizingMaskIntoConstraints=false; return v }()
    private let lbl: UILabel = { let l=UILabel(); l.text="IDLE"; l.font = .systemFont(ofSize:10,weight:.bold); l.textColor=UIColor.white.withAlphaComponent(0.4); l.translatesAutoresizingMaskIntoConstraints=false; return l }()
    override init(frame: CGRect) {
        super.init(frame:frame); backgroundColor=UIColor(hex:"#1C1C28"); layer.cornerRadius=10
        layer.borderWidth=1; layer.borderColor=UIColor.white.withAlphaComponent(0.07).cgColor
        addSubview(dot); addSubview(lbl)
        NSLayoutConstraint.activate([
            dot.leadingAnchor.constraint(equalTo:leadingAnchor,constant:8),
            dot.centerYAnchor.constraint(equalTo:centerYAnchor),
            dot.widthAnchor.constraint(equalToConstant:8), dot.heightAnchor.constraint(equalToConstant:8),
            lbl.leadingAnchor.constraint(equalTo:dot.trailingAnchor,constant:5),
            lbl.trailingAnchor.constraint(equalTo:trailingAnchor,constant:-8),
            lbl.centerYAnchor.constraint(equalTo:centerYAnchor),
            heightAnchor.constraint(equalToConstant:24),
        ])
    }
    required init?(coder: NSCoder) { fatalError() }
    func setStatus(_ s: LoaderStatus) {
        switch s {
        case .idle:  dot.layer.removeAllAnimations(); dot.backgroundColor=UIColor.white.withAlphaComponent(0.3); lbl.textColor=UIColor.white.withAlphaComponent(0.4); lbl.text="IDLE"
        case .active: dot.backgroundColor=UIColor(hex:"#00C853"); lbl.textColor=UIColor(hex:"#00C853"); lbl.text="ACTIVE"
            UIView.animate(withDuration:0.8,delay:0,options:[.repeat,.autoreverse,.allowUserInteraction]){self.dot.alpha=0.2}
        case .error: dot.layer.removeAllAnimations(); dot.backgroundColor=UIColor(hex:"#FF4444"); lbl.textColor=UIColor(hex:"#FF4444"); lbl.text="ERROR"
        }
    }
}
