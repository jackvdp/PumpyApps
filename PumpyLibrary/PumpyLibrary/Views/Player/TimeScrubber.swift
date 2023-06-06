//
//  TimeScrubber.swift
//  PumpyLibrary
//
//  Created by Jack Vanderpump on 04/06/2023.
//

import SwiftUI
import MusicKit

struct TimeScrubber: View {
    
    var player = ApplicationMusicPlayer.shared
    @ObservedObject var queue = ApplicationMusicPlayer.shared.queue
    @ObservedObject var state = ApplicationMusicPlayer.shared.state
    private let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
    @State private var startTime = "--:--"
    @State private var endTime = "--:--"
    @State private var timePercentage: CGFloat = 0
    
    var body: some View {
        VStack(spacing: 4) {
            ZStack(alignment: .leading) {
                GeometryReader { geo in
                    Color.white.opacity(0.5)
                    Color.white.opacity(1)
                        .frame(width: geo.size.width * timePercentage)
                }
            }
            .frame(height: 3)
            .frame(maxWidth: .infinity)
            .cornerRadius(3)
            HStack {
                Text(startTime)
                Spacer()
                audioVariant
                Spacer()
                Text(endTime)
            }
            .foregroundColor(Color.white)
            .font(.footnote)
        }
        .onReceive(timer) { _ in
            setTimeLabels()
            setPercentageDone()
        }
        .onAppear() {
            setTimeLabels()
        }
        .padding(.horizontal)
    }
    
    var audioVariant: some View {
        let (image, name) = variantImageName()
        return HStack {
            Image(image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.white)
                .frame(width: 15, height: 15)
            if let name {
                Text(name)
            }
        }
    }
    
    func variantImageName() -> (imageName: String, variantName: String?) {
        guard #available(iOS 16.0, *),
              let variant = state.audioVariant else { return ("", "") }
        
        switch variant {
        case .dolbyAtmos:
            return ("dolby", "Atmos")
        case .dolbyAudio:
            return ("dolby", nil)
        case .lossless:
            return ("lossless", "Lossless")
        case .highResolutionLossless:
            return ("lossless", "Hi-Res")
        default:
            return ("", nil)
        }
    }
    
    func setPercentageDone() {
        guard let endTime = getEndTime() else {
            timePercentage =  0
            return
        }
        let currentTime = player.playbackTime
        withAnimation {
            timePercentage = currentTime / endTime
        }
    }
    
    func formattedTime(_ interval: TimeInterval?) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.zeroFormattingBehavior = .pad
        guard let interval else { return "--:--" }
        return formatter.string(from: interval) ?? "--:--"
    }
    
    func setTimeLabels() {
        startTime = queue.currentEntry != nil ? formattedTime(player.playbackTime) : "--:--"
        endTime = formattedTime(getEndTime())
    }

    func getEndTime() -> TimeInterval? {
        switch queue.currentEntry?.item {
        case .some(.song(let song)):
            return song.duration
        default:
            return nil
        }
    }
}

struct TimeScrubber_Previews: PreviewProvider {
    static var previews: some View {
        TimeScrubber()
            .padding()
            .background(.blue)
    }
}
