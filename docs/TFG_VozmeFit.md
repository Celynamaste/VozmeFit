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

---

## CAPTURAS DE PANTALLA Y DESCRIPCIÓN DE LA INTERFAZ

### Pantalla de Login (`LoginScreen`)

La pantalla de inicio de sesión presenta un diseño limpio sobre fondo oscuro (`#0A0A0A`). En la parte superior se muestra el nombre de la aplicación **VozmeFit** en tipografía grande y negrita, seguido de un subtítulo contextual que cambia entre "Bienvenido de nuevo" (modo login) y "Crea tu cuenta" (modo registro).

Los campos de entrada `Email` y `Contraseña` siguen el estilo definido en `appTheme`, con bordes redondeados y color de acento en azul agua (`#00B4D8`). El botón principal de acción ocupa todo el ancho disponible.

En modo registro aparece adicionalmente un selector de rol con dos opciones visuales en forma de chip: **Usuario** (icono de persona) y **Entrenador** (icono de mancuerna). Al pie de la pantalla, un enlace permite alternar entre los modos login y registro.

**Elementos de seguridad:** el campo de contraseña usa `obscureText: true`. Los errores de autenticación se muestran en texto rojo antes del formulario, con mensajes descriptivos provenientes de Firebase Auth.

---

### Pantalla Principal (`HomeScreen`)

Tras el inicio de sesión el usuario llega a la pantalla principal, que actúa como hub de navegación. En la barra superior aparece el título **VozmeFit** centrado, con accesos rápidos a Perfil y Cerrar Sesión mediante iconos en los extremos.

El cuerpo muestra:
- Un **saludo personalizado** con el nombre del usuario ("¡Hola, [nombre]!") y su nivel físico actual en color de acento.
- Tres **tarjetas de acceso rápido** (`_HomeCard`) con icono, título y efecto de pulsación: "Ver entrenamientos", "Mi Agenda" y "Mis Estadísticas".
- Una **lista horizontal deslizable** de los últimos 5 entrenamientos disponibles, cada uno en una tarjeta rectangular con icono, título, nivel y tipo.

---

### Lista de Entrenamientos (`WorkoutsListPage`)

Pantalla que muestra todos los entrenamientos disponibles en Firestore. Incluye:

- **Barra de búsqueda** en la parte superior con icono de lupa, que filtra en tiempo real por título.
- **Chips de filtro de nivel** horizontales y deslizables: Todos, Principiante, Intermedio, Avanzado.
- **Lista de tarjetas** (`StreamBuilder`) que se actualiza en tiempo real. Cada tarjeta muestra la imagen del entrenamiento (o un icono de fallback), el título, nivel, tipo y duración.

La combinación de filtros es aditiva: si se selecciona "Intermedio" y se escribe "fuerza", solo aparecen los entrenamientos de nivel intermedio cuyo título contenga esa cadena.

---

### Detalle del Entrenamiento (`TrainingDetailPage`)

Al pulsar cualquier entrenamiento se navega al detalle. La estructura es:

- **AppBar** con el título del entrenamiento y botón de retroceso.
- **Chips de información** en fila: nivel, tipo y duración en minutos.
- **Descripción** del entrenamiento en texto con altura de línea generosa.
- **Contador de ejercicios** en color de acento.
- **Lista de tarjetas de ejercicio** en formato compacto horizontal:
  - Imagen del ejercicio (90×90 px, redondeada a la izquierda) o gradiente de fallback según el tipo.
  - Número de orden en `CircleAvatar`.
  - Nombre del ejercicio en negrita, descripción en gris, tipo y duración en color de acento.
- **FAB** ("Registrar") anclado en la esquina inferior derecha que abre el diálogo de registro de sesión.

---

### Diálogo de Registro de Sesión

Modal `AlertDialog` que aparece al pulsar "Registrar" en el detalle del entrenamiento:

- Campo de texto multilínea: **Notas / sensaciones**.
- Fila con dos campos numéricos: **Peso (kg)** y **Repeticiones**.
- Pregunta "¿Cómo te ha resultado?" con tres `_SensationChip` seleccionables:
  - 😊 **Fácil** — verde
  - 💪 **Normal** — azul agua
  - 🔥 **Duro** — naranja/rojo
- Botones **Cancelar** y **Guardar**.

Al guardar, se escribe el documento en `users/{uid}/workoutLogs` y se muestra un `SnackBar` de confirmación.

