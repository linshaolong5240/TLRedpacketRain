//
//  TLRedPacketView.swift
//  TLRedpacketRain
//
//  Created by teenloong on 2021/9/22.
//

import UIKit
import SnapKit
#if canImport(SwiftUI) && DEBUG
import SwiftUI
#endif

protocol TLRedpacketViewDelegate: class {
    func tlRedpacketViewDidSelected(_ redpacketView: TLRedpacketView, redPacket: TLRedpacket)
}

fileprivate extension TLRedpacket {
    var imageName: String {
        switch reward {
        case .empty:    return "red_packet_empty"
        case .score(_): return "red_packet_score"
        case .ticket:   return "red_packet_ticket"
        }
    }
    
    var defaultImageName: String { "red_packet_Falling" }
    
    var desc: String {
        switch reward {
        case .empty:    return "empty"
        case .score(let value): return "+\(value) " + "Coins"
        case .ticket:   return "Take Away Vouchers"
        }
    }
}

class TLRedpacketView: UIButton {
    static let WIDTH: CGFloat = 60
    static let HEIGHT: CGFloat = 100

    private var redpacket: TLRedpacket
    weak var delegate: TLRedpacketViewDelegate?

    private let descLabel: UILabel = UILabel()
    
    private var animate: UIViewPropertyAnimator?
    
    init(frame: CGRect, redpacket: TLRedpacket) {
        self.redpacket = redpacket
        super.init(frame: frame)
        setImage(UIImage(named: redpacket.defaultImageName), for: .normal)
        setImage(UIImage(named: redpacket.imageName), for: .selected)
        addTarget(self, action: #selector(redPacketButtonOnClicked), for: .touchUpInside)
        configureDescLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func configureDescLabel() {
        descLabel.text = redpacket.desc
        descLabel.textColor = #colorLiteral(red: 0.9983987212, green: 0.8954797387, blue: 0.3431963921, alpha: 1)
        descLabel.textAlignment = .center
        descLabel.font = .systemFont(ofSize: 20, weight: .heavy)
        descLabel.adjustsFontSizeToFitWidth = true
        descLabel.alpha = 0.0
        descLabel.frame = CGRect(x: 0, y: 0, width: bounds.width, height: 28)
        addSubview(descLabel)
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let locationPoint = layer.convert(point, to: layer.presentation())
        if let presentationLayer = layer.presentation() {
            if presentationLayer.contains(locationPoint) {
                return isSelected ? nil : self
            }
        }
        return nil
    }
    
    func startAnimation(_ transform: CGAffineTransform, duration: TimeInterval) {
        animate = UIViewPropertyAnimator(duration: duration, curve: .linear) { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.transform = transform
        }
        animate?.addCompletion { [weak self] positon in
            guard let weakSelf = self, !weakSelf.isSelected else { return }
            weakSelf.removeFromSuperview()
        }
        
        animate?.startAnimation()
    }
    
    func stopAnimation() {
        animate?.stopAnimation(true)
    }

    @objc private func redPacketButtonOnClicked(_ sender: UIButton, _ event: UIEvent) {
        if !sender.isSelected {
            stopAnimation()
            sender.isSelected = true
            delegate?.tlRedpacketViewDidSelected(self, redPacket: redpacket)
            UIView.animate(withDuration: 0.5, delay: 0, options: [.curveLinear]) { [weak self] in
                guard let weakSelf = self else { return }
                weakSelf.descLabel.alpha = 1.0
                weakSelf.descLabel.frame = CGRect(x: 0, y: -20, width: weakSelf.bounds.width, height: 28)
            } completion: { status in
                
            }
            
            UIView.animate(withDuration: 0.5, delay: 0.5, options: [.curveLinear]) { [weak self] in
                guard let weakSelf = self else { return }
                weakSelf.alpha = 0.0
            } completion: { [weak self] status in
                guard let weakSelf = self else { return }
                weakSelf.removeFromSuperview()
            }
//
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
//                guard let weakSelf = self else { return }
//                weakSelf.removeFromSuperview()
//            }
        }
    }
    
    func setData(_ data: TLRedpacket) {
        redpacket = data
        setImage(UIImage(named: redpacket.imageName), for: .selected)
        descLabel.text = redpacket.desc
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

#if canImport(SwiftUI) && DEBUG
@available(iOS 14.0, *)
struct TLRedpacketView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            VStack {
                let v = TLRedpacketView(frame: .zero, redpacket: .init(reward: .empty))
                TLViewRepresentable(v)
                    .frame(width: TLRedpacketView.WIDTH, height: TLRedpacketView.HEIGHT, alignment: .center)
            }
        }.ignoresSafeArea()
    }
}
#endif
