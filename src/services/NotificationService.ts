import { NativeModules, Platform } from 'react-native';

const { LiveNotificationModule } = NativeModules;

export interface LiveActivityParams {
  restaurantName?: string;
  status?: string;
  timeRange?: string;
  step?: number;
}

export const NotificationService = {
  /**
   * Solicita permisos para notificaciones y verifica soporte de Live Activities
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
   * Dispara una notificación estándar (estilo PedidosYa)
   */
  async sendStandardNotification(
    title: string = 'PedidosYa',
    body: string = 'El local ya recibió tu pedido. Te llegará entre las 12:40 - 1:00.'
  ): Promise<any> {
    if (Platform.OS !== 'ios' || !LiveNotificationModule) {
      console.log('[NotificationService Simulación] Notificación Estándar:', { title, body });
      return { success: true, simulated: true };
    }
    return await LiveNotificationModule.sendStandardNotification(title, body);
  },

  /**
   * Inicia una Live Activity en iOS con Dynamic Island y Lock Screen
   */
  async startLiveActivity({
    restaurantName = 'Sushi Express - Costa Verde',
    status = 'El local recibió tu pedido',
    timeRange = '12:40 - 1:00',
    step = 1,
  }: LiveActivityParams = {}): Promise<any> {
    if (Platform.OS !== 'ios' || !LiveNotificationModule) {
      console.log('[NotificationService Simulación] Iniciar Live Activity:', { restaurantName, status, timeRange, step });
      return { success: true, simulated: true };
    }
    return await LiveNotificationModule.startLiveActivity(restaurantName, status, timeRange, step);
  },

  /**
   * Actualiza el estado de una Live Activity existente (avanza el paso)
   */
  async updateLiveActivity({
    status = 'Preparando tu pedido',
    timeRange = '12:40 - 1:00',
    step = 2,
  }: LiveActivityParams): Promise<any> {
    if (Platform.OS !== 'ios' || !LiveNotificationModule) {
      console.log('[NotificationService Simulación] Actualizar Live Activity:', { status, timeRange, step });
      return { success: true, simulated: true };
    }
    return await LiveNotificationModule.updateLiveActivity(status, timeRange, step);
  },

  /**
   * Finaliza la Live Activity activa
   */
  async endLiveActivity(): Promise<any> {
    if (Platform.OS !== 'ios' || !LiveNotificationModule) {
      console.log('[NotificationService Simulación] Finalizar Live Activity');
      return { success: true, simulated: true };
    }
    return await LiveNotificationModule.endLiveActivity();
  },
};