---

### Agenda Semanal (`AgendaScreen`)

La pantalla de agenda se divide en dos secciones verticales:

**Selector de día** — Fila de 7 círculos con las iniciales de los días (L, M, X, J, V, S, D). El día activo se resalta con fondo de color de acento y sombra. Al pulsar un día se filtra la lista inferior.

**Lista de entradas** — Muestra solo las entradas correspondientes al día seleccionado, en tarjetas (`Card + ListTile`) con:
- **Checkbox** para marcar como completado (tacha el texto visualmente).
- **Texto descriptivo** de la entrada.
- **Indicador de entrenamiento vinculado** (icono + texto en color de acento) si la entrada tiene `trainingId`.
- **Botón de navegación** (flecha) para ir directamente al detalle del entrenamiento vinculado.
- **Botón de eliminar** (papelera roja).

El **FAB** (+) abre el diálogo de nueva entrada con selector de entrenamiento (opcional), campo de nota y selector de fecha.

---

### Estadísticas (`StatsScreen`)

Pantalla de solo lectura que muestra el historial de sesiones registradas:

**Tarjetas de resumen** (fila superior):
- Total de sesiones completadas.
- Peso máximo levantado.
- Distribución de sensaciones (barra proporcional con colores verde/azul/rojo).

**Historial cronológico** — Lista de `Card` ordenadas por fecha descendente. Cada tarjeta muestra: fecha formateada, título del entrenamiento (si se resuelve), notas, peso y repeticiones, y un chip de sensación con emoji y color correspondiente.

Si no hay registros, se muestra un icono grande de gráfica con texto informativo.

---

### Perfil de Usuario (`ProfileScreen`)

Pantalla de configuración personal:

- **Avatar** centrado con icono de persona sobre fondo de acento semitransparente.
- **Email** del usuario en gris.
- **Chip de rol** (Usuario / Entrenador) con borde de color de acento.
- **Campo editable** de nombre (`displayName`).
- **Selector de nivel físico** (solo para usuarios): tres botones animados (Principiante / Intermedio / Avanzado) que cambian de estilo al seleccionarse.
- **Botón "Guardar cambios"** que persiste en Firestore y recarga el provider.
- **Botón "Panel de Entrenador"** (solo visible si `role == 'trainer'`), con icono de escudo y borde de acento.

---

### Panel del Entrenador (`TrainerHomeScreen`)

Pantalla exclusiva para usuarios con rol `trainer`:

- **AppBar** con título "Panel Entrenador" y, en modo debug, botón para cargar datos de ejemplo.
- **Chips de filtro** por nivel: Todos, Principiante, Intermedio, Avanzado.
- **Lista de rutinas** en `ListTile` con nombre, nivel, tipo y número de ejercicios. Cada tarjeta tiene dos botones en el trailing: ✏️ (editar) y 🗑️ (eliminar con confirmación).
- **FAB** "Nueva rutina" para crear desde cero.

---

### Formulario de Rutina (`TrainerTrainingForm`)

Formulario completo de creación y edición:

- Campo de **título** con icono de título.
- Campo de **tipo** (Fuerza, Cardio, HIIT, etc.).
- **Selector de nivel** animado (mismo estilo que el perfil).
- **Lista de ejercicios** reordenable con drag & drop (`ReorderableListView`). Cada ejercicio muestra número, nombre, tipo y duración, con botones de editar y eliminar.
- Botón **"Añadir ejercicio"** que abre un diálogo con campos: nombre, descripción, duración (segundos) y tipo (dropdown).
- **Botón "Guardar rutina"** en la parte inferior, que llama a `saveTraining` o `updateTraining` según el modo.

---

## CONCLUSIONES

### Conclusión Técnica

El desarrollo de VozmeFit ha demostrado la viabilidad de construir una aplicación multiplataforma completa con Flutter y Firebase en el contexto de un proyecto académico de ciclo formativo. La combinación de ambas tecnologías permite eliminar la necesidad de un servidor backend propio, reduciendo la complejidad operativa y el coste de infraestructura a cero durante el desarrollo y las pruebas.

La aplicación del patrón **Clean Architecture** —separando claramente las capas de datos, repositorios y presentación— ha facilitado el mantenimiento y la extensión del código. Por ejemplo, cuando fue necesario modificar el comportamiento del registro de sesiones o añadir el campo `imageUrl` al modelo de ejercicio, los cambios quedaron aislados en sus respectivas capas sin afectar al resto del sistema.

