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

class TLRedpacketRainViewController: UIViewController {
    let viewModel = TLRedpacketRainViewModel(redPacketFireTimeInterval: 0.5, durationTime: 20)
    
    private var redpacketRainView = UIView()
    private let redpacketRainStatusView = TLRedpacketRainStatusView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.7027510631)
        configureRedpacketRainView()
        configureRedpacketRainStatusView()
        configureRedpacketRainStartCountdownView()
        configureCloseButton()
        
        viewModel.delegate = self
    }
    
    private func configureRedpacketRainView() {
        view.addSubview(redpacketRainView)
        redpacketRainView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func configureRedpacketRainStartCountdownView() {
        let startCountdownView = TLRedpacketRainStartCountdownView(frame: .zero, totalTime: 3) { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.viewModel.resetTimer()
            weakSelf.redpacketRainStatusView.isHidden = false
        }
        
        view.addSubview(startCountdownView)
        startCountdownView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        startCountdownView.transform = .init(rotationAngle: -25 / 360)
//        startCountdownView.layer.allowsEdgeAntialiasing = true
//        startCountdownView.layer.shouldRasterize = true
        startCountdownView.resetTimer()
    }
    
    private func configureRedpacketRainStatusView() {
        view.addSubview(redpacketRainStatusView)
        redpacketRainStatusView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(80)
            make.centerX.equalToSuperview()
        }
        redpacketRainStatusView.isHidden = true
        redpacketRainStatusView.setCountdown(viewModel.durationTime)
    }
    
    private func configureCloseButton() {
        let closeButton = UIButton(type: .custom)
        closeButton.setImage(UIImage(named: "redpacket_rain_close_button"), for: .normal)
        closeButton.addTarget(self, action: #selector(closeButtonOnClicked), for: .touchUpInside)
        
        view.addSubview(closeButton)
        closeButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.right.equalToSuperview().offset(-20)
            make.size.equalTo(CGSize(width: 30, height: 30))
        }
    }
    
    @objc func closeButtonOnClicked(_ sender: UIButton, _ event: UIEvent) {
        dismiss(animated: true, completion: nil)
        navigationController?.popViewController(animated: true)
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
        redpackets.forEach { redPacket in
            let xOffset: CGFloat = CGFloat(Int.random(in: 0...(Int(view.bounds.width) - Int(TLRedpacketView.WIDTH))))
            let yOffset: CGFloat = -CGFloat(Int.random(in: 0...Int(TLRedpacketView.HEIGHT))) - TLRedpacketView.HEIGHT
            let v = TLRedpacketView(frame: CGRect(x: xOffset, y: yOffset, width: TLRedpacketView.WIDTH, height: TLRedpacketView.HEIGHT), redacket: redPacket)
            redpacketRainView.addSubview(v)
            v.startAnimation(.init(translationX: 0, y: view.bounds.height + TLRedpacketView.HEIGHT * 2))
            v.delegate = self
        }
    }
    
    func redPacketRainViewModel(_ redpacketRainViewModel: TLRedpacketRainViewModel, remainingTime: TimeInterval) {
        redpacketRainStatusView.setCountdown(remainingTime)
    }
    
    func redPacketRainFinished(_ redpacketRainViewModel: TLRedpacketRainViewModel) {
        redpacketRainView.removeFromSuperview()
    }
}

extension TLRedpacketRainViewController: TLRedpacketViewDelegate {
    func tlRedpacketViewDidSelected(_ redpacketView: TLRedpacketView, redPacket: TLRedpacket) {
        viewModel.openRedpacket(redPacket)
        switch redPacket.reward {
        case .empty: break
        case .score:
            redpacketRainStatusView.setScore(viewModel.totalScore)
        case .ticket: break
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
