import UIKit
class ToggleCheatCell: UITableViewCell {
    var onToggle: ((Bool)->Void)?
    private let card: UIView = { let v=UIView(); v.backgroundColor=UIColor(hex:"#12121A"); v.layer.cornerRadius=14; v.layer.borderWidth=1; v.layer.borderColor=UIColor.white.withAlphaComponent(0.07).cgColor; v.translatesAutoresizingMaskIntoConstraints=false; return v }()
    private let bar: UIView = { let v=UIView(); v.backgroundColor=UIColor.white.withAlphaComponent(0.2); v.layer.cornerRadius=2; v.translatesAutoresizingMaskIntoConstraints=false; return v }()
    private let name: UILabel = { let l=UILabel(); l.font=UIFont(name:"AvenirNext-DemiBold",size:15) ?? .boldSystemFont(ofSize:15); l.textColor = .white; l.translatesAutoresizingMaskIntoConstraints=false; return l }()
    private let sub: UILabel = { let l=UILabel(); l.font = .systemFont(ofSize:11); l.textColor=UIColor.white.withAlphaComponent(0.35); l.translatesAutoresizingMaskIntoConstraints=false; return l }()
    private let tog: UISwitch = { let s=UISwitch(); s.onTintColor=UIColor(hex:"#FF6B00"); s.translatesAutoresizingMaskIntoConstraints=false; return s }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style:style,reuseIdentifier:reuseIdentifier); backgroundColor = .clear; selectionStyle = .none
        contentView.addSubview(card); [bar,name,sub,tog].forEach { card.addSubview($0) }
        NSLayoutConstraint.activate([
            card.topAnchor.constraint(equalTo:contentView.topAnchor,constant:4),
            card.bottomAnchor.constraint(equalTo:contentView.bottomAnchor,constant:-4),
            card.leadingAnchor.constraint(equalTo:contentView.leadingAnchor),
            card.trailingAnchor.constraint(equalTo:contentView.trailingAnchor),
            bar.leadingAnchor.constraint(equalTo:card.leadingAnchor,constant:14),
            bar.centerYAnchor.constraint(equalTo:card.centerYAnchor),
            bar.widthAnchor.constraint(equalToConstant:3), bar.heightAnchor.constraint(equalToConstant:28),
            name.leadingAnchor.constraint(equalTo:bar.trailingAnchor,constant:12),
            name.topAnchor.constraint(equalTo:card.topAnchor,constant:14),
            name.trailingAnchor.constraint(equalTo:tog.leadingAnchor,constant:-8),
            sub.leadingAnchor.constraint(equalTo:name.leadingAnchor),
            sub.topAnchor.constraint(equalTo:name.bottomAnchor,constant:3),
            tog.trailingAnchor.constraint(equalTo:card.trailingAnchor,constant:-16),
            tog.centerYAnchor.constraint(equalTo:card.centerYAnchor),
        ])
        tog.addTarget(self,action:#selector(toggled),for:.valueChanged)
    }
    required init?(coder: NSCoder) { fatalError() }
    func configure(with item: CheatItem) {
        name.text=item.name; sub.text=item.subtitle; tog.isOn=item.isEnabled; upd(item.isEnabled)
    }
    private func upd(_ on: Bool) {
        UIView.animate(withDuration:0.25){
            self.bar.backgroundColor = on ? UIColor(hex:"#FF6B00") : UIColor.white.withAlphaComponent(0.2)
            self.card.layer.borderColor = on ? UIColor(hex:"#FF6B00").withAlphaComponent(0.3).cgColor : UIColor.white.withAlphaComponent(0.07).cgColor
        }
    }
    @objc private func toggled() { upd(tog.isOn); HapticManager.light(); onToggle?(tog.isOn) }
}
