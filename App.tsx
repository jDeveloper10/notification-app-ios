import React, { useState, useEffect } from 'react';
import {
  SafeAreaView,
  StatusBar,
  StyleSheet,
  Text,
  TouchableOpacity,
  View,
  ActivityIndicator,
  ScrollView,
  Image,
} from 'react-native';
import { NotificationService, LiveActivityScenarioConfig } from './src/services/NotificationService';

interface ScenarioDefinition {
  id: 'trading' | 'grua' | 'pareja' | 'sports' | 'flight' | 'delivery';
  label: string;
  badge: string;
  accent: 'green' | 'orange' | 'pink' | 'blue' | 'cyan' | 'red';
  accentHex: string;
  image: any;
  standardTitle: string;
  standardBody: string;
  steps: {
    title: string;
    status: string;
    subtitle: string;
    timeRange: string;
    badgeText: string;
  }[];
}

const SCENARIOS: ScenarioDefinition[] = [
  {
    id: 'trading',
    label: '📈 Trading Signal',
    badge: 'CRYPTO / FOREX',
    accent: 'green',
    accentHex: '#00F0A0',
    image: require('./src/assets/images/trading.jpg'),
    standardTitle: '📈 Alerta Binance: BTC/USDT',
    standardBody: '¡Take Profit 2 alcanzado en $67,850! Ganancia neta: +14.8%.',
    steps: [
      {
        title: 'BTC/USDT LONG',
        status: 'Señal Activada en $64,200',
        subtitle: 'Stop Loss: $62,800 • Target 1: $65,500',
        timeRange: '+3.2%',
        badgeText: 'ACTIVA',
      },
      {
        title: 'BTC/USDT LONG',
        status: 'Take Profit 1 Alcanzado ($65,500)',
        subtitle: 'Subiendo Stop Loss a Breakeven ($64,200)',
        timeRange: '+7.5%',
        badgeText: 'TP 1 ✓',
      },
      {
        title: 'BTC/USDT LONG',
        status: 'Take Profit 2 Alcanzado ($67,850)',
        subtitle: 'Volumen comprador récord • Target 3: $69,100',
        timeRange: '+14.8%',
        badgeText: 'TP 2 ✓',
      },
      {
        title: 'BTC/USDT LONG',
        status: '¡Target Final Alcanzado! ($69,100)',
        subtitle: 'Operación cerrada exitosamente con ganancia total',
        timeRange: '+18.5%',
        badgeText: 'WINNER 🏆',
      },
    ],
  },
  {
    id: 'grua',
    label: '🚛 Gruapp Asistencia',
    badge: 'ASISTENCIA VIAL',
    accent: 'orange',
    accentHex: '#FF8C00',
    image: require('./src/assets/images/grua.jpg'),
    standardTitle: '🚛 Gruapp: Tu grúa está cerca',
    standardBody: 'El operador Carlos M. con la grúa Ford F-350 está a 5 minutos de tu ubicación.',
    steps: [
      {
        title: 'Gruapp Asistencia',
        status: 'Grúa Asignada: Ford F-350',
        subtitle: 'Operador: Carlos M. • Placa: ABC-123',
        timeRange: '15 min',
        badgeText: 'ASIGNADA',
      },
      {
        title: 'Gruapp Asistencia',
        status: 'Grúa en Camino hacia tu Auto',
        subtitle: 'Avanzando por Av. Principal • Tráfico fluido',
        timeRange: '8 min',
        badgeText: 'EN RUTA',
      },
      {
        title: 'Gruapp Asistencia',
        status: '¡La Grúa ha Llegado al Lugar!',
        subtitle: 'El operador está estacionando frente a tu auto',
        timeRange: 'En sitio',
        badgeText: 'LLEGÓ ✓',
      },
      {
        title: 'Gruapp Asistencia',
        status: 'Vehículo Asegurado y en Remolque',
        subtitle: 'Traslado seguro hacia el taller seleccionado',
        timeRange: 'En destino',
        badgeText: 'EN TALLER',
      },
    ],
  },
  {
    id: 'pareja',
    label: '❤️ Pareja Llegando',
    badge: 'LOVE RADAR GPS',
    accent: 'pink',
    accentHex: '#FF4081',
    image: require('./src/assets/images/pareja.jpg'),
    standardTitle: '❤️ Mi Amor está cerca',
    standardBody: 'Valentina está a 1.2 km de casa (aprox. 4 minutos). ¡Prepara la cena!',
    steps: [
      {
        title: 'Mi Amor ❤️',
        status: 'Valentina Salió del Trabajo',
        subtitle: 'En camino a casa • Batería: 85% 🔋',
        timeRange: '18 min',
        badgeText: 'SALIDA',
      },
      {
        title: 'Mi Amor ❤️',
        status: 'Avanzando a 3.5 km de Distancia',
        subtitle: 'Comprando algo rápido de camino • Batería: 81%',
        timeRange: '10 min',
        badgeText: 'EN RUTA',
      },
      {
        title: 'Mi Amor ❤️',
        status: '¡A solo 1.2 km de Casa!',
        subtitle: 'Buscando estacionamiento • Batería: 78% 🔋',
        timeRange: '4 min',
        badgeText: 'CERCA',
      },
      {
        title: 'Mi Amor ❤️',
        status: '¡Ha Llegado a la Puerta! 🥰',
        subtitle: 'Tocando el timbre ahora mismo',
        timeRange: '¡EN CASA!',
        badgeText: 'LLEGÓ ❤️',
      },
    ],
  },
  {
    id: 'sports',
    label: '⚽ Champions Live',
    badge: 'FÚTBOL EN VIVO',
    accent: 'blue',
    accentHex: '#2196F3',
    image: require('./src/assets/images/sports.jpg'),
    standardTitle: '⚽ Champions League: ¡GOOOOL!',
    standardBody: 'Vinicius Jr. (74\') anota el 2-1 con remate cruzado en el Bernabéu.',
    steps: [
      {
        title: 'R. Madrid vs Man City',
        status: 'Inicio del Segundo Tiempo (1 - 1)',
        subtitle: 'Posesión: 54% vs 46% • Tiros: 12 vs 10',
        timeRange: '52\'',
        badgeText: 'EN JUEGO',
      },
      {
        title: 'R. Madrid vs Man City',
        status: '¡GOOOOL DE VINICIUS! (2 - 1)',
        subtitle: 'Golazo al ángulo desde fuera del área',
        timeRange: '74\'',
        badgeText: '¡GOL! ⚽',
      },
      {
        title: 'R. Madrid vs Man City',
        status: 'Minutos Finales de Alta Tensión',
        subtitle: 'Tarjeta Amarilla para R. Madrid • 4 min de descuento',
        timeRange: '89\'',
        badgeText: 'FINAL ⌛',
      },
      {
        title: 'R. Madrid vs Man City',
        status: '¡Final del Partido! Victoria 2 - 1',
        subtitle: 'El Madrid clasifica a la Gran Final',
        timeRange: 'FIN',
        badgeText: 'VICTORIA 🏆',
      },
    ],
  },
  {
    id: 'flight',
    label: '✈️ Flight Tracker',
    badge: 'AEROLÍNEA PRO',
    accent: 'cyan',
    accentHex: '#00E5FF',
    image: require('./src/assets/images/flight.jpg'),
    standardTitle: '✈️ Vuelo IB-6251: Puerta de Embarque',
    standardBody: 'Tu vuelo Madrid -> Miami ahora embarca por la Puerta B24 (Grupo 2).',
    steps: [
      {
        title: 'Vuelo IB-6251 (MAD ➔ MIA)',
        status: 'Embarque Iniciado en Puerta B24',
        subtitle: 'Asiento 12A • Salida estimada: 15:45',
        timeRange: 'Puerta B24',
        badgeText: 'EMBARQUE',
      },
      {
        title: 'Vuelo IB-6251 (MAD ➔ MIA)',
        status: 'Despegue Confirmado y en Ascenso',
        subtitle: 'Altitud: 34,000 pies • Velocidad: 890 km/h',
        timeRange: '7h 15m',
        badgeText: 'VOLANDO ✈️',
      },
      {
        title: 'Vuelo IB-6251 (MAD ➔ MIA)',
        status: 'Sobrevolando el Océano Atlántico',
        subtitle: 'Vuelo tranquilo sin turbulencias • Wi-Fi activo',
        timeRange: '3h 40m',
        badgeText: 'EN RUTA',
      },
      {
        title: 'Vuelo IB-6251 (MAD ➔ MIA)',
        status: '¡Aterrizaje en Miami Exitoso!',
        subtitle: 'Recogida de equipaje en Banda #4',
        timeRange: 'A tiempo',
        badgeText: 'LLEGADA ✓',
      },
    ],
  },
  {
    id: 'delivery',
    label: '🍣 Sushi Express',
    badge: 'DELIVERY COMIDA',
    accent: 'red',
    accentHex: '#FF0038',
    image: require('./src/assets/images/trading.jpg'),
    standardTitle: 'PedidosYa',
    standardBody: 'El local ya recibió tu pedido. Te llegará entre las 12:40 - 1:00.',
    steps: [
      {
        title: 'Sushi Express - Costa Verde',
        status: 'El local recibió tu pedido',
        subtitle: 'A tiempo',
        timeRange: '12:40 - 1:00',
        badgeText: 'RECIBIDO',
      },
      {
        title: 'Sushi Express - Costa Verde',
        status: 'Preparando tu sushi y rolls',
        subtitle: 'El chef está en proceso • A tiempo',
        timeRange: '12:45 - 1:00',
        badgeText: 'COCINA',
      },
      {
        title: 'Sushi Express - Costa Verde',
        status: 'El repartidor va en camino',
        subtitle: 'En moto hacia tu dirección • A tiempo',
        timeRange: '12:52 - 1:00',
        badgeText: 'EN VIAJE',
      },
      {
        title: 'Sushi Express - Costa Verde',
        status: '¡Tu pedido ha sido entregado!',
        subtitle: '¡Que disfrutes tu comida! • A tiempo',
        timeRange: '12:58',
        badgeText: 'ENTREGADO',
      },
    ],
  },
];

