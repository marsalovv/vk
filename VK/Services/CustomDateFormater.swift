
import Foundation

struct CustomDateFormatter {
    
    var dt: Int
    private var date: Date {
        Date(timeIntervalSince1970: TimeInterval(dt))
    }
    private let calendar = Calendar.current
    private let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = .current
        
        return formatter
    }()
    
    private let weekDays = ["ВС", "ПН", "ВТ", "СР", "ЧТ", "ПТ", "СБ"]
    
    init(dt: Int) {
        self.dt = dt
    }
    
    func weekDay() -> String {
        let weekDay = calendar.component(.weekday, from: date)
        return weekDays[weekDay - 1]
    }
    
    func getDateAndTime() -> String{
        formatter.dateFormat = "dd.MM.YY HH:mm"
        return formatter.string(from: date)
    }
        
}



