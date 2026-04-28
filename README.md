# VozmeFit

Aplicación móvil de gestión de entrenamiento personal, desarrollada con **Flutter** y **Firebase** como Trabajo de Fin de Grado (DAM 2025–2026).

---

## Descripción

VozmeFit es una app multiplataforma (Android / iOS) con sistema de doble rol:

- **Entrenador** — crea, edita y elimina rutinas de entrenamiento clasificadas por nivel.
- **Usuario** — accede a rutinas filtradas por su nivel físico, registra sesiones, planifica su semana y consulta estadísticas de progreso.

---

## Características principales

| Módulo | Descripción |
|---|---|
| Autenticación | Email/contraseña y Google Sign-In con selección de rol |
| Panel entrenador | CRUD completo de rutinas con ejercicios reordenables |
| Mi Rutina | Filtrado automático por nivel del usuario |
| Registro de sesiones | Peso, repeticiones y sensación de esfuerzo (fácil/normal/duro) |
| Agenda semanal | Planificación por día con vinculación a entrenamientos |
| Estadísticas | Historial, peso máximo y distribución de esfuerzo |
| Perfil | Nombre editable y selector de nivel físico |
| Seed data | Botón de datos de ejemplo en el panel del entrenador (solo debug) |

---

## Tecnología

- **Flutter 3.x / Dart >= 3.0**
- **Firebase Authentication** (email + Google)
- **Cloud Firestore** (NoSQL en tiempo real)
- **Provider 6.x** (gestión de estado)
- **Clean Architecture** (data / repository / presentation)

---

## Estructura del proyecto

```
lib/
├── app/
│   ├── router.dart       # Rutas nombradas centralizadas
│   └── theme.dart        # Paleta corporativa (aqua blue + negro)
├── data/
│   ├── firebase/         # AuthService, TrainingService
│   ├── models/           # Usuario, Training, Exercise
│   ├── repositories/     # AuthRepository
│   └── services/         # UserService, WorkoutLogService, AgendaService, RoutineService
├── presentation/
│   ├── providers/        # AuthProvider
│   ├── screens/          # login, home, trainer, profile, stats, agenda, workouts, my_routine
│   └── widgets/          # Componentes reutilizables
└── main.dart
```

---

## Instalación y ejecución

### Requisitos previos

- [Flutter SDK](https://docs.flutter.dev/get-started/install) >= 3.0
- [Android Studio](https://developer.android.com/studio) o Xcode (para iOS)
- Cuenta de Firebase con proyecto configurado

### Pasos

```bash
# 1. Clonar el repositorio
git clone https://github.com/[usuario]/vozmefit.git
cd vozmefit

# 2. Instalar dependencias
flutter pub get

# 3. Configurar Firebase
#    - Descarga google-services.json y colócalo en android/app/
#    - Descarga GoogleService-Info.plist y colócalo en ios/Runner/

# 4. Ejecutar
flutter run
```

### Ejecutar en Chrome (web)

```bash
flutter run -d chrome
```

---

## Configuración de Firebase

Este proyecto requiere un proyecto Firebase con los siguientes servicios activos:

1. **Firebase Authentication** — habilitar proveedores: Email/Contraseña y Google.
2. **Cloud Firestore** — crear base de datos con las siguientes reglas mínimas:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /trainings/{id} {
      allow read: if request.auth != null;
      allow write: if request.auth != null;
    }
    match /users/{uid}/{document=**} {
      allow read, write: if request.auth != null && request.auth.uid == uid;
    }
  }
}
```

---

## Datos de ejemplo

La app incluye un generador de datos de ejemplo. Inicia sesión como **entrenador** y pulsa el icono del matrás (🧪) en la barra superior para crear 3 rutinas de prueba (Principiante, Intermedio, Avanzado).

> Solo visible en modo `kDebugMode`.

---

## Paleta de colores

| Elemento | Color | Hex |
|---|---|---|
| Primary (aqua blue) | Azul agua | `#00B4D8` |
| Accent | Azul claro | `#48CAE4` |
| Background | Negro profundo | `#080808` |
| Surface (cards) | Negro suave | `#141414` |
| Text primary | Blanco | `#F0F0F0` |
| Text secondary | Gris | `#9E9E9E` |

---

## Documentación TFG

La documentación completa del proyecto se encuentra en [docs/TFG_VozmeFit.md](docs/TFG_VozmeFit.md), incluyendo:

- Abstract (ES/EN)
- Justificación y comparativa de aplicaciones similares
- RFTP completo (Requisitos, Funciones, Tareas, Pruebas)
- Casos de uso con tablas detalladas
- Diagramas de arquitectura, clases y navegación
- Estructura de base de datos Firestore
- Planificación y presupuesto
- Trabajos futuros

---

## Licencia

Proyecto académico — Trabajo de Fin de Grado. No está prevista su distribución comercial.
