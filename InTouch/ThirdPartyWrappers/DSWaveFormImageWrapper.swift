//
//  DSWaveFormImageWrapper.swift
//  InTouch
//
//  Created by Red Wang on 2023/12/21.
//

import UIKit
import DSWaveformImage
import DSWaveformImageViews

class DSWaveFormImageWrapper {
    typealias CompletionHandler<T> = (_ result: Result<T, Error>) -> Void
    static let shared = DSWaveFormImageWrapper()
    
    let waveformImageDrawer = WaveformImageDrawer()
    
    func updateWaveFormProgress(
        url: URL,
        waveImageView: UIImageView,
        completion: @escaping CompletionHandler<UIImage>) {
            
            Task {
                do {
                    let image = try await waveformImageDrawer.waveformImage(
                        fromAudioAt: url,
                        with: .init(
                            size: waveImageView.bounds.size,
                            backgroundColor: DSColor.clear,
                            style: .striped(Waveform.Style.StripeConfig(
                                color: .systemBlue,
                                width: 2.5,
                                spacing: 1.5,
                                lineCap: .round)
                            ),
                            damping: .init(percentage: 0.2,
                                           sides: .right,
                                           easing: { x in pow(x, 4) }),
                            verticalScalingFactor: 2
                        ),
                        renderer: LinearWaveformRenderer()
                    )
                    completion(.success(image))
                } catch {
                    completion(.failure(error))
                }
            }
            
        }
}
