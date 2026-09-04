import Foundation
import ActivityKit

public struct DeliveryAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        public var status: String
        public var timeRange: String
        public var onTimeStatus: String
        public var currentStep: Int
        public var totalSteps: Int

        public init(
            status: String = "El local recibió tu pedido",
            timeRange: String = "12:40 - 1:00",
            onTimeStatus: String = "A tiempo",
            currentStep: Int = 1,
            totalSteps: Int = 4
        ) {
            self.status = status
            self.timeRange = timeRange
            self.onTimeStatus = onTimeStatus
            self.currentStep = currentStep
            self.totalSteps = totalSteps
        }
    }

    public var restaurantName: String

    public init(restaurantName: String = "Sushi Express - Costa Verde") {
        self.restaurantName = restaurantName
    }
}
