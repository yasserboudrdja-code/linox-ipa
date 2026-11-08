import UIKit
class TimerCheatCell: UITableViewCell {
    var onToggle: ((Bool)->Void)?
    var onTimerChange: ((Double)->Void)?
    private let card: UIView = { let v=UIView(); v.backgroundColor=UIColor(hex:"#12121A"); v.layer.cornerRadius=14; v.layer.borderWidth=1; v.layer.borderColor=UIColor.white.withAlphaComponent(0.07).cgColor; v.translatesAutoresizingMaskIntoConstraints=false; return v }()
    private let bar: UIView = { let v=UIView(); v.backgroundColor=UIColor.white.withAlphaComponent(0.2); v.layer.cornerRadius=2; v.translatesAutoresizingMaskIntoConstraints=false; return v }()
    private let name: UILabel = { let l=UILabel(); l.font=UIFont(name:"AvenirNext-DemiBold",size:15) ?? .boldSystemFont(ofSize:15); l.textColor = .white; l.translatesAutoresizingMaskIntoConstraints=false; return l }()
    private let sub: UILabel = { let l=UILabel(); l.font = .systemFont(ofSize:11); l.textColor=UIColor.white.withAlphaComponent(0.35); l.translatesAutoresizingMaskIntoConstraints=false; return l }()
    private let tog: UISwitch = { let s=UISwitch(); s.onTintColor=UIColor(hex:"#FF6B00"); s.translatesAutoresizingMaskIntoConstraints=false; return s }()
    private let timLbl: UILabel = { let l=UILabel(); l.font = .systemFont(ofSize:11,weight:.medium); l.textColor=UIColor.white.withAlphaComponent(0.5); l.text="Kill Delay:"; l.translatesAutoresizingMaskIntoConstraints=false; return l }()
    private let timVal: UILabel = { let l=UILabel(); l.font=UIFont(name:"Courier-Bold",size:12) ?? .monospacedSystemFont(ofSize:12,weight:.bold); l.textColor=UIColor(hex:"#FF6B00"); l.translatesAutoresizingMaskIntoConstraints=false; return l }()
    private let timSlider: UISlider = { let s=UISlider(); s.minimumValue=0.1; s.maximumValue=10; s.value=1; s.minimumTrackTintColor=UIColor(hex:"#FF6B00"); s.maximumTrackTintColor=UIColor.white.withAlphaComponent(0.1); s.thumbTintColor = .white; s.translatesAutoresizingMaskIntoConstraints=false; return s }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style:style,reuseIdentifier:reuseIdentifier); backgroundColor = .clear; selectionStyle = .none
        contentView.addSubview(card); [bar,name,sub,tog,timLbl,timVal,timSlider].forEach { card.addSubview($0) }
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
            name.trailingAnchor.constraint(equalTo:tog.leadingAnchor,constant:-8),
            sub.leadingAnchor.constraint(equalTo:name.leadingAnchor),
            sub.topAnchor.constraint(equalTo:name.bottomAnchor,constant:3),
            tog.trailingAnchor.constraint(equalTo:card.trailingAnchor,constant:-16),
            tog.topAnchor.constraint(equalTo:card.topAnchor,constant:16),
            timLbl.leadingAnchor.constraint(equalTo:card.leadingAnchor,constant:16),
            timLbl.bottomAnchor.constraint(equalTo:card.bottomAnchor,constant:-18),
            timVal.leadingAnchor.constraint(equalTo:timLbl.trailingAnchor,constant:6),
            timVal.centerYAnchor.constraint(equalTo:timLbl.centerYAnchor),
            timSlider.leadingAnchor.constraint(equalTo:timVal.trailingAnchor,constant:10),
            timSlider.trailingAnchor.constraint(equalTo:card.trailingAnchor,constant:-16),
            timSlider.centerYAnchor.constraint(equalTo:timLbl.centerYAnchor),
        ])
        timSlider.addTarget(self,action:#selector(timerCh),for:.valueChanged)
        tog.addTarget(self,action:#selector(toggled),for:.valueChanged)
        updTimer()
    }
    required init?(coder: NSCoder) { fatalError() }
    func configure(with item: CheatItem) {
        name.text=item.name; sub.text=item.subtitle; tog.isOn=item.isEnabled
        timSlider.value=Float(item.timerValue); updStyle(item.isEnabled); updTimer()
    }
    private func updStyle(_ on: Bool) {
        UIView.animate(withDuration:0.25){
            self.bar.backgroundColor = on ? UIColor(hex:"#FF6B00") : UIColor.white.withAlphaComponent(0.2)
            self.card.layer.borderColor = on ? UIColor(hex:"#FF6B00").withAlphaComponent(0.3).cgColor : UIColor.white.withAlphaComponent(0.07).cgColor
        }
    }
    @objc private func timerCh() { updTimer(); HapticManager.selection(); onTimerChange?(Double(timSlider.value)) }
    @objc private func toggled() { updStyle(tog.isOn); HapticManager.light(); onToggle?(tog.isOn) }
    private func updTimer() { timVal.text=String(format:"%.1fs",timSlider.value) }
}
