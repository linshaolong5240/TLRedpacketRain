//
//  TLRedpacketRainStartCountdownView.swift
//  TLRedpacketRain
//
//  Created by teenloong on 2021/9/18.
//

import UIKit
import SnapKit
#if canImport(SwiftUI) && DEBUG
import SwiftUI
#endif

class TLRedpacketRainStartCountdownView: UIView {
    let HEIGHT: CGFloat = 228
    private var timer: Timer?
    private var totalTime: TimeInterval
    private var countdownTime: TimeInterval
    private var endAction: () -> Void
    lazy private var lefImageiew = UIImageView(image: UIImage(named: "red_packet_banner_left"))
    lazy private var rightImageiew = UIImageView(image: UIImage(named: "red_packet_banner_right"))
    lazy private var countdownImageView = UIImageView()

    init(frame: CGRect, totalTime: TimeInterval, action: @escaping () -> Void = { }) {
        self.totalTime = totalTime
        self.countdownTime = totalTime
        self.endAction = action
        super.init(frame: frame)
        configureBanner()
//        configureTitleLabel()
        configureCountdownLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        stopTimer()
    }
    
    private func configureBanner() {
        lefImageiew.contentMode = .right
        addSubview(lefImageiew)
        lefImageiew.snp.makeConstraints { make in
            make.right.equalTo(snp.centerX)
            make.centerY.equalToSuperview()
            make.height.equalTo(HEIGHT)
            make.width.equalToSuperview()
        }
        rightImageiew.contentMode = .left
        addSubview(rightImageiew)
        rightImageiew.snp.makeConstraints { make in
            make.left.equalTo(snp.centerX)
            make.centerY.equalToSuperview()
            make.height.equalTo(HEIGHT)
            make.width.equalToSuperview()
        }
    }
    
    private func configureTitleLabel() {
        let titleLabel = UILabel()
        
        lefImageiew.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(100)
        }
    }
    
    private func configureCountdownLabel() {
        addSubview(countdownImageView)
        countdownImageView.snp.makeConstraints { make in
            make.left.equalTo(snp.centerX)
            make.centerY.equalToSuperview().offset(34)
        }
        
        countdownImageView.image = UIImage(named: "red_packet_rain_countdown_number_\(Int(countdownTime))")
    }
    
    func resetTimer() {
        timer?.invalidate()
        countdownTime = totalTime
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countDownHandler), userInfo: nil, repeats: true)
    }
    
    private func stopTimer() {
        timer?.invalidate()
    }
    
    private func countDownEndHandler() {
        countdownImageView.isHidden = true
        let duration: TimeInterval = 0.25
        UIView.animate(withDuration: duration, delay: 0, options: [.curveLinear]) { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.lefImageiew.snp.remakeConstraints { make in
                make.right.equalTo(weakSelf.snp.left)
                make.centerY.equalToSuperview()
                make.height.equalTo(weakSelf.HEIGHT)
                make.width.equalToSuperview()
            }
            weakSelf.rightImageiew.snp.remakeConstraints { make in
                make.left.equalTo(weakSelf.snp.right)
                make.centerY.equalToSuperview()
                make.height.equalTo(weakSelf.HEIGHT)
                make.width.equalToSuperview()
            }
            weakSelf.layoutIfNeeded()
        } completion: {[weak self] status in
            guard let weakSelf = self else { return }
            weakSelf.removeFromSuperview()
            if status {
                weakSelf.endAction()
            }
        }
    }
    
    @objc private func countDownHandler() {
        countdownTime -= 1
        if countdownTime < 0 {
            stopTimer()
            countDownEndHandler()
        } else {
            countdownImageView.image = UIImage(named: "red_packet_rain_countdown_number_\(Int(countdownTime))")
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
struct TLRedpacketRainStartCountdownView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.pink
            VStack {
                let v = TLRedpacketRainStartCountdownView(frame: .zero, totalTime: 3)
                TLViewRepresentable(v)
                    .rotationEffect(.degrees(-20))
                    .onAppear(perform: {
                        v.resetTimer()
                    })
            }
        }.ignoresSafeArea()
    }
}
#endif
