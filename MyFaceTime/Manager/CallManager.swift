//
//  CallManager.swift
//  MyFaceTime
//
//  Created by Saurabh Jaiswal on 21/10/24.
//

import Foundation
import StreamVideo
import StreamVideoSwiftUI
import StreamVideoUIKit

class CallManager {
    static let shared = CallManager()
    
    struct Constants {
        static let userToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJodHRwczovL3Byb250by5nZXRzdHJlYW0uaW8iLCJzdWIiOiJ1c2VyL01hY2VfV2luZHUiLCJ1c2VyX2lkIjoiTWFjZV9XaW5kdSIsInZhbGlkaXR5X2luX3NlY29uZHMiOjYwNDgwMCwiaWF0IjoxNzI5NTE1Nzk1LCJleHAiOjE3MzAxMjA1OTV9.kiCIK5xnvJlUIjX8wu5cGamCSfQ5_R6P0NGNJUrWEss"
    }
    
    private var video: StreamVideo?
    private var videoUI: StreamVideoUI?
    public private(set) var callViewModel: CallViewModel?
    
    struct UserCredentials {
        let user: User
        let token: UserToken
    }
    
    func setUp(email: String) {
        setUpCallViewModel()
        // UserCredentials
        let credential = UserCredentials(
            user: .guest(email),
            token: UserToken(rawValue: Constants.userToken)
        )
        // StreamVideo
        let video = StreamVideo(
            apiKey: "",
            user: credential.user,
            token: credential.token) { result in
            // Refresh token via real backend
            result(.success(credential.token))
        }
        // StreamVideoUI
        let videoUI = StreamVideoUI(streamVideo: video)
        
        self.video = video
        self.videoUI = videoUI
    }
    
    private func setUpCallViewModel() {
        guard callViewModel == nil else { return }
        DispatchQueue.main.async {
            self.callViewModel = CallViewModel()
        }
    }
}
