//
//  RecipePdf.swift
//  EasyMeals
//
//  Created by Максим on 3/27/19.
//  Copyright © 2019 Yobibyte. All rights reserved.
//

import Foundation

class RecipePDF: Codable {
    let downloadLink: String?
    
    enum CodingKeys: String, CodingKey {
        case downloadLink = "download_link"
    }
    
    init(downloadLink: String?) {
        self.downloadLink = downloadLink
    }
}

// MARK: Convenience initializers and mutators

extension RecipePDF {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(RecipePDF.self, from: data)
        self.init(downloadLink: me.downloadLink)
    }
    
    convenience init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
    
    convenience init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }
    
    func with(
        downloadLink: String?? = nil
        ) -> RecipePDF {
        return RecipePDF(
            downloadLink: downloadLink ?? self.downloadLink
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

fileprivate func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        decoder.dateDecodingStrategy = .iso8601
    }
    return decoder
}

fileprivate func newJSONEncoder() -> JSONEncoder {
    let encoder = JSONEncoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        encoder.dateEncodingStrategy = .iso8601
    }
    return encoder
}
