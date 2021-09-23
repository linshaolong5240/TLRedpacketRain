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
}

class TLRedpacketView: UIButton {
    static let WIDTH: CGFloat = 60
    static let HEIGHT: CGFloat = 100

    private let redpacket: TLRedpacket
    weak var delegate: TLRedpacketViewDelegate?
    
    private var animate: UIViewPropertyAnimator?
    
    init(frame: CGRect, redacket: TLRedpacket) {
        self.redpacket = redacket
        super.init(frame: frame)
        setImage(UIImage(named: redpacket.defaultImageName), for: .normal)
        setImage(UIImage(named: redpacket.imageName), for: .selected)
        addTarget(self, action: #selector(redPacketButtonOnClicked), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let locationPoint = layer.convert(point, to: layer.presentation())
        if let presentationLayer = layer.presentation() {
            if presentationLayer.contains(locationPoint) {
                return self
            }
        }
        return nil
    }
    
    func startAnimation(_ transform: CGAffineTransform) {
        animate = UIViewPropertyAnimator(duration: 3, curve: .linear) { [weak self] in
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
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                guard let weakSelf = self else { return }
                weakSelf.removeFromSuperview()
            }
        }
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
        ZStack {            VStack {
            let v = TLRedpacketView(frame: .zero, redacket: .init(reward: .score(5)))
                TLViewRepresentable(v)
                    .frame(width: TLRedpacketView.WIDTH, height: TLRedpacketView.HEIGHT, alignment: .center)
                    .onAppear(perform: {
                        v.startAnimation(.init(translationX: 0, y: UIScreen.main.bounds.height))
                    })
            }
        }.ignoresSafeArea()
    }
}
#endif
