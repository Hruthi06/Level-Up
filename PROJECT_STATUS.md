# LEVEL UP — Project Status & Roadmap Tracker

> **Tagline:** TRAIN. COMPLETE. LEVEL UP.  
> **Core Concept:** AI-Powered Gamified Fitness App (Bodyweight Exercises + RPG Progression + On-Device Vision)  
> **Target OS:** Android (via Flutter + Native MediaPipe / CameraX)  
> **Backend:** Firebase (Auth, Cloud Firestore, Cloud Functions for anti-cheat XP validation)

---

## 1. Project Phase Overview

| Phase | Description | Status |
| :--- | :--- | :--- |
| **Phase 0** | **Technical Architecture & Specifications** | 🟢 Complete |
| **Phase 1** | **UI & Foundation (Milestone 1)** | 🟢 Complete |
| **Phase 2** | **User Accounts, Auth & Firebase Sync** | ⚪ Next Up |
| **Phase 3** | **Gamification Engine (XP, Streaks, Levels, Badges)** | ⚪ Planned |
| **Phase 4** | **AI Camera & Pose Recognition Engine (MediaPipe)** | ⚪ Planned |
| **Phase 5** | **Social Features, Duels & Leaderboards** | ⚪ Planned |
| **Phase 6** | **AI Coach, Personalization & Cosmetic RPG Store** | ⚪ Planned |
| **Phase 7** | **Performance Optimization, Testing & Release** | ⚪ Planned |

---

## 2. Milestone 1: UI & Foundation Tracking

| Component / Screen | Status | Description |
| :--- | :--- | :--- |
| **Design System & Theme** | 🟢 Complete | Deep Black (`#0A0A0C`), Dark Charcoal (`#16161A`), Neon Lime (`#00FF66`), Emerald (`#059669`), Rajdhani & Chakra Petch typography |
| **Core Architecture & Routing** | 🟢 Complete | Clean Modular Architecture, Riverpod 2.x, GoRouter StatefulShellRoute with 5 persistent HUD tabs |
| **Splash Screen** | 🟢 Complete | Glowing cyber pulse animation, brand emblem, session router check (`/splash`) |
| **Welcome Screen** | 🟢 Complete | Value proposition, feature triad, quick demo mode bypass (`/welcome`) |
| **Authentication UI** | 🟢 Complete | Player Login (`/login`), Register Alias (`/register`), Recover Access (`/forgot-password`), Google Sign-In buttons |
| **Onboarding Flow** | 🟢 Complete | 4-step interactive wizard: fitness level, primary goal, weekly workout days, and intensity rank with Rest Day Shield info (`/onboarding`) |
| **Main Dashboard** | 🟢 Complete | Player Status Hero (Level 08 Warrior, 1250/1500 XP, 12-day streak), 5 daily mission tiles, weekly cadence tracker (`/dashboard`) |
| **Daily Missions Hub** | 🟢 Complete | 3-tab view (Daily Quests, Weekly Milestones, Special Raids) with +50 XP Daily Clear Bonus banner (`/missions`) |
| **Workout Details & Prep** | 🟢 Complete | Biomechanical requirements, camera positioning guide (6-8 ft, angles), reward display (`/workout/prep/:id`) |
| **AI Workout Camera & HUD** | 🟢 Complete | Viewfinder cyber grid, dynamic angle overlay (`165°` to `84°`), movement phase indicator, real-time coach feedback, rep counter linked to state provider (`/workout/active/:id`) |
| **Leaderboard / Ranks** | 🟢 Complete | Global Tier and Friends League ranking cards (`/leaderboard`) |
| **Friends & Duels** | 🟢 Complete | Allies online list, active 1v1 duel card (50 Squats challenge), duel invite action (`/friends`) |
| **Profile & Dossier** | 🟢 Complete | RPG character card, XP bar, combat analytics grid, trophy case with 5 achievement badges, settings sheet (`/profile`) |
| **Mock Repository Layer** | 🟢 Complete | `MockFitnessNotifier` & `MockFitnessState` supporting real-time XP addition, level progression, and mission completion without active backend dependency |

---

## 3. Algorithmic Verification & Tests

- **Biomechanical Angle Calculations:** 180° lockout, 90° push-up depth inflection, and acute angles verified.
- **XP Scaling Curve:** Exponential RPG formula $\text{XP}(L) = 100 \times L^{1.35}$ verified across Level 1 to Level 8.

---

## 4. Next Immediate Steps (Phase 2 & Phase 3)

1. Review Milestone 1 architecture and UI implementation with lead.
2. Initialize Firebase Android configuration (`google-services.json`, Firebase Auth & Cloud Firestore).
3. Connect `MockFitnessNotifier` to live Firestore streams with offline persistence.
4. Integrate native MediaPipe Pose Landmarker for on-device live camera inference.
