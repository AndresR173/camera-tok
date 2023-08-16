//
//  VideoMetadataView.swift
//  CameraTok
//
//  Created by Andres Rojas on 16/08/23.
//

import SwiftUI
import MapKit

struct VideoMetadataView: View {
    let metadata: VideoAsset.Metadata
    

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                if let date = metadata.creationDate {
                    Text(date, style: .date)
                }

                if let time = formatTimeInterval(100) {
                    HStack(spacing: 8) {
                        Text("Duration")
                        Text(time)
                    }
                }
                if let location = metadata.location {
                    Map(
                        coordinateRegion: .constant(
                            .init(
                                center: location.coordinate,
                                span: MKCoordinateSpan(
                                    latitudeDelta: 0.5,
                                    longitudeDelta: 0.5
                                )
                            )
                        )
                    )
                    .frame(
                        minWidth: 200,
                        maxWidth: 500,
                        minHeight: 300,
                        maxHeight: 300
                    )
                }
            }
            Spacer()
        }
        .padding(.all)
    }

    func formatTimeInterval(_ timeInterval: TimeInterval) -> String? {

        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.maximumUnitCount = 2
        formatter.unitsStyle = .abbreviated
        formatter.zeroFormattingBehavior = .pad

        return formatter.string(from: timeInterval)
    }
}

struct VideoMetadataView_Previews: PreviewProvider {
    static var previews: some View {
        VideoMetadataView(
            metadata: .init(
                location: nil,
                creationDate: .now,
                duration: 10_450.0
            )
        )
    }
}
