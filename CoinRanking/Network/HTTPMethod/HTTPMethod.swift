//
//  HTTPMethod.swift
//  CoinRanking
//
//  Created by Amol Prakash on 19/01/25.
//

import Foundation

/// An enumeration representing the various HTTP methods used in network requests.
///
/// `HTTPMethod` is a simple enumeration that defines the most common HTTP methods
/// for interacting with RESTful APIs. These methods dictate the type of operation
/// being performed in the context of a web request, such as retrieving data, sending
/// data, updating resources, or deleting data.
///
/// This enum is typically used in the context of building HTTP requests, specifying
/// the type of operation to be executed by the server.
enum HTTPMethod: String {
    
    /// The `GET` method is used to retrieve data from the server.
    ///
    /// The GET method is safe and idempotent, meaning that it should not modify
    /// any server state and multiple identical requests should have the same result.
    case GET
    
    /// The `POST` method is used to send data to the server, often resulting in
    /// the creation of a new resource or triggering an action on the server.
    ///
    /// POST requests typically include data in the request body and may modify
    /// the state of the server.
    case POST
    
    /// The `PUT` method is used to update an existing resource on the server.
    ///
    /// PUT requests typically include data in the request body that should
    /// replace the current representation of the resource identified by the URL.
    case PUT
    
    /// The `DELETE` method is used to delete a resource from the server.
    ///
    /// DELETE requests typically remove the resource identified by the URL.
    case DELETE
    
    /// The `PATCH` method is used to make partial updates to an existing resource.
    ///
    /// PATCH requests typically send only the data that should be modified, unlike PUT,
    /// which replaces the entire resource. PATCH requests are often used for smaller updates.
    case PATCH
}
