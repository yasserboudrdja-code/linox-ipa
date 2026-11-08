import Foundation

enum CheatType {
    case toggle
    case toggleWithTimer
    case toggleWithMap
    case slider(min: Float, max: Float, defaultVal: Float)
    case segmented([String])
}

struct CheatItem {
    var name: String
    var subtitle: String
    var type: CheatType
    var isEnabled: Bool = false
    var sliderValue: Float = 0
    var segmentIndex: Int = 0
    var timerValue: Double = 1.0
}
