//
//  TimerTableViewFirstCell.swift
//  MultiTimer
//
//  Created by Apex on 13.07.2021.
//

import UIKit

class TimerTableViewFirstCell: UITableViewCell {

    let smallFontSize: CGFloat = 15
    let borderOffset: CGFloat = 20
    let verticalOffset: CGFloat = 10
    
    lazy var timerTableFirstCellText: UILabel = {
            let label = UILabel()
            formatLabel(label)
            return label
    }()
    
    func formatLabel(_ label: UILabel) {
        label.font = UIFont.systemFont(ofSize: smallFontSize)
        label.textColor =  #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(timerTableFirstCellText)
        self.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
        timerTableFirstCellText.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: borderOffset).isActive = true
        timerTableFirstCellText.topAnchor.constraint(equalTo: contentView.topAnchor, constant: verticalOffset).isActive = true
        timerTableFirstCellText.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -verticalOffset).isActive = true
        timerTableFirstCellText.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -contentView.frame.midX).isActive = true
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

