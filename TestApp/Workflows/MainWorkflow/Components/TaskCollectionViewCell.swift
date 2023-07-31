//
//  TaskCollectionViewCell.swift
//  TestApp
//
//  Created by Ramazan Iusupov on 25/7/23.
//

import UIKit
import SwipeCellKit

class TaskCollectionViewCell: SwipeCollectionViewCell {
    static let reuseId = String(describing: TaskCollectionViewCell.self)
    
    private var isTodayIndicator: UIView = {
        let view = UIView()
        view.backgroundColor = Constants.Color.blueColor
        view.layer.cornerRadius = Constants.Corners.standartCorner
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var titleLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .systemFont(ofSize: Constants.FontSize.font16, weight: .medium)
        view.textColor = .black
        return view
    }()
    
    private var timeLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .systemFont(ofSize: Constants.FontSize.font12, weight: .medium)
        view.textColor = .black
        view.textAlignment = .right
        return view
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }
    
    private func setup() {
        backgroundColor = Constants.Color.redColor
        layer.cornerRadius = Constants.Corners.corner16
        
        addSubview(isTodayIndicator)
        addSubview(titleLabel)
        addSubview(timeLabel)
        
        NSLayoutConstraint.activate([
            isTodayIndicator.topAnchor.constraint(equalTo: topAnchor, constant: Constants.Sizes.padding8),
            isTodayIndicator.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.Sizes.padding8),
            isTodayIndicator.widthAnchor.constraint(equalToConstant: Constants.Sizes.padding4),
            isTodayIndicator.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.Sizes.padding8),
            
            titleLabel.centerYAnchor.constraint(equalTo: isTodayIndicator.centerYAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: isTodayIndicator.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: isTodayIndicator.trailingAnchor, constant: Constants.Sizes.padding8),
            titleLabel.bottomAnchor.constraint(equalTo: isTodayIndicator.bottomAnchor, constant: Constants.Sizes.padding8),
            titleLabel.trailingAnchor.constraint(greaterThanOrEqualTo: timeLabel.leadingAnchor),
            
            timeLabel.centerYAnchor.constraint(equalTo: isTodayIndicator.centerYAnchor),
            timeLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 156),
            timeLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.Sizes.padding16)
        ])
    }
    
    func display(item: Task) {
        isTodayIndicator.isHidden = item.creationDate == nil || !Calendar.current.isDateInToday(item.creationDate!)
        
        titleLabel.text = item.title
        timeLabel.text = item.creationTime?.format(format: .hhmm) ?? item.creationDate?.format(format: .hhmm)
    }
}
