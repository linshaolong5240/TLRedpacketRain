//
//  Preview.swift
//  TLRedPacketRain
//
//  Created by teenloong on 2021/9/7.
//
import Foundation
#if canImport(SwiftUI) && DEBUG
import SwiftUI
#endif

#if canImport(SwiftUI) && DEBUG
@available(iOS 14.0, *)
struct TLViewRepresentable<T: UIView>: UIViewRepresentable {
    let view: T
    
    init(_ view: T) {
        self.view = view
    }

    func makeUIView(context: Context) -> T {
        return view
    }
    
    func updateUIView(_ uiView: T, context: Context) {
        
    }
    
    typealias UIViewType = T
}

@available(iOS 14.0, *)
struct TLViewControllerRepresentable<T: UIViewController>: UIViewControllerRepresentable {
    let viewController: T
    
    init(_ viewController: T) {
        self.viewController = viewController
    }
    
    func makeUIViewController(context: Context) -> UIViewControllerType {
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
    typealias UIViewControllerType = T
}

@available(iOS 14.0, *)
struct TLPreview_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            let vc: UIViewController = {
                let vc = UIViewController()
                vc.view.backgroundColor = .orange
                return vc
            }()
            
            TLViewControllerRepresentable(vc)
//            ViewRepresentable(v: EWWeatherView())
        }.ignoresSafeArea()
    }
}
#endif
