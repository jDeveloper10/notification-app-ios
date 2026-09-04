import Foundation
import UserNotifications
import ActivityKit
import React

@objc(LiveNotificationModule)
class LiveNotificationModule: NSObject, RCTBridgeModule {

    @objc static func moduleName() -> String! {
        return "LiveNotificationModule"
    }

    // Store active activity reference for live updates
    private var currentActivity: Any?

    @objc
    static func requiresMainQueueSetup() -> Bool {
        return true
    }

    // MARK: - Permissions
    @objc
    func requestPermissions(
        _ resolve: @escaping RCTPromiseResolveBlock,
        rejecter reject: @escaping RCTPromiseRejectBlock
    ) {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                reject("PERM_ERROR", error.localizedDescription, error)
                return
            }

            var liveActivitiesEnabled = false
            if #available(iOS 16.1, *) {
                liveActivitiesEnabled = ActivityAuthorizationInfo().areActivitiesEnabled
            }

            resolve([
                "notificationsGranted": granted,
                "liveActivitiesEnabled": liveActivitiesEnabled
            ])
        }
    }

    // MARK: - 1. Notificación Estándar (Estilo PedidosYa)
    @objc
    func sendStandardNotification(
        _ title: String,
        body: String,
        resolver resolve: @escaping RCTPromiseResolveBlock,
        rejecter reject: @escaping RCTPromiseRejectBlock
    ) {
        let center = UNUserNotificationCenter.current()

        let content = UNMutableNotificationContent()
        content.title = title.isEmpty ? "PedidosYa" : title
        content.body = body.isEmpty ? "El local ya recibió tu pedido. Te llegará entre las 12:40 - 1:00." : body
        content.sound = .default

        // Trigger after 1 second
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1.0, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        center.add(request) { error in
            if let error = error {
                reject("NOTIF_ERROR", "Error scheduling notification: \(error.localizedDescription)", error)
            } else {
                resolve(["success": true, "message": "Notificación estándar programada"])
            }
        }
    }

    // MARK: - 2. Live Activity (Estilo Sushi Express con ActivityKit)
    @objc
    func startLiveActivity(
        _ restaurantName: String,
        status: String,
        timeRange: String,
        step: NSNumber,
        resolver resolve: @escaping RCTPromiseResolveBlock,
        rejecter reject: @escaping RCTPromiseRejectBlock
    ) {
        guard #available(iOS 16.1, *) else {
            reject("UNSUPPORTED_VERSION", "Live Activities requieren iOS 16.1 o superior", nil)
            return
        }

        guard ActivityAuthorizationInfo().areActivitiesEnabled else {
            reject("DISABLED", "Live Activities están deshabilitadas en este dispositivo", nil)
            return
        }

        let restaurant = restaurantName.isEmpty ? "Sushi Express - Costa Verde" : restaurantName
        let currentStatus = status.isEmpty ? "El local recibió tu pedido" : status
        let time = timeRange.isEmpty ? "12:40 - 1:00" : timeRange
        let stepNumber = step.intValue > 0 ? step.intValue : 1

        let attributes = DeliveryAttributes(restaurantName: restaurant)
        let initialContentState = DeliveryAttributes.ContentState(
            status: currentStatus,
            timeRange: time,
            onTimeStatus: "A tiempo",
            currentStep: stepNumber,
            totalSteps: 4
        )

        do {
            if #available(iOS 16.2, *) {
                let activityContent = ActivityContent(state: initialContentState, staleDate: nil)
                let activity = try Activity<DeliveryAttributes>.request(
                    attributes: attributes,
                    content: activityContent,
                    pushType: nil
                )
                self.currentActivity = activity
                resolve(["success": true, "activityId": activity.id])
            } else {
                let activity = try Activity<DeliveryAttributes>.request(
                    attributes: attributes,
                    contentState: initialContentState,
                    pushType: nil
                )
                self.currentActivity = activity
                resolve(["success": true, "activityId": activity.id])
            }
        } catch {
            reject("LIVE_ACTIVITY_ERROR", "No se pudo iniciar la Live Activity: \(error.localizedDescription)", error)
        }
    }

    // MARK: - Actualizar Live Activity (Avanzar paso)
    @objc
    func updateLiveActivity(
        _ status: String,
        timeRange: String,
        step: NSNumber,
        resolver resolve: @escaping RCTPromiseResolveBlock,
        rejecter reject: @escaping RCTPromiseRejectBlock
    ) {
        guard #available(iOS 16.1, *) else {
            reject("UNSUPPORTED_VERSION", "Requiere iOS 16.1+", nil)
            return
        }

        guard let activity = self.currentActivity as? Activity<DeliveryAttributes> else {
            // Intentar buscar una actividad activa si la referencia se perdió
            if let firstActive = Activity<DeliveryAttributes>.activities.first {
                self.currentActivity = firstActive
                self.updateLiveActivity(status, timeRange: timeRange, step: step, resolver: resolve, rejecter: reject)
                return
            }
            reject("NO_ACTIVITY", "No hay ninguna Live Activity activa para actualizar", nil)
            return
        }

        let updatedStatus = status.isEmpty ? "Preparando tu pedido" : status
        let time = timeRange.isEmpty ? "12:40 - 1:00" : timeRange
        let stepNumber = step.intValue

        let updatedContentState = DeliveryAttributes.ContentState(
            status: updatedStatus,
            timeRange: time,
            onTimeStatus: "A tiempo",
            currentStep: stepNumber,
            totalSteps: 4
        )

        Task {
            if #available(iOS 16.2, *) {
                let activityContent = ActivityContent(state: updatedContentState, staleDate: nil)
                await activity.update(activityContent)
            } else {
                await activity.update(using: updatedContentState)
            }
            resolve(["success": true, "step": stepNumber])
        }
    }

    // MARK: - Finalizar Live Activity
    @objc
    func endLiveActivity(
        _ resolve: @escaping RCTPromiseResolveBlock,
        rejecter reject: @escaping RCTPromiseRejectBlock
    ) {
        guard #available(iOS 16.1, *) else {
            resolve(["success": true])
            return
        }

        Task {
            for activity in Activity<DeliveryAttributes>.activities {
                await activity.end(dismissalPolicy: .immediate)
            }
            self.currentActivity = nil
            resolve(["success": true, "message": "Live Activities finalizadas"])
        }
    }
}
