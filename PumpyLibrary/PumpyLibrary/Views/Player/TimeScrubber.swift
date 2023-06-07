//
//  TimeScrubber.swift
//  PumpyLibrary
//
//  Created by Jack Vanderpump on 04/06/2023.
//

import SwiftUI
import MusicKit
import Sliders
import MediaPlayer

struct TimeScrubber: View {
    
    var player = ApplicationMusicPlayer.shared
    @ObservedObject var queue = ApplicationMusicPlayer.shared.queue
    @ObservedObject var state = ApplicationMusicPlayer.shared.state
    private let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
    @State private var startTime = Self.noTimeLabel
    @State private var endTime = Self.noTimeLabel
    @State private var timePercentage: Double = 0
    let opacity: CGFloat
    static let noTimeLabel = "--:--"
    
    var body: some View {
        VStack(spacing: 4) {
            slider
            HStack {
                Text(startTime)
                Spacer()
                audioVariant
                Spacer()
                Text(endTime)
            }.opacity(opacity)
            .foregroundColor(Color.white)
            .font(.footnote)
        }
        .onReceive(timer) { _ in
            if !isEditing {
                setTimeLabels()
                setPercentageDone()
            }
        }
        .onAppear() {
            setTimeLabels()
            setPercentageDone(animated: false)
        }
        .padding(.horizontal)
    }
    
    // MARK: - Slider
    
    @State private var isEditing = false
    
    var slider: some View {
        ValueSlider(value: $timePercentage, onEditingChanged: { editing in
            isEditing = editing
        })
            .valueSliderStyle(
                HorizontalValueSliderStyle(
                    track:
                        HorizontalValueTrack(
                            view: Capsule().foregroundColor(.white).opacity(opacity)
                        )
                        .background(Capsule().foregroundColor(Color.white.opacity(0.25).opacity(opacity)))
                        .frame(height: 3),
                    thumb: Circle().foregroundColor(.white),
                    thumbSize: CGSize(width: 8, height: 8)
                )
            )
            .frame(height: 10)
            .frame(maxWidth: .infinity)
            .onChange(of: isEditing) { newValue in
                guard !isEditing else { return }
                setPlaybacktimeFromPercentage(timePercentage)
            }
    }
    
    // MARK: - Audio Variant
    
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
    
    // MARK: - Methods
    
    func setPlaybacktimeFromPercentage(_ percentage: Double) {
        guard let endTime = getEndTime() else { return }
        let newTime = endTime * percentage
        MPMusicPlayerController.applicationQueuePlayer.currentPlaybackTime = newTime
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
    
    func setPercentageDone(animated: Bool = true) {
        guard let endTime = getEndTime() else {
            timePercentage =  0
            return
        }
        let currentTime = player.playbackTime
        if animated {
            withAnimation {
                timePercentage = currentTime / endTime
            }
        } else {
            timePercentage = currentTime / endTime
        }
    }
    
    func formattedTime(_ interval: TimeInterval?) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.zeroFormattingBehavior = .pad
        guard let interval else { return Self.noTimeLabel }
        return formatter.string(from: interval) ?? Self.noTimeLabel
    }
    
    func setTimeLabels() {
        startTime = queue.currentEntry != nil ? formattedTime(player.playbackTime) : Self.noTimeLabel
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

// MARK: - Previews

struct TimeScrubber_Previews: PreviewProvider {
    static var previews: some View {
        TimeScrubber(opacity: 1)
            .padding()
            .background(.blue)
    }
}
