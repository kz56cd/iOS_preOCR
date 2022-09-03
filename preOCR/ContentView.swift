//
//  ContentView.swift
//  preOCR
//
//  Created by Masakazu Sano on 2022/09/03.
//

import SwiftUI
import Vision

struct ContentView: View {
    
    private let ocrRequest: VNRecognizeTextRequest
    private static let sampleUrl = URL(string: "https://user-images.githubusercontent.com/8345452/188253333-f8d5b424-1727-4bc8-8a74-ae0f6a2a2a8f.jpg")!
    
    // 仮で解析対象の画像URLを渡している
    // TODO: カメラ経由の映像を解析できるようにする
    private let handler = VNImageRequestHandler(url: sampleUrl)
    //    let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer)
    //    let handler = VNImageRequestHandler(cmSampleBuffer: sampleBuffer)
    
    var body: some View {
        VStack {
            Text("OCR sample")
            AsyncImage(url: ContentView.sampleUrl) { image in
                image.resizable()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 200, height: 300)
            .aspectRatio(contentMode: .fit)
            Spacer(minLength: 50)
            Button {
                self.startOCR()
            } label: {
                Text("start OCR")
                    .font(.largeTitle)
            }
            Spacer(minLength: 50)

        }
        .padding(10)
    }
    
    init() {
        ocrRequest = VNRecognizeTextRequest()
        ocrRequest.recognitionLanguages = ["ja-JP"]
    }
}

// MARK: - private
extension ContentView {
    private func startOCR() {
        do {
            try handler.perform([ocrRequest])
        } catch {
            print("[cannnot configure OCR request] ", error)
        }
        
        guard let observations = ocrRequest.results else { return }
        observations.forEach { observation in
            let box = observation.boundingBox // 位置のボックス
            let topCandidate = observation.topCandidates(1)
            if let recognizedText = topCandidate.first?.string { // 検出したテキスト
                print(recognizedText)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