El uso de **Cloud Firestore** con streams en tiempo real ha resultado especialmente adecuado para la agenda y la lista de entrenamientos, donde los cambios del entrenador deben reflejarse de inmediato en los dispositivos de los usuarios. La gestión de subcollecciones por usuario (`workoutLogs`, `agenda`, `myRoutine`) ha permitido un modelo de datos escalable que respeta el aislamiento de datos entre usuarios.

El mayor desafío técnico encontrado fue la gestión del estado global con **Provider**, especialmente en lo relativo a la carga asíncrona del perfil de usuario desde Firestore tras el login. La solución adoptada —cargar el perfil en `AuthProvider._loadCurrentUser()` inmediatamente después de la autenticación y forzar una recarga al abrir el perfil— resuelve el problema de forma sencilla y comprensible.

### Conclusión Personal

Este proyecto ha representado un salto cualitativo en mi formación como desarrollador. Partir de una idea funcional —una app de entrenamiento con dos roles— y llevarla hasta un producto funcional con autenticación real, base de datos en la nube, múltiples pantallas y un sistema de registro de sesiones ha supuesto enfrentarme a problemas reales de desarrollo de software: conflictos de imports, gestión de estado asíncrono, diseño de esquemas de base de datos NoSQL y decisiones de arquitectura con impacto directo en la escalabilidad.

Flutter ha superado mis expectativas en cuanto a velocidad de desarrollo y calidad visual del resultado. La curva de aprendizaje inicial de Dart fue corta gracias a mi base en Java, y el ecosistema de paquetes (`provider`, `firebase_auth`, `cloud_firestore`, `uuid`) cubre la mayoría de necesidades sin necesidad de reinventar la rueda.

Firebase, aunque con ciertas limitaciones en el plan gratuito, ha demostrado ser una plataforma robusta y bien documentada que permite a un desarrollador individual construir productos con características propias de equipos más grandes.

Considero que VozmeFit es una base sólida sobre la cual construir mejoras reales, especialmente las relacionadas con notificaciones push, modo offline y gráficas de progreso, que son las funcionalidades que más valor aportarían a los usuarios finales.

---

## GLOSARIO DE TÉRMINOS TÉCNICOS

