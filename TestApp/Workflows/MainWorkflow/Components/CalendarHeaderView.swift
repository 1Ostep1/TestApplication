//
//  CalendarHeaderView.swift
//  TestApp
//
//  Created by Ramazan Iusupov on 26/7/23.
//

import UIKit
import FSCalendar

protocol CalendarHeaderViewDelegate: AnyObject {
    func didSelectAt(date: Date)
    func deselectDate()
}

class CalendarHeaderView: UICollectionReusableView {
    static let reuseId = String(describing: CalendarHeaderView.self)
    
    private let calendarView: FSCalendar = {
        let view = FSCalendar()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Constants.Color.redColor
        view.layer.cornerRadius = Constants.Corners.corner16
        view.appearance.caseOptions = .headerUsesCapitalized
        view.appearance.headerDateFormat = "MMMM YYYY"
        view.appearance.headerTitleColor = .black
        view.appearance.selectionColor = Constants.Color.blueColor
        view.appearance.weekdayTextColor = .black
        view.appearance.todayColor = Constants.Color.blueColor
        return view
    }()
    
    private var tasksCountByDate: [String: Int] = [:] {
        didSet {
            calendarView.reloadData()
        }
    }
    weak var delegate: CalendarHeaderViewDelegate?
   
    override func layoutSubviews() {
        super.layoutSubviews()
        calendarView.delegate = self
        calendarView.dataSource = self
        
        addSubview(calendarView)
        NSLayoutConstraint.activate([
            calendarView.topAnchor.constraint(equalTo: topAnchor),
            calendarView.bottomAnchor.constraint(equalTo: bottomAnchor),
            calendarView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.Sizes.padding16),
            calendarView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.Sizes.padding16)
        ])
    }
     
    func diplay(item: [String: Int]) {
        self.tasksCountByDate = item
    }
}

extension CalendarHeaderView: FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        delegate?.didSelectAt(date: date)
    }
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        delegate?.deselectDate()
    }
}

extension CalendarHeaderView: FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let stringDate = date.format(format: .yyyyMMMMdd)
        print(tasksCountByDate)
        if tasksCountByDate.keys.contains(stringDate) {
            return tasksCountByDate[stringDate]!
        }
        return .zero
    }
}
