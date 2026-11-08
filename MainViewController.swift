import UIKit
class MainViewController: UIViewController {
    private let cats = ["ESP","AIMBOT","MOVEMENT","WEAPON","MISC"]
    private var cur = 0
    private var data: [String:[CheatItem]] = [:]
    private var injected = false
    private let particle = ParticleBackgroundView()
    private let header = LoaderHeaderView()
    private let catBar = CategoryBarView()
    private let table = UITableView()
    private let injectBtn = GlowButton()
    private let badge = StatusBadgeView()
    override func viewDidLoad() { super.viewDidLoad(); buildData(); buildUI(); buildActions() }
    private func buildData() {
        data = [
            "ESP":[
                CheatItem(name:"Player ESP",subtitle:"Box / Skeleton / Distance / Health",type:.toggle),
                CheatItem(name:"Item ESP",subtitle:"Weapons / Ammo / Med Kits",type:.toggle),
                CheatItem(name:"Radar Hack",subtitle:"Enemy positions on minimap",type:.toggle),
            ],
            "AIMBOT":[
                CheatItem(name:"Auto Aim",subtitle:"Lock on nearest visible enemy",type:.toggle),
                CheatItem(name:"Silent Aim",subtitle:"No screen movement required",type:.toggle),
                CheatItem(name:"Aimkill",subtitle:"Auto kill visible enemies",type:.toggleWithTimer,timerValue:1.0),
                CheatItem(name:"Aim Smoothing",subtitle:"Natural aim movement",type:.slider(min:0,max:100,defaultVal:50)),
                CheatItem(name:"FOV Circle",subtitle:"Aim radius -- drag to resize",type:.slider(min:10,max:360,defaultVal:90)),
                CheatItem(name:"Target Bone",subtitle:"Select aim target bone",type:.segmented(["Head","Chest","Auto"])),
            ],
            "MOVEMENT":[
                CheatItem(name:"Speed Hack",subtitle:"Movement speed multiplier",type:.slider(min:1,max:10,defaultVal:2)),
                CheatItem(name:"High Jump",subtitle:"Enhanced jump height",type:.toggle),
                CheatItem(name:"Fly Mode",subtitle:"Free fly anywhere on map",type:.toggle),
                CheatItem(name:"Teleport",subtitle:"Tap map → instant teleport",type:.toggleWithMap),
                CheatItem(name:"Teleport Mark",subtitle:"Set drop zone from airplane",type:.toggleWithMap),
            ],
            "WEAPON":[
                CheatItem(name:"No Recoil",subtitle:"Zero weapon recoil",type:.toggle),
                CheatItem(name:"No Spread",subtitle:"Perfect bullet accuracy",type:.toggle),
                CheatItem(name:"Rapid Fire",subtitle:"Maximum fire rate",type:.toggle),
                CheatItem(name:"Fast Reload",subtitle:"Instant magazine reload",type:.toggle),
            ],
            "MISC":[
                CheatItem(name:"Anti-Ban",subtitle:"Protection layer active",type:.toggle),
                CheatItem(name:"See Through Walls",subtitle:"Full environment wallhack",type:.toggle),
                CheatItem(name:"PC Mode Badge",subtitle:"Show PC badge to other players",type:.toggle),
            ]
        ]
    }
    private func buildUI() {
        view.backgroundColor=UIColor(hex:"#0A0A0F")
        particle.frame=view.bounds; particle.autoresizingMask=[.flexibleWidth,.flexibleHeight]; view.addSubview(particle)
        header.translatesAutoresizingMaskIntoConstraints=false; view.addSubview(header)
        badge.translatesAutoresizingMaskIntoConstraints=false; view.addSubview(badge)
        catBar.configure(categories:cats)
        catBar.onSelect = { [weak self] idx in
            guard let s=self else { return }
            s.cur=idx; s.table.reloadData()
            s.table.setContentOffset(.zero,animated:true)
        }
        catBar.translatesAutoresizingMaskIntoConstraints=false; view.addSubview(catBar)
        table.backgroundColor = .clear; table.separatorStyle = .none
        table.showsVerticalScrollIndicator=false
        table.contentInset=UIEdgeInsets(top:4,left:0,bottom:4,right:0)
        table.delegate=self; table.dataSource=self
        table.register(ToggleCheatCell.self,forCellReuseIdentifier:"T")
        table.register(SliderCheatCell.self,forCellReuseIdentifier:"S")
        table.register(SegmentedCheatCell.self,forCellReuseIdentifier:"G")
        table.register(TimerCheatCell.self,forCellReuseIdentifier:"K")
        table.translatesAutoresizingMaskIntoConstraints=false; view.addSubview(table)
        injectBtn.setTitle("⚡️  INJECT INTO FREE FIRE",for:.normal)
        injectBtn.translatesAutoresizingMaskIntoConstraints=false; view.addSubview(injectBtn)
        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo:view.safeAreaLayoutGuide.topAnchor),
            header.leadingAnchor.constraint(equalTo:view.leadingAnchor),
            header.trailingAnchor.constraint(equalTo:view.trailingAnchor),
            header.heightAnchor.constraint(equalToConstant:60),
            badge.centerYAnchor.constraint(equalTo:header.centerYAnchor),
            badge.trailingAnchor.constraint(equalTo:view.trailingAnchor,constant:-16),
            catBar.topAnchor.constraint(equalTo:header.bottomAnchor,constant:10),
            catBar.leadingAnchor.constraint(equalTo:view.leadingAnchor),
            catBar.trailingAnchor.constraint(equalTo:view.trailingAnchor,constant:-16),
            catBar.heightAnchor.constraint(equalToConstant:36),
            table.topAnchor.constraint(equalTo:catBar.bottomAnchor,constant:10),
            table.leadingAnchor.constraint(equalTo:view.leadingAnchor,constant:12),
            table.trailingAnchor.constraint(equalTo:view.trailingAnchor,constant:-12),
            table.bottomAnchor.constraint(equalTo:injectBtn.topAnchor,constant:-12),
            injectBtn.leadingAnchor.constraint(equalTo:view.leadingAnchor,constant:16),
            injectBtn.trailingAnchor.constraint(equalTo:view.trailingAnchor,constant:-16),
            injectBtn.bottomAnchor.constraint(equalTo:view.safeAreaLayoutGuide.bottomAnchor,constant:-16),
            injectBtn.heightAnchor.constraint(equalToConstant:56),
        ])
    }
    private func buildActions() { injectBtn.addTarget(self,action:#selector(inject),for:.touchUpInside) }
    @objc private func inject() {
        guard !injected else {
            let a=UIAlertController(title:"✅ Already Active",message:"Cheats already injected.",preferredStyle:.alert)
            a.addAction(UIAlertAction(title:"OK",style:.default)); present(a,animated:true); return
        }
        injectBtn.setTitle("INJECTING...",for:.normal); injectBtn.isEnabled=false; HapticManager.medium()
        DispatchQueue.main.asyncAfter(deadline:.now()+2.8){
            self.injected=true
            UIView.animate(withDuration:0.3){
                self.injectBtn.backgroundColor=UIColor(hex:"#00C853")
                self.injectBtn.layer.shadowColor=UIColor(hex:"#00C853").cgColor
            }
            self.injectBtn.setTitle("✅  INJECTED — LAUNCH GAME",for:.normal)
            self.badge.setStatus(.active); HapticManager.success()
            let a=UIAlertController(title:"✅ Injection Successful",message:"FreeFire patched.\nLaunch the game now.",preferredStyle:.alert)
            a.addAction(UIAlertAction(title:"OK",style:.default)); self.present(a,animated:true)
        }
    }
}
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ t: UITableView, numberOfRowsInSection s: Int) -> Int { data[cats[cur]]?.count ?? 0 }
    func tableView(_ t: UITableView, cellForRowAt ip: IndexPath) -> UITableViewCell {
        let k=cats[cur]; guard var item=data[k]?[ip.row] else { return UITableViewCell() }
        switch item.type {
        case .toggle,.toggleWithMap:
            let c=t.dequeueReusableCell(withIdentifier:"T",for:ip) as! ToggleCheatCell
            c.configure(with:item); c.onToggle={ [weak self] on in self?.data[k]?[ip.row].isEnabled=on }; return c
        case .slider:
            let c=t.dequeueReusableCell(withIdentifier:"S",for:ip) as! SliderCheatCell
            c.configure(with:item); c.onValueChange={ [weak self] v in self?.data[k]?[ip.row].sliderValue=v }; return c
        case .segmented:
            let c=t.dequeueReusableCell(withIdentifier:"G",for:ip) as! SegmentedCheatCell
            c.configure(with:item); c.onSegmentChange={ [weak self] i in self?.data[k]?[ip.row].segmentIndex=i }; return c
        case .toggleWithTimer:
            let c=t.dequeueReusableCell(withIdentifier:"K",for:ip) as! TimerCheatCell
            c.configure(with:item)
            c.onToggle={ [weak self] on in self?.data[k]?[ip.row].isEnabled=on }
            c.onTimerChange={ [weak self] v in self?.data[k]?[ip.row].timerValue=v }; return c
        }
    }
    func tableView(_ t: UITableView, heightForRowAt ip: IndexPath) -> CGFloat {
        guard let item=data[cats[cur]]?[ip.row] else { return 72 }
        switch item.type { case .slider: return 96; case .toggleWithTimer: return 108; default: return 72 }
    }
}
