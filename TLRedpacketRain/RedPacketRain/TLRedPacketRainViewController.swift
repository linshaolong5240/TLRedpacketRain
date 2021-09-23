//
//  TLRedPacketRainViewController.swift
//  TLRedPacketRain
//
//  Created by teenloong on 2021/9/18.
//

import UIKit
import SnapKit
#if canImport(SwiftUI) && DEBUG
import SwiftUI
#endif

class TLRedPacketRainViewController: UIViewController {
    let viewModel = TLRedPacketRainViewModel(redPacketFireTimeInterval: 0.5, durationTime: 20)
    
    private var redPacketRainView = UIView()
    private let redPacketRainStatusView = TLRedPacketRainStatusView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.7027510631)
        configureRedPacketRainView()
        configureRedPacketRainStatusView()
        configureRedPacketRainStartCountdownView()
        configureCloseButton()
        
        viewModel.delegate = self
    }
    
    private func configureRedPacketRainView() {
        view.addSubview(redPacketRainView)
        redPacketRainView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func configureRedPacketRainStartCountdownView() {
        let startCountdownView = TLRedPacketRainStartCountdownView(frame: .zero, totalTime: 3) { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.viewModel.resetTimer()
            weakSelf.redPacketRainStatusView.isHidden = false
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
    
    private func configureRedPacketRainStatusView() {
        view.addSubview(redPacketRainStatusView)
        redPacketRainStatusView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(80)
            make.centerX.equalToSuperview()
        }
        redPacketRainStatusView.isHidden = true
        redPacketRainStatusView.setCountdown(viewModel.durationTime)
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

extension TLRedPacketRainViewController: TLRedPacketRainViewModelDelegate {
    
    func redPacketRainViewModel(_ redPacketRainViewModel: TLRedPacketRainViewModel, fired redPackets: [TLRedPacket]) {
        redPackets.forEach { redPacket in
            let xOffset: CGFloat = CGFloat(Int.random(in: 0...(Int(view.bounds.width) - Int(TLRedPacketView.WIDTH))))
            let yOffset: CGFloat = -CGFloat(Int.random(in: 0...Int(TLRedPacketView.HEIGHT))) - TLRedPacketView.HEIGHT
            let v = TLRedPacketView(frame: CGRect(x: xOffset, y: yOffset, width: TLRedPacketView.WIDTH, height: TLRedPacketView.HEIGHT), redPacket: redPacket)
            redPacketRainView.addSubview(v)
            v.startAnimation(.init(translationX: 0, y: view.bounds.height + TLRedPacketView.HEIGHT * 2))
            v.delegate = self
        }
    }
    
    func redPacketRainViewModel(_ redPacketRainViewModel: TLRedPacketRainViewModel, remainingTime: TimeInterval) {
        redPacketRainStatusView.setCountdown(remainingTime)
    }
    
    func redPacketRainFinished(_ redPacketRainViewModel: TLRedPacketRainViewModel) {
        redPacketRainView.removeFromSuperview()
    }
}

extension TLRedPacketRainViewController: TLRedPacketViewDelegate {
    func tlRedPacketViewDidSelected(_ redPacketView: TLRedPacketView, redPacket: TLRedPacket) {
        viewModel.openRedPacket(redPacket)
        switch redPacket.reward {
        case .empty: break
        case .score:
            redPacketRainStatusView.setScore(viewModel.totalScore)
        case .ticket: break
        }
    }
}

#if canImport(SwiftUI) && DEBUG
@available(iOS 14.0, *)
struct TLRedPacketRainMainView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.pink
            VStack {
                let vc = TLRedPacketRainViewController()
                TLViewControllerRepresentable(vc)
            }
        }.ignoresSafeArea()
    }
}
#endif
