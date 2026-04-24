# VozmeFit — Aplicación de Gestión de Entrenamiento Personal
## Trabajo de Fin de Grado (TFG)

**Autor:** [Nombre del alumno]  
**Tutor:** [Nombre del tutor]  
**Centro:** [Nombre del centro]  
**Ciclo Formativo:** Desarrollo de Aplicaciones Multiplataforma (DAM)  
**Curso:** 2025–2026  

---

## ÍNDICE DE CONTENIDO

1. [Abstract](#abstract)
2. [Justificación del Proyecto](#justificación-del-proyecto)
3. [Introducción](#introducción)
4. [Objetivos — RFTP](#objetivos--rftp)
5. [Descripción](#descripción)
6. [Diseños](#diseños)
7. [Tecnología](#tecnología)
8. [Metodología](#metodología)
9. [Trabajos Futuros](#trabajos-futuros)

---

## ABSTRACT

### Español

VozmeFit es una aplicación móvil multiplataforma desarrollada con Flutter y Firebase que facilita la gestión personalizada del entrenamiento físico. El sistema contempla dos roles diferenciados: **entrenador**, que puede crear, editar y eliminar rutinas de entrenamiento clasificadas por nivel; y **usuario**, que accede a rutinas filtradas según su nivel físico declarado, registra cada sesión con datos objetivos (peso, repeticiones) y subjetivos (sensación de esfuerzo), planifica su semana mediante una agenda semanal y consulta estadísticas de progreso.

El proyecto aplica principios de Arquitectura Limpia (Clean Architecture), separando las capas de datos, repositorios y presentación. La autenticación se gestiona mediante Firebase Authentication (correo/contraseña y Google Sign-In), y la persistencia de datos se apoya en Cloud Firestore (base de datos NoSQL en tiempo real). La interfaz sigue una paleta corporativa oscura con acento en azul agua, cumpliendo criterios de accesibilidad y usabilidad en dispositivos Android e iOS.

### English

VozmeFit is a cross-platform mobile application developed with Flutter and Firebase that enables personalized fitness training management. The system supports two distinct roles: **trainer**, who can create, edit, and delete training routines classified by difficulty level; and **user**, who accesses routines filtered by their declared fitness level, logs each session with objective data (weight, reps) and subjective data (effort sensation), plans their week through a weekly agenda, and views progress statistics.

The project applies Clean Architecture principles, separating data, repository, and presentation layers. Authentication is handled via Firebase Authentication (email/password and Google Sign-In), and data persistence relies on Cloud Firestore (real-time NoSQL database). The interface follows a dark corporate palette with aqua blue accents, meeting accessibility and usability standards on Android and iOS devices.

---

## JUSTIFICACIÓN DEL PROYECTO

### Motivación

El sector del fitness y el entrenamiento personal ha experimentado una digitalización creciente, acelerada por el auge de las aplicaciones móviles de salud. Sin embargo, la mayoría de las soluciones existentes están orientadas al usuario final sin contemplar la figura del entrenador personal como gestor de contenido dentro de la misma plataforma, o bien son herramientas complejas orientadas a profesionales con curvas de aprendizaje elevadas.

VozmeFit nace de la necesidad de crear un puente digital entre entrenador y usuario dentro de un entorno sencillo, escalable y de código abierto, pensado para el ámbito académico y con potencial de crecimiento real.

### Estado de la Cuestión

| Aplicación | Rol dual | Registro de sesiones | Filtro por nivel | Gratuita | Offline |
|---|---|---|---|---|---|
| **MyFitnessPal** | ✗ | ✓ (alimentos) | ✗ | Freemium | Parcial |
| **Hevy** | ✗ | ✓ | ✗ | Freemium | Sí |
| **TrueCoach** | ✓ | ✓ | ✓ | De pago | No |
| **Fitbod** | ✗ | ✓ | ✓ | De pago | No |
| **VozmeFit** | **✓** | **✓** | **✓** | **✓** | **Parcial** |

**Análisis:**
- **MyFitnessPal** está centrado en nutrición. Carece de gestión de rutinas de fuerza y no contempla al entrenador como rol.
- **Hevy** ofrece buen registro de sesiones pero no tiene figura de entrenador ni filtrado por nivel.
- **TrueCoach** es la solución más cercana conceptualmente, pero es de pago y propietaria.
- **VozmeFit** cubre el hueco del mercado con una solución dual, gratuita, escalable y de código abierto construida sobre tecnologías modernas.

### Público Objetivo

- **Entrenadores personales** que deseen gestionar rutinas para distintos niveles de clientes sin herramientas externas complejas.
- **Usuarios de fitness** (principiantes a avanzados) que quieran seguir una rutina guiada, registrar su progreso y planificar su semana.
- Rango de edad estimado: 18–45 años, usuarios habituados a aplicaciones móviles.

---

## INTRODUCCIÓN

VozmeFit es una aplicación de gestión de entrenamiento físico desarrollada con Flutter (Dart) y Firebase. Funciona en dispositivos Android e iOS desde una única base de código y utiliza la nube de Firebase como backend.

### Principales Funciones

- **Autenticación dual**: registro e inicio de sesión con correo/contraseña o Google, con selección de rol (usuario/entrenador).
- **Panel de entrenador**: creación, edición y eliminación de rutinas con ejercicios ordenables, clasificadas por nivel (Principiante / Intermedio / Avanzado).
- **Mi Rutina**: pantalla personalizada para el usuario que filtra entrenamientos según su nivel físico declarado.
- **Registro de sesiones**: el usuario puede registrar cada entrenamiento completado indicando peso, repeticiones y sensación de esfuerzo.
- **Agenda semanal**: planificación de entrenamientos por día de la semana, con posibilidad de vincular a una rutina existente.
- **Estadísticas**: historial de sesiones con resumen de esfuerzo, peso máximo y distribución visual por dificultad.
- **Perfil de usuario**: nombre editable y selector de nivel físico que personaliza toda la experiencia.

### Problemas que Resuelve

- Elimina la necesidad de hojas de cálculo o aplicaciones de notas para gestionar rutinas.
- Centraliza en una sola app la gestión del entrenador y el seguimiento del usuario.
- Permite al usuario ver únicamente las rutinas apropiadas para su nivel, evitando la sobreinformación.
- Proporciona retroalimentación objetiva del progreso mediante estadísticas almacenadas en la nube.

### Requisitos Generales

1. El sistema debe gestionar dos roles con interfaces y permisos diferenciados.
2. Los datos deben persistir en la nube y ser accesibles desde cualquier dispositivo.
3. La autenticación debe ser segura y soportar al menos dos métodos.
4. La interfaz debe ser intuitiva para usuarios no técnicos.
5. La aplicación debe funcionar en Android e iOS desde el mismo código.

---

## OBJETIVOS — RFTP

### R01 — El sistema debe permitir el registro e inicio de sesión de usuarios

**R01F01 — El usuario debe poder registrarse con correo y contraseña**

- R01F01T01 — Crear colección `users` en Firestore con campos: uid, email, displayName, role, level.
  - R01F01T01P01 — Registrar un usuario de prueba y verificar que aparece en Firestore Console.
- R01F01T02 — Diseñar la pantalla de registro con campos email, contraseña y selector de rol.
  - R01F01T02P01 — Visualizar `LoginScreen` en modo registro y comprobar que los campos son funcionales.
- R01F01T03 — Implementar `AuthRepository.register()` que crea el usuario en Firebase Auth y guarda su perfil en Firestore.
  - R01F01T03P01 — Registrar un usuario y verificar que existe tanto en Firebase Auth como en Firestore.

**R01F02 — El usuario debe poder iniciar sesión con correo y contraseña**

- R01F02T01 — Implementar `AuthRepository.login()` con Firebase Auth.
  - R01F02T01P01 — Iniciar sesión con credenciales válidas y verificar redirección según rol.
- R01F02T02 — Mostrar mensaje de error si las credenciales son incorrectas.
  - R01F02T02P01 — Introducir contraseña incorrecta y verificar que aparece el mensaje de error.

**R01F03 — El usuario debe poder iniciar sesión con Google**

- R01F03T01 — Integrar `google_sign_in` y `firebase_auth` para autenticación OAuth.
  - R01F03T01P01 — Pulsar "Continuar con Google" y completar el flujo OAuth.
- R01F03T02 — Crear perfil en Firestore si es el primer acceso (rol por defecto: 'user').
  - R01F03T02P01 — Verificar que se crea el documento en `users/{uid}` tras el primer login con Google.

---

### R02 — El sistema debe diferenciar la experiencia según el rol del usuario

**R02F01 — El usuario con rol 'user' debe acceder a la pantalla principal de usuario**

- R02F01T01 — Implementar `AuthProvider.isTrainer` y `_routeForRole()` en la pantalla de login.
  - R02F01T01P01 — Iniciar sesión como usuario y verificar que se navega a `/home`.

**R02F02 — El usuario con rol 'trainer' debe acceder al panel de entrenador**

- R02F02T01 — Redirigir a `/trainer-home` si `currentUser.role == 'trainer'`.
  - R02F02T01P01 — Iniciar sesión como entrenador y verificar que se navega a `/trainer-home`.

**R02F03 — El usuario debe poder cerrar sesión desde cualquier pantalla principal**

- R02F03T01 — Implementar `AuthProvider.logout()` que limpia el estado y redirige a `/login`.
  - R02F03T01P01 — Pulsar "Cerrar sesión" y verificar que se llega a la pantalla de login.

---

### R03 — El entrenador debe poder gestionar rutinas de entrenamiento

**R03F01 — El entrenador debe poder crear una rutina**

- R03F01T01 — Diseñar `TrainerTrainingForm` con campos: título, nivel, tipo, lista de ejercicios.
  - R03F01T01P01 — Crear una rutina de prueba y verificar que aparece en Firestore.
- R03F01T02 — Implementar `TrainingService.saveTraining()` que persiste en la colección `trainings`.
  - R03F01T02P01 — Verificar el documento creado en Firestore Console.
- R03F01T03 — Permitir añadir ejercicios con nombre, descripción, tipo y duración.
  - R03F01T03P01 — Añadir 3 ejercicios y verificar que se guardan correctamente.

**R03F02 — El entrenador debe poder editar una rutina existente**

- R03F02T01 — Implementar `TrainingService.updateTraining()` con `set()` y merge.
  - R03F02T01P01 — Editar el título de una rutina y verificar el cambio en Firestore.

**R03F03 — El entrenador debe poder eliminar una rutina**

- R03F03T01 — Implementar `TrainingService.deleteTraining()` con confirmación previa.
  - R03F03T01P01 — Eliminar una rutina y verificar que desaparece de Firestore y de la lista.

**R03F04 — El entrenador debe poder filtrar rutinas por nivel**

- R03F04T01 — Implementar chips de filtro (Todos / Principiante / Intermedio / Avanzado) en `TrainerHomeScreen`.
  - R03F04T01P01 — Seleccionar "Intermedio" y verificar que solo aparecen rutinas de ese nivel.

---

### R04 — El usuario debe poder ver y acceder a rutinas según su nivel

**R04F01 — El usuario debe poder configurar su nivel físico**

- R04F01T01 — Diseñar `ProfileScreen` con selector de nivel (Principiante / Intermedio / Avanzado).
  - R04F01T01P01 — Cambiar el nivel y verificar que se actualiza en Firestore.
- R04F01T02 — Recargar `AuthProvider.currentUser` tras guardar el perfil.
  - R04F01T02P01 — Verificar que `MyRoutineScreen` filtra correctamente tras el cambio de nivel.

**R04F02 — La pantalla "Mi Rutina" debe mostrar solo las rutinas del nivel del usuario**

- R04F02T01 — Implementar filtrado en `MyRoutineScreen._loadRoutine()`.
  - R04F02T01P01 — Crear rutinas de varios niveles y verificar el filtrado.

**R04F03 — El usuario debe poder explorar todas las rutinas disponibles**

- R04F03T01 — Implementar `WorkoutsListPage` con filtros de nivel opcionales.
  - R04F03T01P01 — Navegar a "Ver Entrenamientos" y verificar que se muestran todas las rutinas.

---

### R05 — El usuario debe poder registrar sesiones de entrenamiento

**R05F01 — El usuario debe poder registrar una sesión al completar un entrenamiento**

- R05F01T01 — Implementar diálogo de registro en `TrainingDetailPage` y `MyRoutineScreen`.
  - R05F01T01P01 — Registrar una sesión y verificar el documento en `users/{uid}/workoutLogs`.
- R05F01T02 — Registrar campos: trainingId, fecha, notas, peso, repeticiones, sensación.
  - R05F01T02P01 — Verificar todos los campos en Firestore.

**R05F02 — La sensación de esfuerzo debe registrarse mediante chips visuales**

- R05F02T01 — Implementar `_SensationChip` con valores 'facil', 'normal', 'duro'.
  - R05F02T01P01 — Seleccionar cada opción y verificar que el valor guardado es correcto.

---

### R06 — El usuario debe poder planificar entrenamientos en una agenda semanal

**R06F01 — El usuario debe poder añadir entradas a la agenda por día de la semana**

- R06F01T01 — Implementar `AgendaService.addItem()` con fecha y trainingId opcional.
  - R06F01T01P01 — Añadir una entrada el lunes y verificar que aparece al seleccionar ese día.

**R06F02 — El usuario debe poder vincular una entrada de agenda a una rutina existente**

- R06F02T01 — Añadir selector de entrenamiento en el diálogo de nueva entrada.
  - R06F02T01P01 — Vincular una rutina y verificar que aparece el enlace de navegación.

**R06F03 — El usuario debe poder marcar entradas como completadas y eliminarlas**

- R06F03T01 — Implementar checkbox y botón de eliminación en cada entrada.
  - R06F03T01P01 — Marcar como completada y eliminar una entrada, verificando los cambios.

---

### R07 — El usuario debe poder consultar estadísticas de su progreso

**R07F01 — Se deben mostrar métricas resumen de las sesiones registradas**

- R07F01T01 — Calcular total de sesiones y peso máximo desde `workoutLogs`.
  - R07F01T01P01 — Registrar 3 sesiones con pesos distintos y verificar que el máximo es correcto.

**R07F02 — Se debe mostrar la distribución de esfuerzo por sensación**

- R07F02T01 — Agrupar logs por campo `sensation` y mostrar barra visual proporcional.
  - R07F02T01P01 — Registrar sesiones de distintas sensaciones y verificar la barra.

**R07F03 — Se debe mostrar un historial cronológico de sesiones**

- R07F03T01 — Listar logs ordenados por fecha descendente con `WorkoutLogService.getLogs()`.
  - R07F03T01P01 — Verificar que el log más reciente aparece primero.

---

### R08 — El usuario debe poder gestionar su perfil personal

**R08F01 — El usuario debe poder editar su nombre**

- R08F01T01 — Implementar campo de texto en `ProfileScreen` ligado a `displayName`.
  - R08F01T01P01 — Cambiar el nombre y verificar el saludo en `HomeScreen`.

**R08F02 — El sistema debe mostrar un saludo personalizado con el nombre del usuario**

- R08F02T01 — Leer `auth.currentUser?.displayName` en `HomeScreen`.
  - R08F02T01P01 — Verificar que el saludo cambia tras editar el nombre en el perfil.

---

## DESCRIPCIÓN

### Arquitectura de la Solución

VozmeFit implementa **Clean Architecture** con tres capas bien diferenciadas:

```
┌─────────────────────────────────────────────────────┐
│                 PRESENTATION LAYER                  │
│   Screens (UI)  ←→  Providers (State)              │
│   LoginScreen, HomeScreen, ProfileScreen,           │
│   TrainerHomeScreen, MyRoutineScreen, StatsScreen…  │
└───────────────────────┬─────────────────────────────┘
                        │ (lee/escribe a través de)
┌───────────────────────▼─────────────────────────────┐
│                  DOMAIN / REPOSITORY LAYER          │
│   AuthRepository, RoutineService,                   │
│   WorkoutLogService, AgendaService, UserService     │
└───────────────────────┬─────────────────────────────┘
                        │ (accede a)
┌───────────────────────▼─────────────────────────────┐
│                   DATA LAYER                        │
│   Firebase Auth  ←─  AuthService                   │
│   Cloud Firestore ←─ TrainingService, UserService  │
│   Models: Usuario, Training, Exercise              │
└─────────────────────────────────────────────────────┘
                        │
              ┌─────────▼──────────┐
              │  Firebase Cloud    │
              │  (Auth + Firestore)│
              └────────────────────┘
```

### Casos de Uso

---

**Caso de uso: CU01 — Registrarse en el sistema**

| Campo | Descripción |
|---|---|
| **Actor** | Usuario no registrado |
| **Descripción** | El usuario crea una cuenta con email, contraseña y rol seleccionado |
| **Precondiciones** | El usuario no tiene cuenta previa con ese email |
| **Postcondiciones** | Se crea usuario en Firebase Auth y documento en Firestore `users/{uid}` |
| **Datos de entrada** | email, contraseña, rol ('user' \| 'trainer') |
| **Datos de salida** | Token de sesión, redirección a pantalla principal según rol |
| **Tablas/Colecciones** | `users` |
| **Clases** | `AuthRepository`, `AuthService`, `UserService` |
| **Interfaces** | `LoginScreen` (modo registro) |

---

**Caso de uso: CU02 — Crear rutina de entrenamiento**

| Campo | Descripción |
|---|---|
| **Actor** | Entrenador autenticado |
| **Descripción** | El entrenador crea una rutina con título, nivel, tipo y lista de ejercicios |
| **Precondiciones** | Usuario con rol 'trainer' autenticado |
| **Postcondiciones** | Documento creado en colección `trainings` en Firestore |
| **Datos de entrada** | título, nivel, tipo, lista de ejercicios (nombre, descripción, tipo, duración) |
| **Datos de salida** | Rutina visible en el panel y en las pantallas de usuario |
| **Tablas/Colecciones** | `trainings` |
| **Clases** | `TrainingService`, `Training`, `Exercise` |
| **Interfaces** | `TrainerHomeScreen`, `TrainerTrainingForm` |

---

**Caso de uso: CU03 — Registrar sesión de entrenamiento**

| Campo | Descripción |
|---|---|
| **Actor** | Usuario autenticado |
| **Descripción** | El usuario registra una sesión completada con datos objetivos y subjetivos |
| **Precondiciones** | Usuario autenticado con rol 'user'; entrenamiento existente |
| **Postcondiciones** | Documento creado en `users/{uid}/workoutLogs` con fecha actual |
| **Datos de entrada** | trainingId, notas, peso (opcional), repeticiones (opcional), sensación |
| **Datos de salida** | SnackBar de confirmación; log visible en Estadísticas |
| **Tablas/Colecciones** | `users/{uid}/workoutLogs` |
| **Clases** | `WorkoutLogService` |
| **Interfaces** | `TrainingDetailPage` (FAB + diálogo), `MyRoutineScreen` (botón por rutina) |

---

**Caso de uso: CU04 — Planificar entrenamiento en la agenda**

| Campo | Descripción |
|---|---|
| **Actor** | Usuario autenticado |
| **Descripción** | El usuario añade una entrada en la agenda para un día concreto, opcionalmente vinculada a una rutina |
| **Precondiciones** | Usuario autenticado |
| **Postcondiciones** | Documento creado en `users/{uid}/agenda`; visible al seleccionar ese día |
| **Datos de entrada** | descripción, fecha, trainingId (opcional) |
| **Datos de salida** | Entrada visible en el día seleccionado |
| **Tablas/Colecciones** | `users/{uid}/agenda`, `trainings` |
| **Clases** | `AgendaService`, `TrainingService` |
| **Interfaces** | `AgendaScreen` |

---

**Caso de uso: CU05 — Consultar estadísticas de progreso**

| Campo | Descripción |
|---|---|
| **Actor** | Usuario autenticado |
| **Descripción** | El usuario visualiza el resumen de sus sesiones registradas |
| **Precondiciones** | Usuario autenticado; al menos una sesión registrada |
| **Postcondiciones** | Ninguna (operación de solo lectura) |
| **Datos de entrada** | UID del usuario (implícito) |
| **Datos de salida** | Total sesiones, peso máximo, distribución por sensación, historial |
| **Tablas/Colecciones** | `users/{uid}/workoutLogs` |
| **Clases** | `WorkoutLogService` |
| **Interfaces** | `StatsScreen` |

---

### Estructura de la Base de Datos (Firestore)

**Colección `trainings`** — Rutinas creadas por entrenadores

```
trainings/
  {trainingId}/
    title: String
    level: String  // 'Principiante' | 'Intermedio' | 'Avanzado'
    type: String
    exercises: Array<{
      name: String
      description: String
      duration: Number  // segundos
      type: String
    }>
```

**Colección `users`** — Perfiles de usuario

```
users/
  {uid}/
    uid: String
    email: String
    displayName: String
    role: String     // 'user' | 'trainer'
    level: String    // 'Principiante' | 'Intermedio' | 'Avanzado'

    workoutLogs/
      {logId}/
        trainingId: String
        date: String (ISO 8601)
        notes: String
        weight: Number | null
        reps: Number | null
        sensation: String  // 'facil' | 'normal' | 'duro'

    agenda/
      {itemId}/
        text: String
        date: String (ISO 8601)
        completed: Boolean
        trainingId: String | null

    myRoutine/
      {trainingId}/
        (subcolección vacía, actúa como bookmark)
```

---

## DISEÑOS

### Diagrama de Clases (Modelos de Datos)

```
┌─────────────────┐         ┌──────────────────┐
│    Usuario      │         │    Training      │
├─────────────────┤         ├──────────────────┤
│ uid: String     │         │ id: String       │
│ email: String   │         │ title: String    │
│ displayName: Str│    1    │ level: String    │
│ role: String    │─────────│ type: String     │
│ level: String   │    N    │ exercises: List  │
├─────────────────┤         └────────┬─────────┘
│ fromMap()       │                  │ 1
│ toMap()         │                  │ N
└─────────────────┘         ┌────────▼─────────┐
                             │    Exercise      │
┌─────────────────┐         ├──────────────────┤
│  WorkoutLog     │         │ name: String     │
├─────────────────┤         │ description: Str │
│ trainingId: Str │         │ duration: int    │
│ date: String    │         │ type: String     │
│ notes: String   │         ├──────────────────┤
│ weight: double? │         │ fromMap()        │
│ reps: int?      │         │ toMap()          │
│ sensation: Str  │         └──────────────────┘
└─────────────────┘

┌─────────────────┐
│   AgendaItem    │
├─────────────────┤
│ id: String      │
│ text: String    │
│ date: String    │
│ completed: bool │
│ trainingId: Str?│
└─────────────────┘
```

### Diagrama de Flujo de Navegación

```
                    ┌──────────────┐
                    │  LoginScreen  │
                    │  /login       │
                    └──────┬───────┘
                           │ role?
              ┌────────────┴────────────┐
              │ user                    │ trainer
    ┌─────────▼──────────┐   ┌─────────▼──────────┐
    │   HomeScreen        │   │ TrainerHomeScreen   │
    │   /home             │   │ /trainer-home       │
    └──┬──┬──┬──┬─────────┘   └──┬──────────────────┘
       │  │  │  │                 │
       │  │  │  └──────────────── │ ──────► ProfileScreen /profile
       │  │  │                    └───────► TrainerTrainingForm
       │  │  └──────────────────────────► StatsScreen /stats
       │  └─────────────────────────────► AgendaScreen /agenda
       └────────────────────────────────► MyRoutineScreen /my-routine
                                          WorkoutsListPage /workouts
                                            └► TrainingDetailPage
```

### Diagrama de Red

```
  ┌──────────────────────┐         ┌───────────────────────────┐
  │   Dispositivo Móvil  │ HTTPS   │    Firebase Cloud (GCP)   │
  │   Android / iOS      │◄───────►│                           │
  │                      │         │  ┌─────────────────────┐  │
  │  Flutter App         │         │  │  Firebase Auth      │  │
  │  (Dart / Widgets)    │         │  │  (JWT tokens)       │  │
  │                      │         │  └─────────────────────┘  │
  │  Provider (Estado)   │         │                           │
  │  AuthProvider        │         │  ┌─────────────────────┐  │
  │                      │         │  │  Cloud Firestore    │  │
  └──────────────────────┘         │  │  (NoSQL, real-time) │  │
                                   │  └─────────────────────┘  │
                                   └───────────────────────────┘
```

---

## TECNOLOGÍA

### Flutter (v3.x) y Dart (SDK ≥ 3.0.0)

**Descripción:** Flutter es el framework de UI de Google para el desarrollo de aplicaciones nativas compiladas para móvil, web y escritorio desde una única base de código. Dart es el lenguaje de programación orientado a objetos que utiliza Flutter.

**Uso en el proyecto:** Se usa Flutter como framework principal para construir toda la capa de presentación (pantallas, widgets, animaciones). El código Dart implementa la lógica de negocio, los modelos de datos y la integración con Firebase.

---

### Firebase Authentication

**Descripción:** Servicio de autenticación de Google que gestiona el ciclo de vida de los usuarios, tokens JWT y proveedores de identidad (email/contraseña, Google, etc.).

**Uso en el proyecto:** Gestiona el registro, login y logout de usuarios. Se integra mediante el paquete `firebase_auth`. El UID generado por Firebase es la clave primaria en Firestore.

---

### Cloud Firestore

**Descripción:** Base de datos NoSQL orientada a documentos, en tiempo real y serverless de Google Firebase. Los datos se organizan en colecciones y documentos anidables.

**Uso en el proyecto:** Almacena todos los datos de la aplicación: perfiles de usuario (`users`), rutinas de entrenamiento (`trainings`), logs de sesiones, entradas de agenda y rutinas favoritas. Las consultas se realizan mediante streams en tiempo real.

---

### Provider (^6.1.2)

**Descripción:** Paquete de gestión de estado recomendado por el equipo de Flutter, basado en `ChangeNotifier` e inyección de dependencias mediante el árbol de widgets.

**Uso en el proyecto:** `AuthProvider` es el provider principal que mantiene el estado de autenticación (`currentUser`, `isLoading`, `errorMessage`) y notifica a todas las pantallas cuando el estado cambia.

---

### google_sign_in (^6.2.1)

**Descripción:** Paquete oficial de Flutter para la autenticación OAuth 2.0 con cuentas de Google.

**Uso en el proyecto:** Implementa el flujo de "Continuar con Google" en la pantalla de login, complementando a Firebase Authentication.

---

### uuid (^4.2.1)

**Descripción:** Generador de identificadores únicos universales (UUID v4) para Dart.

**Uso en el proyecto:** Se utiliza para generar IDs únicos al crear nuevas rutinas de entrenamiento antes de persistirlas en Firestore.

---

### Visual Studio Code

**Descripción:** Editor de código fuente ligero y extensible de Microsoft, con soporte completo para Flutter y Dart mediante extensiones oficiales.

**Uso en el proyecto:** Entorno de desarrollo principal. Se utilizan las extensiones Flutter, Dart y Firebase para el desarrollo, depuración y emulación.

---

### Firebase Console

**Descripción:** Panel web de administración de proyectos Firebase, que permite gestionar usuarios, ver documentos de Firestore y configurar reglas de seguridad.

**Uso en el proyecto:** Utilizado para verificar los datos escritos durante el desarrollo, gestionar usuarios de prueba y configurar las reglas de Firestore.

---

### Git y GitHub

**Descripción:** Sistema de control de versiones distribuido y plataforma de alojamiento de repositorios.

**Uso en el proyecto:** Control de versiones del código fuente, seguimiento de cambios y respaldo del proyecto.

---

## METODOLOGÍA

### Metodología Utilizada: Desarrollo Iterativo e Incremental

Se ha adoptado un enfoque **iterativo e incremental**, dividiendo el proyecto en sprints cortos de 1–2 semanas, cada uno con entregables funcionales y verificables. Esta metodología es adecuada para proyectos académicos individuales porque:

- Permite detectar problemas de diseño temprano y corregirlos antes de que afecten a capas superiores.
- Facilita la adaptación a cambios de requisitos (como la ampliación del alcance durante el TFG).
- Genera versiones funcionales del producto en cada iteración, lo que facilita la revisión del tutor.

### Planificación Inicial (Estimada)

| Fase | Descripción | Horas estimadas |
|---|---|---|
| Análisis y diseño | Propuesta, RFTP, diagramas, wireframes | 12 h |
| Configuración del entorno | Flutter, Firebase, estructura de carpetas | 6 h |
| Autenticación | Login, registro, Google Sign-In, roles | 10 h |
| Modelos y servicios | Usuario, Training, Exercise, servicios Firebase | 8 h |
| Panel del entrenador | CRUD de rutinas, formulario con ejercicios | 12 h |
| Pantallas de usuario | HomeScreen, MyRoutineScreen, WorkoutsListPage | 10 h |
| Registro de sesiones | Diálogo de log, WorkoutLogService | 6 h |
| Agenda semanal | AgendaScreen, AgendaService | 8 h |
| Estadísticas | StatsScreen, métricas, historial | 6 h |
| Perfil de usuario | ProfileScreen, nivel, nombre | 4 h |
| Tema y diseño visual | Paleta corporativa, theme.dart | 4 h |
| Pruebas y corrección de errores | Depuración, null safety, memory leaks | 8 h |
| Documentación | TFG, README, diagramas | 10 h |
| **TOTAL ESTIMADO** | | **104 h** |

### Planificación Final (Real)

| Fase | Horas reales | Desviación | Motivo |
|---|---|---|---|
| Análisis y diseño | 10 h | −2 h | El diagrama de clases fue más sencillo de lo esperado |
| Configuración del entorno | 8 h | +2 h | Problemas con google-services.json y Firebase init |
| Autenticación | 12 h | +2 h | Gestión de errores y null safety más compleja |
| Modelos y servicios | 9 h | +1 h | Ajustes en `Training.fromMap` |
| Panel del entrenador | 14 h | +2 h | Reordenación de ejercicios (ReorderableListView) |
| Pantallas de usuario | 10 h | 0 h | Según estimación |
| Registro de sesiones | 7 h | +1 h | Gestión del contexto tras cierre del diálogo |
| Agenda semanal | 10 h | +2 h | Rediseño completo de la pantalla |
| Estadísticas | 6 h | 0 h | Según estimación |
| Perfil de usuario | 5 h | +1 h | Recarga del provider tras guardar |
| Tema y diseño visual | 5 h | +1 h | Ajustes de contraste y accesibilidad |
| Pruebas y corrección | 10 h | +2 h | Errores de imports y dead code |
| Documentación | 12 h | +2 h | Nivel de detalle requerido en RFTP |
| **TOTAL REAL** | **118 h** | **+14 h** | |

### Presupuesto

| Concepto | Horas | Coste/hora | Total |
|---|---|---|---|
| Análisis y diseño | 10 h | 25 €/h | 250 € |
| Desarrollo (backend/Firebase) | 35 h | 30 €/h | 1.050 € |
| Desarrollo (frontend/UI) | 45 h | 28 €/h | 1.260 € |
| Pruebas | 10 h | 20 €/h | 200 € |
| Documentación | 12 h | 20 €/h | 240 € |
| Licencias y herramientas | — | — | 0 € (herramientas gratuitas) |
| Firebase (plan Spark) | — | — | 0 € (gratuito) |
| **TOTAL** | **118 h** | | **3.000 €** |

> Nota: Los costes son orientativos para un desarrollador junior. Herramientas como Flutter, Firebase (plan Spark), VS Code y Git son gratuitas.

### Diagrama de Gantt (Resumen)

```
Semana:       1   2   3   4   5   6   7   8   9  10  11  12
Análisis      ███
Config env        ██
Auth              ████
Modelos/Srv            ██
Panel trainer          ████
UI usuario                 ████
Logs sesiones                   ██
Agenda                              ████
Stats                                   ██
Perfil                                     ██
Tema/Diseño                                  ██
Pruebas                                       ████
Documentación                                     ████
```

---

## TRABAJOS FUTUROS

### Mejoras Técnicas

1. **Modo offline con caché local**: implementar `Hive` o `sqflite` para que el usuario pueda ver sus rutinas y registrar sesiones sin conexión, sincronizando cuando recupere la red.

2. **Notificaciones push**: integrar `firebase_messaging` para enviar recordatorios de entrenamiento según la agenda planificada del usuario.

3. **Temporizador de ejercicios**: añadir un cronómetro interactivo en la pantalla de detalle del entrenamiento que avance automáticamente entre ejercicios usando los campos `duration`, con alertas de audio (los assets de sonido ya están declarados en `pubspec.yaml`).

4. **Tests unitarios y de widget**: implementar tests con `flutter_test` para los modelos, providers y pantallas principales, alcanzando una cobertura mínima del 70%.

5. **CI/CD**: configurar GitHub Actions para ejecutar los tests y generar builds automáticos en cada push a `main`.

### Nuevas Funcionalidades

6. **Chat entrenador-usuario**: canal de mensajería en tiempo real usando Firestore o Firebase Realtime Database para que el entrenador pueda dar feedback personalizado.

7. **Asignación directa de rutinas**: el entrenador puede asignar rutinas específicas a usuarios concretos, en lugar de que el filtrado sea solo por nivel.

8. **Planes de entrenamiento semanales**: el entrenador diseña un plan semanal completo (qué día se entrena qué) y el usuario lo recibe directamente en su agenda.

9. **Progresión de peso**: gráficas de evolución del peso levantado por ejercicio a lo largo del tiempo, usando `fl_chart`.

10. **Internacionalización (i18n)**: soporte multiidioma (español/inglés) mediante `flutter_localizations` y archivos ARB.

11. **Versión web**: aprovechar la compilación web de Flutter para ofrecer acceso desde navegador, especialmente útil para el entrenador que gestiona rutinas desde el ordenador.

12. **Exportar historial**: permitir al usuario exportar su historial de entrenamientos en CSV o PDF para compartir con su entrenador o médico.

---

*Documento generado para el Trabajo de Fin de Grado — VozmeFit — Curso 2025/2026*
