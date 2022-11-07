//
//  DownloadManager.swift
//  Pumpy Music iOS
//
//  Created by Jack Vanderpump on 28/06/2020.
//  Copyright © 2020 Jack Vanderpump. All rights reserved.
//

import Foundation

class FileDownloader {

    static func loadFileAsync(url: URL, completion: @escaping (URL?, Error?) -> Void) {
        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let destinationUrl = documentsUrl.appendingPathComponent(url.lastPathComponent)
        print(documentsUrl)
        
        if FileManager().fileExists(atPath: destinationUrl.path) {
            print("File already exists [\(destinationUrl.path)]")
            completion(destinationUrl, nil)
        } else {
            let configuration = URLSessionConfiguration.default
            let operationQueue = OperationQueue()
            let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: operationQueue)
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            let task = session.dataTask(with: request, completionHandler: { data, response, error in
                if error == nil {
                    if let response = response as? HTTPURLResponse {
                        if response.statusCode == 200 {
                            if let data = data {
                                if let _ = try? data.write(to: destinationUrl, options: Data.WritingOptions.atomic) {
                                    completion(destinationUrl, error)
                                } else {
                                    completion(destinationUrl, error)
                                }
                            } else {
                                completion(destinationUrl, error)
                            }
                        }
                    }
                } else {
                    completion(destinationUrl, error)
                }
            })
            task.resume()
        }
    }
}

extension FileManager {
    func urls(for directory: FileManager.SearchPathDirectory, skipsHiddenFiles: Bool = true ) -> [URL]? {
        let documentsURL = urls(for: directory, in: .userDomainMask)[0]
        let fileURLs = try? contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil, options: skipsHiddenFiles ? .skipsHiddenFiles : [] )
        return fileURLs
    }
}
