//LMN

// Classe wrapper pour AVAudioPlayer
class AudioPlayer: Equatable {
    let player: AVAudioPlayer

    init(player: AVAudioPlayer) {
        self.player = player
    }

    static func == (lhs: AudioPlayer, rhs: AudioPlayer) -> Bool {
        return lhs.player == rhs.player
    }
}

struct ContentView: View {
    // Les noms des fichiers son et leurs alias pour l'affichage
    let sounds = [
        "sound1": "Son 1",
        "sound2": "Son 2",
        "sound3": "Son 3"
    ]

    // Le son sélectionné par l'utilisateur
    @State private var selectedSound = "sound1"

    // Les lecteurs audio pour chaque son
    @State private var soundPlayers: [String: AudioPlayer]

    var body: some View {
        VStack {
            // Le sélecteur de son
            List(sounds.keys.sorted(), id: \.self) { sound in
                HStack {
                    Text(self.sounds[sound] ?? sound)
                    Spacer()
                    if sound == selectedSound {
                        Image(systemName: "checkmark")
                    }
                }
                .contentShape(Rectangle())  // Make the entire row clickable
                .onTapGesture {
                    self.selectedSound = sound
                }
            }

            // An example view that responds to shaking
            Text("Secouez-moi!")
                .onShake {
                    self.soundPlayers[self.selectedSound]?.player.play()
                }
        }
    }
}




// ABS


struct ContentView: View {
    // The sound file names and their aliases for display
    let sounds = [
        "sound1": "Sound 1",
        "sound2": "Sound 2",
        "sound3": "Sound 3"
    ]

    // The sound selected by the user
    @State private var selectedSound = "sound1"

    // The audio players for each sound
    var soundPlayers: [String: AVAudioPlayer]

    var body: some View {
        VStack {
            // The sound selector
            List(sounds.keys.sorted(), id: \.self) { sound in
                HStack {
                    Text(self.sounds[sound] ?? sound)
                    Spacer()
                    if sound == selectedSound {
                        Image(systemName: "checkmark")
                    }
                }
                .contentShape(Rectangle())  // Make the entire row clickable
                .onTapGesture {
                    self.selectedSound = sound
                }
            }

            // An example view that responds to shaking
            Text("Shake me!")
                .onShake {
                    self.soundPlayers[self.selectedSound]?.play()
                }
        }
    }
}



// XYZ

struct ContentView: View {
    // Les noms des fichiers son et leurs alias pour l'affichage
    let sounds = [
        "sound1": "Son 1",
        "sound2": "Son 2",
        "sound3": "Son 3"
    ]

    // Le son sélectionné par l'utilisateur
    @State private var selectedSound = "sound1"

    // Les lecteurs audio pour chaque son
    var soundPlayers: [String: AVAudioPlayer]

    var body: some View {
        VStack {
            // Le sélecteur de son
            Picker("Choisissez un son", selection: $selectedSound) {
                ForEach(sounds.keys.sorted(), id: \.self) { sound in
                    Text(self.sounds[sound] ?? sound).tag(sound)
                }
            }.pickerStyle(RadioGroupPickerStyle())

            // Un exemple de vue qui réagit au secouement
            Text("Secouez-moi!")
                .onShake {
                    self.soundPlayers[self.selectedSound]?.play()
                }
        }
    }
}





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
