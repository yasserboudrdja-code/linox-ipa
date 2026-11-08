import UIKit
class SplashViewController: UIViewController {
    private let particle = ParticleBackgroundView()
    private let logo: UILabel = { let l=UILabel(); l.text="🦅"; l.font = .systemFont(ofSize:80); l.textAlignment = .center; l.alpha=0; l.translatesAutoresizingMaskIntoConstraints=false; return l }()
    private let title: UILabel = { let l=UILabel(); l.text="LINOX"; l.font=UIFont(name:"AvenirNext-Heavy",size:46) ?? .boldSystemFont(ofSize:46); l.textColor = .white; l.textAlignment = .center; l.alpha=0; l.transform=CGAffineTransform(translationX:0,y:20); l.translatesAutoresizingMaskIntoConstraints=false; return l }()
    private let sub: UILabel = { let l=UILabel(); l.text="FREE FIRE LOADER"; l.font = .systemFont(ofSize:13,weight:.medium); l.textColor=UIColor(hex:"#FF6B00"); l.textAlignment = .center; l.alpha=0; l.transform=CGAffineTransform(translationX:0,y:15); l.translatesAutoresizingMaskIntoConstraints=false; return l }()
    private let barBG: UIView = { let v=UIView(); v.backgroundColor=UIColor(hex:"#FF6B00").withAlphaComponent(0.25); v.layer.cornerRadius=1.5; v.translatesAutoresizingMaskIntoConstraints=false; return v }()
    private let barFill: UIView = { let v=UIView(); v.backgroundColor=UIColor(hex:"#FF6B00"); v.layer.cornerRadius=1.5; v.translatesAutoresizingMaskIntoConstraints=false; return v }()
    private var fillW: NSLayoutConstraint?
    override func viewDidLoad() { super.viewDidLoad(); setup() }
    override func viewDidAppear(_ animated: Bool) { super.viewDidAppear(animated); animate() }
    private func setup() {
        view.backgroundColor=UIColor(hex:"#0A0A0F")
        particle.frame=view.bounds; particle.autoresizingMask=[.flexibleWidth,.flexibleHeight]; view.addSubview(particle)
        barBG.addSubview(barFill)
        [logo,title,sub,barBG].forEach { view.addSubview($0) }
        fillW = barFill.widthAnchor.constraint(equalToConstant:0)
        NSLayoutConstraint.activate([
            logo.centerXAnchor.constraint(equalTo:view.centerXAnchor),
            logo.centerYAnchor.constraint(equalTo:view.centerYAnchor,constant:-70),
            title.topAnchor.constraint(equalTo:logo.bottomAnchor,constant:16),
            title.centerXAnchor.constraint(equalTo:view.centerXAnchor),
            sub.topAnchor.constraint(equalTo:title.bottomAnchor,constant:8),
            sub.centerXAnchor.constraint(equalTo:view.centerXAnchor),
            barBG.topAnchor.constraint(equalTo:sub.bottomAnchor,constant:36),
            barBG.centerXAnchor.constraint(equalTo:view.centerXAnchor),
            barBG.widthAnchor.constraint(equalToConstant:120),
            barBG.heightAnchor.constraint(equalToConstant:3),
            barFill.leadingAnchor.constraint(equalTo:barBG.leadingAnchor),
            barFill.topAnchor.constraint(equalTo:barBG.topAnchor),
            barFill.bottomAnchor.constraint(equalTo:barBG.bottomAnchor),
            fillW!,
        ])
    }
    private func animate() {
        UIView.animate(withDuration:0.7,delay:0.2,options:.curveEaseOut){self.logo.alpha=1}
        UIView.animate(withDuration:0.7,delay:0.5,usingSpringWithDamping:0.8,initialSpringVelocity:0.5,options:[]){self.title.alpha=1;self.title.transform = .identity}
        UIView.animate(withDuration:0.7,delay:0.7,usingSpringWithDamping:0.8,initialSpringVelocity:0.5,options:[]){self.sub.alpha=1;self.sub.transform = .identity}
        DispatchQueue.main.asyncAfter(deadline:.now()+1.0){
            self.fillW?.constant=120
            UIView.animate(withDuration:1.2,delay:0,options:.curveEaseInOut){self.barBG.layoutIfNeeded()} completion:{ _ in
                DispatchQueue.main.asyncAfter(deadline:.now()+0.3){
                    let vc=LoginViewController(); vc.modalTransitionStyle = .crossDissolve; vc.modalPresentationStyle = .fullScreen
                    self.present(vc,animated:true)
                }
            }
        }
    }
}
