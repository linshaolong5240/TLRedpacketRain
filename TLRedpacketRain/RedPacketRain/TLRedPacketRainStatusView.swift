//
//  TLRedpacketRainStatusView.swift
//  TLRedpacketRain
//
//  Created by teenloong on 2021/9/18.
//

import UIKit
import SnapKit
#if canImport(SwiftUI) && DEBUG
import SwiftUI
#endif

class TLRedpacketRainStatusView: UIView {
    
    private let content = UIStackView()
    private var countdownLabel = UILabel()
    private let scoreLabel = UILabel()
    private let scoreDescriptionLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        isUserInteractionEnabled = false
        configureContent()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureContent() {
        addSubview(content)
        content.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        content.axis = .vertical
        content.distribution = .fillEqually
        
        content.addArrangedSubview(countdownLabel)
        content.addArrangedSubview(scoreLabel)
        content.addArrangedSubview(scoreDescriptionLabel)
        
        countdownLabel.textAlignment = .center
        countdownLabel.textColor = #colorLiteral(red: 0.9983987212, green: 0.8954797387, blue: 0.3431963921, alpha: 1)
        countdownLabel.font = .systemFont(ofSize: 16, weight: .medium)
        
        scoreLabel.textAlignment = .center
        scoreLabel.textColor = #colorLiteral(red: 0.9957824349, green: 0.2807509601, blue: 0.1596641243, alpha: 1)
        scoreLabel.font = .systemFont(ofSize: 22, weight: .heavy)
        
        scoreDescriptionLabel.text = NSLocalizedString("已获得金币", comment: "")
        scoreDescriptionLabel.textAlignment = .center
        scoreDescriptionLabel.textColor = #colorLiteral(red: 0.9983987212, green: 0.8954797387, blue: 0.3431963921, alpha: 1)
        scoreDescriptionLabel.font = .systemFont(ofSize: 12, weight: .regular)
        setCountdown(0)
        setScore(0)
    }
    
    func setCountdown(_ timeInterval: TimeInterval) {
        let string = NSLocalizedString("剩余时间", comment: "") + String(format: " %02d:%02d", Int(timeInterval) / 60, Int(timeInterval) % 60)
        countdownLabel.text = string
    }
    
    func setScore(_ score: Int) {
        let prefix = "\(score)"
        let suffix = NSLocalizedString(" 币", comment: "")
        let prefixAttribute: [NSAttributedString.Key: Any] = [.foregroundColor: #colorLiteral(red: 0.9957824349, green: 0.2807509601, blue: 0.1596641243, alpha: 1), .font: UIFont.systemFont(ofSize: 22, weight: .heavy)]
        let suffixAttribute: [NSAttributedString.Key: Any] = [.foregroundColor: #colorLiteral(red: 0.9983987212, green: 0.8954797387, blue: 0.3431963921, alpha: 1), .font: UIFont.systemFont(ofSize: 12, weight: .medium)]
        let attributedText: NSMutableAttributedString = .init(string: prefix + suffix)
        attributedText.addAttributes(prefixAttribute, range: .init(location: 0, length: prefix.count))
        attributedText.addAttributes(suffixAttribute, range: .init(location: prefix.count, length: suffix.count))
        scoreLabel.attributedText = attributedText
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
struct TLRedpacketRainStatusView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.pink
            VStack {
                let v = TLRedpacketRainStatusView()
                TLViewRepresentable(v)
                    .background(Color.black.opacity(0.3))
                    .frame(height: 80)
                    .onAppear(perform: {
                        v.setScore(555)
                        v.setCountdown(75)
                    })
            }
        }.ignoresSafeArea()
    }
}
#endif
