//
//  TLRedpacketRainViewController.swift
//  TLRedpacketRain
//
//  Created by teenloong on 2021/9/18.
//

import UIKit
import SnapKit
#if canImport(SwiftUI) && DEBUG
import SwiftUI
#endif

protocol TLRedpacketRainViewDelegate: class {
    func didClickedCloseButon()
}

class TLRedpacketRainViewController: UIViewController {
    let viewModel = TLRedpacketRainViewModel(fireTimeInterval: 0.5, fireNumber: 2, fallTime: 5, redpackkets: .init(repeating: TLRedpacket(reward: .score(5)), count: 20))
    weak var delegate: TLRedpacketRainViewDelegate?
    private var startCountdownView: TLRedpacketRainStartCountdownView!
    private var redpacketRainView = UIView()
    private let redpacketRainStatusView = TLRedpacketRainStatusView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.7027510631)
        configureRedpacketRainStatusView()
        configureRedpacketRainView()
        configureRedpacketRainStartCountdownView()
        configureCloseButton()
        
        viewModel.delegate = self
        startCountdownView.resetTimer()
    }
    
    private func configureRedpacketRainStatusView() {
        view.addSubview(redpacketRainStatusView)
        redpacketRainStatusView.snp.makeConstraints { make in
            make.top.equalTo(topLayoutGuide.snp.bottom).offset(80)
            make.centerX.equalToSuperview()
        }
        redpacketRainStatusView.isHidden = true
        redpacketRainStatusView.setCountdown(viewModel.durationTime)
    }

    private func configureRedpacketRainView() {
        view.addSubview(redpacketRainView)
        redpacketRainView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func configureRedpacketRainStartCountdownView() {
        startCountdownView = TLRedpacketRainStartCountdownView(frame: .zero, totalTime: 3) { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.viewModel.resetTimer()
            weakSelf.redpacketRainStatusView.isHidden = false
        }
        
        view.addSubview(startCountdownView)
        startCountdownView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        startCountdownView.transform = .init(rotationAngle: -30 / 360)
//        startCountdownView.layer.allowsEdgeAntialiasing = true
//        startCountdownView.layer.shouldRasterize = true
    }
    
    private func configureCloseButton() {
        let closeButton = UIButton(type: .custom)
        closeButton.setImage(UIImage(named: "redpacket_rain_close_button"), for: .normal)
        closeButton.addTarget(self, action: #selector(closeButtonOnClicked), for: .touchUpInside)
        
        view.addSubview(closeButton)
        closeButton.snp.makeConstraints { make in
            make.top.equalTo(topLayoutGuide.snp.bottom).offset(20)
            make.right.equalToSuperview().offset(-20)
            make.size.equalTo(CGSize(width: 30, height: 30))
        }
    }
    
    @objc func closeButtonOnClicked() {
        view.removeFromSuperview()
        removeFromParent()
        delegate?.didClickedCloseButon()
    }
    
    @objc func getButtonOnClicked(_ sender: UIButton, _ event: UIEvent) {
        
    }
    
    @objc func notificationButtonOnClicked(_ sender: UIButton, _event: UIEvent) {
        
    }
    
    @objc func ticketButtonOnClicked(_ sender: UIButton, _event: UIEvent) {
        
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

extension TLRedpacketRainViewController: TLRedpacketRainViewModelDelegate {
    
    func redpacketRainViewModel(_ redPacketRainViewModel: TLRedpacketRainViewModel, fired redpackets: [TLRedpacket]) {
        redpackets.enumerated().forEach { index, redPacket in
            let widthOffset: CGFloat = UIScreen.main.bounds.width / CGFloat(redPacketRainViewModel.fireNumber)
            let xOffset: CGFloat = CGFloat(Int.random(in: 0...(Int(widthOffset) - Int(TLRedpacketView.WIDTH)))) + CGFloat(index) * widthOffset
            
            let yOffset: CGFloat = -CGFloat(Int.random(in: 0...Int(TLRedpacketView.HEIGHT))) - TLRedpacketView.HEIGHT
            let v = TLRedpacketView(frame: CGRect(x: xOffset, y: yOffset, width: TLRedpacketView.WIDTH, height: TLRedpacketView.HEIGHT), redpacket: redPacket)
            redpacketRainView.addSubview(v)
            v.startAnimation(.init(translationX: 0, y: view.bounds.height + TLRedpacketView.HEIGHT * 2), duration: redPacketRainViewModel.fallTime)
            v.delegate = self
        }
    }
    
    func redPacketRainViewModel(_ redpacketRainViewModel: TLRedpacketRainViewModel, remainingTime: TimeInterval) {
        redpacketRainStatusView.setCountdown(remainingTime)
    }
    
    func redPacketRainFinished(_ redpacketRainViewModel: TLRedpacketRainViewModel) {
        redpacketRainView.removeFromSuperview()
        redpacketRainStatusView.removeFromSuperview()
    }
}

extension TLRedpacketRainViewController: TLRedpacketViewDelegate {
    func tlRedpacketViewDidSelected(_ redpacketView: TLRedpacketView, redPacket: TLRedpacket) {
        if viewModel.openedRedpackkets.count == 2  {
            let packet: TLRedpacket = .init(reward: .ticket)
            viewModel.openRedpacket(packet)
            redpacketView.setData(packet)
        } else {
            viewModel.openRedpacket(redPacket)
            switch redPacket.reward {
            case .empty: break
            case .score:
                redpacketRainStatusView.setScore(viewModel.totalScore)
            case .ticket: break
            }
        }
    }
}

#if canImport(SwiftUI) && DEBUG
@available(iOS 14.0, *)
struct TLRedpacketRainMainView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.pink
            VStack {
                let vc = TLRedpacketRainViewController()
                TLViewControllerRepresentable(vc)
            }
        }.ignoresSafeArea()
    }
}
#endif
