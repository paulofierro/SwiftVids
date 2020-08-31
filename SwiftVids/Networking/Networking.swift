//
//  Networking.swift
//  SwiftVids
//
//  Created by Paulo Fierro on 8/27/20.
//

import Foundation

extension String: Error {}

struct Networking {

    private let searchURL = "https://www.googleapis.com/youtube/v3/search"
    private let apiKey = "" // Sign up for an API key at https://developers.google.com/youtube/v3

    private func buildURL() -> URL {
        guard !apiKey.isEmpty else {
            fatalError("No API key found.")
        }
        
        var components = URLComponents(string: searchURL)
        components?.queryItems = [
            URLQueryItem(name: "key", value: apiKey), // Authenticate ourselves
            URLQueryItem(name: "q", value: "swift"), // Search for this term
            URLQueryItem(name: "part", value: "snippet"), // Get a snippet of details for each video
            URLQueryItem(name: "type", value: "video")
        ]

        guard let url = components?.url else {
            fatalError("Could not create URL")
        }
        return url
    }

    func loadData(completionHandler: @escaping (Result<SearchItems, Error>) -> Void) {
        let url = buildURL()

        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            // The result object
            var result: Result<SearchItems, Error>

            // Ensure that results are always returned on the main thread.
            defer {
                DispatchQueue.main.async {
                    completionHandler(result)
                }
            }

            if let error = error {
                result = .failure("Could not load data: \(error.localizedDescription)")
                return
            }

            guard let data = data else {
                result = .failure("No data received.")
                return
            }

            do {
                let apiData = try JSONDecoder().decode(SearchItems.self, from: data)
                result = .success(apiData)
            } catch {
                result = .failure("Could not parse response: \(error)")
            }
        }
        task.resume()
    }
}