export default function App() {
  const [selectedScenarioIndex, setSelectedScenarioIndex] = useState(0);
  const [currentStepIndex, setCurrentStepIndex] = useState(0);
  const [isLiveActive, setIsLiveActive] = useState(false);
  const [loadingAction, setLoadingAction] = useState<string | null>(null);
  const [lastMessage, setLastMessage] = useState('Selecciona un escenario y presiona los botones');

  const activeScenario = SCENARIOS[selectedScenarioIndex];

  useEffect(() => {
    NotificationService.requestPermissions()
      .then(res => console.log('Permisos concedidos:', res))
      .catch(err => console.warn('Error permisos:', err));
  }, []);

  // Disparar Notificación Push Estándar
  const handleTriggerStandardNotification = async () => {
    try {
      setLoadingAction('standard');
      setLastMessage('Verificando permisos...');
      await NotificationService.requestPermissions();

      setLastMessage(`Enviando notificación: ${activeScenario.standardTitle}...`);
      await NotificationService.sendStandardNotification(
        activeScenario.standardTitle,
        activeScenario.standardBody
      );

      setLastMessage(`✓ Notificación "${activeScenario.label}" enviada.`);
    } catch (error: any) {
      setLastMessage(`Error: ${error?.message || 'Fallo al enviar notificación'}`);
    } finally {
      setLoadingAction(null);
    }
  };

  // Iniciar / Avanzar Live Activity en Dynamic Island & Lock Screen
  const handleTriggerLiveActivity = async () => {
    try {
      setLoadingAction('live');
      await NotificationService.requestPermissions();

      if (!isLiveActive) {
        // Iniciar en Paso 1
        const stepData = activeScenario.steps[0];
        setLastMessage(`Iniciando Live Activity (${activeScenario.label})...`);

        const config: LiveActivityScenarioConfig = {
          scenarioType: activeScenario.id,
          title: stepData.title,
          status: stepData.status,
          subtitle: stepData.subtitle,
          timeRange: stepData.timeRange,
          currentStep: 1,
          totalSteps: activeScenario.steps.length,
          badgeText: stepData.badgeText,
          accentColor: activeScenario.accent,
        };

        await NotificationService.startLiveActivity(config);
        setIsLiveActive(true);
        setCurrentStepIndex(0);
        setLastMessage(`✓ Live Activity activa en pantalla de bloqueo e Isla Dinámica.`);
      } else {
        // Avanzar al siguiente paso
        const nextStepIndex = (currentStepIndex + 1) % activeScenario.steps.length;
        const stepData = activeScenario.steps[nextStepIndex];

        setLastMessage(`Actualizando a: "${stepData.status}"...`);

        await NotificationService.updateLiveActivity({
          status: stepData.status,
          subtitle: stepData.subtitle,
          timeRange: stepData.timeRange,
          currentStep: nextStepIndex + 1,
          badgeText: stepData.badgeText,
        });

        setCurrentStepIndex(nextStepIndex);
        setLastMessage(`✓ Paso ${nextStepIndex + 1}/${activeScenario.steps.length}: ${stepData.badgeText}`);
      }
    } catch (error: any) {
      setLastMessage(`Error Live Activity: ${error?.message || 'No disponible'}`);
    } finally {
      setLoadingAction(null);
    }
  };

  // Finalizar Live Activity
  const handleEndLiveActivity = async () => {
    try {
      setLoadingAction('end');
      await NotificationService.endLiveActivity();
      setIsLiveActive(false);
      setCurrentStepIndex(0);
      setLastMessage('Live Activity finalizada.');
    } catch (error: any) {
      setLastMessage(`Error al finalizar: ${error?.message || 'Error'}`);
    } finally {
      setLoadingAction(null);
    }
  };

  return (
    <SafeAreaView style={styles.safeArea}>
      <StatusBar barStyle="light-content" />

      <ScrollView contentContainerStyle={styles.scrollContent} showsVerticalScrollIndicator={false}>
        {/* Cabecera */}
        <View style={styles.header}>
          <View style={styles.pillTag}>
            <View style={styles.statusDot} />
            <Text style={styles.pillText}>IOS 16.1+ ACTIVITYKIT & DYNAMIC ISLAND</Text>
          </View>
          <Text style={styles.title}>Live Activities Pro</Text>
          <Text style={styles.subtitle}>
            Trading • Grúas • Pareja • Deportes • Vuelos • Delivery
          </Text>
        </View>

        {/* Selector Horizontal de Escenarios */}
        <ScrollView
          horizontal
          showsHorizontalScrollIndicator={false}
          contentContainerStyle={styles.tabsContainer}
        >
          {SCENARIOS.map((sc, idx) => {
            const isSelected = idx === selectedScenarioIndex;
            return (
              <TouchableOpacity
                key={sc.id}
                onPress={() => {
                  setSelectedScenarioIndex(idx);
                  setIsLiveActive(false);
                  setCurrentStepIndex(0);
                }}
                style={[
                  styles.tabChip,
                  isSelected && {
                    backgroundColor: sc.accentHex + '25',
                    borderColor: sc.accentHex,
                  },
                ]}
              >
                <Text
                  style={[
                    styles.tabChipText,
                    isSelected && { color: sc.accentHex, fontWeight: '800' },
                  ]}
                >
                  {sc.label}
                </Text>
              </TouchableOpacity>
            );
          })}
        </ScrollView>

        {/* Tarjeta del Escenario Activo con Ilustración Generada */}
        <View style={[styles.heroCard, { borderColor: activeScenario.accentHex + '40' }]}>
          <Image source={activeScenario.image} style={styles.heroImage} />

          <View style={styles.heroInfo}>
            <View style={styles.heroBadgeRow}>
              <View
                style={[
                  styles.scenarioBadge,
                  { backgroundColor: activeScenario.accentHex + '20', borderColor: activeScenario.accentHex },
                ]}
              >
                <Text style={[styles.scenarioBadgeText, { color: activeScenario.accentHex }]}>
                  {activeScenario.badge}
                </Text>
              </View>
              {isLiveActive && (
                <View style={styles.liveIndicator}>
                  <View style={[styles.liveDot, { backgroundColor: activeScenario.accentHex }]} />
                  <Text style={[styles.liveText, { color: activeScenario.accentHex }]}>
                    EN VIVO (Paso {currentStepIndex + 1}/{activeScenario.steps.length})
                  </Text>
                </View>
              )}
            </View>

            <Text style={styles.heroTitle}>{activeScenario.steps[currentStepIndex].title}</Text>
            <Text style={styles.heroStatus}>{activeScenario.steps[currentStepIndex].status}</Text>
            <Text style={styles.heroSubtitle}>{activeScenario.steps[currentStepIndex].subtitle}</Text>

            {/* Barra de progreso de pasos */}
            <View style={styles.stepBarsContainer}>
              {activeScenario.steps.map((_, i) => (
                <View
                  key={i}
                  style={[
                    styles.stepBarItem,
                    i <= currentStepIndex
                      ? { backgroundColor: activeScenario.accentHex }
                      : styles.stepBarItemInactive,
                  ]}
                />
              ))}
            </View>
          </View>
        </View>

        {/* Feedback de estado */}
        <View style={styles.feedbackCard}>
          <Text style={styles.feedbackLabel}>CONSOLA DE ESTADO</Text>
          <Text style={styles.feedbackMessage}>{lastMessage}</Text>
        </View>

        {/* LOS DOS BOTONES PRINCIPALES */}
        <View style={styles.actionButtons}>
          {/* BOTÓN 1: NOTIFICACIÓN ESTÁNDAR */}
          <TouchableOpacity
            activeOpacity={0.82}
            style={[styles.primaryButton, { backgroundColor: '#1E1632', borderColor: '#362A58' }]}
            onPress={handleTriggerStandardNotification}
            disabled={loadingAction !== null}
          >
            <Text style={styles.buttonIcon}>🔔</Text>
            <View style={styles.buttonTextContainer}>
              <Text style={styles.buttonTitle}>Botón 1: Notificación Push</Text>
              <Text style={styles.buttonSubtitle}>Alerta estándar con sonido y banner de sistema</Text>
            </View>
            {loadingAction === 'standard' && <ActivityIndicator color="#FFF" size="small" />}
          </TouchableOpacity>

          {/* BOTÓN 2: LIVE ACTIVITY */}
          <TouchableOpacity
            activeOpacity={0.82}
            style={[
              styles.primaryButton,
              {
                backgroundColor: activeScenario.accentHex + '18',
                borderColor: activeScenario.accentHex,
              },
            ]}
            onPress={handleTriggerLiveActivity}
            disabled={loadingAction !== null}
          >
            <Text style={styles.buttonIcon}>⚡</Text>
            <View style={styles.buttonTextContainer}>
              <Text style={[styles.buttonTitle, { color: activeScenario.accentHex }]}>
                {isLiveActive
                  ? `Avanzar Paso (${currentStepIndex + 1}/${activeScenario.steps.length})`
                  : 'Botón 2: Iniciar Live Activity'}
              </Text>
              <Text style={styles.buttonSubtitle}>
                {isLiveActive
                  ? 'Toca para simular el siguiente estado en vivo'
                  : 'Dynamic Island e interactiva en Lock Screen'}
              </Text>
            </View>
            {loadingAction === 'live' && <ActivityIndicator color={activeScenario.accentHex} size="small" />}
          </TouchableOpacity>

          {/* Finalizar Live Activity */}
          {isLiveActive && (
            <TouchableOpacity
              style={styles.endLiveButton}
              onPress={handleEndLiveActivity}
              disabled={loadingAction !== null}
            >
              <Text style={styles.endLiveButtonText}>✕ Cerrar Actividad en Vivo</Text>
            </TouchableOpacity>
          )}
        </View>

        <View style={styles.footer}>
          <Text style={styles.footerText}>
            Compatible con iOS 16.1+ • Pantalla de Bloqueo & Dynamic Island
          </Text>
        </View>
      </ScrollView>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  safeArea: {
    flex: 1,
    backgroundColor: '#090611',
  },
  scrollContent: {
    paddingHorizontal: 18,
    paddingTop: 8,
    paddingBottom: 30,
  },
  header: {
    alignItems: 'center',
    marginVertical: 10,
  },
  pillTag: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: 'rgba(255, 255, 255, 0.08)',
    paddingHorizontal: 12,
    paddingVertical: 4,
    borderRadius: 20,
    marginBottom: 8,
  },
  statusDot: {
    width: 6,
    height: 6,
    borderRadius: 3,
    backgroundColor: '#00F0A0',
    marginRight: 6,
  },
  pillText: {
    color: '#A79EC2',
    fontSize: 10,
    fontWeight: '800',
    letterSpacing: 0.8,
  },
  title: {
    fontSize: 26,
    fontWeight: '900',
    color: '#FFFFFF',
    letterSpacing: -0.5,
    marginBottom: 4,
  },
  subtitle: {
    fontSize: 12,
    color: '#837A9E',
    textAlign: 'center',
  },
  tabsContainer: {
    paddingVertical: 10,
    gap: 8,
  },
  tabChip: {
    paddingHorizontal: 14,
    paddingVertical: 8,
    borderRadius: 20,
    backgroundColor: 'rgba(255, 255, 255, 0.06)',
    borderWidth: 1,
    borderColor: 'rgba(255, 255, 255, 0.1)',
  },
  tabChipText: {
    color: '#9F96BA',
    fontSize: 12,
    fontWeight: '600',
  },
  heroCard: {
    backgroundColor: '#130E24',
    borderRadius: 22,
    overflow: 'hidden',
    borderWidth: 1.5,
    marginVertical: 10,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 8 },
    shadowOpacity: 0.4,
    shadowRadius: 12,
    elevation: 10,
  },
  heroImage: {
    width: '100%',
    height: 180,
    resizeMode: 'cover',
  },
  heroInfo: {
    padding: 16,
  },
  heroBadgeRow: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: 8,
  },
  scenarioBadge: {
    paddingHorizontal: 8,
    paddingVertical: 3,
    borderRadius: 6,
    borderWidth: 1,
  },
  scenarioBadgeText: {
    fontSize: 10,
    fontWeight: '900',
  },
  liveIndicator: {
    flexDirection: 'row',
    alignItems: 'center',
  },
  liveDot: {
    width: 6,
    height: 6,
    borderRadius: 3,
    marginRight: 6,
  },
  liveText: {
    fontSize: 10,
    fontWeight: '800',
  },
  heroTitle: {
    fontSize: 18,
    fontWeight: '800',
    color: '#FFFFFF',
    marginBottom: 4,
  },
  heroStatus: {
    fontSize: 15,
    fontWeight: '700',
    color: '#E0DBF0',
    marginBottom: 4,
  },
  heroSubtitle: {
    fontSize: 12,
    color: '#8E85A7',
    marginBottom: 12,
  },
  stepBarsContainer: {
    flexDirection: 'row',
    gap: 5,
  },
  stepBarItem: {
    flex: 1,
    height: 4,
    borderRadius: 2,
  },
  stepBarItemInactive: {
    backgroundColor: 'rgba(255, 255, 255, 0.16)',
  },
  feedbackCard: {
    backgroundColor: 'rgba(255, 255, 255, 0.04)',
    borderRadius: 14,
    padding: 12,
    borderWidth: 1,
    borderColor: 'rgba(255, 255, 255, 0.08)',
    marginVertical: 6,
  },
  feedbackLabel: {
    color: '#655D7E',
    fontSize: 9,
    fontWeight: '800',
    letterSpacing: 0.6,
    marginBottom: 3,
  },
  feedbackMessage: {
    color: '#D4CEE6',
    fontSize: 12,
    fontWeight: '500',
  },
  actionButtons: {
    gap: 12,
    marginVertical: 10,
  },
  primaryButton: {
    flexDirection: 'row',
    alignItems: 'center',
    padding: 14,
    borderRadius: 16,
    borderWidth: 1.5,
  },
  buttonIcon: {
    fontSize: 24,
    marginRight: 12,
  },
  buttonTextContainer: {
    flex: 1,
  },
  buttonTitle: {
    fontSize: 15,
    fontWeight: '800',
    color: '#FFFFFF',
    marginBottom: 2,
  },
  buttonSubtitle: {
    fontSize: 11,
    color: '#8C84A6',
  },
  endLiveButton: {
    alignSelf: 'center',
    paddingVertical: 8,
    paddingHorizontal: 16,
    backgroundColor: 'rgba(255, 255, 255, 0.06)',
    borderRadius: 10,
  },
  endLiveButtonText: {
    color: '#D97A88',
    fontSize: 12,
    fontWeight: '700',
  },
  footer: {
    alignItems: 'center',
    paddingTop: 10,
  },
  footerText: {
    color: '#4B4362',
    fontSize: 10,
    textAlign: 'center',
  },
});
