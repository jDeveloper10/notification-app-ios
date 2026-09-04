import WidgetKit
import SwiftUI
import ActivityKit

struct DeliveryLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: DeliveryAttributes.self) { context in
            // MARK: - Lock Screen & Banner Presentation
            ScenarioLiveActivityView(context: context)
                .activityBackgroundTint(backgroundColor(for: context.state.scenarioType))
                .activitySystemActionForegroundColor(.white)
        } dynamicIsland: { context in
            // MARK: - Dynamic Island Presentation
            DynamicIsland {
                // Expanded Leading
                DynamicIslandExpandedRegion(.leading) {
                    HStack(spacing: 6) {
                        scenarioIcon(for: context.state.scenarioType)
                            .foregroundColor(accentColor(for: context.state.accentColor))
                            .font(.system(size: 18))
                        Text(context.state.title)
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(.white)
                            .lineLimit(1)
                    }
                    .padding(.leading, 4)
                }

                // Expanded Trailing
                DynamicIslandExpandedRegion(.trailing) {
                    Text(context.state.timeRange)
                        .font(.system(size: 13, weight: .black))
                        .foregroundColor(accentColor(for: context.state.accentColor))
                        .padding(.trailing, 4)
                }

                // Expanded Bottom
                DynamicIslandExpandedRegion(.bottom) {
                    VStack(alignment: .leading, spacing: 7) {
                        Text(context.state.status)
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(.white)

                        // Barra de progreso interactiva
                        ProgressSegmentsView(
                            currentStep: context.state.currentStep,
                            totalSteps: context.state.totalSteps,
                            color: accentColor(for: context.state.accentColor)
                        )

                        HStack {
                            Text(context.state.subtitle)
                                .font(.system(size: 11, weight: .medium))
                                .foregroundColor(.white.opacity(0.8))
                            Spacer()
                            Text(context.state.badgeText)
                                .font(.system(size: 10, weight: .black))
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(accentColor(for: context.state.accentColor).opacity(0.25))
                                .cornerRadius(4)
                                .foregroundColor(accentColor(for: context.state.accentColor))
                        }
                    }
                    .padding(.horizontal, 4)
                    .padding(.top, 4)
                }
            } compactLeading: {
                scenarioIcon(for: context.state.scenarioType)
                    .foregroundColor(accentColor(for: context.state.accentColor))
                    .font(.system(size: 12))
            } compactTrailing: {
                Text(context.state.timeRange)
                    .font(.system(size: 11, weight: .black))
                    .foregroundColor(accentColor(for: context.state.accentColor))
            } minimal: {
                scenarioIcon(for: context.state.scenarioType)
                    .foregroundColor(accentColor(for: context.state.accentColor))
                    .font(.system(size: 12))
            }
        }
    }
}

// MARK: - Lock Screen View (Card multipropósito con soporte para 6 escenarios)
struct ScenarioLiveActivityView: View {
    let context: ActivityViewContext<DeliveryAttributes>

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Header
            HStack(spacing: 8) {
                // Badge con ícono
                ZStack {
                    RoundedRectangle(cornerRadius: 7)
                        .fill(accentColor(for: context.state.accentColor))
                        .frame(width: 24, height: 24)
                    scenarioIcon(for: context.state.scenarioType)
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.white)
                }

                Text(context.state.title)
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(.white)

                Spacer()

                Text(context.state.badgeText)
                    .font(.system(size: 10, weight: .black))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(accentColor(for: context.state.accentColor).opacity(0.2))
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(accentColor(for: context.state.accentColor).opacity(0.4), lineWidth: 1)
                    )
                    .cornerRadius(6)
                    .foregroundColor(accentColor(for: context.state.accentColor))
            }

            // Cuerpo principal
            HStack(alignment: .center) {
                VStack(alignment: .leading, spacing: 3) {
                    Text(context.state.status)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                        .fixedSize(horizontal: false, vertical: true)

                    Text(context.state.subtitle)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.white.opacity(0.75))
                }

                Spacer()

                // Ilustración lateral según escenario
                sideIllustration(for: context.state.scenarioType, accent: accentColor(for: context.state.accentColor))
            }

            // Barra de progreso
            ProgressSegmentsView(
                currentStep: context.state.currentStep,
                totalSteps: context.state.totalSteps,
                color: accentColor(for: context.state.accentColor)
            )

            // Footer
            HStack {
                Text(context.state.scenarioType.uppercased() + " • EN VIVO")
                    .font(.system(size: 9, weight: .heavy))
                    .foregroundColor(.white.opacity(0.55))

                Spacer()

                Text(context.state.timeRange)
                    .font(.system(size: 13, weight: .black))
                    .foregroundColor(accentColor(for: context.state.accentColor))
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: 22)
                .fill(cardGradient(for: context.state.scenarioType))
                .overlay(
                    RoundedRectangle(cornerRadius: 22)
                        .stroke(accentColor(for: context.state.accentColor).opacity(0.3), lineWidth: 1)
                )
        )
    }
}

// MARK: - Barra de progreso segmentada
struct ProgressSegmentsView: View {
    let currentStep: Int
    let totalSteps: Int
    let color: Color

