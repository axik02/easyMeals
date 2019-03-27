//
//  File.swift
//  EasyMeals
//
//  Created by Максим on 3/18/19.
//  Copyright © 2019 Yobibyte. All rights reserved.
//

import Foundation

class File: Codable {
    let fileData: FileData?
    
    enum CodingKeys: String, CodingKey {
        case fileData = "data"
    }
    
    init(fileData: FileData?) {
        self.fileData = fileData
    }
}

class FileData: Codable {
    let filesid: Int?
    let filename: String?
    
    enum CodingKeys: String, CodingKey {
        case filesid = "files_id"
        case filename = "filename"
    }
    
    init(filesid: Int?, filename: String?) {
        self.filesid = filesid
        self.filename = filename
    }
}

// MARK: Convenience initializers and mutators

extension File {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(File.self, from: data)
        self.init(fileData: me.fileData)
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
        fileData: FileData?? = nil
        ) -> File {
        return File(
            fileData: fileData ?? self.fileData
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension FileData {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(FileData.self, from: data)
        self.init(filesid: me.filesid, filename: me.filename)
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
        filesid: Int?? = nil,
        filename: String?? = nil
        ) -> FileData {
        return FileData(
            filesid: filesid ?? self.filesid,
            filename: filename ?? self.filename
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