| Término | Definición |
|---|---|
| **API** | Application Programming Interface. Interfaz que permite la comunicación entre componentes de software. |
| **AppBar** | Barra superior de una pantalla en Flutter que contiene el título y acciones. |
| **ARB** | Application Resource Bundle. Formato de archivo para internacionalización en Flutter. |
| **Authentication** | Proceso de verificación de la identidad de un usuario. En Firebase, gestiona tokens JWT. |
| **ChangeNotifier** | Clase de Flutter que notifica a los widgets oyentes cuando su estado cambia. |
| **Clean Architecture** | Patrón de diseño de software que separa el código en capas independientes (datos, dominio, presentación). |
| **Cloud Firestore** | Base de datos NoSQL orientada a documentos de Google Firebase, con sincronización en tiempo real. |
| **Collection** | Colección de documentos en Firestore, equivalente a una tabla en bases de datos relacionales. |
| **CORS** | Cross-Origin Resource Sharing. Mecanismo de seguridad de los navegadores que restringe las peticiones HTTP entre dominios distintos. |
| **DAM** | Desarrollo de Aplicaciones Multiplataforma. Ciclo formativo de grado superior. |
| **Dart** | Lenguaje de programación orientado a objetos desarrollado por Google, usado en Flutter. |
| **Document** | Unidad de almacenamiento en Firestore, equivalente a un registro, identificado por un ID único. |
| **FAB** | Floating Action Button. Botón flotante circular de acción principal en Material Design. |
| **Firebase** | Plataforma de desarrollo de aplicaciones de Google que ofrece autenticación, base de datos, almacenamiento y más. |
| **Flutter** | Framework de Google para crear interfaces de usuario nativas compiladas para móvil, web y escritorio desde un único código base. |
| **GCP** | Google Cloud Platform. Infraestructura cloud sobre la que se ejecuta Firebase. |
| **HIIT** | High Intensity Interval Training. Tipo de entrenamiento de intervalos de alta intensidad. |
| **Hot Reload** | Funcionalidad de Flutter que aplica cambios en el código sin reiniciar la aplicación, manteniendo el estado. |
| **Hot Restart** | Reinicio completo de la aplicación Flutter descartando el estado actual. |
| **i18n** | Abreviatura de internacionalización (18 letras entre la i y la n). |
| **ISO 8601** | Estándar internacional para la representación de fechas y horas (ej: `2025-03-15T10:30:00`). |
| **JWT** | JSON Web Token. Estándar para la transmisión segura de información entre partes como objeto JSON firmado. |
| **Material Design** | Sistema de diseño de Google que define componentes visuales, animaciones y principios de usabilidad. |
| **NoSQL** | Tipo de base de datos que no usa el modelo relacional tabular. Firestore es un ejemplo orientado a documentos. |
| **Null Safety** | Característica de Dart que previene errores de referencia nula en tiempo de compilación. |
| **OAuth 2.0** | Protocolo de autorización estándar usado por Google Sign-In para delegar el acceso sin compartir contraseñas. |
| **Provider** | Patrón y paquete de gestión de estado en Flutter basado en InheritedWidget. |
| **RFTP** | Requisitos Funcionales por Tareas y Pruebas. Metodología de especificación de requisitos usada en ciclos formativos. |
| **Scaffold** | Widget de Flutter que implementa la estructura visual básica de Material Design (AppBar, body, FAB, Drawer). |
| **SnackBar** | Mensaje flotante temporal en la parte inferior de la pantalla en Flutter. |
| **Stream** | Flujo de datos asíncrono en Dart que emite eventos a lo largo del tiempo. Usado con Firestore para actualizaciones en tiempo real. |
| **StreamBuilder** | Widget de Flutter que reconstruye la UI cada vez que el Stream emite un nuevo valor. |
| **TFG** | Trabajo de Fin de Grado. Proyecto final del ciclo formativo. |
| **UID** | User ID. Identificador único generado por Firebase Authentication para cada usuario registrado. |
| **UUID** | Universally Unique Identifier. Identificador único universal de 128 bits generado aleatoriamente. |
| **Widget** | Elemento básico de construcción de interfaces en Flutter. Todo en Flutter es un widget. |

---

## BIBLIOGRAFÍA Y REFERENCIAS

### Documentación Oficial

1. **Flutter Documentation** — Google LLC.
   Documentación oficial del framework Flutter, incluyendo guías de widgets, gestión de estado y publicación.
   Disponible en: https://docs.flutter.dev

2. **Dart Language Tour** — Google LLC.
   Guía completa del lenguaje de programación Dart con ejemplos de sintaxis, tipos y programación asíncrona.
   Disponible en: https://dart.dev/guides/language/language-tour

3. **Firebase Documentation** — Google LLC.
   Documentación de Firebase Authentication, Cloud Firestore, reglas de seguridad y Console.
   Disponible en: https://firebase.google.com/docs

4. **Cloud Firestore Data Model** — Google LLC.
   Documentación sobre la estructura de documentos, colecciones y subcollecciones en Firestore.
   Disponible en: https://firebase.google.com/docs/firestore/data-model

5. **Provider Package Documentation** — Remi Rousselet.
   Documentación del paquete `provider` para gestión de estado en Flutter.
   Disponible en: https://pub.dev/packages/provider

### Libros y Recursos de Aprendizaje

6. **"Flutter Complete Reference"** — Alberto Miola. Packt Publishing, 2021.
   Referencia completa sobre widgets, animaciones y arquitectura de aplicaciones Flutter.

7. **"Clean Architecture"** — Robert C. Martin (Uncle Bob). Prentice Hall, 2017.
   Libro de referencia sobre principios de diseño de software y separación de capas.

8. **"NoSQL Distilled"** — Martin Fowler, Pramod Sadalage. Addison-Wesley, 2012.
   Introducción a los distintos tipos de bases de datos NoSQL y sus casos de uso.

### Paquetes de Terceros Utilizados

9. **firebase_core** (v3.x) — Paquete de Flutter para inicializar Firebase.
   Disponible en: https://pub.dev/packages/firebase_core

10. **firebase_auth** (v5.x) — Autenticación con Firebase.
    Disponible en: https://pub.dev/packages/firebase_auth

11. **cloud_firestore** (v5.x) — Cliente de Cloud Firestore para Flutter.
    Disponible en: https://pub.dev/packages/cloud_firestore

