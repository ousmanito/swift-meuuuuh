//
//  ContentView.swift
//  swift-meuuuh
//
//  Created by Utilisateur invité on 08/06/2023.
//

import SwiftUI
import AVFoundation

extension UIDevice {
    static let devideDidShakeNotif = Notification.Name(rawValue: "deviceDidShakeNotif")
}

extension UIWindow {
    open override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            NotificationCenter.default.post(name: UIDevice.devideDidShakeNotif, object: nil)
        }
    }
}

struct DeviceShakeViewModifier: ViewModifier {
    let action: () -> Void
    
    func body(content: Content) -> some View {
        content
            .onAppear()
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.devideDidShakeNotif)) {
                _ in action()
            }
    }
}

extension View {
    func onShake(perform action: @escaping () -> Void) -> some View {
        self.modifier(DeviceShakeViewModifier(action: action))
    }
}




struct ContentView: View {
    @State private var boiteMeuhLecteur: AVAudioPlayer?
    
    var body: some View {
        Text("Secouez le téléphone !").onShake {
            playSound()
        }
    }
    
    func playSound() {
        let path = Bundle.main.path(forResource: "media/AMBBird_Reveil des oiseaux 3 (ID 0999)_LS" , ofType: "wav")!
        let url  = URL(fileURLWithPath: path)
        
        do {
            boiteMeuhLecteur = try AVAudioPlayer(contentsOf: url)
            boiteMeuhLecteur?.play()
        } catch {
            print("Pas possible de lire le son")
        }
    }
}
