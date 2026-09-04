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
                            .foregroundColor(themeColor(for: context.state.accentColor))
                            .font(.system(size: 16))
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
                        .foregroundColor(themeColor(for: context.state.accentColor))
                        .padding(.trailing, 4)
                }

                // Expanded Bottom
                DynamicIslandExpandedRegion(.bottom) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(context.state.status)
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white)
                            .lineLimit(1)

                        // Visual específico del escenario en la Isla Dinámica
                        ScenarioDynamicIslandBottom(context: context)

                        HStack {
                            Text(context.state.subtitle)
                                .font(.system(size: 10, weight: .medium))
                                .foregroundColor(.white.opacity(0.8))
                                .lineLimit(1)
                            Spacer()
                            Text(context.state.badgeText)
                                .font(.system(size: 9, weight: .black))
                                .padding(.horizontal, 5)
                                .padding(.vertical, 2)
                                .background(themeColor(for: context.state.accentColor).opacity(0.25))
                                .cornerRadius(4)
                                .foregroundColor(themeColor(for: context.state.accentColor))
                        }
                    }
                    .padding(.horizontal, 4)
                    .padding(.top, 2)
                }
            } compactLeading: {
                scenarioIcon(for: context.state.scenarioType)
                    .foregroundColor(themeColor(for: context.state.accentColor))
                    .font(.system(size: 12))
            } compactTrailing: {
                Text(context.state.timeRange)
                    .font(.system(size: 11, weight: .black))
                    .foregroundColor(themeColor(for: context.state.accentColor))
            } minimal: {
                scenarioIcon(for: context.state.scenarioType)
                    .foregroundColor(themeColor(for: context.state.accentColor))
                    .font(.system(size: 12))
            }
        }
    }
}

// MARK: - Lock Screen View (Diseños Creativos Especializados por Escenario)
struct ScenarioLiveActivityView: View {
    let context: ActivityViewContext<DeliveryAttributes>

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Header común elegante
            HStack(spacing: 8) {
                ZStack {
                    RoundedRectangle(cornerRadius: 7)
                        .fill(themeColor(for: context.state.accentColor))
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
                    .background(themeColor(for: context.state.accentColor).opacity(0.22))
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(themeColor(for: context.state.accentColor).opacity(0.5), lineWidth: 1)
                    )
                    .cornerRadius(6)
                    .foregroundColor(themeColor(for: context.state.accentColor))
            }

            // Cuerpo Dinámico y Creativo según el Escenario (¡Sin barras aburridas!)
            switch context.state.scenarioType {
            case "trading":
                TradingWidgetView(context: context)
            case "flight":
                FlightWidgetView(context: context)
            case "grua":
                GruaWidgetView(context: context)
            case "pareja":
                ParejaRadarWidgetView(context: context)
            case "sports":
                SportsScoreboardWidgetView(context: context)
            default:
                DeliveryClassicWidgetView(context: context)
            }

            // Footer con timestamp e indicador activo
            HStack {
                HStack(spacing: 4) {
                    Circle()
                        .fill(themeColor(for: context.state.accentColor))
                        .frame(width: 5, height: 5)
                    Text(context.state.scenarioType.uppercased() + " • EN VIVO")
                        .font(.system(size: 9, weight: .heavy))
                        .foregroundColor(.white.opacity(0.6))
                }

                Spacer()

                Text(context.state.timeRange)
                    .font(.system(size: 13, weight: .black))
                    .foregroundColor(themeColor(for: context.state.accentColor))
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: 22)
                .fill(cardGradient(for: context.state.scenarioType))
                .overlay(
                    RoundedRectangle(cornerRadius: 22)
                        .stroke(themeColor(for: context.state.accentColor).opacity(0.3), lineWidth: 1)
                )
        )
    }
}