12. **google_sign_in** (v6.x) — Autenticación OAuth 2.0 con Google.
    Disponible en: https://pub.dev/packages/google_sign_in

13. **uuid** (v4.x) — Generador de UUIDs para Dart.
    Disponible en: https://pub.dev/packages/uuid

### Recursos Web Complementarios

14. **Stack Overflow** — Comunidad de preguntas y respuestas técnicas.
    Consultado para resolución de problemas específicos de Flutter, Dart y Firebase.
    Disponible en: https://stackoverflow.com

15. **Material Design 3 Guidelines** — Google LLC.
    Guía de diseño de interfaces con los principios de Material You.
    Disponible en: https://m3.material.io

16. **Flutter & Firebase Codelab** — Google Developers.
    Tutorial oficial de integración de Flutter con Firebase paso a paso.
    Disponible en: https://firebase.google.com/codelabs/firebase-get-to-know-flutter

---

## APÉNDICE — FRAGMENTOS DE CÓDIGO RELEVANTES

### A.1 — Modelo de datos `Training`

El modelo `Training` demuestra cómo se implementa la serialización/deserialización entre objetos Dart y documentos Firestore mediante `fromMap` y `toMap`:

```dart
class Training {
  final String id;
  final String title;
  final String level;
  final String type;
  final String description;
  final String imageUrl;
  final int duration;
  final List<Exercise> exercises;

  const Training({
    required this.id,
    required this.title,
    required this.level,
    required this.type,
    this.description = '',
    this.imageUrl = '',
    this.duration = 0,
    this.exercises = const [],
  });

  factory Training.fromMap(String id, Map<String, dynamic> data) {
    return Training(
      id: id,
      title: data['title'] as String? ?? data['name'] as String? ?? '',
      level: data['level'] as String? ?? 'Principiante',
      type: data['type'] as String? ?? '',
      description: data['description'] as String? ?? '',
      imageUrl: data['imageUrl'] as String? ?? '',
      duration: (data['duration'] as num?)?.toInt() ?? 0,
      exercises: (data['exercises'] as List<dynamic>? ?? [])
          .map((e) => Exercise.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() => {
    'title': title,
    'level': level,
    'type': type,
    'description': description,
    'imageUrl': imageUrl,
    'duration': duration,
    'exercises': exercises.map((e) => e.toMap()).toList(),
  };
}
```

---

### A.2 — AuthProvider (gestión de estado global)

El `AuthProvider` centraliza todo el estado de autenticación y notifica a los widgets dependientes:

```dart
class AuthProvider extends ChangeNotifier {
  final AuthRepository _authRepository = AuthRepository();
  final UserService _userService = UserService();

  bool isLoading = false;
  String? errorMessage;
  Usuario? currentUser;

  bool get isTrainer => currentUser?.role == 'trainer';

  Future<void> _loadCurrentUser() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    currentUser = await _userService.getUser(uid);
  }

  Future<bool> login(String email, String password) async {
    isLoading = true;
    notifyListeners();
    final result = await _authRepository.login(email, password);
    if (result == null) {
      await _loadCurrentUser();
      isLoading = false;
      notifyListeners();
      return true;
    }
    errorMessage = result;
    isLoading = false;
    notifyListeners();
    return false;
  }
}
```

---

### A.3 — StreamBuilder con Firestore en tiempo real

Ejemplo de cómo `WorkoutsListPage` escucha cambios en Firestore en tiempo real:

```dart
StreamBuilder<List<Training>>(
  stream: _service.streamTrainings(),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    }
    final all = snapshot.data ?? [];
    final filtered = all.where((t) {
      final matchLevel = _filterLevel == 'Todos' || t.level == _filterLevel;
      final matchSearch = t.title
          .toLowerCase()
          .contains(_searchQuery.toLowerCase());
      return matchLevel && matchSearch;
    }).toList();

    return ListView.builder(
      itemCount: filtered.length,
      itemBuilder: (context, index) => TrainingCard(training: filtered[index]),
    );
  },
)
```

---

### A.4 — AgendaService (operaciones CRUD en subcollección)

El servicio de agenda ilustra el patrón de acceso a subcollecciones de usuario en Firestore:

