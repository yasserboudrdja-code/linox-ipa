import UIKit
class SegmentedCheatCell: UITableViewCell {
    var onSegmentChange: ((Int)->Void)?
    private let card: UIView = { let v=UIView(); v.backgroundColor=UIColor(hex:"#12121A"); v.layer.cornerRadius=14; v.layer.borderWidth=1; v.layer.borderColor=UIColor.white.withAlphaComponent(0.07).cgColor; v.translatesAutoresizingMaskIntoConstraints=false; return v }()
    private let bar: UIView = { let v=UIView(); v.backgroundColor=UIColor(hex:"#FF6B00"); v.layer.cornerRadius=2; v.translatesAutoresizingMaskIntoConstraints=false; return v }()
    private let name: UILabel = { let l=UILabel(); l.font=UIFont(name:"AvenirNext-DemiBold",size:15) ?? .boldSystemFont(ofSize:15); l.textColor = .white; l.translatesAutoresizingMaskIntoConstraints=false; return l }()
    private let seg: UISegmentedControl = { let s=UISegmentedControl(); s.selectedSegmentTintColor=UIColor(hex:"#FF6B00"); s.setTitleTextAttributes([.foregroundColor:UIColor.white],for:.selected); s.setTitleTextAttributes([.foregroundColor:UIColor.white.withAlphaComponent(0.5)],for:.normal); s.backgroundColor=UIColor(hex:"#1C1C28"); s.translatesAutoresizingMaskIntoConstraints=false; return s }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style:style,reuseIdentifier:reuseIdentifier); backgroundColor = .clear; selectionStyle = .none
        contentView.addSubview(card); [bar,name,seg].forEach { card.addSubview($0) }
        NSLayoutConstraint.activate([
            card.topAnchor.constraint(equalTo:contentView.topAnchor,constant:4),
            card.bottomAnchor.constraint(equalTo:contentView.bottomAnchor,constant:-4),
            card.leadingAnchor.constraint(equalTo:contentView.leadingAnchor),
            card.trailingAnchor.constraint(equalTo:contentView.trailingAnchor),
            bar.leadingAnchor.constraint(equalTo:card.leadingAnchor,constant:14),
            bar.centerYAnchor.constraint(equalTo:card.centerYAnchor),
            bar.widthAnchor.constraint(equalToConstant:3), bar.heightAnchor.constraint(equalToConstant:28),
            name.leadingAnchor.constraint(equalTo:bar.trailingAnchor,constant:12),
            name.centerYAnchor.constraint(equalTo:card.centerYAnchor),
            seg.trailingAnchor.constraint(equalTo:card.trailingAnchor,constant:-16),
            seg.centerYAnchor.constraint(equalTo:card.centerYAnchor),
            seg.widthAnchor.constraint(equalToConstant:170),
        ])
        seg.addTarget(self,action:#selector(changed),for:.valueChanged)
    }
    required init?(coder: NSCoder) { fatalError() }
    func configure(with item: CheatItem) {
        name.text=item.name
        if case .segmented(let opts) = item.type {
            seg.removeAllSegments()
            opts.enumerated().forEach { seg.insertSegment(withTitle:$1,at:$0,animated:false) }
            seg.selectedSegmentIndex=item.segmentIndex
        }
    }
    @objc private func changed() { HapticManager.selection(); onSegmentChange?(seg.selectedSegmentIndex) }
}
