//
//  TLViewWrapperViewController.swift
//  TLRedpacketRain
//
//  Created by teenloong on 2021/9/18.
//

import UIKit
import SnapKit
#if canImport(SwiftUI) && DEBUG
import SwiftUI
#endif

class TLViewWrapperViewController: UIViewController {
    private var wrappedView: UIView
    
    init(_ wrappedView: UIView) {
        self.wrappedView = wrappedView
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.addSubview(wrappedView)
        wrappedView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

#if canImport(SwiftUI) && DEBUG
@available(iOS 14.0, *)
struct TLViewWrapperViewController_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.pink
            VStack {
                let v: UIView = {
                    let v = UIView()
                    v.backgroundColor = .orange
                    return v
                }()
                let vc = TLViewWrapperViewController(v)
                TLViewControllerRepresentable(vc)
            }
        }.ignoresSafeArea()
    }
}
#endif