```dart
class AgendaService {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  String? get _uid => _auth.currentUser?.uid;

  Stream<List<Map<String, dynamic>>> getItems() {
    final uid = _uid;
    if (uid == null) return const Stream.empty();
    return _db
        .collection('users').doc(uid)
        .collection('agenda')
        .orderBy('date')
        .snapshots()
        .map((snap) => snap.docs.map((doc) => {
          'id': doc.id,
          'text': doc['text'],
          'date': doc['date'],
          'completed': doc['completed'] ?? false,
          'trainingId': doc.data().containsKey('trainingId')
              ? doc['trainingId'] : null,
        }).toList());
  }

  Future<void> addItem(String text, DateTime date,
      {String? trainingId}) async {
    final uid = _uid;
    if (uid == null) return;
    await _db
        .collection('users').doc(uid)
        .collection('agenda')
        .add({
      'text': text,
      'date': date.toIso8601String(),
      'completed': false,
      if (trainingId != null) 'trainingId': trainingId,
    });
  }
}
```

---

### A.5 — Router de la aplicación

El router centraliza todas las rutas nombradas de la aplicación:

```dart
class AppRouter {
  static const String login   = '/login';
  static const String home    = '/home';
  static const String agenda  = '/agenda';
  static const String workouts = '/workouts';
  static const String profile = '/profile';
  static const String stats   = '/stats';
  static const String trainerHome = '/trainer-home';

  static Map<String, WidgetBuilder> get routes => {
    login:       (_) => const LoginScreen(),
    home:        (_) => const HomeScreen(),
    agenda:      (_) => const AgendaScreen(),
    workouts:    (_) => const WorkoutsListPage(),
    profile:     (_) => const ProfileScreen(),
    stats:       (_) => const StatsScreen(),
    trainerHome: (_) => const TrainerHomeScreen(),
  };
}
```

---

### A.6 — Estructura de carpetas del proyecto

```
vozmefit/
├── lib/
│   ├── main.dart                    # Punto de entrada, inicialización Firebase
│   ├── app/
│   │   ├── router.dart              # Rutas nombradas de la app
│   │   └── theme.dart               # Tema visual global (colores, tipografía)
│   ├── data/
│   │   ├── firebase/
│   │   │   ├── auth_service.dart    # Login, registro, Google Sign-In
│   │   │   └── training_service.dart # CRUD de entrenamientos en Firestore
│   │   ├── models/
│   │   │   ├── training.dart        # Modelo Training con fromMap/toMap
│   │   │   ├── exercise.dart        # Modelo Exercise
│   │   │   ├── usuario.dart         # Modelo Usuario con roles y nivel
│   │   │   └── exercise_types.dart  # Constantes de tipos de ejercicio
│   │   ├── repositories/
│   │   │   └── auth_repository.dart # Intermediario entre AuthService y UI
│   │   ├── services/
│   │   │   ├── agenda_service.dart  # CRUD agenda del usuario en Firestore
│   │   │   ├── routine_service.dart # Rutinas favoritas del usuario
│   │   │   ├── user_service.dart    # Perfil del usuario en Firestore
│   │   │   └── workout_log_service.dart # Logs de sesiones
│   │   └── utils/
│   │       └── firebase_options.dart # Configuración de Firebase por plataforma
│   └── presentation/
│       ├── providers/
│       │   └── auth_provider.dart   # Estado global de autenticación
│       ├── screens/
│       │   ├── login/               # Pantalla de login y registro
│       │   ├── home/                # Dashboard principal
│       │   ├── workouts/            # Lista y detalle de entrenamientos
│       │   ├── agenda/              # Planificador semanal
│       │   ├── stats/               # Estadísticas de progreso
│       │   ├── profile/             # Perfil de usuario
│       │   └── trainer/             # Panel CRUD del entrenador
│       └── widgets/
│           ├── custom_button.dart   # Botón reutilizable
│           └── custom_input.dart    # Campo de texto reutilizable
├── android/                         # Configuración Android (Gradle, google-services)
├── ios/                             # Configuración iOS (Runner, Info.plist)
├── web/                             # Configuración web (index.html)
├── assets/
│   └── sounds/                      # Assets de audio (para futuro temporizador)
├── pubspec.yaml                     # Dependencias y assets del proyecto
└── docs/
    └── TFG_VozmeFit.md              # Este documento
```

---

*Documento generado para el Trabajo de Fin de Grado — VozmeFit — Curso 2025/2026*
*Autor: [Tu Nombre] | Tutor: [Nombre del Tutor] | Centro: [Nombre del Centro]*
