import { NativeModules, Platform } from 'react-native';

const { LiveNotificationModule } = NativeModules;

export interface LiveActivityScenarioConfig {
  scenarioType: 'trading' | 'grua' | 'pareja' | 'sports' | 'flight' | 'delivery';
  title: string;
  status: string;
  subtitle: string;
  timeRange: string;
  currentStep: number;
  totalSteps: number;
  badgeText: string;
  accentColor: 'green' | 'orange' | 'pink' | 'blue' | 'cyan' | 'red';
}

export const NotificationService = {
  /**
   * Solicita permisos para notificaciones y Live Activities
   */
  async requestPermissions(): Promise<{ notificationsGranted: boolean; liveActivitiesEnabled: boolean }> {
    if (Platform.OS !== 'ios' || !LiveNotificationModule) {
      console.warn('[NotificationService] Módulo nativo solo disponible en iOS.');
      return { notificationsGranted: true, liveActivitiesEnabled: true };
    }
    try {
      return await LiveNotificationModule.requestPermissions();
    } catch (error) {
      console.error('[NotificationService] Error al solicitar permisos:', error);
      throw error;
    }
  },

  /**
   * Dispara una notificación estándar con título y texto personalizado
   */
  async sendStandardNotification(title: string, body: string): Promise<any> {
    if (Platform.OS !== 'ios' || !LiveNotificationModule) {
      console.log('[NotificationService Simulación] Notificación Estándar:', { title, body });
      return { success: true, simulated: true };
    }
    return await LiveNotificationModule.sendStandardNotification(title, body);
  },

  /**
   * Inicia una Live Activity en Dynamic Island y Pantalla de Bloqueo
   */
  async startLiveActivity(config: LiveActivityScenarioConfig): Promise<any> {
    if (Platform.OS !== 'ios' || !LiveNotificationModule) {
      console.log('[NotificationService Simulación] Iniciar Live Activity:', config);
      return { success: true, simulated: true };
    }
    return await LiveNotificationModule.startLiveActivity(
      config.scenarioType,
      config.title,
      config.status,
      config.subtitle,
      config.timeRange,
      config.currentStep,
      config.totalSteps,
      config.badgeText,
      config.accentColor
    );
  },

  /**
   * Actualiza el estado y paso de una Live Activity existente
   */
  async updateLiveActivity(params: {
    status: string;
    subtitle: string;
    timeRange: string;
    currentStep: number;
    badgeText: string;
  }): Promise<any> {
    if (Platform.OS !== 'ios' || !LiveNotificationModule) {
      console.log('[NotificationService Simulación] Actualizar Live Activity:', params);
      return { success: true, simulated: true };
    }
    return await LiveNotificationModule.updateLiveActivity(
      params.status,
      params.subtitle,
      params.timeRange,
      params.currentStep,
      params.badgeText
    );
  },

  /**
   * Finaliza las Live Activities activas
   */
  async endLiveActivity(): Promise<any> {
    if (Platform.OS !== 'ios' || !LiveNotificationModule) {
      console.log('[NotificationService Simulación] Finalizar Live Activity');
      return { success: true, simulated: true };
    }
    return await LiveNotificationModule.endLiveActivity();
  },
};
