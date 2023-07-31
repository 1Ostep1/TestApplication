//
//  AddTaskViewController.swift
//  TestApp
//
//  Created by Ramazan Iusupov on 26/7/23.
//

import UIKit

class AddTaskViewController: BaseViewController {

    private let containerView = UIView()
    private let eventTitleLabel = TextFieldWithHeader(headerTitle: "Event Title")
    private let dateTitleLabel = TextFieldWithHeader(headerTitle: "Date", type: .date(Date()))
    private let timeTitleLabel = TextFieldWithHeader(headerTitle: "Time", type: .time(Date()))
    
    private var task: Task? = nil
    
    init(task: Task?) {
        self.task = task
        super.init(nibName: nil, bundle: nil)
    }
    
    convenience init() {
        self.init(task: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func loadView() {
        super.loadView()
        setup()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureFields()
    }
    
    private func configureFields() {
        eventTitleLabel.delegate = self
        dateTitleLabel.delegate = self
        timeTitleLabel.delegate = self
        if let title = task?.title {
            eventTitleLabel.textfield.text = title
        }
        
        if let date = task?.creationDate?.format(format: .yyyyMMMMdd) {
            dateTitleLabel.textfield.text = date
        }
        
        if let time = task?.creationTime?.format(format: .hhmm) {
            timeTitleLabel.textfield.text = time
        }
    }
    
    private func setup() {
        view.backgroundColor = .white
        title = "Events Calendar"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .done, target: self, action: #selector(addTaskTapped))
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = .white
        view.addSubview(containerView)
        containerView.addSubview(eventTitleLabel)
        containerView.addSubview(dateTitleLabel)
        containerView.addSubview(timeTitleLabel)
        
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.Sizes.padding12),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.Sizes.padding12),
            containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.Sizes.padding12),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: Constants.Sizes.padding12),
            
            eventTitleLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
            eventTitleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            eventTitleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            
            dateTitleLabel.topAnchor.constraint(equalTo: eventTitleLabel.bottomAnchor, constant: Constants.Sizes.padding8),
            dateTitleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            dateTitleLabel.trailingAnchor.constraint(equalTo: timeTitleLabel.leadingAnchor, constant: -Constants.Sizes.padding8),
            
            timeTitleLabel.topAnchor.constraint(equalTo: eventTitleLabel.bottomAnchor, constant: Constants.Sizes.padding8),
            timeTitleLabel.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.3),
            timeTitleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        ])
    }
    
    @objc
    private func addTaskTapped() {
        guard task != nil else {
            return
        }
        DataManager.shared.save()
        navigationController?.popViewController(animated: true)
    }
}

extension AddTaskViewController: TextFieldWithHeaderDelegate {
    func textDidChange(_ type: TextFieldWithHeader.FieldType) {
        switch type {
        case .default(let text):
            task?.setValue(text, forKey: #keyPath(Task.title))
        case .date(let date):
            task?.setValue(date, forKey: #keyPath(Task.creationDate))
        case .time(let time):
            task?.setValue(time, forKey: #keyPath(Task.creationTime))
        }
    }
}
