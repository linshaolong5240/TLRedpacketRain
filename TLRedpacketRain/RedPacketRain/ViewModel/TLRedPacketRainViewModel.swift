//
//  TLRedpacketRainViewModel.swift
//  TLRedpacketRain
//
//  Created by teenloong on 2021/9/18.
//

import Foundation

enum TLRedpacketReward {
    case empty
    case score(Int)
    case ticket
}

struct TLRedpacket {
    var reward: TLRedpacketReward = .empty
}

protocol TLRedpacketRainViewModelDelegate: class {
    func redpacketRainViewModel(_ redpacketRainViewModel: TLRedpacketRainViewModel, fired redpackets: [TLRedpacket])
    func redPacketRainViewModel(_ redPpacketRainViewModel: TLRedpacketRainViewModel, remainingTime: TimeInterval)
    func redPacketRainFinished(_ redpacketRainViewModel: TLRedpacketRainViewModel)
}

class TLRedpacketRainViewModel {
    private var openedRedpackkets: [TLRedpacket] = .init()
    
    var totalScore: Int {
        openedRedpackkets.map { redPacket -> Int in
            if case .score(let value) = redPacket.reward {
                return value
            } else { return 0}
        }.reduce(0, +)
    }
    
    private var remainingTime: TimeInterval
    private(set) var durationTime: TimeInterval
    private let redpacketFireTimeInterval: TimeInterval
    private var countdownTimer: Timer?
    private var redpacketFireTimer: Timer?
    weak var delegate: TLRedpacketRainViewModelDelegate?
    
    init(redPacketFireTimeInterval: TimeInterval, durationTime: TimeInterval) {
        self.redpacketFireTimeInterval = redPacketFireTimeInterval
        self.durationTime = durationTime
        self.remainingTime = durationTime
    }
    
    deinit {
        stopTimer()
    }
    
    func resetTimer() {
        stopTimer()
        countdownTimer = .scheduledTimer(timeInterval: 1, target: self, selector: #selector(countDownHandler), userInfo: nil, repeats: true)
        redpacketFireTimer = .scheduledTimer(timeInterval: redpacketFireTimeInterval, target: self, selector: #selector(fireRedpacket), userInfo: nil, repeats: true)
    }
    
    func stopTimer() {
        countdownTimer?.invalidate()
        redpacketFireTimer?.invalidate()
    }
    
    @objc private func countDownHandler() {
        guard remainingTime > 0 else {
            stopTimer()
            delegate?.redPacketRainFinished(self)
            return
        }
        remainingTime -= 1
        delegate?.redPacketRainViewModel(self, remainingTime: remainingTime)
    }
    
    @objc private func fireRedpacket() {
        delegate?.redpacketRainViewModel(self, fired: [TLRedpacket(reward: .score(5)), TLRedpacket(reward: .ticket), TLRedpacket(reward: .empty)])
    }
    
    func openRedpacket(_ redPacket: TLRedpacket) {
        openedRedpackkets.append(redPacket)
    }
}
