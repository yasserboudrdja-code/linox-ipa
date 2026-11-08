import UIKit
class SliderCheatCell: UITableViewCell {
    var onValueChange: ((Float)->Void)?
    private let card: UIView = { let v=UIView(); v.backgroundColor=UIColor(hex:"#12121A"); v.layer.cornerRadius=14; v.layer.borderWidth=1; v.layer.borderColor=UIColor.white.withAlphaComponent(0.07).cgColor; v.translatesAutoresizingMaskIntoConstraints=false; return v }()
    private let bar: UIView = { let v=UIView(); v.backgroundColor=UIColor(hex:"#FF6B00"); v.layer.cornerRadius=2; v.translatesAutoresizingMaskIntoConstraints=false; return v }()
    private let name: UILabel = { let l=UILabel(); l.font=UIFont(name:"AvenirNext-DemiBold",size:15) ?? .boldSystemFont(ofSize:15); l.textColor = .white; l.translatesAutoresizingMaskIntoConstraints=false; return l }()
    private let val: UILabel = { let l=UILabel(); l.font=UIFont(name:"Courier-Bold",size:13) ?? .monospacedSystemFont(ofSize:13,weight:.bold); l.textColor=UIColor(hex:"#FF6B00"); l.translatesAutoresizingMaskIntoConstraints=false; return l }()
    private let slider: UISlider = { let s=UISlider(); s.minimumTrackTintColor=UIColor(hex:"#FF6B00"); s.maximumTrackTintColor=UIColor.white.withAlphaComponent(0.1); s.thumbTintColor = .white; s.translatesAutoresizingMaskIntoConstraints=false; return s }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style:style,reuseIdentifier:reuseIdentifier); backgroundColor = .clear; selectionStyle = .none
        contentView.addSubview(card); [bar,name,val,slider].forEach { card.addSubview($0) }
        NSLayoutConstraint.activate([
            card.topAnchor.constraint(equalTo:contentView.topAnchor,constant:4),
            card.bottomAnchor.constraint(equalTo:contentView.bottomAnchor,constant:-4),
            card.leadingAnchor.constraint(equalTo:contentView.leadingAnchor),
            card.trailingAnchor.constraint(equalTo:contentView.trailingAnchor),
            bar.leadingAnchor.constraint(equalTo:card.leadingAnchor,constant:14),
            bar.topAnchor.constraint(equalTo:card.topAnchor,constant:14),
            bar.widthAnchor.constraint(equalToConstant:3), bar.heightAnchor.constraint(equalToConstant:20),
            name.leadingAnchor.constraint(equalTo:bar.trailingAnchor,constant:12),
            name.centerYAnchor.constraint(equalTo:bar.centerYAnchor),
            val.trailingAnchor.constraint(equalTo:card.trailingAnchor,constant:-16),
            val.centerYAnchor.constraint(equalTo:name.centerYAnchor),
            slider.topAnchor.constraint(equalTo:name.bottomAnchor,constant:10),
            slider.leadingAnchor.constraint(equalTo:card.leadingAnchor,constant:16),
            slider.trailingAnchor.constraint(equalTo:card.trailingAnchor,constant:-16),
            slider.bottomAnchor.constraint(equalTo:card.bottomAnchor,constant:-14),
        ])
        slider.addTarget(self,action:#selector(changed),for:.valueChanged)
    }
    required init?(coder: NSCoder) { fatalError() }
    func configure(with item: CheatItem) {
        name.text=item.name
        if case .slider(let mn,let mx,let def) = item.type {
            slider.minimumValue=mn; slider.maximumValue=mx
            slider.value = item.sliderValue==0 ? def : item.sliderValue
        }
        updVal()
    }
    @objc private func changed() { updVal(); HapticManager.selection(); onValueChange?(slider.value) }
    private func updVal() { val.text = slider.value>=10 ? String(format:"%.0f",slider.value) : String(format:"%.1f",slider.value) }
}
