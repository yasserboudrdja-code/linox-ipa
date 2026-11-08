import UIKit
class CategoryBarView: UIView {
    var onSelect: ((Int)->Void)?
    private var buttons: [UIButton] = []
    private var sel = 0
    private let sv: UIScrollView = { let s=UIScrollView(); s.showsHorizontalScrollIndicator=false; s.translatesAutoresizingMaskIntoConstraints=false; return s }()
    private let stack: UIStackView = { let s=UIStackView(); s.axis = .horizontal; s.spacing=8; s.alignment = .center; s.translatesAutoresizingMaskIntoConstraints=false; return s }()
    override init(frame: CGRect) {
        super.init(frame:frame); backgroundColor = .clear; addSubview(sv); sv.addSubview(stack)
        NSLayoutConstraint.activate([
            sv.topAnchor.constraint(equalTo:topAnchor), sv.bottomAnchor.constraint(equalTo:bottomAnchor),
            sv.leadingAnchor.constraint(equalTo:leadingAnchor,constant:12), sv.trailingAnchor.constraint(equalTo:trailingAnchor),
            stack.topAnchor.constraint(equalTo:sv.topAnchor), stack.bottomAnchor.constraint(equalTo:sv.bottomAnchor),
            stack.leadingAnchor.constraint(equalTo:sv.leadingAnchor), stack.trailingAnchor.constraint(equalTo:sv.trailingAnchor),
            stack.heightAnchor.constraint(equalTo:sv.heightAnchor),
        ])
    }
    required init?(coder: NSCoder) { fatalError() }
    func configure(categories: [String]) {
        buttons.forEach { $0.removeFromSuperview() }; buttons.removeAll()
        categories.enumerated().forEach { idx,title in
            let b=UIButton(type:.custom); b.setTitle(title,for:.normal)
            b.titleLabel?.font=UIFont(name:"AvenirNext-DemiBold",size:12) ?? .boldSystemFont(ofSize:12)
            b.contentEdgeInsets=UIEdgeInsets(top:6,left:14,bottom:6,right:14)
            b.layer.cornerRadius=10; b.tag=idx
            b.addTarget(self,action:#selector(tap(_:)),for:.touchUpInside)
            upd(b, sel:idx==0); stack.addArrangedSubview(b); buttons.append(b)
        }
    }
    private func upd(_ b: UIButton, sel: Bool) {
        UIView.animate(withDuration:0.2){
            b.backgroundColor = sel ? UIColor(hex:"#FF6B00") : UIColor(hex:"#1C1C28")
            b.setTitleColor(sel ? .white : UIColor.white.withAlphaComponent(0.5), for:.normal)
        }
    }
    @objc private func tap(_ s: UIButton) {
        guard s.tag != sel else { return }
        buttons.forEach { upd($0, sel:$0.tag==s.tag) }; sel=s.tag; onSelect?(s.tag); HapticManager.light()
    }
}
