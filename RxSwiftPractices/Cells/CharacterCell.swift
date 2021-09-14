//
//  CharacterCell.swift
//  RxSwiftPractices
//
//  Created by 여나경 on 2021/09/12.
//

import UIKit
import SnapKit

class CharacterCell: UITableViewCell {
    
    static let identifier = "characterCell"

    var thumbnail: UIImageView?
    var nameLabel: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.initContent()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }

    /// UIImageView와 UILabel 위치 초기화
    func initContent() {
        guard let label = nameLabel, let imageView = thumbnail else { return }
        contentView.addSubview(label)
        contentView.addSubview(imageView)

        label.snp.makeConstraints {
//            $0.top.equalTo(contentView).offset(4)
            $0.top.equalTo(contentView).offset(4+15) // 21: cell간 간격
            $0.left.equalTo(contentView).offset(25)
            $0.right.equalTo(contentView).offset(-113)
//            $0.bottom.equalTo(contentView).offset(-30)
        }

        imageView.snp.makeConstraints {
//            $0.top.equalTo(contentView).offset(0)
            $0.top.equalTo(contentView).offset(15)
            $0.right.equalTo(contentView).offset(-25)
//            $0.bottom.equalTo(contentView).offset(0)
            $0.bottom.equalTo(contentView).offset(-15) // 21: cell간 간격
            $0.width.height.equalTo(78)
        }

        label.numberOfLines = 2 // TODO: 필요 없으면 제거
    }
}
