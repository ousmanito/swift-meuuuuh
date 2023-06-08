// Etape 1 : Faire en sorte d'avoir une liste de sons avec laquelle l'utilisateur peut interagir
//       => C'est à  dire qu'il appuie et que le son est joué.

struct SoundSelectionView: View {
    @Binding var selectedSound: String

    // Vous devriez remplir cette liste avec les noms de vos fichiers sons.
    let availableSounds = ["sound1", "sound2", "sound3"]

    var body: some View {
        List(availableSounds, id: \.self) { sound in
            Button(action: {
                self.selectedSound = sound
            }) {
                Text(sound)
            }
        }
    }
}



struct ContentView: View {
    @State private var selectedSound: String = "defaultSound"
    @State private var isShowingSoundSelection = false
    @State private var soundEffect: AVAudioPlayer?

    var body: some View {
        VStack {
            Button("Choose Sound") {
                self.isShowingSoundSelection = true
            }

            Text("Shake me!")
                .onShake {
                    let path = Bundle.main.path(forResource: self.selectedSound, ofType: "mp3")!
                    let url = URL(fileURLWithPath: path)
                    
                    do {
                        soundEffect = try AVAudioPlayer(contentsOf: url)
                        soundEffect?.play()
                    } catch {
                        // couldn't load file
                    }
                }
        }
        .sheet(isPresented: $isShowingSoundSelection) {
            SoundSelectionView(selectedSound: self.$selectedSound)
        }
    }
}


// Etape 2 : Utiliser des alias pour que l'utilisateur se sente à l'aise

struct Sound {
    let alias: String
    let filename: String
}


struct SoundSelectionView: View {
    @Binding var selectedSound: Sound

    // Remplissez cette liste avec vos sons
    let availableSounds = [
        Sound(alias: "Sound 1", filename: "sound1"),
        Sound(alias: "Sound 2", filename: "sound2"),
        // etc.
    ]

    var body: some View {
        List(availableSounds, id: \.alias) { sound in
            Button(action: {
                self.selectedSound = sound
            }) {
                Text(sound.alias)
            }
        }
    }
}



struct ContentView: View {
    @State private var selectedSound: Sound = Sound(alias: "Default Sound", filename: "defaultSound")
    @State private var isShowingSoundSelection = false
    @State private var soundEffect: AVAudioPlayer?

    var body: some View {
        VStack {
            Button("Choose Sound") {
                self.isShowingSoundSelection = true
            }

            Text("Shake me!")
                .onShake {
                    let path = Bundle.main.path(forResource: self.selectedSound.filename, ofType: "mp3")!
                    let url = URL(fileURLWithPath: path)
                    
                    do {
                        soundEffect = try AVAudioPlayer(contentsOf: url)
                        soundEffect?.play()
                    } catch {
                        // couldn't load file
                    }
                }
        }
        .sheet(isPresented: $isShowingSoundSelection) {
            SoundSelectionView(selectedSound: self.$selectedSound)
        }
    }
}


// Etape 3 : Permettre à l'utilisateur d'avoir plus de contrôle sur les sons joués
//       => Concrètement, il pourra mettre un son en pause, stopper et changer de son


struct Sound {
    let alias: String
    let filename: String
    let player: AVAudioPlayer
}


let availableSounds = [
    Sound(alias: "Sound 1", filename: "sound1", player: try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "sound1", ofType: "mp3")!))),
    Sound(alias: "Sound 2", filename: "sound2", player: try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "sound2", ofType: "mp3")!))),
    // etc.
]


struct SoundSelectionView: View {
    @Binding var selectedSound: Sound

    // Remplissez cette liste avec vos sons
    let availableSounds: [Sound]

    var body: some View {
        List(availableSounds, id: \.alias) { sound in
            HStack {
                Button(action: {
                    self.selectedSound = sound
                }) {
                    Text(sound.alias)
                }

                Spacer()

                Button(action: {
                    sound.player.play()
                }) {
                    Image(systemName: "play.fill")
                }

                Button(action: {
                    sound.player.pause()
                }) {
                    Image(systemName: "pause.fill")
                }

                Button(action: {
                    sound.player.stop()
                }) {
                    Image(systemName: "stop.fill")
                }
            }
        }
    }
}
