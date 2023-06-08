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


class AudioPlayer: Equatable {
    let player: AVAudioPlayer

    init(player: AVAudioPlayer) {
        self.player = player
    }

    static func == (lhs: AudioPlayer, rhs: AudioPlayer) -> Bool {
        return lhs.player === rhs.player
    }
}

//


struct ContentView: View {
    let sonsArray = [
        "AMBBird_Reveil des oiseaux 3 (ID 0999)_LS": "Réveil des oiseaux",
        "ANMLCat_Miaulement chat 2 (ID 1890)_LS": "Miaulement chat",
        "ANMLDog_Chien qui aboie 3 (ID 2955)_LS": "Chien qui aboie",
        "ANMLFarm_Canards (ID 0276)_LS": "Canards",
        "ANMLFarm_Poules et ponte (ID 0978)_LS": "Poules et ponte",
        "ANMLFarm_Vache qui meugle (ID 0546)_LS": "Vache qui meugle",
        "ANMLHors_Hennissement de cheval 3 (ID 0863)_LS": "Cheval",
        "ANMLInsc_Grillon champetre male (ID 1020)_LS": "Grillon champetre",
        "BIRDCrow_Corneilles 2 (ID 0956)_LS": "Corneilles",
        "BIRDPrey_Chouette hulotte 2 (ID 1764)_LS": "Chouette hulotte",
        "BIRDPrey_Hibou moyen duc (ID 0936)_LS": "Hibou moyen duc",
        "BIRDSong_Rouge gorge 4 (ID 1670)_LS": "Rouge gorge",
        "FOLYFeet_Galop de cheval sur sol dur (ID 0611)_LS": "Galop cheval sur sol dur",
    ]

    @State private var selectedSound = "BIRDPrey_Hibou moyen duc (ID 0936)_LS"
    @State private var currentPlayingSound: String?

    @State private var soundPlayers: [String: AudioPlayer]?

    var body: some View {
        VStack {
            List(sonsArray.keys.sorted(), id: \.self) { sound in
                HStack {
                    Text(self.sonsArray[sound] ?? sound)
                    Spacer()
                    if sound == selectedSound {
                        Image(systemName: "checkmark")
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    self.selectedSound = sound
                }
            }

            Text("Secouez-moi!")
                .onShake {
                    // Stop the current playing sound if there is one
                    if let currentPlayingSound = currentPlayingSound {
                        self.soundPlayers?[currentPlayingSound]?.player.stop()
                    }

                    // Play the selected sound
                    self.soundPlayers?[self.selectedSound]?.player.play()

                    // Update the current playing sound
                    self.currentPlayingSound = self.selectedSound
                }
        }
        .onAppear(perform: loadSounds)
    }

    private func loadSounds() {
        var players: [String: AudioPlayer] = [:]

        for sound in sonsArray.keys {
            let path = Bundle.main.path(forResource: "media/" + sound, ofType: "wav")!
            let url = URL(fileURLWithPath: path)
            let player = try! AVAudioPlayer(contentsOf: url)

            players[sound] = AudioPlayer(player: player)
        }

        soundPlayers = players
    }
}
