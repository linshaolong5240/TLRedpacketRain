//
//  TLRedPacketView.swift
//  TLRedPacketRain
//
//  Created by teenloong on 2021/9/22.
//

import UIKit
import SnapKit
#if canImport(SwiftUI) && DEBUG
import SwiftUI
#endif

protocol TLRedPacketViewDelegate: class {
    func tlRedPacketViewDidSelected(_ redPacketView: TLRedPacketView, redPacket: TLRedPacket)
}

fileprivate extension TLRedPacket {
    var imageName: String {
        switch reward {
        case .empty:    return "red_packet_empty"
        case .score(_): return "red_packet_score"
        case .ticket:   return "red_packet_ticket"
        }
    }
    
    var defaultImageName: String { "red_packet_Falling" }
}

class TLRedPacketView: UIButton {
    static let WIDTH: CGFloat = 60
    static let HEIGHT: CGFloat = 100

    private let redPacket: TLRedPacket
    weak var delegate: TLRedPacketViewDelegate?
    
    private var animate: UIViewPropertyAnimator?
    
    init(frame: CGRect, redPacket: TLRedPacket) {
        self.redPacket = redPacket
        super.init(frame: frame)
        configureRedPacketButton()
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
    
    private func configureRedPacketButton() {
        setImage(UIImage(named: redPacket.defaultImageName), for: .normal)
        setImage(UIImage(named: redPacket.imageName), for: .selected)
        addTarget(self, action: #selector(redPacketButtonOnClicked), for: .touchUpInside)
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
            delegate?.tlRedPacketViewDidSelected(self, redPacket: redPacket)
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
struct TLRedPacketView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {            VStack {
            let v = TLRedPacketView(frame: .zero, redPacket: .init(reward: .ticket))
                TLViewRepresentable(v)
                    .frame(width: TLRedPacketView.WIDTH, height: TLRedPacketView.HEIGHT, alignment: .center)
                    .onAppear(perform: {
                        v.startAnimation(.init(translationX: 0, y: UIScreen.main.bounds.height))
                    })
            }
        }.ignoresSafeArea()
    }
}
#endif
