//
//  AccountViewController.swift
//  MyFaceTime
//
//  Created by Saurabh Jaiswal on 19/11/24.
//

import UIKit
import Combine
import StreamVideo
import StreamVideoSwiftUI
import StreamVideoUIKit

class AccountViewController: UIViewController {
    
    private var cancellables = Set<AnyCancellable>()
    
    private var activeCallView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Account"
        view.backgroundColor = .systemGreen
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Sign Out", style: .done, target: self, action: #selector(signOut))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Join Call", style: .done, target: self, action: #selector(joinCall))
    }
    
    @objc private func signOut() {
        let alert = UIAlertController(title: "Sign Out", message: "Are you sure you want to sign out?", preferredStyle: .alert)
        alert.addAction(.init(title: "Cancel", style: .cancel))
        alert.addAction(.init(title: "Sign Out", style: .destructive, handler: { _ in
            AuthManager.shared.signOut()
            let vc = UINavigationController(rootViewController: WelcomeViewController())
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
        }))
        present(alert, animated: true)
    }
    
    @objc private func joinCall() {
        guard let callViewModel = CallManager.shared.callViewModel else { return }
        // Join Call
         callViewModel.joinCall(callType: .default, callId: "default_a7fb26ac-263c-4d4d-8c4a-61b11f6c6b53")
        // Start Call
        // callViewModel.startCall(callType: .default, callId: UUID().uuidString, members: [])
        showCallUI()
    }
    
    private func listenForIncomingCall() {
        guard let callViewModel = CallManager.shared.callViewModel else { return }
        callViewModel.$callingState.sink { [weak self] state in
            switch state {
            case .incoming(_):
                DispatchQueue.main.async {
                    self?.showCallUI()
                }
            case .idle:
                DispatchQueue.main.async {
                    self?.hideCallUI()
                }
            default:
                break
            }
        }
        .store(in: &cancellables)
    }
    
    // UI Util
    
    private func showCallUI() {
        guard let callViewModel = CallManager.shared.callViewModel else { return }
        let callVC = CallViewController.make(with: callViewModel)
        view.addSubview(callVC.view)
        callVC.view?.bounds = view.bounds
        activeCallView = callVC.view
    }
    
    private func hideCallUI() {
        activeCallView?.removeFromSuperview()
        
    }

}
