//
//  TLRedpacketRainViewModel.swift
//  TLRedpacketRain
//
//  Created by teenloong on 2021/9/18.
//

import Foundation

public enum TLRedpacketReward {
    case empty
    case score(Int)
    case ticket
}

public struct TLRedpacket {
    var id: Int = -1
    var reward: TLRedpacketReward = .empty
}

protocol TLRedpacketRainViewModelDelegate: class {
    func redpacketRainViewModel(_ redpacketRainViewModel: TLRedpacketRainViewModel, fired redpackets: [TLRedpacket])
    func redPacketRainViewModel(_ redPpacketRainViewModel: TLRedpacketRainViewModel, remainingTime: TimeInterval)
    func redPacketRainFinished(_ redpacketRainViewModel: TLRedpacketRainViewModel)
}

class TLRedpacketRainViewModel {
    private(set) var redpackkets: [TLRedpacket]
    private(set) var openedRedpackkets: [TLRedpacket] = .init()
    var openedScoreRedpackkets: [TLRedpacket] {
        return openedRedpackkets.filter({ item in
            switch item.reward {
            case .score: return true
            default:    return false
            }
        })
    }

    var totalScore: Int {
        openedRedpackkets.map { redPacket -> Int in
            if case .score(let value) = redPacket.reward {
                return value
            } else { return 0}
        }.reduce(0, +)
    }
    
    private let redpacketFireTimeInterval: TimeInterval
    private(set) var fireNumber: Int
    private(set) var fallTime: TimeInterval
    
    private var remainingTime: TimeInterval
    private(set) var durationTime: TimeInterval
    private var countdownTimer: Timer?
    private var redpacketFireTimer: Timer?
    weak var delegate: TLRedpacketRainViewModelDelegate?
    
    init(fireTimeInterval: TimeInterval, fireNumber: Int, fallTime: TimeInterval, redpackkets: [TLRedpacket]) {
        self.redpacketFireTimeInterval = fireTimeInterval
        self.fireNumber = fireNumber
        self.fallTime = fallTime
        self.durationTime = .init(Double(redpackkets.count) / Double(fireNumber) * fireTimeInterval) + fallTime
        self.remainingTime = durationTime
        self.redpackkets = redpackkets
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
        var redPacketsToFire: [TLRedpacket] = .init()
        for _ in (0..<fireNumber) {
            if redpackkets.count > 0 {
                redPacketsToFire.append(redpackkets.removeFirst())
            }
        }
        delegate?.redpacketRainViewModel(self, fired: redPacketsToFire)
    }
    
    func openRedpacket(_ redPacket: TLRedpacket) {
        openedRedpackkets.append(redPacket)
    }
    
    func getRedpacket() {
        
    }
}
