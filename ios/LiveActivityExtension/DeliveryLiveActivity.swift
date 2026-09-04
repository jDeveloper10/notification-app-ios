import WidgetKit
import SwiftUI
import ActivityKit

struct DeliveryLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: DeliveryAttributes.self) { context in
            // MARK: - Lock Screen & Banner Presentation (Exact match to screenshot)
            LockScreenLiveActivityView(context: context)
                .activityBackgroundTint(Color(red: 0.08, green: 0.06, blue: 0.15))
                .activitySystemActionForegroundColor(.white)
        } dynamicIsland: { context in
            // MARK: - Dynamic Island Presentation
            DynamicIsland {
                // Expanded Leading
                DynamicIslandExpandedRegion(.leading) {
                    HStack(spacing: 6) {
                        Image(systemName: "fork.knife.circle.fill")
                            .foregroundColor(Color(red: 0.98, green: 0.05, blue: 0.28))
                            .font(.system(size: 20))
                        Text(context.attributes.restaurantName)
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(.white)
                            .lineLimit(1)
                    }
                    .padding(.leading, 4)
                }

                // Expanded Trailing
                DynamicIslandExpandedRegion(.trailing) {
                    Text(context.state.timeRange)
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.white.opacity(0.85))
                        .padding(.trailing, 4)
                }

                // Expanded Bottom
                DynamicIslandExpandedRegion(.bottom) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(context.state.status)
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(.white)

                        // 4-step progress bar
                        ProgressBarView(currentStep: context.state.currentStep, totalSteps: context.state.totalSteps)

                        HStack {
                            Text(context.state.onTimeStatus)
                                .font(.system(size: 11, weight: .regular))
                                .foregroundColor(.white.opacity(0.7))
                            Text(context.state.timeRange)
                                .font(.system(size: 11, weight: .semibold))
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.horizontal, 4)
                    .padding(.top, 4)
                }
            } compactLeading: {
                HStack(spacing: 3) {
                    Image(systemName: "bag.fill")
                        .foregroundColor(Color(red: 0.98, green: 0.05, blue: 0.28))
                        .font(.system(size: 11))
                }
            } compactTrailing: {
                Text("\(context.state.currentStep)/\(context.state.totalSteps)")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(.white)
            } minimal: {
                Image(systemName: "bag.fill")
                    .foregroundColor(Color(red: 0.98, green: 0.05, blue: 0.28))
                    .font(.system(size: 11))
            }
        }
    }
}

// MARK: - Lock Screen View (Card matching user screenshot)
struct LockScreenLiveActivityView: View {
    let context: ActivityViewContext<DeliveryAttributes>

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Header: Logo & Restaurant Name
            HStack(spacing: 8) {
                // Red badge
                ZStack {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color(red: 0.98, green: 0.05, blue: 0.28))
                        .frame(width: 20, height: 20)
                    Text("P")
                        .font(.system(size: 12, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                }

                Text(context.attributes.restaurantName)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.white)

                Spacer()
            }

            // Main Content: Status and Receipt Icon
            HStack(alignment: .center) {
                Text(context.state.status)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                    .fixedSize(horizontal: false, vertical: true)

                Spacer()

                // Receipt Icon with Green Checkmark
                ReceiptIconView()
            }

            // 4-Segment Progress Bar
            ProgressBarView(currentStep: context.state.currentStep, totalSteps: context.state.totalSteps)

            // Footer: "A tiempo" and Estimated Time Range
            HStack(spacing: 6) {
                Text(context.state.onTimeStatus)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.white.opacity(0.8))

                Text(context.state.timeRange)
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.white)

                Spacer()
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: 22)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(red: 0.09, green: 0.06, blue: 0.17),
                            Color(red: 0.06, green: 0.04, blue: 0.13)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 22)
                        .stroke(Color.white.opacity(0.08), lineWidth: 1)
                )
        )
    }
}

// MARK: - 4-Segment Progress Bar
struct ProgressBarView: View {
    let currentStep: Int
    let totalSteps: Int

    var body: some View {
        HStack(spacing: 6) {
            ForEach(1...totalSteps, id: \.self) { step in
                Capsule()
                    .fill(step <= currentStep ? Color.white : Color.white.opacity(0.22))
                    .frame(height: 6)
            }
        }
    }
}

// MARK: - Receipt Icon with Checkmark
struct ReceiptIconView: View {
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            // Receipt shape
            ZStack {
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color(red: 0.78, green: 0.86, blue: 0.88))
                    .frame(width: 32, height: 40)

                VStack(spacing: 3) {
                    RoundedRectangle(cornerRadius: 1)
                        .fill(Color(red: 0.55, green: 0.65, blue: 0.68))
                        .frame(width: 20, height: 2)
                    RoundedRectangle(cornerRadius: 1)
                        .fill(Color(red: 0.55, green: 0.65, blue: 0.68))
                        .frame(width: 16, height: 2)
                    RoundedRectangle(cornerRadius: 1)
                        .fill(Color(red: 0.55, green: 0.65, blue: 0.68))
                        .frame(width: 20, height: 2)
                }
            }

            // Green circle with checkmark
            ZStack {
                Circle()
                    .fill(Color(red: 0.18, green: 0.73, blue: 0.38))
                    .frame(width: 14, height: 14)
                Image(systemName: "checkmark")
                    .font(.system(size: 8, weight: .black))
                    .foregroundColor(.white)
            }
            .offset(x: 4, y: 4)
        }
        .frame(width: 38, height: 44)
    }
}
