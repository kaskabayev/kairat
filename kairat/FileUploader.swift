//
//  FileUploader.swift
//
//  Copyright (c) 2015 Narciso Cerezo Jiménez. All rights reserved.
//  Largely based on this stackoverflow question: http://stackoverflow.com/questions/26121827/uploading-file-with-parameters-using-alamofire/28467829//

import Foundation
import Alamofire

private struct FileUploadInfo {
    var name:String
    var mimeType:String
    var fileName:String
    var url:NSURL?
    var data:NSData?
    
    init( name: String, withFileURL url: NSURL, withMimeType mimeType: String? = nil ) {
        self.name = name
        self.url = url
        self.fileName = name
        self.mimeType = "application/octet-stream"
        if mimeType != nil {
            self.mimeType = mimeType!
        }
        if let _name = url.lastPathComponent {
            fileName = _name
        }
        if mimeType == nil, let _extension = url.pathExtension {
            switch _extension.lowercased() {
                
            case "jpeg", "jpg":
                self.mimeType = "image/jpeg"
                
            case "png":
                self.mimeType = "image/png"
                
            default:
                self.mimeType = "application/octet-stream"
            }
        }
    }
    
    init( name: String, withData data: NSData, withMimeType mimeType: String ) {
        self.name = name
        self.data = data
        self.fileName = "\(name).jpg"
        self.mimeType = mimeType
    }
}

class FileUploader {
    
    private var parameters = [String:String]()
    private var files = [FileUploadInfo]()
    private var headers = [String:String]()
    
    func setValue( value: String, forParameter parameter: String ) {
        parameters[parameter] = value
    }
    
    func setValue( value: String, forHeader header: String ) {
        headers[header] = value
    }
    
    func addParametersFrom( map: [String:String] ) {
        for (key,value) in map {
            parameters[key] = value
        }
    }
    
    func addHeadersFrom( map: [String:String] ) {
        for (key,value) in map {
            headers[key] = value
        }
    }
    
    func addFileURL( url: NSURL, withName name: String, withMimeType mimeType:String? = nil ) {
        files.append( FileUploadInfo( name: name, withFileURL: url, withMimeType: mimeType ) )
    }
    
    func addFileData( data: NSData, withName name: String, withMimeType mimeType:String = "application/octet-stream" ) {
        files.append( FileUploadInfo( name: name, withData: data, withMimeType: mimeType ) )
    }
    
    func uploadFile( request sourceRequest: NSURLRequest)->UploadRequest?{
        let request = sourceRequest.mutableCopy() as! NSMutableURLRequest
        request.httpMethod="POST"
        let boundary = "FileUploader-boundary-\(arc4random())-\(arc4random())"
        request.setValue( "multipart/form-data;boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        let data = NSMutableData()
        
        for (name, value) in headers {
            request.setValue(value, forHTTPHeaderField: name)
        }
        
        // Amazon S3 (probably others) wont take parameters after files, so we put them first
        for (key, value) in parameters {
            data.append("\r\n--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
            data.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n\(value)".data(using: String.Encoding.utf8)!)
        }
        
        for fileUploadInfo in files {
            data.append( "\r\n--\(boundary)\r\n".data(using: String.Encoding.utf8)! )
            data.append( "Content-Disposition: form-data; name=\"\(fileUploadInfo.name)\"; filename=\"\(fileUploadInfo.fileName)\"\r\n".data(using: String.Encoding.utf8)!)
            data.append( "Content-Type: \(fileUploadInfo.mimeType)\r\n\r\n".data(using: String.Encoding.utf8)!)
            if fileUploadInfo.data != nil {
                data.append( fileUploadInfo.data! as Data )
            }
            else if fileUploadInfo.url != nil, let fileData = NSData(contentsOf: fileUploadInfo.url! as URL) {
                data.append( fileData as Data )
            }
            else { // ToDo: report error
                return nil
            }
        }
        data.append("\r\n--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)
        return Alamofire.upload(data as Data, with: request as URLRequest)
    }
}