    var body: some View {
        HStack(spacing: 5) {
            ForEach(1...max(1, totalSteps), id: \.self) { step in
                Capsule()
                    .fill(step <= currentStep ? color : Color.white.opacity(0.2))
                    .frame(height: 5)
            }
        }
    }
}

// MARK: - Helpers visuales para íconos, gráficos e ilustraciones
func scenarioIcon(for type: String) -> Image {
    switch type {
    case "trading":
        return Image(systemName: "chart.line.uptrend.xyaxis")
    case "grua":
        return Image(systemName: "truck.box.fill")
    case "pareja":
        return Image(systemName: "heart.fill")
    case "sports":
        return Image(systemName: "sportscourt.fill")
    case "flight":
        return Image(systemName: "airplane")
    default:
        return Image(systemName: "fork.knife")
    }
}

@ViewBuilder
func sideIllustration(for type: String, accent: Color) -> some View {
    switch type {
    case "trading":
        VStack(spacing: 2) {
            Image(systemName: "arrow.up.right.circle.fill")
                .font(.system(size: 26))
                .foregroundColor(accent)
            Text("PROFIT")
                .font(.system(size: 9, weight: .black))
                .foregroundColor(accent)
        }
    case "grua":
        ZStack {
            Circle()
                .fill(accent.opacity(0.2))
                .frame(width: 36, height: 36)
            Image(systemName: "car.fill")
                .font(.system(size: 18))
                .foregroundColor(accent)
        }
    case "pareja":
        ZStack {
            Circle()
                .fill(accent.opacity(0.2))
                .frame(width: 36, height: 36)
            Image(systemName: "location.fill")
                .font(.system(size: 18))
                .foregroundColor(accent)
        }
    case "sports":
        VStack(spacing: 2) {
            Text("⚽ GOL")
                .font(.system(size: 11, weight: .black))
                .foregroundColor(accent)
            Text("EN VIVO")
                .font(.system(size: 8, weight: .bold))
                .foregroundColor(.white.opacity(0.7))
        }
    case "flight":
        VStack(spacing: 2) {
            Image(systemName: "airplane.departure")
                .font(.system(size: 22))
                .foregroundColor(accent)
            Text("GATE B24")
                .font(.system(size: 8, weight: .heavy))
                .foregroundColor(accent)
        }
    default:
        ZStack(alignment: .bottomTrailing) {
            RoundedRectangle(cornerRadius: 4)
                .fill(Color(red: 0.78, green: 0.86, blue: 0.88))
                .frame(width: 28, height: 34)
            Circle()
                .fill(Color(red: 0.18, green: 0.73, blue: 0.38))
                .frame(width: 12, height: 12)
                .offset(x: 3, y: 3)
        }
    }
}

func accentColor(for colorName: String) -> Color {
    switch colorName {
    case "green":
        return Color(red: 0.0, green: 0.94, blue: 0.63) // Neon green trading
    case "orange":
        return Color(red: 1.0, green: 0.55, blue: 0.0) // Neon orange grua
    case "pink":
        return Color(red: 1.0, green: 0.25, blue: 0.51) // Neon pink pareja
    case "blue":
        return Color(red: 0.13, green: 0.65, blue: 1.0) // Electric blue sports
    case "cyan":
        return Color(red: 0.22, green: 0.88, blue: 0.98) // Cyan flight
    default:
        return Color(red: 0.98, green: 0.05, blue: 0.28) // Red delivery
    }
}

func backgroundColor(for type: String) -> Color {
    switch type {
    case "trading":
        return Color(red: 0.04, green: 0.08, blue: 0.15)
    case "grua":
        return Color(red: 0.12, green: 0.07, blue: 0.04)
    case "pareja":
        return Color(red: 0.14, green: 0.04, blue: 0.12)
    case "sports":
        return Color(red: 0.04, green: 0.08, blue: 0.18)
    case "flight":
        return Color(red: 0.04, green: 0.10, blue: 0.16)
    default:
        return Color(red: 0.08, green: 0.06, blue: 0.15)
    }
}

func cardGradient(for type: String) -> LinearGradient {
    let topColor: Color
    let bottomColor: Color

    switch type {
    case "trading":
        topColor = Color(red: 0.05, green: 0.11, blue: 0.20)
        bottomColor = Color(red: 0.03, green: 0.06, blue: 0.12)
    case "grua":
        topColor = Color(red: 0.16, green: 0.10, blue: 0.06)
        bottomColor = Color(red: 0.09, green: 0.05, blue: 0.03)
    case "pareja":
        topColor = Color(red: 0.18, green: 0.06, blue: 0.16)
        bottomColor = Color(red: 0.10, green: 0.03, blue: 0.09)
    case "sports":
        topColor = Color(red: 0.05, green: 0.12, blue: 0.24)
        bottomColor = Color(red: 0.02, green: 0.06, blue: 0.14)
    case "flight":
        topColor = Color(red: 0.06, green: 0.14, blue: 0.22)
        bottomColor = Color(red: 0.03, green: 0.08, blue: 0.13)
    default:
        topColor = Color(red: 0.09, green: 0.06, blue: 0.17)
        bottomColor = Color(red: 0.06, green: 0.04, blue: 0.13)
    }

    return LinearGradient(
        gradient: Gradient(colors: [topColor, bottomColor]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}
