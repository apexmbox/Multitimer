//
//  TimerTableViewCell.swift
//  MultiTimer
//
//  Created by Apex on 12.07.2021.
//

import UIKit

class TimerTableViewCell: UITableViewCell {

    let smallFontSize: CGFloat = 15
    let borderOffset: CGFloat = 20
    let verticalOffset: CGFloat = 10
    let pauseButtonOffset: CGFloat = 10
    let pauseButtonWidth: CGFloat = 25
    
    var handler: ((Int)->())?
    private var timer: Timer?
    private var counter = 100 {
        didSet {
            DispatchQueue.main.async {
                self.timerDurationLabel.text = String().secondsToTimeStamp(self.counter)
                self.handler?(self.counter)
            }
        }
    }
    
    lazy var timerNameLabel: UILabel = {
            let label = UILabel()
            formatLabel(label)
            return label
    }()
    
    lazy var timerDurationLabel: UILabel = {
        let label = UILabel()
        formatLabel(label)
        label.textAlignment = .right
        return label
    }()
    
    lazy var pauseButtonLabel: UILabel = {
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
    
    func configure(with counter: Int) {
        self.counter = counter
        self.setTimer()
    }
    
    private func setTimer() {
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: {[weak self] (timer) in
            if let counter = self?.counter, counter > 0 {
                self?.counter -= 1
            } else {
                timer.invalidate()
            }
        })
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(timerNameLabel)
        self.contentView.addSubview(timerDurationLabel)
        self.contentView.addSubview(pauseButtonLabel)
        
        timerNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: borderOffset).isActive = true
        timerNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: verticalOffset).isActive = true
        timerNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -verticalOffset).isActive = true
        timerNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -contentView.frame.midX).isActive = true
        
        pauseButtonLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -borderOffset / 2).isActive = true
        pauseButtonLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: verticalOffset).isActive = true
        pauseButtonLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -verticalOffset).isActive = true
        pauseButtonLabel.widthAnchor.constraint(equalToConstant: pauseButtonWidth).isActive = true
        
        timerDurationLabel.trailingAnchor.constraint(equalTo: pauseButtonLabel.leadingAnchor, constant: -pauseButtonOffset).isActive = true
        timerDurationLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: verticalOffset).isActive = true
        timerDurationLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -verticalOffset).isActive = true
        timerDurationLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: contentView.frame.midX).isActive = true
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
