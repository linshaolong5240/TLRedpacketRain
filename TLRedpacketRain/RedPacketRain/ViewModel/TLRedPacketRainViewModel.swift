//
//  TLRedPacketRainViewModel.swift
//  TLRedPacketRain
//
//  Created by teenloong on 2021/9/18.
//

import Foundation

enum TLRedPacketReward {
    case empty
    case score(Int)
    case ticket
}

struct TLRedPacket {
    var reward: TLRedPacketReward = .empty
}

protocol TLRedPacketRainViewModelDelegate: class {
    func redPacketRainViewModel(_ redPacketRainViewModel: TLRedPacketRainViewModel, fired redPackets: [TLRedPacket])
    func redPacketRainViewModel(_ redPacketRainViewModel: TLRedPacketRainViewModel, remainingTime: TimeInterval)
    func redPacketRainFinished(_ redPacketRainViewModel: TLRedPacketRainViewModel)
}

class TLRedPacketRainViewModel {
    private var openedRedPackkets: [TLRedPacket] = .init()
    
    var totalScore: Int {
        openedRedPackkets.map { redPacket -> Int in
            if case .score(let value) = redPacket.reward {
                return value
            } else { return 0}
        }.reduce(0, +)
    }
    
    private var remainingTime: TimeInterval
    private(set) var durationTime: TimeInterval
    private let redPacketFireTimeInterval: TimeInterval
    private var countdownTimer: Timer?
    private var redPacketFireTimer: Timer?
    weak var delegate: TLRedPacketRainViewModelDelegate?
    
    init(redPacketFireTimeInterval: TimeInterval, durationTime: TimeInterval) {
        self.redPacketFireTimeInterval = redPacketFireTimeInterval
        self.durationTime = durationTime
        self.remainingTime = durationTime
    }
    
    deinit {
        stopTimer()
    }
    
    func resetTimer() {
        stopTimer()
        countdownTimer = .scheduledTimer(timeInterval: 1, target: self, selector: #selector(countDownHandler), userInfo: nil, repeats: true)
        redPacketFireTimer = .scheduledTimer(timeInterval: redPacketFireTimeInterval, target: self, selector: #selector(fireRedPacket), userInfo: nil, repeats: true)
    }
    
    func stopTimer() {
        countdownTimer?.invalidate()
        redPacketFireTimer?.invalidate()
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
    
    @objc private func fireRedPacket() {
        delegate?.redPacketRainViewModel(self, fired: [TLRedPacket(reward: .score(5)), TLRedPacket(reward: .ticket), TLRedPacket(reward: .empty)])
    }
    
    func openRedPacket(_ redPacket: TLRedPacket) {
        openedRedPackkets.append(redPacket)
    }
}
