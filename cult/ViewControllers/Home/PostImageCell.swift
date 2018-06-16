//
//  PostImageCell.swift
//  Cult
//
//  Created by iOS Developer on 6/12/18.
//  Copyright © 2018 Han. All rights reserved.
//

import Foundation
import UIKit

class PostImageCell: UITableViewCell {
    
    @IBOutlet weak var view_post: UIView!
    
    @IBOutlet weak var img_profile: UIImageView!
    @IBOutlet weak var img_type: UIImageView!
    @IBOutlet weak var label_name: UILabel!
    @IBOutlet weak var label_time: UILabel!
    @IBOutlet weak var label_content: UILabel!
    @IBOutlet weak var img_post: UIImageView!
    @IBOutlet weak var btn_view: RadiusButtonGradient!
    @IBOutlet weak var btn_reply: RadiusButtonGradient!
    @IBOutlet weak var btn_cheer: RadiusButtonGradient!

    override func layoutSubviews() {
        btn_reply.gradientLayer.frame = btn_reply.bounds
        btn_view.gradientLayer.frame = btn_view.bounds
        let maskPath = UIBezierPath(roundedRect: img_post.bounds,
                                    byRoundingCorners: [.bottomLeft, .topRight],
                                    cornerRadii: CGSize(width: 15.0, height: 15.0))
        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        img_post.layer.mask = shape        
        img_profile.layer.cornerRadius = img_profile.frame.size.width / 2
        img_profile.clipsToBounds = true
    }
}
