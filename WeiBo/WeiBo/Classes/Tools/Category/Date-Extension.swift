import Foundation

extension Date{
    static func creatDateString(creatAtString : String) -> String {

        let fmt = DateFormatter()
        fmt.dateFormat = "EEE MM dd HH:mm:ss Z yyyy"
        fmt.locale = Locale.current

        guard let creatDate = fmt.date(from: creatAtString) else{
            return ""
        }

        let nowDate = Date()
        let interval = Int(nowDate.timeIntervalSince(creatDate))
        if interval < 60 {
            return "just now"
        }

        if interval < 60 * 60 {
            return "\(interval / 60) minutes ago"
        }

        if interval < 60 * 60 * 24 {
            return "\(interval / 60) hours ago"
        }

        let calender = Calendar.current
        if calender.isDateInYesterday(creatDate) {
            fmt.dateFormat = "yesterday HH:mm"
            let timeStr = fmt.string(from: creatDate)
            return timeStr
        }
        

        let cmps = calender.component(.year, from: creatDate)

        if cmps < 1 {
            fmt.dateFormat = "MM-dd HH:mm"
            let timeStr = fmt.string(from: creatDate)
            return timeStr
        }

        if cmps >= 1 {
            fmt.dateFormat = "yyyy-MM-dd HH:mm"
            let timeStr = fmt.string(from: creatDate)
            return timeStr
        }

        return "1970-01-01 00：00"
    }
}
