import Foundation
import ActivityKit

public struct DeliveryAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        public var scenarioType: String  // "trading", "grua", "pareja", "delivery"
        public var title: String
        public var status: String
        public var subtitle: String
        public var timeRange: String
        public var currentStep: Int
        public var totalSteps: Int
        public var badgeText: String
        public var accentColor: String

        public init(
            scenarioType: String = "delivery",
            title: String = "Sushi Express - Costa Verde",
            status: String = "El local recibió tu pedido",
            subtitle: String = "A tiempo",
            timeRange: String = "12:40 - 1:00",
            currentStep: Int = 1,
            totalSteps: Int = 4,
            badgeText: String = "PEDIDO",
            accentColor: String = "red"
        ) {
            self.scenarioType = scenarioType
            self.title = title
            self.status = status
            self.subtitle = subtitle
            self.timeRange = timeRange
            self.currentStep = currentStep
            self.totalSteps = totalSteps
            self.badgeText = badgeText
            self.accentColor = accentColor
        }
    }

    public var restaurantName: String

    public init(restaurantName: String = "NotificationApp") {
        self.restaurantName = restaurantName
    }
}