// MARK: - 1. TRADING CREATIVO (Sparkline Vectorial + Orderbook + PnL)
struct TradingWidgetView: View {
    let context: ActivityViewContext<DeliveryAttributes>

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(alignment: .bottom) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(context.state.status)
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(.white)
                    Text(context.state.subtitle)
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(.white.opacity(0.7))
                }
                Spacer()
                // PnL Badge con Glow Neón
                Text(context.state.timeRange)
                    .font(.system(size: 16, weight: .black, design: .monospaced))
                    .foregroundColor(themeColor(for: context.state.accentColor))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(themeColor(for: context.state.accentColor).opacity(0.15))
                    .cornerRadius(6)
            }

            // Mini Gráfico de Velas / Sparkline Vectorial con Curvas Bézier
            HStack(spacing: 10) {
                SparklineChart(step: context.state.currentStep, color: themeColor(for: context.state.accentColor))
                    .frame(height: 38)

                // Presión de compra (Buyers vs Sellers)
                VStack(alignment: .trailing, spacing: 3) {
                    Text("BUY 74%")
                        .font(.system(size: 8, weight: .heavy))
                        .foregroundColor(themeColor(for: context.state.accentColor))
                    HStack(spacing: 2) {
                        RoundedRectangle(cornerRadius: 1).fill(themeColor(for: context.state.accentColor)).frame(width: 22, height: 4)
                        RoundedRectangle(cornerRadius: 1).fill(Color.red.opacity(0.6)).frame(width: 8, height: 4)
                    }
                    Text("VOL: 2.4M")
                        .font(.system(size: 8, weight: .bold))
                        .foregroundColor(.white.opacity(0.5))
                }
            }
        }
    }
}

// MARK: - 2. VUELO CREATIVO (Boarding Pass con Arco de Vuelo y Códigos IATA)
struct FlightWidgetView: View {
    let context: ActivityViewContext<DeliveryAttributes>

    var body: some View {
        VStack(spacing: 8) {
            // Aeropuertos origen y destino
            HStack {
                VStack(alignment: .leading, spacing: 1) {
                    Text("MAD")
                        .font(.system(size: 18, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                    Text("Madrid")
                        .font(.system(size: 9, weight: .semibold))
                        .foregroundColor(.white.opacity(0.6))
                }

                Spacer()

                // Arco de vuelo con avión avanzando
                FlightPathArc(
                    progress: Double(context.state.currentStep) / Double(context.state.totalSteps),
                    color: themeColor(for: context.state.accentColor)
                )
                .frame(width: 120, height: 28)

                Spacer()

                VStack(alignment: .trailing, spacing: 1) {
                    Text("MIA")
                        .font(.system(size: 18, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                    Text("Miami")
                        .font(.system(size: 9, weight: .semibold))
                        .foregroundColor(.white.opacity(0.6))
                }
            }

            // Datos de vuelo
            HStack {
                Text(context.state.status)
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.white)
                Spacer()
                Text(context.state.subtitle)
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(.white.opacity(0.75))
            }
        }
    }
}

// MARK: - 3. GRÚA CREATIVA (Tacómetro de Distancia + Placa Metálica Vehicular)
struct GruaWidgetView: View {
    let context: ActivityViewContext<DeliveryAttributes>

    var body: some View {
        HStack(spacing: 12) {
            // Tacómetro semicircular de distancia
            ZStack {
                Circle()
                    .trim(from: 0.15, to: 0.85)
                    .stroke(Color.white.opacity(0.15), style: StrokeStyle(lineWidth: 4, lineCap: .round))
                    .frame(width: 48, height: 48)
                    .rotationEffect(.degrees(90))

                Circle()
                    .trim(from: 0.15, to: 0.15 + (CGFloat(context.state.currentStep) / 4.0) * 0.70)
                    .stroke(themeColor(for: context.state.accentColor), style: StrokeStyle(lineWidth: 4, lineCap: .round))
                    .frame(width: 48, height: 48)
                    .rotationEffect(.degrees(90))

                VStack(spacing: -2) {
                    Text(context.state.currentStep == 4 ? "0" : "\(5 - context.state.currentStep)")
                        .font(.system(size: 14, weight: .black))
                        .foregroundColor(.white)
                    Text("KM")
                        .font(.system(size: 7, weight: .heavy))
                        .foregroundColor(themeColor(for: context.state.accentColor))
                }
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(context.state.status)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white)
                    .lineLimit(1)

                HStack(spacing: 8) {
                    // Placa Metálica de Auto Realista
                    HStack(spacing: 3) {
                        RoundedRectangle(cornerRadius: 1)
                            .fill(Color.blue)
                            .frame(width: 4, height: 12)
                        Text("ABC • 123")
                            .font(.system(size: 10, weight: .heavy, design: .monospaced))
                            .foregroundColor(.black)
                    }
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(Color(white: 0.94))
                    .cornerRadius(4)

                    // Operador y Estrellas
                    HStack(spacing: 2) {
                        Text("⭐ 4.9")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(.yellow)
                        Text("Carlos M.")
                            .font(.system(size: 10, weight: .medium))
                            .foregroundColor(.white.opacity(0.8))
                    }
                }
            }
            Spacer()
        }
    }
}

// MARK: - 4. PAREJA CREATIVA (Radar GPS de Ondas Concéntricas + Batería)
struct ParejaRadarWidgetView: View {
    let context: ActivityViewContext<DeliveryAttributes>

    var body: some View {
        HStack(spacing: 12) {
            // Radar de Anillos Concéntricos con Onda
            ZStack {
                ForEach(1...3, id: \.self) { ring in
                    Circle()
                        .stroke(themeColor(for: context.state.accentColor).opacity(Double(ring) * 0.15), lineWidth: 1.5)
                        .frame(width: CGFloat(ring * 16), height: CGFloat(ring * 16))
                }

                // Casa en el centro
                Image(systemName: "house.fill")
                    .font(.system(size: 10))
                    .foregroundColor(.white)

                // Corazón de ella acercándose al centro según el paso
                let offsetAmount = CGFloat(4 - context.state.currentStep) * 6.0
                Image(systemName: "heart.fill")
                    .font(.system(size: 12))
                    .foregroundColor(themeColor(for: context.state.accentColor))
                    .offset(x: offsetAmount, y: -offsetAmount * 0.7)
            }
            .frame(width: 52, height: 52)

            VStack(alignment: .leading, spacing: 3) {
                Text(context.state.status)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white)
                    .lineLimit(1)

                Text(context.state.subtitle)
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(.white.opacity(0.8))
                    .lineLimit(1)

                // Distintivo de batería
                HStack(spacing: 4) {
                    Image(systemName: "battery.75")
                        .font(.system(size: 10))
                        .foregroundColor(Color.green)
                    Text("iPhone: 78% • En tiempo real")
                        .font(.system(size: 9, weight: .semibold))
                        .foregroundColor(.white.opacity(0.6))
                }
            }
            Spacer()
        }
    }
}

// MARK: - 5. DEPORTES CREATIVO (Marcador LED de Estadio + Barra de Posesión)
struct SportsScoreboardWidgetView: View {
    let context: ActivityViewContext<DeliveryAttributes>

