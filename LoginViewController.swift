import UIKit
class LoginViewController: UIViewController {
    private let TRIAL_KEY = "LinoxXios"
    private let particle = ParticleBackgroundView()
    private let box: UIView = { let v=UIView(); v.backgroundColor=UIColor(hex:"#12121A"); v.layer.cornerRadius=28; v.layer.borderWidth=1; v.layer.borderColor=UIColor(hex:"#FF6B00").withAlphaComponent(0.2).cgColor; v.translatesAutoresizingMaskIntoConstraints=false; return v }()
    private let logo: UILabel = { let l=UILabel(); l.text="🦅"; l.font = .systemFont(ofSize:52); l.textAlignment = .center; l.translatesAutoresizingMaskIntoConstraints=false; return l }()
    private let ttl: UILabel = { let l=UILabel(); l.text="LINOX"; l.font=UIFont(name:"AvenirNext-Heavy",size:34) ?? .boldSystemFont(ofSize:34); l.textColor = .white; l.textAlignment = .center; l.translatesAutoresizingMaskIntoConstraints=false; return l }()
    private let sub: UILabel = { let l=UILabel(); l.text="ENTER YOUR ACCESS KEY"; l.font = .systemFont(ofSize:11,weight:.semibold); l.textColor=UIColor.white.withAlphaComponent(0.35); l.textAlignment = .center; l.translatesAutoresizingMaskIntoConstraints=false; return l }()
    private let tf: UITextField = {
        let t=UITextField()
        t.attributedPlaceholder=NSAttributedString(string:"XXXX-XXXX-XXXX",attributes:[.foregroundColor:UIColor.white.withAlphaComponent(0.2)])
        t.textColor = .white; t.tintColor=UIColor(hex:"#FF6B00"); t.backgroundColor=UIColor(hex:"#1A1A24")
        t.layer.cornerRadius=14; t.layer.borderWidth=1; t.layer.borderColor=UIColor.white.withAlphaComponent(0.08).cgColor
        t.textAlignment = .center; t.font=UIFont(name:"Courier-Bold",size:17) ?? .monospacedSystemFont(ofSize:17,weight:.bold)
        t.autocapitalizationType = .allCharacters; t.autocorrectionType = .no
        t.keyboardType = .asciiCapable; t.returnKeyType = .go
        t.leftView=UIView(frame:CGRect(x:0,y:0,width:16,height:0)); t.leftViewMode = .always
        t.rightView=UIView(frame:CGRect(x:0,y:0,width:16,height:0)); t.rightViewMode = .always
        t.translatesAutoresizingMaskIntoConstraints=false; return t }()
    private let btn = GlowButton()
    private let status: UILabel = { let l=UILabel(); l.text=""; l.font = .systemFont(ofSize:12,weight:.medium); l.textColor=UIColor(hex:"#FF6B00"); l.textAlignment = .center; l.alpha=0; l.translatesAutoresizingMaskIntoConstraints=false; return l }()
    private let spinner: UIActivityIndicatorView = { let a=UIActivityIndicatorView(style:.medium); a.color=UIColor(hex:"#FF6B00"); a.hidesWhenStopped=true; a.translatesAutoresizingMaskIntoConstraints=false; return a }()
    override func viewDidLoad() { super.viewDidLoad(); setup(); checkSaved() }
    private func setup() {
        view.backgroundColor=UIColor(hex:"#0A0A0F")
        particle.frame=view.bounds; particle.autoresizingMask=[.flexibleWidth,.flexibleHeight]; view.addSubview(particle)
        btn.setTitle("ACTIVATE",for:.normal); view.addSubview(box)
        [logo,ttl,sub,tf,btn,status,spinner].forEach { box.addSubview($0) }
        NSLayoutConstraint.activate([
            box.centerXAnchor.constraint(equalTo:view.centerXAnchor),
            box.centerYAnchor.constraint(equalTo:view.centerYAnchor,constant:-20),
            box.leadingAnchor.constraint(equalTo:view.leadingAnchor,constant:24),
            box.trailingAnchor.constraint(equalTo:view.trailingAnchor,constant:-24),
            logo.topAnchor.constraint(equalTo:box.topAnchor,constant:36), logo.centerXAnchor.constraint(equalTo:box.centerXAnchor),
            ttl.topAnchor.constraint(equalTo:logo.bottomAnchor,constant:12), ttl.centerXAnchor.constraint(equalTo:box.centerXAnchor),
            sub.topAnchor.constraint(equalTo:ttl.bottomAnchor,constant:8), sub.centerXAnchor.constraint(equalTo:box.centerXAnchor),
            tf.topAnchor.constraint(equalTo:sub.bottomAnchor,constant:32),
            tf.leadingAnchor.constraint(equalTo:box.leadingAnchor,constant:20),
            tf.trailingAnchor.constraint(equalTo:box.trailingAnchor,constant:-20),
            tf.heightAnchor.constraint(equalToConstant:56),
            btn.topAnchor.constraint(equalTo:tf.bottomAnchor,constant:14),
            btn.leadingAnchor.constraint(equalTo:box.leadingAnchor,constant:20),
            btn.trailingAnchor.constraint(equalTo:box.trailingAnchor,constant:-20),
            btn.heightAnchor.constraint(equalToConstant:56),
            status.topAnchor.constraint(equalTo:btn.bottomAnchor,constant:14),
            status.centerXAnchor.constraint(equalTo:box.centerXAnchor),
            status.bottomAnchor.constraint(equalTo:box.bottomAnchor,constant:-28),
            spinner.centerXAnchor.constraint(equalTo:btn.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo:btn.centerYAnchor),
        ])
        btn.addTarget(self,action:#selector(activate),for:.touchUpInside)
        tf.delegate=self
        view.addGestureRecognizer(UITapGestureRecognizer(target:self,action:#selector(dismiss_kb)))
    }
    private func checkSaved() {
        if let s=UserDefaults.standard.string(forKey:"linox_key"), s.uppercased()==TRIAL_KEY.uppercased() { go() }
    }
    @objc private func activate() {
        guard let k=tf.text?.trimmingCharacters(in:.whitespacesAndNewlines), !k.isEmpty else {
            showStatus("⚠️ أدخل الـ key","#FF8C00"); shake(); return
        }
        setLoad(true)
        DispatchQueue.main.asyncAfter(deadline:.now()+1.4){ self.validate(k) }
    }
    private func validate(_ k: String) {
        if k.uppercased()==TRIAL_KEY.uppercased() {
            UserDefaults.standard.set(k,forKey:"linox_key"); setLoad(false)
            showStatus("✅ تم التحقق بنجاح","#00C853"); HapticManager.success()
            DispatchQueue.main.asyncAfter(deadline:.now()+0.9){ self.go() }
        } else {
            setLoad(false); showStatus("❌ Key غير صحيح","#FF4444"); HapticManager.error(); shake()
            UIView.animate(withDuration:0.1){self.tf.layer.borderColor=UIColor(hex:"#FF4444").cgColor} completion:{ _ in
                UIView.animate(withDuration:0.6,delay:1.2){self.tf.layer.borderColor=UIColor.white.withAlphaComponent(0.08).cgColor}
            }
        }
    }
    private func setLoad(_ on: Bool) {
        btn.setTitle(on ? "" : "ACTIVATE",for:.normal); btn.isEnabled = !on; tf.isEnabled = !on
        on ? spinner.startAnimating() : spinner.stopAnimating()
    }
    private func showStatus(_ t: String,_ c: String) {
        status.text=t; status.textColor=UIColor(hex:c)
        UIView.animate(withDuration:0.3){self.status.alpha=1}
    }
    private func shake() {
        let a=CAKeyframeAnimation(keyPath:"transform.translation.x")
        a.timingFunction=CAMediaTimingFunction(name:.linear); a.duration=0.4; a.values=[-10,10,-8,8,-5,5,0]
        tf.layer.add(a,forKey:"shake")
    }
    @objc private func dismiss_kb() { view.endEditing(true) }
    private func go() {
        let vc=MainViewController(); vc.modalTransitionStyle = .crossDissolve; vc.modalPresentationStyle = .fullScreen
        present(vc,animated:true)
    }
}
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ t: UITextField) -> Bool { activate(); return true }
}
