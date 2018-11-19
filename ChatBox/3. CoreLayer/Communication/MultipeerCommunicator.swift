//
//  MultipeerCommunicator.swift
//  ChatBox
//
//  Created by Alexey Teplonogov on 25/10/2018.
//  Copyright © 2018 Alexey Teplonogov. All rights reserved.
//

import Foundation
import MultipeerConnectivity

protocol Communicator: class {
    var online: Bool? {get set}
    var delegate: ICommunicationService? {get set}
    func sendMessage(string: String, to userID: String, completionHandler:((_ success: Bool, _ error: Error?) -> Void)?)
    func startCommunication(name: String?)
}

class MultipeerCommunicator: NSObject, Communicator {
    
    static let shared = MultipeerCommunicator()

    var nearbyServiceAdvertiser: MCNearbyServiceAdvertiser!
    var nearbyServiceBrowser: MCNearbyServiceBrowser!
    var localPeerID: MCPeerID!

    var serviceType: String!
    var discoveryInfo: [String: String]!
    var online: Bool?
    weak var delegate: ICommunicationService?

    var sessions: [String: MCSession] = [:]

    
    func startCommunication(name: String?) {
        guard nearbyServiceBrowser != nil, nearbyServiceAdvertiser != nil else {
            return
        }
        
        discoveryInfo = ["userName": name ?? "noname: (\(UIDevice.current.model))"]
        serviceType = "tinkoff-chat"
        localPeerID = MCPeerID(displayName: UIDevice.current.name)
        
        nearbyServiceBrowser = MCNearbyServiceBrowser(peer: localPeerID, serviceType: serviceType)
        nearbyServiceAdvertiser = MCNearbyServiceAdvertiser(peer: localPeerID,
                                                            discoveryInfo: discoveryInfo,
                                                            serviceType: serviceType)
        
        nearbyServiceBrowser.delegate = self
        nearbyServiceAdvertiser.delegate = self
        
        online = true
        nearbyServiceAdvertiser.startAdvertisingPeer()
        nearbyServiceBrowser.startBrowsingForPeers()
    }

    func sendMessage(string: String, to userID: String, completionHandler: ((Bool, Error?) -> Void)?) {

        guard let session = sessions[userID] else {
            return
        }

        let messageDict = ["eventType": "TextMessage", "messageId": generateMessageID(), "text": string]

        guard let jsonObject = try? JSONSerialization.data(withJSONObject: messageDict, options: .prettyPrinted) else {
            return
        }

        do {
            try session.send(jsonObject, toPeers: session.connectedPeers, with: .reliable)
            delegate?.didReceiveMessage(text: string, fromUser: localPeerID.displayName, toUser: userID)
            if let completion = completionHandler {
                completion(true, nil)
            }
        } catch let error {
            if let completion = completionHandler {
                completion(false, error)
            }
        }
    }

    func generateMessageID() -> String {
        let date = Date.timeIntervalSinceReferenceDate
        let string = "\(arc4random_uniform(UINT32_MAX))+\(date)+\(arc4random_uniform(UINT32_MAX))"
            .data(using: .utf8)?.base64EncodedString()
        return string!
    }


    func getSession(peerID: MCPeerID) -> MCSession {

        if let session = sessions[peerID.displayName] {
            return session
        }

        let session = MCSession(peer: localPeerID, securityIdentity: nil, encryptionPreference: .none)
        session.delegate = self
        sessions[peerID.displayName] = session
        return session
    }

}

extension MultipeerCommunicator: MCSessionDelegate, MCNearbyServiceBrowserDelegate, MCNearbyServiceAdvertiserDelegate {

    // MARK: - MCSessionDelegate

    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case .connected:
            print("Connected to session: \(session)")

        case .connecting:
            print("Connecting to session: \(session)")

        case .notConnected:
            print("Did not connect to session: \(session)")
        }
    }

    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        let jsonDecoder = JSONDecoder()
        guard let info = try? jsonDecoder.decode([String: String].self, from: data),
            info["eventType"] == "TextMessage" else {
            return
        }
        delegate?.didReceiveMessage(text: info["text"]!, fromUser: peerID.displayName, toUser: localPeerID.displayName)
    }

    func session(_ session: MCSession,
                 didReceive stream: InputStream,
                 withName streamName: String,
                 fromPeer peerID: MCPeerID) {
        print(#function)
    }

    func session(_ session: MCSession,
                 didStartReceivingResourceWithName resourceName: String,
                 fromPeer peerID: MCPeerID,
                 with progress: Progress) {
        print(#function)
    }

    func session(_ session: MCSession,
                 didFinishReceivingResourceWithName resourceName: String,
                 fromPeer peerID: MCPeerID,
                 at localURL: URL?,
                 withError error: Error?) {
        print(#function)
    }

    // MARK: - MCNearbyServiceBrowserDelegate

    func browser(_ browser: MCNearbyServiceBrowser,
                 foundPeer peerID: MCPeerID,
                 withDiscoveryInfo info: [String: String]?) {

        guard let info = info, let userName = info["userName"] else {
            return
        }

        let session = getSession(peerID: peerID)
        browser.invitePeer(peerID, to: session, withContext: nil, timeout: 10)
        delegate?.didFoundUser(userId: peerID.displayName, userName: userName)
    }

    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        print("❗️\(#function)")
        delegate?.didLostUser(userId: peerID.displayName)
    }

    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        print("❗️\(#function)")
        delegate?.failedToStartBrowsingForUsers(error: error)
    }

    // MARK: - MCNearbyServiceAdvertiserDelegate

    func advertiser(_ advertiser: MCNearbyServiceAdvertiser,
                    didReceiveInvitationFromPeer peerID: MCPeerID,
                    withContext context: Data?,
                    invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        print(#function)
        let session = getSession(peerID: peerID)
        invitationHandler(true, session)
    }

    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        delegate?.failedToStartAdvertising(error: error)
        print("❗️\(#function)")
    }

}