    var body: some View {
        VStack(spacing: 6) {
            HStack(spacing: 16) {
                // Equipo Local
                VStack(spacing: 1) {
                    Text("RMA")
                        .font(.system(size: 12, weight: .black))
                        .foregroundColor(.white)
                    Text("2")
                        .font(.system(size: 24, weight: .black, design: .rounded))
                        .foregroundColor(themeColor(for: context.state.accentColor))
                }

                // VS y Minuto
                VStack(spacing: 2) {
                    Text("VS")
                        .font(.system(size: 9, weight: .heavy))
                        .foregroundColor(.white.opacity(0.4))
                    Text(context.state.timeRange)
                        .font(.system(size: 11, weight: .black))
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(themeColor(for: context.state.accentColor).opacity(0.2))
                        .cornerRadius(4)
                        .foregroundColor(themeColor(for: context.state.accentColor))
                }

                // Equipo Visitante
                VStack(spacing: 1) {
                    Text("MCI")
                        .font(.system(size: 12, weight: .black))
                        .foregroundColor(.white)
                    Text("1")
                        .font(.system(size: 24, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                }

                Spacer()

                VStack(alignment: .leading, spacing: 2) {
                    Text(context.state.status)
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.white)
                        .lineLimit(1)
                    Text(context.state.subtitle)
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(.white.opacity(0.7))
                        .lineLimit(1)
                }
            }

            // Barra Bicolor de Posesión de Balón (56% vs 44%)
            HStack(spacing: 3) {
                Text("POSESIÓN")
                    .font(.system(size: 8, weight: .black))
                    .foregroundColor(.white.opacity(0.4))

                RoundedRectangle(cornerRadius: 2)
                    .fill(themeColor(for: context.state.accentColor))
                    .frame(width: 90, height: 4)

                RoundedRectangle(cornerRadius: 2)
                    .fill(Color.white.opacity(0.3))
                    .frame(width: 70, height: 4)

                Spacer()
                Text("56% - 44%")
                    .font(.system(size: 8, weight: .heavy))
                    .foregroundColor(.white.opacity(0.6))
            }
        }
    }
}

// MARK: - 6. DELIVERY CLÁSICO (Con Recibo e Indicador)
struct DeliveryClassicWidgetView: View {
    let context: ActivityViewContext<DeliveryAttributes>

    var body: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 3) {
                Text(context.state.status)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.white)
                Text(context.state.subtitle)
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(.white.opacity(0.75))
            }
            Spacer()
            // Recibo con check verde
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
}

// MARK: - Vistas Vectoriales Especiales

