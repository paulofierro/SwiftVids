//
//  SearchItems.swift
//  SwiftVids
//
//  Created by Paulo Fierro on 8/27/20.
//

import Foundation

struct SearchItems: Decodable {
    let items: [VideoItem]
}

struct VideoItem: Decodable {
    private let id: Id
    private let snippet: Snippet

    var title: String {
        snippet.title
    }

    var description: String {
        snippet.description
    }

    var videoURL: URL? {
        URL(string: "https://youtube.com/watch?v=\(id.videoId)")
    }

    var thumbnail: URL? {
        URL(string: snippet.thumbnails.high.url)
    }

    struct Id: Decodable {
        let videoId: String
    }

    struct Snippet: Decodable {
        let title: String
        let description: String
        let thumbnails: Thumbnails

        struct Thumbnails: Decodable {
            let high: Thumbnail

            struct Thumbnail: Decodable {
                let url: String
            }
        }
    }
}
