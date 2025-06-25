//
//  NetBrowser.swift
//  Equilibrium
//
//  Created by Leo Wehrfritz on 23.06.25.
//

import Network
import Foundation
import OSLog

enum ZeroconfError: Error {
    case unexpectedServiceFound
}

@Observable
class ZeroconfBrowser {
    
    private static let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier!,
        category: String(describing: ZeroconfBrowser.self)
    )
    
    var discoveredServices: [DiscoveredService] = []
    
    var browser: NWBrowser?
    
    var error: Error?
    
    func startBrowsing() {
        
        let bonjourParms = NWParameters.init()
        bonjourParms.allowLocalEndpointReuse = true
        bonjourParms.acceptLocalOnly = true
        bonjourParms.allowFastOpen = true
        
        self.browser = NWBrowser(for: .bonjour(type: "_equilibrium._tcp", domain: nil), using: bonjourParms)
        
        browser?.stateUpdateHandler = { newState in
            switch newState {
            case .failed(let error):
                Self.logger.error("NW Browser: now in Error state: \(error, privacy: .public)")
                self.error = error
                self.browser?.cancel()
            case .ready:
                Self.logger.debug("Browser ready")
            case .setup:
                Self.logger.debug("Setting up browser...")
            default:
                break
            }
        }
        
        browser?.browseResultsChangedHandler = { ( results, changes ) in
            
            for change in changes {
                if case .added(let added) = change {
                    if case .service(let name,_,_,_) = added.endpoint {
                        
                        Self.logger.debug("Found service: \(name, privacy: .public)")
                        
                        let connection = NWConnection(to: added.endpoint, using: .tcp)
                        
                        connection.stateUpdateHandler = { state in
                            switch state {
                            case .ready:
                                if let innerEndpoint = connection.currentPath?.remoteEndpoint,
                                   case .hostPort(let host, let port) = innerEndpoint {
                                    switch host {
                                    case .name(let hostName, _):
                                        
                                        self.discoveredServices.append(DiscoveredService(name: name, host: hostName, port: Int(port.rawValue)))
                                    case .ipv4(let iPv4Address):
                                        self.discoveredServices.append(DiscoveredService(name: name, host: iPv4Address.debugDescription, port: Int(port.rawValue)))
                                    case .ipv6(let iPv6Address):
                                        self.discoveredServices.append(DiscoveredService(name: name, host: iPv6Address.debugDescription, port: Int(port.rawValue)))
                                        
                                    @unknown default:
                                        Self.logger.error("Received unexpected endpoint information")
                                        self.error = ZeroconfError.unexpectedServiceFound
                                    }
                                    connection.cancel()
                                }
                            default:
                                break
                            }
                        }
                        connection.start(queue: .global())
                    }
                }
                
                
                if case .removed(let removed) = change {
                    if case .service(let name,_,_,_) = removed.endpoint {
                        Self.logger.debug("Service removed: \(name, privacy: .public)")
                        let index = self.discoveredServices.firstIndex(where:{$0.name == name })
                        self.discoveredServices.remove(at: index!)
                    }
                }
            }
        }
        self.browser?.start(queue: DispatchQueue.main)
    }
    
    func stopBrowsing() {
        self.browser?.cancel()
        self.browser = nil
        Self.logger.debug("Stopped browser!")
    }
}