// Sparkline Chart con curvas Bézier para Trading
struct SparklineChart: View {
    let step: Int
    let color: Color

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height

            // Datos de precio simulados según el paso
            let basePoints: [CGFloat] = [0.2, 0.35, 0.28, 0.45, 0.40, 0.60, 0.55, 0.75, 0.70, 0.95]
            let visibleCount = min(basePoints.count, max(3, step * 3))
            let points = Array(basePoints.prefix(visibleCount))

            // Línea punteada de Target / Take Profit
            Path { path in
                path.move(to: CGPoint(x: 0, y: h * 0.15))
                path.addLine(to: CGPoint(x: w, y: h * 0.15))
            }
            .stroke(color.opacity(0.35), style: StrokeStyle(lineWidth: 1, dash: [3, 3]))

            // Curva Bézier del precio
            Path { path in
                guard points.count > 1 else { return }
                let stepX = w / CGFloat(points.count - 1)

                for (idx, pt) in points.enumerated() {
                    let x = CGFloat(idx) * stepX
                    let y = h - (pt * h * 0.85) - 2

                    if idx == 0 {
                        path.move(to: CGPoint(x: x, y: y))
                    } else {
                        let prevX = CGFloat(idx - 1) * stepX
                        let prevY = h - (points[idx - 1] * h * 0.85) - 2
                        let midX = (prevX + x) / 2
                        path.addCurve(to: CGPoint(x: x, y: y), control1: CGPoint(x: midX, y: prevY), control2: CGPoint(x: midX, y: y))
                    }
                }
            }
            .stroke(
                LinearGradient(colors: [color.opacity(0.5), color], startPoint: .leading, endPoint: .trailing),
                style: StrokeStyle(lineWidth: 2.5, lineCap: .round, lineJoin: .round)
            )
        }
    }
}

// Arco de vuelo para Vuelos
struct FlightPathArc: View {
    let progress: Double
    let color: Color

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height

            // Arco punteado completo
            Path { path in
                path.move(to: CGPoint(x: 5, y: h - 4))
                path.addQuadCurve(to: CGPoint(x: w - 5, y: h - 4), control: CGPoint(x: w / 2, y: 0))
            }
            .stroke(Color.white.opacity(0.2), style: StrokeStyle(lineWidth: 2, dash: [3, 3]))

            // Arco activo
            Path { path in
                path.move(to: CGPoint(x: 5, y: h - 4))
                path.addQuadCurve(to: CGPoint(x: w - 5, y: h - 4), control: CGPoint(x: w / 2, y: 0))
            }
            .trim(from: 0, to: CGFloat(max(0.05, progress)))
            .stroke(color, style: StrokeStyle(lineWidth: 2.5, lineCap: .round))

            // Ícono de avión en la punta del arco
            let clampedP = min(1.0, max(0.05, progress))
            let posX = 5 + (w - 10) * CGFloat(clampedP)
            let posY = (h - 4) - sin(clampedP * .pi) * (h * 0.7)

            Image(systemName: "airplane")
                .font(.system(size: 11, weight: .bold))
                .foregroundColor(color)
                .rotationEffect(.degrees(clampedP < 0.5 ? -10 : 10))
                .position(x: posX, y: posY)
        }
    }
}

// Visual para Dynamic Island inferior
@ViewBuilder
func ScenarioDynamicIslandBottom(context: ActivityViewContext<DeliveryAttributes>) -> some View {
    switch context.state.scenarioType {
    case "trading":
        SparklineChart(step: context.state.currentStep, color: themeColor(for: context.state.accentColor))
            .frame(height: 24)
    case "flight":
        FlightPathArc(progress: Double(context.state.currentStep) / Double(context.state.totalSteps), color: themeColor(for: context.state.accentColor))
            .frame(height: 20)
    case "sports":
        HStack {
            Text("RMA 2 - 1 MCI")
                .font(.system(size: 11, weight: .heavy))
                .foregroundColor(themeColor(for: context.state.accentColor))
            Spacer()
            Text(context.state.timeRange)
                .font(.system(size: 10, weight: .black))
                .foregroundColor(.white)
        }
    default:
        HStack(spacing: 4) {
            ForEach(1...context.state.totalSteps, id: \.self) { step in
                Capsule()
                    .fill(step <= context.state.currentStep ? themeColor(for: context.state.accentColor) : Color.white.opacity(0.2))
                    .frame(height: 4)
            }
        }
    }
}

// MARK: - Helpers
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

func themeColor(for colorName: String) -> Color {
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
