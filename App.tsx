import React, { useState, useEffect } from 'react';
import {
  SafeAreaView,
  StatusBar,
  StyleSheet,
  Text,
  TouchableOpacity,
  View,
  ActivityIndicator,
  Animated,
} from 'react-native';
import { NotificationService } from './src/services/NotificationService';

const STEPS = [
  { step: 1, title: 'El local recibió tu pedido', time: '12:40 - 1:00' },
  { step: 2, title: 'Preparando tu pedido', time: '12:45 - 1:00' },
  { step: 3, title: 'El repartidor va en camino', time: '12:50 - 1:00' },
  { step: 4, title: '¡Tu pedido ha sido entregado!', time: '12:58' },
];

export default function App() {
  const [loadingAction, setLoadingAction] = useState<string | null>(null);
  const [liveActivityStep, setLiveActivityStep] = useState<number>(0);
  const [lastMessage, setLastMessage] = useState<string>('Toca un botón para probar');

  useEffect(() => {
    // Solicitar permisos al abrir la aplicación
    NotificationService.requestPermissions()
      .then(res => {
        console.log('Permisos concedidos:', res);
      })
      .catch(err => {
        console.warn('Error solicitando permisos:', err);
      });
  }, []);

  // Botón 1: Disparar Notificación Estándar (PedidosYa)
  const handleTriggerStandardNotification = async () => {
    try {
      setLoadingAction('standard');
      setLastMessage('Enviando notificación estándar...');

      await NotificationService.sendStandardNotification(
        'PedidosYa',
        'El local ya recibió tu pedido. Te llegará entre las 12:40 - 1:00.'
      );

      setLastMessage('✓ Notificación PedidosYa enviada. ¡Revisa tu pantalla de bloqueo!');
    } catch (error: any) {
      setLastMessage(`Error: ${error?.message || 'Fallo al enviar notificación'}`);
    } finally {
      setLoadingAction(null);
    }
  };

  // Botón 2: Disparar / Avanzar Live Activity (Sushi Express)
  const handleTriggerLiveActivity = async () => {
    try {
      setLoadingAction('live');

      if (liveActivityStep === 0) {
        // Iniciar en el Paso 1 (idéntico a la captura)
        setLastMessage('Iniciando Live Activity en Dynamic Island & Lock Screen...');
        await NotificationService.startLiveActivity({
          restaurantName: 'Sushi Express - Costa Verde',
          status: STEPS[0].title,
          timeRange: STEPS[0].time,
          step: 1,
        });
        setLiveActivityStep(1);
        setLastMessage('✓ Live Activity activa en pantalla de bloqueo e Isla Dinámica');
      } else {
        // Avanzar al siguiente paso (2, 3 o 4)
        const nextStep = liveActivityStep < 4 ? liveActivityStep + 1 : 1;
        const stepData = STEPS[nextStep - 1];

        setLastMessage(`Actualizando a: "${stepData.title}"...`);
        await NotificationService.updateLiveActivity({
          status: stepData.title,
          timeRange: stepData.time,
          step: nextStep,
        });

        setLiveActivityStep(nextStep);
        setLastMessage(`✓ Live Activity actualizada al paso ${nextStep}/4`);
      }
    } catch (error: any) {
      setLastMessage(`Error Live Activity: ${error?.message || 'No disponible'}`);
    } finally {
      setLoadingAction(null);
    }
  };

  // Finalizar actividad en vivo si está activa
  const handleEndLiveActivity = async () => {
    try {
      setLoadingAction('end');
      await NotificationService.endLiveActivity();
      setLiveActivityStep(0);
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

      <View style={styles.container}>
        {/* Cabecera */}
        <View style={styles.header}>
          <View style={styles.pillTag}>
            <View style={styles.statusDot} />
            <Text style={styles.pillText}>SWIFT NATIVE + REACT NATIVE</Text>
          </View>
          <Text style={styles.title}>Notificaciones iOS</Text>
          <Text style={styles.subtitle}>
            Presiona cualquiera de los dos botones para disparar las notificaciones de la captura
          </Text>
        </View>

        {/* Feedback de estado */}
        <View style={styles.feedbackCard}>
          <Text style={styles.feedbackLabel}>ESTADO ACTUAL</Text>
          <Text style={styles.feedbackMessage}>{lastMessage}</Text>
        </View>

        {/* CONTENEDOR PRINCIPAL: LOS 2 BOTONES */}
        <View style={styles.buttonsContainer}>
          {/* BOTÓN 1: NOTIFICACIÓN ESTÁNDAR (PEDIDOSYA) */}
          <TouchableOpacity
            activeOpacity={0.82}
            style={[styles.actionCard, styles.standardCard]}
            onPress={handleTriggerStandardNotification}
            disabled={loadingAction !== null}
          >
            <View style={styles.cardHeader}>
              <View style={styles.logoBadgeRed}>
                <Text style={styles.logoBadgeText}>P</Text>
              </View>
              <View style={styles.cardBadge}>
                <Text style={styles.cardBadgeText}>BOTÓN 1</Text>
              </View>
            </View>

            <Text style={styles.cardTitle}>Notificación Estándar</Text>
            <Text style={styles.cardDescription}>
              Dispara el banner clásico estilo <Text style={styles.highlightText}>PedidosYa</Text> con hora de entrega (12:40 - 1:00).
            </Text>

            <View style={styles.buttonTriggerStandard}>
              {loadingAction === 'standard' ? (
                <ActivityIndicator color="#FFFFFF" size="small" />
              ) : (
                <Text style={styles.buttonTriggerText}>🔔 Disparar Notificación</Text>
              )}
            </View>
          </TouchableOpacity>

          {/* BOTÓN 2: LIVE ACTIVITY (SUSHI EXPRESS) */}
          <TouchableOpacity
            activeOpacity={0.82}
            style={[styles.actionCard, styles.liveActivityCard]}
            onPress={handleTriggerLiveActivity}
            disabled={loadingAction !== null}
          >
            <View style={styles.cardHeader}>
              <View style={styles.pulseContainer}>
                <View style={styles.pulseDot} />
                <Text style={styles.pulseText}>ACTIVITYKIT</Text>
              </View>
              <View style={styles.cardBadge}>
                <Text style={styles.cardBadgeText}>BOTÓN 2</Text>
              </View>
            </View>

            <Text style={styles.cardTitle}>Live Activity (En Vivo)</Text>
            <Text style={styles.cardDescription}>
              Inicia la tarjeta en <Text style={styles.highlightText}>Dynamic Island</Text> y Pantalla de Bloqueo de <Text style={styles.highlightText}>Sushi Express</Text> con barra de progreso de 4 pasos.
            </Text>

            {/* Visualización de los 4 pasos */}
            <View style={styles.stepsPreview}>
              {[1, 2, 3, 4].map(stepIndex => (
                <View
                  key={stepIndex}
                  style={[
                    styles.stepBar,
                    liveActivityStep >= stepIndex ? styles.stepBarActive : styles.stepBarInactive,
                  ]}
                />
              ))}
            </View>

            <View style={styles.buttonTriggerLive}>
              {loadingAction === 'live' ? (
                <ActivityIndicator color="#FFFFFF" size="small" />
              ) : (
                <Text style={styles.buttonTriggerText}>
                  {liveActivityStep === 0
                    ? '⚡ Iniciar Live Activity'
                    : `⏩ Avanzar Paso (${liveActivityStep}/4)`}
                </Text>
              )}
            </View>
          </TouchableOpacity>
        </View>

        {/* Botón secundario para detener Live Activity si está en ejecución */}
        {liveActivityStep > 0 && (
          <TouchableOpacity
            style={styles.endButton}
            onPress={handleEndLiveActivity}
            disabled={loadingAction !== null}
          >
            <Text style={styles.endButtonText}>✕ Finalizar Live Activity</Text>
          </TouchableOpacity>
        )}

        <View style={styles.footer}>
          <Text style={styles.footerText}>
            Compatible con iOS 16.1+ • Compilable vía GitHub Actions a IPA
          </Text>
        </View>
      </View>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  safeArea: {
    flex: 1,
    backgroundColor: '#0C0816',
  },
  container: {
    flex: 1,
    paddingHorizontal: 20,
    paddingTop: 12,
    paddingBottom: 24,
    justifyContent: 'space-between',
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
    paddingVertical: 5,
    borderRadius: 20,
    marginBottom: 12,
  },
  statusDot: {
    width: 6,
    height: 6,
    borderRadius: 3,
    backgroundColor: '#00F0A0',
    marginRight: 6,
  },
  pillText: {
    color: '#9E94B8',
    fontSize: 10,
    fontWeight: '700',
    letterSpacing: 0.8,
  },
  title: {
    fontSize: 28,
    fontWeight: '800',
    color: '#FFFFFF',
    letterSpacing: -0.5,
    marginBottom: 6,
  },
  subtitle: {
    fontSize: 13,
    color: '#8D85A5',
    textAlign: 'center',
    lineHeight: 18,
    paddingHorizontal: 15,
  },
  feedbackCard: {
    backgroundColor: 'rgba(255, 255, 255, 0.04)',
    borderRadius: 14,
    padding: 12,
    borderWidth: 1,
    borderColor: 'rgba(255, 255, 255, 0.07)',
    marginVertical: 8,
  },
  feedbackLabel: {
    color: '#6F6789',
    fontSize: 10,
    fontWeight: '800',
    letterSpacing: 0.6,
    marginBottom: 3,
  },
  feedbackMessage: {
    color: '#E0DBF0',
    fontSize: 13,
    fontWeight: '500',
  },
  buttonsContainer: {
    gap: 16,
    marginVertical: 8,
  },
  actionCard: {
    borderRadius: 20,
    padding: 18,
    borderWidth: 1,
    backgroundColor: '#150F26',
    shadowColor: '#000000',
    shadowOffset: { width: 0, height: 6 },
    shadowOpacity: 0.35,
    shadowRadius: 10,
    elevation: 8,
  },
  standardCard: {
    borderColor: 'rgba(255, 0, 56, 0.25)',
  },
  liveActivityCard: {
    borderColor: 'rgba(120, 80, 255, 0.35)',
  },
  cardHeader: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: 12,
  },
  logoBadgeRed: {
    width: 26,
    height: 26,
    borderRadius: 7,
    backgroundColor: '#FF0038',
    justifyContent: 'center',
    alignItems: 'center',
  },
  logoBadgeText: {
    color: '#FFFFFF',
    fontWeight: '900',
    fontSize: 14,
  },
  pulseContainer: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: 'rgba(138, 43, 226, 0.22)',
    paddingHorizontal: 8,
    paddingVertical: 4,
    borderRadius: 12,
  },
  pulseDot: {
    width: 6,
    height: 6,
    borderRadius: 3,
    backgroundColor: '#9B51E0',
    marginRight: 6,
  },
  pulseText: {
    color: '#D4B3FF',
    fontSize: 10,
    fontWeight: '700',
  },
  cardBadge: {
    backgroundColor: 'rgba(255, 255, 255, 0.07)',
    paddingHorizontal: 8,
    paddingVertical: 3,
    borderRadius: 6,
  },
  cardBadgeText: {
    color: '#A29BB9',
    fontSize: 10,
    fontWeight: '700',
  },
  cardTitle: {
    fontSize: 19,
    fontWeight: '700',
    color: '#FFFFFF',
    marginBottom: 6,
  },
  cardDescription: {
    fontSize: 13,
    color: '#9C95B5',
    lineHeight: 18,
    marginBottom: 14,
  },
  highlightText: {
    color: '#FFFFFF',
    fontWeight: '600',
  },
  stepsPreview: {
    flexDirection: 'row',
    gap: 6,
    marginBottom: 14,
  },
  stepBar: {
    flex: 1,
    height: 5,
    borderRadius: 3,
  },
  stepBarActive: {
    backgroundColor: '#FFFFFF',
  },
  stepBarInactive: {
    backgroundColor: 'rgba(255, 255, 255, 0.18)',
  },
  buttonTriggerStandard: {
    backgroundColor: '#FF0038',
    borderRadius: 12,
    paddingVertical: 12,
    alignItems: 'center',
    justifyContent: 'center',
  },
  buttonTriggerLive: {
    backgroundColor: '#6C3EE8',
    borderRadius: 12,
    paddingVertical: 12,
    alignItems: 'center',
    justifyContent: 'center',
  },
  buttonTriggerText: {
    color: '#FFFFFF',
    fontSize: 15,
    fontWeight: '700',
  },
  endButton: {
    backgroundColor: 'rgba(255, 255, 255, 0.08)',
    borderRadius: 10,
    paddingVertical: 8,
    alignItems: 'center',
    alignSelf: 'center',
    paddingHorizontal: 16,
    marginVertical: 4,
  },
  endButtonText: {
    color: '#D47E8B',
    fontSize: 12,
    fontWeight: '600',
  },
  footer: {
    alignItems: 'center',
    paddingTop: 8,
  },
  footerText: {
    color: '#57506F',
    fontSize: 11,
    textAlign: 'center',
  },
});
