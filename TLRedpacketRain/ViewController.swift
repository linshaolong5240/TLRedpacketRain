//
//  ViewController.swift
//  TLRedpacketRain
//
//  Created by teenloong on 2021/9/23.
//

import UIKit

#if canImport(SwiftUI) && DEBUG
import SwiftUI
#endif

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .systemPink
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let vc = TLRedPacketRainViewController()
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: false, completion: nil)
    }
}

#if canImport(SwiftUI) && DEBUG
@available(iOS 14.0, *)
struct ViewController_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.pink
            VStack {
                let vc = ViewController()
                TLViewControllerRepresentable(vc)
            }
        }.ignoresSafeArea()
    }
}
#endif

