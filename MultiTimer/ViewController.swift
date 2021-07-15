//
//  ViewController.swift
//  MultiTimer
//
//  Created by Apex on 12.07.2021.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let timerModel = TimerModel()
    var updateTimer: Timer!
    
    let borderOffset: CGFloat = 20
    let topBorderOffset: CGFloat = 0
    let navigationBarHeight: CGFloat = 90
    let textFieldHeight: CGFloat = 30
    let elementsOffset: CGFloat = 15
    let smallFontSize: CGFloat = 15
    let regularFontSize: CGFloat = 20
    
    let containerView = UIView()
    var navigationBar = UINavigationBar()
   
    lazy var addTimerLabel: PaddingLabel = {
        let label = PaddingLabel()
        label.text = "Добавление таймеров"
        formatLabel(label)
        return label
    }()
    
    lazy var timerNameTextField: UITextField = {
        let textField = UITextField()
        formatTextField(textField, withDefaultText: "Название таймера")
        return textField
    }()
    
    lazy var timerDurationTextField: UITextField = {
        let textField = UITextField()
        textField.keyboardType = .numberPad
        formatTextField(textField, withDefaultText: "Время в секундах")
        return textField
    }()
    
    lazy var addTimerButton: UIButton = {
        let button = UIButton()
        button.setTitle("Добавить", for: .normal)
        formatButton(button)
        button.addTarget(self, action: #selector(addTimerDown(sender:)), for: [.touchDown, .touchDragEnter])
        button.addTarget(self, action: #selector(addTimerUp(sender:)), for: [.touchUpInside, .touchCancel, .touchDragExit])
        return button
    }()
    
    lazy var timersTable: UITableView = {
        let table = UITableView()
        table.dataSource = self
        formatTableView(table)
        return table
    }()
    
    private func formatLabel(_ label: PaddingLabel) {
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = #colorLiteral(red: 0.9576454759, green: 0.9578056931, blue: 0.9576243758, alpha: 1)
        label.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        label.font = .systemFont(ofSize: smallFontSize)
        label.leftInset = borderOffset
        label.topInset = borderOffset
        label.bottomInset = borderOffset / 2
    }
    
    private func formatTextField(_ textField: UITextField, withDefaultText text: String) {
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.attributedPlaceholder = NSAttributedString(string: text, attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        textField.borderStyle = .roundedRect
        textField.font = .systemFont(ofSize: smallFontSize)
    }
    
    private func formatButton(_ button: UIButton) {
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = #colorLiteral(red: 0.9105809927, green: 0.9107337594, blue: 0.9105609059, alpha: 1)
        button.setTitleColor(.systemBlue, for: .normal)
        button.layer.cornerRadius = 10
        button.titleLabel?.font = .systemFont(ofSize: regularFontSize)
    }
    
    private func formatTableView(_ table: UITableView) {
        table.translatesAutoresizingMaskIntoConstraints = false
    }
    
    @objc func addTimerDown(sender: UIButton) {
        animate(sender, transform: CGAffineTransform.identity.scaledBy(x: 0.95, y: 0.95))
    }
    
    @objc func addTimerUp(sender: UIButton) {
        animate(sender, transform: .identity)
        if timerDurationTextField.text != nil, timerDurationTextField.text!.isInt {
            if timerNameTextField.text != nil, !timerNameTextField.text!.isEmpty {
                timerModel.addTimer(name: timerNameTextField.text!, duration: Double(timerDurationTextField.text!)!)
                timerModel.timers.sort() {$0.estimatedTime > $1.estimatedTime}
            }
        }
    }
    
    private func animate(_ button: UIButton, transform: CGAffineTransform) {
        UIView.animate(withDuration: 0.2,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 3,
                       options: [.curveEaseInOut],
                       animations: { button.transform = transform },
                       completion: nil)
    }
    
    @objc func updateTimers() {
        for index in 0..<timerModel.timers.count {
            if timerModel.timers[index].timer.isValid {
                timerModel.timers[index].estimatedTime -= Date().timeIntervalSince(timerModel.timers[index].startTime)
                if timerModel.timers[index].estimatedTime <= 0 {
                    timerModel.timers[index].timer.invalidate()
                }
                timerModel.timers[index].startTime = Date()
            }
            if !timerModel.timers[index].timer.isValid && Int(timerModel.timers[index].estimatedTime) <= 0 {
                if self.presentedViewController != nil {
                    self.dismiss(animated: true, completion: nil)
                }
                let alertController = UIAlertController(title: timerModel.timers[index].name, message: "Время вышло.", preferredStyle: .alert)
                let yesAction = UIAlertAction(title: "Ok", style: .default) { _ in }
                alertController.addAction(yesAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
        timerModel.removeInactiveTimers()
        timersTable.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        self.updateTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [self]updateTimer in updateTimers()
        }
        
        timersTable.register(TimerTableViewFirstCell.self, forCellReuseIdentifier: "timerFirstCell")
        timersTable.register(TimerTableViewCell.self, forCellReuseIdentifier: "timerCell")
        timersTable.delegate = self
        timersTable.keyboardDismissMode = .interactive
            
        setUpNavigation()
        view.addSubview(navigationBar)
        view.addSubview(containerView)
 
        containerView.addSubviews([
            addTimerLabel,
            timerNameTextField,
            timerDurationTextField,
            addTimerButton,
            timersTable
        ])

        containerView.edgesToSuperView(edges: [.bottom, .right, .left])
        containerView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: 0).isActive = true
        
        autoLayout()
    }
    
    private func autoLayout() {
        NSLayoutConstraint.activate([
            navigationBar.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0),
            navigationBar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
            navigationBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
            navigationBar.bottomAnchor.constraint(equalTo: self.view.topAnchor, constant: navigationBarHeight),
            
            addTimerLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: topBorderOffset),
            addTimerLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 0),
            addTimerLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: 0),
            
            timerNameTextField.topAnchor.constraint(equalTo: addTimerLabel.bottomAnchor, constant: elementsOffset),
            timerNameTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: borderOffset),
            timerNameTextField.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -borderOffset),
                        
            timerDurationTextField.topAnchor.constraint(equalTo: timerNameTextField.bottomAnchor, constant: elementsOffset),
            timerDurationTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: borderOffset),
            timerDurationTextField.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -borderOffset),
            
            addTimerButton.topAnchor.constraint(equalTo: timerDurationTextField.bottomAnchor, constant: elementsOffset),
            addTimerButton.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: borderOffset),
            addTimerButton.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -borderOffset),
            addTimerButton.heightAnchor.constraint(equalToConstant: 50),
            
            timersTable.topAnchor.constraint(equalTo: addTimerButton.bottomAnchor, constant: elementsOffset),
            timersTable.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: borderOffset),
            timersTable.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -borderOffset),
            timersTable.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -borderOffset)
        ])
    }
    
    func setUpNavigation() {
        navigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: navigationBarHeight))
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        
        let navigationItem = UINavigationItem(title: "Мультитаймер")
        navigationBar.setItems([navigationItem], animated: false)
        navigationBar.barTintColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timerModel.getAllTimers().count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "timerFirstCell", for: indexPath) as! TimerTableViewFirstCell
            cell.timerTableFirstCellText.text = "Таймеры"
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "timerCell", for: indexPath) as! TimerTableViewCell
            cell.timerNameLabel.text = timerModel.timers[indexPath.row - 1].name
            cell.configure(with: Int(timerModel.timers[indexPath.row - 1].estimatedTime))
            cell.pauseButtonLabel.text = timerModel.timers[indexPath.row - 1].timer.isValid ? "⏸" : "▶️"
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row > 0 {
            if timerModel.timers[indexPath.row - 1].timer.isValid {
                timerModel.timers[indexPath.row - 1].pause()
            } else {
                timerModel.timers[indexPath.row - 1].start()
            }
        }
    }

}



