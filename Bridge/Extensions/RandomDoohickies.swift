//
//  RandomDoohickies.swift
//  Bridge
//
//  Created by jailbreak.party on 10/23/25.
//  Thanks skadz108 for literally fucking everything.
//

import Foundation
import UIKit
import Combine

class Haptic: ObservableObject {
    static let shared = Haptic()
    
    func play(_ feedbackStyle: UIImpactFeedbackGenerator.FeedbackStyle) {
        Task { @MainActor in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                UIImpactFeedbackGenerator(style: feedbackStyle).impactOccurred()
            }
        }
    }
    
    func notify(_ feedbackType: UINotificationFeedbackGenerator.FeedbackType) {
        Task { @MainActor in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                UINotificationFeedbackGenerator().notificationOccurred(feedbackType)
            }
        }
    }
}

func exitinator() {
    UIControl().sendAction(#selector(URLSessionTask.suspend), to: UIApplication.shared, for: nil)
    Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { (timer) in
        exit(0)
    }
}
