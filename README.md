# NotificationApp (React Native + Swift Live Activities)

Aplicación móvil desarrollada en **React Native** con módulos nativos en **Swift** y **SwiftUI** (ActivityKit + UserNotifications), diseñada para simular e interactuar con los dos tipos de notificaciones de la pantalla de bloqueo de iOS:

1. **Notificación Estándar**: Notificación push/local idéntica a **PedidosYa** (*"El local ya recibió tu pedido. Te llegará entre las 12:40 - 1:00"*).
2. **Live Activity (Actividad en Vivo)**: Notificación en vivo interactiva para **Dynamic Island** y **Pantalla de Bloqueo** idéntica a **Sushi Express** (*"El local recibió tu pedido"*, barra de progreso segmentada de 4 estados, icono de recibo con checkmark verde y tiempo estimado de entrega).

---

## 📱 Capturas y Funcionalidad

| Notificación Estándar (Botón 1) | Live Activity en Bloqueo & Dynamic Island (Botón 2) |
|---|---|
| • Icono rojo PedidosYa<br>• Título y hora estimada de entrega<br>• Notificación instantánea de sistema vía `UNUserNotificationCenter` | • Widget nativo SwiftUI con `ActivityKit`<br>• Barra de progreso de 4 pasos (Recibido → Preparando → En camino → Entregado)<br>• Soporte completo de Dynamic Island expandida y compacta |

---

## 🛠️ Estructura del Código

```
├── App.tsx                                   # UI en React Native con los 2 botones de acción
├── src/
│   └── services/
│       └── NotificationService.ts            # Wrapper TypeScript para el módulo nativo Swift
├── ios/
│   ├── NotificationApp/
│   │   ├── AppDelegate.swift                 # Entrada nativa de la app
│   │   ├── DeliveryAttributes.swift          # Estructura ActivityAttributes para ActivityKit
│   │   ├── LiveNotificationModule.swift      # Lógica en Swift (UserNotifications + ActivityKit)
│   │   ├── LiveNotificationModule.m          # Exportación de métodos al bridge de React Native
│   │   ├── NotificationApp-Bridging-Header.h # Bridging Header Obj-C a Swift
│   │   └── Info.plist                        # NSSupportsLiveActivities = YES
│   ├── LiveActivityExtension/
│   │   ├── DeliveryLiveActivity.swift        # UI en SwiftUI (Lock Screen & Dynamic Island)
│   │   ├── LiveActivityBundle.swift          # WidgetBundle de iOS
│   │   └── Info.plist                        # Configuración widgetkit-extension
│   └── Podfile                               # Configurado para iOS 16.2+
└── .github/workflows/
    └── build-ipa.yml                         # Workflow GitHub Actions para generar el .ipa
```

---

## 🚀 Compilar el archivo `.ipa` con GitHub Actions

El repositorio ya cuenta con el flujo de trabajo automatizado en `.github/workflows/build-ipa.yml`.

### Pasos para generar tu `.ipa`:

1. **Subir este código a tu repositorio de GitHub**:
   ```bash
   git init
   git add .
   git commit -m "feat: app react native con notificaciones swift y live activity"
   git branch -M main
   git remote add origin https://github.com/TU_USUARIO/TU_REPOSITORIO.git
   git push -u origin main
   ```

2. **Ejecutar la compilación**:
   - En GitHub, ve a la pestaña **Actions**.
   - Verás el workflow llamado **"Compilar IPA (iOS)"**.
   - Haz clic en **Run workflow** (o se ejecutará automáticamente con el `push`).
   - El workflow usa runners `macos-14` con Xcode para compilar el proyecto y empaquetar el `.ipa`.

3. **Descargar el archivo `.ipa`**:
   - Una vez finalizado el workflow (aprox. 5 a 10 minutos), entra a la ejecución.
   - En la sección inferior **Artifacts**, descarga el archivo **`NotificationApp-iOS-IPA`**.
   - Al descomprimir el zip obtendrás directamente **`NotificationApp.ipa`**.

---

## 📲 Cómo instalar el `.ipa` en tu iPhone

Puedes instalar el archivo `.ipa` en cualquier iPhone con iOS 16.1 o superior utilizando cualquiera de estos métodos sencillos:

- **Sideloadly (Recomendado - Mac y Windows)**: Conecta el iPhone por cable, arrastra el `.ipa` a Sideloadly, coloca tu Apple ID y presiona Start.
- **AltStore**: Abre el `.ipa` con AltStore en tu dispositivo.
- **TrollStore**: Si tu dispositivo cuenta con TrollStore, instala con un solo toque sin vencimiento de certificado.
- **TestFlight / App Store**: Si cuentas con certificado de desarrollador Apple Developer, puedes firmar el archivo o compilar con los perfiles en GitHub Actions.
