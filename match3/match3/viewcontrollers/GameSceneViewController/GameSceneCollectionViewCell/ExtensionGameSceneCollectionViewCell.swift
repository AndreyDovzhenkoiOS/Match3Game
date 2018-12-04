//
//  ExtensionGameSceneCollectionViewCell.swift
//  Match3
//
//  Created by Andrey on 21.03.2018.
//  Copyright © 2018 Andrey Dovzhenko. All rights reserved.
//

import UIKit
extension GameSceneCollectionViewCell{
    public func allNotification(){
        self.addNotification(notificationName: Notifications.notificationNameSwap)
        self.addNotification(notificationName: Notifications.notificationNameMatch)
    }
    
    public func getImage()->UIImage {
        let imageDefault = ManagerGame.sharedInstance.getImage(type: (modelCell?.type)!, isClick: false)
        let imageClick = ManagerGame.sharedInstance.getImage(type: (modelCell?.type)!, isClick: true)
        
        if (modelCell?.click)! {
            return imageClick
        }else{
            return imageDefault
        }
    }
    
    private func addNotification(notificationName:Notification.Name){
        NotificationCenter.default.addObserver(self, selector: #selector(updateModelCell(notification:)), name: notificationName, object: nil)
    }
    
    @objc func updateModelCell(notification:Notification){
        if let currentModelCell = notification.object as? ModelCell {
            if self.modelCell == currentModelCell{
                self.modelCell = currentModelCell
                if notification.name == Notifications.notificationNameMatch{
                    self.hideAnimate()
                }
            }
        }
    }
    
    private func hideAnimate(){
        UIView.animate(withDuration:0.8) {
            self.alpha = 0
        }
    }
}
