import UIKit
class LoaderHeaderView: UIView {
    private let logo: UILabel = { let l=UILabel(); l.text="🦅"; l.font = .systemFont(ofSize:28); l.translatesAutoresizingMaskIntoConstraints=false; return l }()
    private let title: UILabel = { let l=UILabel(); l.text="LINOX"; l.font=UIFont(name:"AvenirNext-Heavy",size:22) ?? .boldSystemFont(ofSize:22); l.textColor = .white; l.translatesAutoresizingMaskIntoConstraints=false; return l }()
    private let subtitle: UILabel = { let l=UILabel(); l.text="FREE FIRE LOADER"; l.font = .systemFont(ofSize:10,weight:.medium); l.textColor=UIColor(hex:"#FF6B00"); l.translatesAutoresizingMaskIntoConstraints=false; return l }()
    private let divider: UIView = { let v=UIView(); v.backgroundColor=UIColor.white.withAlphaComponent(0.07); v.translatesAutoresizingMaskIntoConstraints=false; return v }()
    override init(frame: CGRect) {
        super.init(frame:frame); backgroundColor=UIColor(hex:"#0A0A0F")
        [logo,title,subtitle,divider].forEach { addSubview($0) }
        NSLayoutConstraint.activate([
            logo.leadingAnchor.constraint(equalTo:leadingAnchor,constant:16),
            logo.centerYAnchor.constraint(equalTo:centerYAnchor),
            title.leadingAnchor.constraint(equalTo:logo.trailingAnchor,constant:10),
            title.topAnchor.constraint(equalTo:centerYAnchor,constant:-18),
            subtitle.leadingAnchor.constraint(equalTo:title.leadingAnchor),
            subtitle.topAnchor.constraint(equalTo:title.bottomAnchor,constant:2),
            divider.bottomAnchor.constraint(equalTo:bottomAnchor),
            divider.leadingAnchor.constraint(equalTo:leadingAnchor),
            divider.trailingAnchor.constraint(equalTo:trailingAnchor),
            divider.heightAnchor.constraint(equalToConstant:1),
        ])
    }
    required init?(coder: NSCoder) { fatalError() }
}
