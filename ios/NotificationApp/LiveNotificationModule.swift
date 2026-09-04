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

    // MARK: - 1. Notificación Estándar
    @objc
    func sendStandardNotification(
        _ title: String,
        body: String,
        resolver resolve: @escaping RCTPromiseResolveBlock,
        rejecter reject: @escaping RCTPromiseRejectBlock
    ) {
        let center = UNUserNotificationCenter.current()

        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                reject("PERM_ERROR", "Error de permisos: \(error.localizedDescription)", error)
                return
            }

            guard granted else {
                reject("NOT_PERMITTED", "Permiso de notificaciones denegado. Ve a Ajustes > NotificationApp > Notificaciones y actívalas.", nil)
                return
            }

            let content = UNMutableNotificationContent()
            content.title = title.isEmpty ? "Notificación" : title
            content.body = body.isEmpty ? "Nueva alerta recibida" : body
            content.sound = .default
            content.badge = 1

            // Disparar en 1 segundo
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1.0, repeats: false)
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

            center.add(request) { error in
                if let error = error {
                    reject("NOTIF_ERROR", "Error al programar: \(error.localizedDescription)", error)
                } else {
                    resolve(["success": true, "message": "Notificación estándar programada"])
                }
            }
        }
    }

    // MARK: - 2. Live Activity Multipropósito (Trading, Grúas, Pareja, Delivery)
    @objc
    func startLiveActivity(
        _ scenarioType: String,
        title: String,
        status: String,
        subtitle: String,
        timeRange: String,
        currentStep: NSNumber,
        totalSteps: NSNumber,
        badgeText: String,
        accentColor: String,
        resolver resolve: @escaping RCTPromiseResolveBlock,
        rejecter reject: @escaping RCTPromiseRejectBlock
    ) {
        guard #available(iOS 16.1, *) else {
            reject("UNSUPPORTED_VERSION", "Live Activities requieren iOS 16.1+", nil)
            return
        }

        guard ActivityAuthorizationInfo().areActivitiesEnabled else {
            reject("DISABLED", "Live Activities están deshabilitadas en este dispositivo", nil)
            return
        }

        // Si ya hay una actividad previa, cerrarla antes de abrir una nueva
        Task {
            for oldActivity in Activity<DeliveryAttributes>.activities {
                await oldActivity.end(dismissalPolicy: .immediate)
            }
        }

        let attributes = DeliveryAttributes(restaurantName: title)
        let initialContentState = DeliveryAttributes.ContentState(
            scenarioType: scenarioType,
            title: title,
            status: status,
            subtitle: subtitle,
            timeRange: timeRange,
            currentStep: currentStep.intValue > 0 ? currentStep.intValue : 1,
            totalSteps: totalSteps.intValue > 0 ? totalSteps.intValue : 4,
            badgeText: badgeText,
            accentColor: accentColor
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
            reject("LIVE_ACTIVITY_ERROR", "Error al iniciar Live Activity: \(error.localizedDescription)", error)
        }
    }

    // MARK: - Actualizar Live Activity
    @objc
    func updateLiveActivity(
        _ status: String,
        subtitle: String,
        timeRange: String,
        currentStep: NSNumber,
        badgeText: String,
        resolver resolve: @escaping RCTPromiseResolveBlock,
        rejecter reject: @escaping RCTPromiseRejectBlock
    ) {
        guard #available(iOS 16.1, *) else {
            reject("UNSUPPORTED_VERSION", "Requiere iOS 16.1+", nil)
            return
        }

        guard let activity = (self.currentActivity as? Activity<DeliveryAttributes>) ?? Activity<DeliveryAttributes>.activities.first else {
            reject("NO_ACTIVITY", "No hay Live Activity activa para actualizar", nil)
            return
        }

        let prevState = activity.content.state
        let updatedContentState = DeliveryAttributes.ContentState(
            scenarioType: prevState.scenarioType,
            title: prevState.title,
            status: status.isEmpty ? prevState.status : status,
            subtitle: subtitle.isEmpty ? prevState.subtitle : subtitle,
            timeRange: timeRange.isEmpty ? prevState.timeRange : timeRange,
            currentStep: currentStep.intValue,
            totalSteps: prevState.totalSteps,
            badgeText: badgeText.isEmpty ? prevState.badgeText : badgeText,
            accentColor: prevState.accentColor
        )

        Task {
            if #available(iOS 16.2, *) {
                let activityContent = ActivityContent(state: updatedContentState, staleDate: nil)
                await activity.update(activityContent)
            } else {
                await activity.update(using: updatedContentState)
            }
            resolve(["success": true, "step": currentStep.intValue])
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
