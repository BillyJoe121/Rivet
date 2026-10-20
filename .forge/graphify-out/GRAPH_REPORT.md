# Graph Report - Rivet  (2026-10-19)

## Corpus Check
- 162 files · ~2,433,138 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 2219 nodes · 2878 edges · 127 communities (120 shown, 7 thin omitted)
- Extraction: 99% EXTRACTED · 1% INFERRED · 0% AMBIGUOUS · INFERRED: 18 edges (avg confidence: 0.8)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `e6ed285f`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- Win32Window
- screen_explorer_screen.dart
- models.dart
- notifications_screen.dart
- AppDelegate
- negotiation_chat_screen.dart
- contractor_visit_screen.dart
- proposal_detail_screen.dart
- app_colors.dart
- materials_order_screen.dart
- app_spacing.dart
- my_application.cc
- app_typography.dart
- create_project_screen.dart
- app_text_field.dart
- package:flutter/material.dart
- login_screen.dart
- app_button.dart
- app_card.dart
- app_header.dart
- ValueChanged
- add_catalog_product_screen.dart
- cancellation_refund_screen.dart
- supplier_home_view.dart
- widgets.dart
- wWinMain
- project_payment_screen.dart
- add_surface_sheet.dart
- rv_icons.dart
- create_incident_screen.dart
- chat_bubble.dart
- materials_catalog_screen.dart
- manifest.json
- admin_dispute_resolution_screen.dart
- forgot_password_screen.dart
- pro_rate_authorization_screen.dart
- rv_tokens.dart
- VoidCallback?
- figma_harness.dart
- mock_data.dart
- Pantallas y trazabilidad de Rivet
- ../../core/models/models.dart
- ../theme/theme.dart
- State
- project_review_step.dart
- 03-pantallas-y-trazabilidad_6a332278.md
- material_detail_screen.dart
- rv_icon_data.dart
- client_harness.dart
- rv_images.dart
- app_date_picker_dialog.dart
- StatelessWidget
- package:flutter_test/flutter_test.dart
- MainActivity
- @correo
- String?
- app_price_select_dialog.dart
- rv_surfaces.dart
- app_modal.dart
- financial_transactions_screen.dart
- app_shell.dart
- app_search_bar.dart
- auth_widgets.dart
- rv_bottom_nav.dart
- Handoff del Proyecto Rivet (Para Claude / Antigravity)
- app_images.dart
- app_bottom_nav.dart
- app_list_tile.dart
- Épica 9 — Administración y evolución
- Épica 9 Administración y evolución
- rv_header.dart
- ../figma_harness.dart
- rivet_scaffold.dart
- app_confirm_dialog.dart
- rivet_header.dart
- rv_button.dart
- rv_page.dart
- Rivet — Requisitos funcionales
- app_avatar.dart
- app_quick_action_tile.dart
- app_segmented_control.dart
- visit_payment_modal.dart
- work_progress_screen.dart
- supplier_order_card.dart
- Color
- app_bottom_sheet.dart
- 02-requisitos-funcionales_4355953a.md
- app_filter_chips.dart
- date_extension_modal.dart
- Rivet — propuesta de identidad de marca
- components_visual_test.dart
- app_theme.dart
- Épica 1 — Acceso, perfiles y privacidad
- Épica 2 — Proyecto, captura y dossier
- Épica 5 — Cotización y negociación
- Épica 6 — Contratación y seguimiento financiero
- Épica 1 Acceso perfiles y privacidad
- Épica 2 Proyecto captura y dossier
- Épica 5 Cotización y negociación
- Épica 6 Contratación y seguimiento financiero
- 04-identidad-de-marca_e238044a.md
- List
- Rivet — pitch de propuesta académica
- Épica 7 — Materiales, entrega y comisiones
- Épica 8 — Cancelaciones, conciliación, reseñas y casos
- Épica 7 Materiales entrega y comisiones
- Épica 8 Cancelaciones conciliación reseñas y casos
- 🚀 Handoff del Proyecto Rivet (Flutter + Figma)
- app_button_visual_test.dart
- entry_visual_test.dart
- Épica 3 — Catálogo de materiales
- Épica 4 — Exploración y visitas
- 01-pitch_7c3294d4.md
- Épica 3 Catálogo de materiales
- Épica 4 Exploración y visitas
- app_badge_visual_test.dart
- app_text_field_visual_test.dart
- compare.py
- scaffold_visual_test.dart
- rivet
- figma_export.py
- LaunchImage.imageset/README.md
- Size

## God Nodes (most connected - your core abstractions)
1. `Pantallas y trazabilidad de Rivet` - 55 edges
2. `Win32Window` - 22 edges
3. `Rivet — Requisitos funcionales` - 18 edges
4. `Épica 9 — Administración y evolución` - 15 edges
5. `Épica 9 Administración y evolución` - 15 edges
6. `MessageHandler` - 12 edges
7. `FlutterWindow` - 10 edges
8. `Create` - 10 edges
9. `WndProc` - 10 edges
10. `MessageHandler` - 9 edges

## Surprising Connections (you probably didn't know these)
- `wWinMain()` --calls--> `CreateAndAttachConsole()`  [INFERRED]
  windows/runner/main.cpp → windows/runner/utils.cpp
- `Win32Window::Win32Window()` --calls--> `Destroy`  [INFERRED]
  windows/runner/win32_window.cpp → windows/runner/win32_window.h
- `my_application_activate()` --calls--> `fl_register_plugins()`  [INFERRED]
  linux/runner/my_application.cc → linux/flutter/generated_plugin_registrant.cc
- `main()` --calls--> `my_application_new()`  [INFERRED]
  linux/runner/main.cc → linux/runner/my_application.cc
- `OnCreate` --calls--> `RegisterPlugins()`  [INFERRED]
  windows/runner/flutter_window.h → windows/flutter/generated_plugin_registrant.cc

## Import Cycles
- None detected.

## Communities (127 total, 7 thin omitted)

### Community 0 - "Win32Window"
Cohesion: 0.06
Nodes (53): PluginRegistry, Point, RECT, unique_ptr, RegisterPlugins(), DartProject, HWND, LPARAM (+45 more)

### Community 1 - "screen_explorer_screen.dart"
Cohesion: 0.07
Nodes (29): ../admin/admin_dashboard_screen.dart, ../admin/admin_dispute_resolution_screen.dart, ../auth/forgot_password_screen.dart, component_gallery_screen.dart, ../contractors/contractor_detail_screen.dart, ../contractors/visit_payment_modal.dart, ../disputes/cancellation_refund_screen.dart, ../disputes/create_incident_screen.dart (+21 more)

### Community 2 - "models.dart"
Cohesion: 0.04
Nodes (44): areaM2, bio, brand, budgetEstimateCop, category, city, clientName, clientPriceCop (+36 more)

### Community 3 - "notifications_screen.dart"
Cohesion: 0.10
Nodes (19): AppBadge, AppBadgeVariant, build, compact, count, icon, _isCount, text (+11 more)

### Community 4 - "AppDelegate"
Cohesion: 0.06
Nodes (26): Any, Cocoa, Flutter, FlutterAppDelegate, FlutterImplicitEngineBridge, FlutterImplicitEngineDelegate, FlutterMacOS, FlutterPluginRegistry (+18 more)

### Community 5 - "negotiation_chat_screen.dart"
Cohesion: 0.17
Nodes (12): build, _buildInputBar, contractor, createState, dispose, _messageController, _messages, NegotiationChatScreen (+4 more)

### Community 6 - "contractor_visit_screen.dart"
Cohesion: 0.18
Nodes (11): DateTime, _addressController, build, contractor, ContractorVisitScreen, _ContractorVisitScreenState, createState, dispose (+3 more)

### Community 7 - "proposal_detail_screen.dart"
Cohesion: 0.10
Nodes (19): ../contractors/contractor_visit_screen.dart, ../execution/work_progress_screen.dart, Proposal, build, _buildReceiptRow, _formatCurrency, paymentMethod, PaymentReceiptScreen (+11 more)

### Community 8 - "app_colors.dart"
Cohesion: 0.05
Nodes (39): AppColors, barrier, brand700, brand800, brandGradient, brandGradientEnd, brandGradientStart, brandLight (+31 more)

### Community 9 - "materials_order_screen.dart"
Cohesion: 0.07
Nodes (28): int get, build, CreateProposalScreen, _CreateProposalScreenState, createState, _daysController, dispose, _formatCurrency (+20 more)

### Community 10 - "app_spacing.dart"
Cohesion: 0.04
Nodes (48): AppSpacing, cardPadding, dialogPadding, gestureBarHeight, headerGutter, headerHeight, heroHeight, lg (+40 more)

### Community 11 - "my_application.cc"
Cohesion: 0.09
Nodes (22): FlPluginRegistry, FlView, GApplication, gboolean, gchar, GObject, GtkApplication, fl_register_plugins() (+14 more)

### Community 12 - "app_typography.dart"
Cohesion: 0.07
Nodes (29): AppTypography, badgeText, bodyLarge, bodyMedium, bodySmall, bodyStrong, buttonText, caption (+21 more)

### Community 13 - "create_project_screen.dart"
Cohesion: 0.09
Nodes (22): double get, _aiMinimizationAccepted, build, _buildBottomBar, _buildStepGeneralData, _buildStepSurfaces, _cityController, CreateProjectScreen (+14 more)

### Community 14 - "app_text_field.dart"
Cohesion: 0.07
Nodes (27): FormFieldValidator, autofocus, build, _buildField, controller, createState, dispose, enabled (+19 more)

### Community 15 - "package:flutter/material.dart"
Cohesion: 0.08
Nodes (29): admin_dispute_resolution_screen.dart, contractor_detail_screen.dart, ../../core/data/mock_data.dart, core/theme/theme.dart, ../../core/widgets/widgets.dart, features/onboarding/welcome_screen.dart, AdminDashboardScreen, build (+21 more)

### Community 16 - "login_screen.dart"
Cohesion: 0.06
Nodes (34): ../auth/login_screen.dart, forgot_password_screen.dart, ../home/app_shell.dart, build, createState, _enter, _keepSession, LoginScreen (+26 more)

### Community 17 - "app_button.dart"
Cohesion: 0.04
Nodes (44): bool get, AppButton, AppButtonSize, AppButtonVariant, _backgroundColor, _border, build, _ButtonSpec (+36 more)

### Community 18 - "app_card.dart"
Cohesion: 0.15
Nodes (12): BorderRadius?, AppCard, backgroundColor, borderColor, borderRadius, borderWidth, build, child (+4 more)

### Community 19 - "app_header.dart"
Cohesion: 0.13
Nodes (15): actions, AppHeader, backgroundColor, _barHeight, bottom, build, leading, onBack (+7 more)

### Community 20 - "ValueChanged"
Cohesion: 0.13
Nodes (13): build, _buildPhotoTeaserCard, _buildQuickActionCard, ClientHomeView, onSwitchRole, aiMinimizationAccepted, build, noPrivateDataConfirmed (+5 more)

### Community 21 - "add_catalog_product_screen.dart"
Cohesion: 0.14
Nodes (14): AddCatalogProductScreen, _AddCatalogProductScreenState, _brandController, build, _category, _clientPriceController, _coverageController, createState (+6 more)

### Community 22 - "cancellation_refund_screen.dart"
Cohesion: 0.17
Nodes (12): build, CancellationRefundScreen, _CancellationRefundScreenState, contractorName, createState, dispose, escrowAmountCop, _explanationController (+4 more)

### Community 23 - "supplier_home_view.dart"
Cohesion: 0.17
Nodes (12): _activeTab, build, _buildOrdersSection, _buildProNetworkSection, _buildSummarySection, createState, initialTab, initState (+4 more)

### Community 24 - "widgets.dart"
Cohesion: 0.08
Nodes (24): app_avatar.dart, app_badge.dart, app_bottom_nav.dart, app_bottom_sheet.dart, app_card.dart, app_confirm_dialog.dart, app_date_picker_dialog.dart, app_empty_state.dart (+16 more)

### Community 25 - "wWinMain"
Cohesion: 0.24
Nodes (9): _In_, _In_opt_, vector, wWinMain(), string, wchar_t, CreateAndAttachConsole(), GetCommandLineArguments() (+1 more)

### Community 26 - "project_payment_screen.dart"
Cohesion: 0.18
Nodes (11): build, _buildRow, createState, _formatCurrency, _isProcessing, _processPayment, ProjectPaymentScreen, _ProjectPaymentScreenState (+3 more)

### Community 27 - "add_surface_sheet.dart"
Cohesion: 0.20
Nodes (9): build, createState, dispose, _finishType, _heightController, _nameController, onAddSurface, _submit (+1 more)

### Community 28 - "rv_icons.dart"
Cohesion: 0.02
Nodes (98): apple, arrowDownUp, arrowRight, backChevron, backChevron30x28, bell, building, calendar (+90 more)

### Community 29 - "create_incident_screen.dart"
Cohesion: 0.20
Nodes (10): build, _category, counterpartName, CreateIncidentScreen, _CreateIncidentScreenState, createState, _descriptionController, dispose (+2 more)

### Community 30 - "chat_bubble.dart"
Cohesion: 0.18
Nodes (10): build, ChatBubble, ChatMessage, id, isMe, isOfferUpdate, message, senderName (+2 more)

### Community 31 - "materials_catalog_screen.dart"
Cohesion: 0.18
Nodes (11): build, createState, _formatCurrency, initState, isProRateView, isSupplierAdmin, MaterialsCatalogScreen, _MaterialsCatalogScreenState (+3 more)

### Community 32 - "manifest.json"
Cohesion: 0.18
Nodes (10): background_color, description, display, icons, name, orientation, prefer_related_applications, short_name (+2 more)

### Community 33 - "admin_dispute_resolution_screen.dart"
Cohesion: 0.22
Nodes (9): AdminDisputeResolutionScreen, _AdminDisputeResolutionScreenState, build, _clientCommissionController, _contractorCommissionController, createState, dispose, _materialsFeeController (+1 more)

### Community 34 - "forgot_password_screen.dart"
Cohesion: 0.22
Nodes (9): build, _contactController, createState, dispose, ForgotPasswordScreen, _ForgotPasswordScreenState, _handleSubmit, _isLoading (+1 more)

### Community 35 - "pro_rate_authorization_screen.dart"
Cohesion: 0.20
Nodes (10): Contractor, build, _buildDiscountRow, contractor, createState, dispose, _isAuthorized, ProRateAuthorizationScreen (+2 more)

### Community 36 - "rv_tokens.dart"
Cohesion: 0.03
Nodes (64): double? lineHeight,
  Color, FontWeight, bodySmall, bodyStrong, bottomNav, brand700, brand800, brandGradient (+56 more)

### Community 37 - "VoidCallback?"
Cohesion: 0.08
Nodes (24): app_button.dart, IconData, actionLabel, AppEmptyState, build, icon, message, onAction (+16 more)

### Community 38 - "figma_harness.dart"
Cohesion: 0.04
Nodes (56): Alignment, Color? background,
  bool, dart:convert, required bool settle,
  bool, add, alignment, background, boundary (+48 more)

### Community 39 - "mock_data.dart"
Cohesion: 0.22
Nodes (8): contractors, materials, MockData, projects, proposals, ../models/models.dart, static const List, static final List

### Community 40 - "Pantallas y trazabilidad de Rivet"
Cohesion: 0.04
Nodes (55): Convenciones y estados comunes, Matriz de trazabilidad, P-001 Acceso, P-002 Registro, P-003 Recuperación de acceso, P-004 Inicio por rol, P-005 Perfil del cliente, P-006 Perfil y portafolio profesional (+47 more)

### Community 41 - "../../core/models/models.dart"
Cohesion: 0.07
Nodes (30): contractor_visit_screen.dart, ../../core/models/models.dart, create_project_screen.dart, Project, _card, _sessionRow, build, _buildMetric (+22 more)

### Community 42 - "../theme/theme.dart"
Cohesion: 0.14
Nodes (12): AppPriceBadge, build, priceCop, statusText, stockText, unitText, AppProgressBar, build (+4 more)

### Community 43 - "State"
Cohesion: 0.27
Nodes (10): AppDatePickerDialog, _AppDatePickerDialogState, AppTextField, _AppTextFieldState, MyProjectsScreen, _MyProjectsScreenState, AddSurfaceSheet, _AddSurfaceSheetState (+2 more)

### Community 44 - "project_review_step.dart"
Cohesion: 0.25
Nodes (7): build, city, neighborhood, ProjectReviewStep, surfaces, title, totalArea

### Community 45 - "03-pantallas-y-trazabilidad_6a332278.md"
Cohesion: 0.04
Nodes (54): Convenciones y estados comunes, Matriz de trazabilidad, P 001 Acceso, P 002 Registro, P 003 Recuperación de acceso, P 004 Inicio por rol, P 005 Perfil del cliente, P 006 Perfil y portafolio profesional (+46 more)

### Community 46 - "material_detail_screen.dart"
Cohesion: 0.29
Nodes (6): MaterialProduct, build, _formatCurrency, isProRate, material, MaterialDetailScreen

### Community 47 - "rv_icon_data.dart"
Cohesion: 0.04
Nodes (44): CustomPainter, double?, _ChevronPainter, AppInfoBanner, AppInfoBannerVariant, build, compact, icon (+36 more)

### Community 48 - "client_harness.dart"
Cohesion: 0.05
Nodes (42): dart:io, dart:ui, Future, GlobalKey, package:flutter/rendering.dart, package:rivet/features/projects/widgets/client_kit/client_kit.dart, required String name,
  Size, Set (+34 more)

### Community 49 - "rv_images.dart"
Cohesion: 0.06
Nodes (33): brightBathroom, brightKitchen, dampWall, emptyGreenRoom, emptyRoomWindow, ferreCasaFront, greenWallVertical, headerBotanical (+25 more)

### Community 50 - "app_date_picker_dialog.dart"
Cohesion: 0.06
Nodes (32): build, _buildCalendar, _buildDay, cancelLabel, _cellSize, _columnGap, confirmLabel, createState (+24 more)

### Community 51 - "StatelessWidget"
Cohesion: 0.06
Nodes (37): auth_widgets.dart, build, icon, input, label, LoginField, LoginTabs, onCreateAccount (+29 more)

### Community 52 - "package:flutter_test/flutter_test.dart"
Cohesion: 0.18
Nodes (9): package:flutter_test/flutter_test.dart, package:lucide_icons_flutter/lucide_icons.dart, package:rivet/core/widgets/app_empty_state.dart, package:rivet/core/widgets/app_spec_row.dart, package:rivet/main.dart, main, main, main (+1 more)

### Community 60 - "app_price_select_dialog.dart"
Cohesion: 0.07
Nodes (27): ImageProvider? productImage,
  String, AppPriceOption, AppPriceOptionRow, AppPriceSelectDialog, _AppPriceSelectDialogState, build, cancelLabel, confirmLabel (+19 more)

### Community 61 - "rv_surfaces.dart"
Cohesion: 0.08
Nodes (25): background, borderColor, borderWidth, build, child, color, current, foreground (+17 more)

### Community 62 - "app_modal.dart"
Cohesion: 0.09
Nodes (22): AppModal, AppModalActions, AppModalButton, AppModalMessage, AppModalTitle, barrierDismissible, build, cancelLabel (+14 more)

### Community 63 - "financial_transactions_screen.dart"
Cohesion: 0.10
Nodes (19): UserRole, build, _buildSettingsRow, currentRole, onSwitchRole, ProfileScreen, amountCop, build (+11 more)

### Community 64 - "app_shell.dart"
Cohesion: 0.11
Nodes (19): ../account/profile_screen.dart, client_home_view.dart, contractor_home_view.dart, ../contractors/contractors_directory_screen.dart, ../../core/widgets/app_bottom_nav.dart, ../explorer/screen_explorer_screen.dart, AppShell, _AppShellState (+11 more)

### Community 65 - "app_search_bar.dart"
Cohesion: 0.10
Nodes (19): FocusNode, AppFilterField, AppFilterGrid, AppSearchBar, build, child, controller, fields (+11 more)

### Community 66 - "auth_widgets.dart"
Cohesion: 0.10
Nodes (19): AuthColors, AuthGradientButton, AuthInput, build, controller, fieldStroke, height, hint (+11 more)

### Community 67 - "rv_bottom_nav.dart"
Cohesion: 0.12
Nodes (16): activeIndex, build, _destination, destinations, onSelect, RvBottomNav, rv_bottom_nav.dart, rv_button.dart (+8 more)

### Community 68 - "Handoff del Proyecto Rivet (Para Claude / Antigravity)"
Cohesion: 0.12
Nodes (15): 1. Sistema de Tokens (`lib/core/theme/`), 1. Visión General del Proyecto, 2. Componentes Reutilizables Centrales (`lib/core/widgets/`), 2. Entorno y Estado del Repositorio, 3. Figma y Conexión MCP / REST, 3. Navegación y Explorador 1-Click, 4. Banco de Imágenes y Assets (`Fondos/` y `Pantallas/`), 5. Arquitectura del Código y Sistema de Diseño (+7 more)

### Community 69 - "app_images.dart"
Cohesion: 0.12
Nodes (15): all, AppHeroImages, documents, greenery, home, livingRoom, lounge, messages (+7 more)

### Community 70 - "app_bottom_nav.dart"
Cohesion: 0.12
Nodes (15): AppBottomNav, AppNavDestination, AppNavDestinations, build, client, currentIndex, destination, destinations (+7 more)

### Community 71 - "app_list_tile.dart"
Cohesion: 0.12
Nodes (15): AppListTile, AppSwitch, build, leading, leadingIcon, meta, onChanged, onTap (+7 more)

### Community 72 - "Épica 9 — Administración y evolución"
Cohesion: 0.13
Nodes (15): RF-059 Administrar usuarios y reportes, RF-060 Resolver casos con trazabilidad, RF-061 Configurar tarifas y plazos con auditoría, RF-062 Administrar disponibilidad de catálogo, RF-063 Consultar actividad operativa, RF-064 Verificar identidad de profesional automáticamente, RF-065 Autorizar manualmente al contratista para precio profesional, RF-066 Estimar rango de materiales con trazabilidad (+7 more)

### Community 73 - "Épica 9 Administración y evolución"
Cohesion: 0.13
Nodes (15): RF 059 Administrar usuarios y reportes, RF 060 Resolver casos con trazabilidad, RF 061 Configurar tarifas y plazos con auditoría, RF 062 Administrar disponibilidad de catálogo, RF 063 Consultar actividad operativa, RF 064 Verificar identidad de profesional automáticamente, RF 065 Autorizar manualmente al contratista para precio profesional, RF 066 Estimar rango de materiales con trazabilidad (+7 more)

### Community 74 - "rv_header.dart"
Cohesion: 0.13
Nodes (14): build, children, color, gap, keepBackSpace, onBack, onTap, padding (+6 more)

### Community 75 - "../figma_harness.dart"
Cohesion: 0.18
Nodes (10): ../figma_harness.dart, package:rivet/core/theme/theme.dart, package:rivet/core/widgets/app_price_badge.dart, package:rivet/core/widgets/app_segmented_control.dart, package:rivet/core/widgets/app_stat_tile.dart, package:rivet/core/widgets/app_step_progress.dart, main, main (+2 more)

### Community 76 - "rivet_scaffold.dart"
Cohesion: 0.14
Nodes (13): actions, backgroundImagePath, body, bottomBar, build, headerHero, onBack, RivetScaffold (+5 more)

### Community 77 - "app_confirm_dialog.dart"
Cohesion: 0.15
Nodes (12): app_modal.dart, AppConfirmDialog, barrierDismissible, build, cancelLabel, confirmLabel, message, onCancel (+4 more)

### Community 78 - "rivet_header.dart"
Cohesion: 0.15
Nodes (12): actions, build, color, onBack, onPressed, RivetBackButton, RivetHeader, showBackButton (+4 more)

### Community 79 - "rv_button.dart"
Cohesion: 0.15
Nodes (12): build, chevronSize, height, horizontalPadding, label, onPressed, RvButton, RvButtonVariant (+4 more)

### Community 80 - "rv_page.dart"
Cohesion: 0.15
Nodes (12): background, body, build, footer, footerPadding, header, headerImage, headerImageHeight (+4 more)

### Community 81 - "Rivet — Requisitos funcionales"
Cohesion: 0.17
Nodes (11): Decisiones pendientes de producto (no aprobadas), Estados funcionales principales, Fuentes oficiales consultadas, Fuera de alcance V1 / V2, Glosario, Propósito y alcance, Reglas comerciales y límites, Requisitos complementarios de liquidación y acceso (+3 more)

### Community 82 - "app_avatar.dart"
Cohesion: 0.17
Nodes (11): ImageProvider?, AppAvatar, backgroundColor, build, image, initials, onTap, semanticLabel (+3 more)

### Community 83 - "app_quick_action_tile.dart"
Cohesion: 0.17
Nodes (11): AppQuickActionRow, AppQuickActionTile, build, gap, height, icon, iconSize, label (+3 more)

### Community 84 - "app_segmented_control.dart"
Cohesion: 0.17
Nodes (11): AppSegmentedControl, build, _height, items, onChanged, _radius, _segment, selected (+3 more)

### Community 85 - "visit_payment_modal.dart"
Cohesion: 0.18
Nodes (11): build, contractor, createState, _formatCurrency, _handlePayment, _isProcessing, scheduledDate, _selectedMethod (+3 more)

### Community 86 - "work_progress_screen.dart"
Cohesion: 0.18
Nodes (11): build, _clientApproved, _commentController, _contractorApproved, createState, dispose, _formatCurrency, proposal (+3 more)

### Community 87 - "supplier_order_card.dart"
Cohesion: 0.17
Nodes (11): build, contractorName, hasActionButton, id, items, onAction, projectTitle, status (+3 more)

### Community 88 - "Color"
Cohesion: 0.18
Nodes (10): Color, int?, actionLabel, AppCountPill, AppSectionHeader, build, count, onAction (+2 more)

### Community 89 - "app_bottom_sheet.dart"
Cohesion: 0.18
Nodes (10): EdgeInsetsGeometry, AppBottomSheet, build, child, color, isScrollControlled, padding, radius (+2 more)

### Community 90 - "02-requisitos-funcionales_4355953a.md"
Cohesion: 0.18
Nodes (10): Decisiones pendientes de producto no aprobadas, Estados funcionales principales, Fuentes oficiales consultadas, Fuera de alcance V1 V2, Glosario, Propósito y alcance, Reglas comerciales y límites, Requisitos complementarios de liquidación y acceso (+2 more)

### Community 91 - "app_filter_chips.dart"
Cohesion: 0.18
Nodes (10): AppFilterChip, AppFilterChips, build, label, labels, onSelected, onTap, selected (+2 more)

### Community 92 - "date_extension_modal.dart"
Cohesion: 0.20
Nodes (10): build, createState, currentDeadline, DateExtensionModal, _DateExtensionModalState, dispose, initState, _newDeadline (+2 more)

### Community 93 - "Rivet — propuesta de identidad de marca"
Cohesion: 0.20
Nodes (9): 1. Posicionamiento, públicos y promesa, 2. Nombre y uso, 3. Voz y ejemplos funcionales, 4. Paleta y tipografía, 5. Tokens de interfaz y significado, 6. Concepto de logotipo y especificación, 7. Fotografía, privacidad y uso de imágenes, 8. Accesibilidad, uso incorrecto y límites (+1 more)

### Community 94 - "components_visual_test.dart"
Cohesion: 0.20
Nodes (8): EdgeInsets, package:rivet/core/widgets/widgets.dart, _card, file, main, _render, main, _shadowMargin

### Community 95 - "app_theme.dart"
Cohesion: 0.28
Nodes (7): app_colors.dart, app_images.dart, app_spacing.dart, app_theme.dart, app_typography.dart, AppTheme, package:flutter/services.dart

### Community 96 - "Épica 1 — Acceso, perfiles y privacidad"
Cohesion: 0.22
Nodes (9): RF-001 Crear cuenta y seleccionar rol, RF-002 Iniciar sesión, RF-003 Recuperar acceso, RF-004 Completar perfil de cliente, RF-005 Completar perfil profesional, RF-006 Vincular proveedor y autorizar catálogo, RF-007 Configurar zona pública, RF-008 Administrar consentimiento de datos e imágenes (+1 more)

### Community 97 - "Épica 2 — Proyecto, captura y dossier"
Cohesion: 0.22
Nodes (9): RF-009 Crear proyecto de pintura o estuco, RF-010 Registrar superficie y medidas, RF-011 Adjuntar fotos por superficie, RF-012 Revisar alcance de autorización antes de procesar, RF-013 Solicitar ocultamiento de pertenencias, RF-014 Revisar imágenes transformadas, RF-015 Mantener original privado y derivado publicado, RF-016 Consultar y editar esquema 3D paramétrico (+1 more)

### Community 98 - "Épica 5 — Cotización y negociación"
Cohesion: 0.22
Nodes (9): RF-029 Preparar propuesta profesional, RF-030 Desglosar mano de obra y materiales, RF-031 Corregir cantidades del dossier, RF-032 Negociar alcance y precio, RF-033 Ver tarifa del cliente antes de fijar, RF-034 Publicar proyecto sin costo, RF-035 Consultar y comparar cotizaciones, RF-036 Fijar cotización aceptada (+1 more)

### Community 99 - "Épica 6 — Contratación y seguimiento financiero"
Cohesion: 0.22
Nodes (9): RF-037 Formalizar contratación, RF-038 Consultar tarifa de servicio del cliente, RF-039 Retener saldo total de mano de obra hasta aprobación final, RF-040 Aprobar cumplimiento de mano de obra, RF-041 Gestionar vencimiento de fecha pactada, RF-042 Solicitar prórroga por ambas partes, RF-043 Retener revisión ante silencio o desacuerdo, RF-044 Consultar historial financiero y estado de pago (+1 more)

### Community 100 - "Épica 1 Acceso perfiles y privacidad"
Cohesion: 0.22
Nodes (9): RF 001 Crear cuenta y seleccionar rol, RF 002 Iniciar sesión, RF 003 Recuperar acceso, RF 004 Completar perfil de cliente, RF 005 Completar perfil profesional, RF 006 Vincular proveedor y autorizar catálogo, RF 007 Configurar zona pública, RF 008 Administrar consentimiento de datos e imágenes (+1 more)

### Community 101 - "Épica 2 Proyecto captura y dossier"
Cohesion: 0.22
Nodes (9): RF 009 Crear proyecto de pintura o estuco, RF 010 Registrar superficie y medidas, RF 011 Adjuntar fotos por superficie, RF 012 Revisar alcance de autorización antes de procesar, RF 013 Solicitar ocultamiento de pertenencias, RF 014 Revisar imágenes transformadas, RF 015 Mantener original privado y derivado publicado, RF 016 Consultar y editar esquema 3D paramétrico (+1 more)

### Community 102 - "Épica 5 Cotización y negociación"
Cohesion: 0.22
Nodes (9): RF 029 Preparar propuesta profesional, RF 030 Desglosar mano de obra y materiales, RF 031 Corregir cantidades del dossier, RF 032 Negociar alcance y precio, RF 033 Ver tarifa del cliente antes de fijar, RF 034 Publicar proyecto sin costo, RF 035 Consultar y comparar cotizaciones, RF 036 Fijar cotización aceptada (+1 more)

### Community 103 - "Épica 6 Contratación y seguimiento financiero"
Cohesion: 0.22
Nodes (9): RF 037 Formalizar contratación, RF 038 Consultar tarifa de servicio del cliente, RF 039 Retener saldo total de mano de obra hasta aprobación final, RF 040 Aprobar cumplimiento de mano de obra, RF 041 Gestionar vencimiento de fecha pactada, RF 042 Solicitar prórroga por ambas partes, RF 043 Retener revisión ante silencio o desacuerdo, RF 044 Consultar historial financiero y estado de pago (+1 more)

### Community 104 - "04-identidad-de-marca_e238044a.md"
Cohesion: 0.22
Nodes (8): 1 Posicionamiento públicos y promesa, 2 Nombre y uso, 3 Voz y ejemplos funcionales, 4 Paleta y tipografía, 5 Tokens de interfaz y significado, 6 Concepto de logotipo y especificación, 7 Fotografía privacidad y uso de imágenes, 8 Accesibilidad uso incorrecto y límites

### Community 105 - "List"
Cohesion: 0.22
Nodes (8): AppStepProgress, build, currentStep, _idleFill, _step, steps, List, static const Color

### Community 106 - "Rivet — pitch de propuesta académica"
Cohesion: 0.25
Nodes (7): Alcance y validación, Modelo de ingresos y decisiones pendientes, Presentación ampliada · aproximadamente 2 minutos, Presentación breve · 45–60 segundos, Problema y alternativas, Propuesta de valor, Rivet — pitch de propuesta académica

### Community 107 - "Épica 7 — Materiales, entrega y comisiones"
Cohesion: 0.25
Nodes (8): RF-045 Solicitar materiales por cotización, RF-046 Coordinar entrega de materiales, RF-047 Confirmar recepción y aceptación de materiales, RF-048 Liberar pago de materiales por separado, RF-049 Registrar comisión profesional pendiente, RF-050 Calcular liquidación profesional al desembolso, RF-051 Evitar cobros o desembolsos duplicados, Épica 7 — Materiales, entrega y comisiones

### Community 108 - "Épica 8 — Cancelaciones, conciliación, reseñas y casos"
Cohesion: 0.25
Nodes (8): RF-052 Cancelar contratación, RF-053 Solicitar reembolso, RF-054 Conciliar pagos con pasarela, RF-055 Confirmar pago con resultado de pasarela, RF-056 Calificar transacción completada, RF-057 Reportar incidencia o incumplimiento, RF-058 Consultar resolución y plazos de disputa, Épica 8 — Cancelaciones, conciliación, reseñas y casos

### Community 109 - "Épica 7 Materiales entrega y comisiones"
Cohesion: 0.25
Nodes (8): RF 045 Solicitar materiales por cotización, RF 046 Coordinar entrega de materiales, RF 047 Confirmar recepción y aceptación de materiales, RF 048 Liberar pago de materiales por separado, RF 049 Registrar comisión profesional pendiente, RF 050 Calcular liquidación profesional al desembolso, RF 051 Evitar cobros o desembolsos duplicados, Épica 7 Materiales entrega y comisiones

### Community 110 - "Épica 8 Cancelaciones conciliación reseñas y casos"
Cohesion: 0.25
Nodes (8): RF 052 Cancelar contratación, RF 053 Solicitar reembolso, RF 054 Conciliar pagos con pasarela, RF 055 Confirmar pago con resultado de pasarela, RF 056 Calificar transacción completada, RF 057 Reportar incidencia o incumplimiento, RF 058 Consultar resolución y plazos de disputa, Épica 8 Cancelaciones conciliación reseñas y casos

### Community 111 - "🚀 Handoff del Proyecto Rivet (Flutter + Figma)"
Cohesion: 0.25
Nodes (7): 1. Contexto del Producto, 2. Lo que ya está hecho ✅, 3. Flujos de Pantallas Mapeados en Figma, 4. Reglas de Calidad y Arquitectura (Forge), 5. Visualizador / Emulador en PC, 6. Próximos Pasos para el Nuevo Chat (Inicio Inmediato), 🚀 Handoff del Proyecto Rivet (Flutter + Figma)

### Community 112 - "app_button_visual_test.dart"
Cohesion: 0.25
Nodes (6): package:rivet/core/widgets/app_button.dart, package:rivet/core/widgets/app_card.dart, file, main, _render, main

### Community 113 - "entry_visual_test.dart"
Cohesion: 0.29
Nodes (6): client_harness.dart, package:rivet/features/auth/login_screen.dart, package:rivet/features/auth/signup_screen.dart, package:rivet/features/onboarding/role_selection_screen.dart, package:rivet/features/onboarding/welcome_screen.dart, main

### Community 114 - "Épica 3 — Catálogo de materiales"
Cohesion: 0.29
Nodes (7): RF-017 Consultar catálogo autorizado, RF-018 Ver ficha técnica y rendimiento, RF-019 Ver precios y vigencia, RF-020 Confirmar disponibilidad con proveedor, RF-021 Administrar referencias de proveedor, RF-022 Consultar procedencia y respaldo de materiales, Épica 3 — Catálogo de materiales

### Community 115 - "Épica 4 — Exploración y visitas"
Cohesion: 0.29
Nodes (7): RF-023 Explorar proyectos abiertos por zona, RF-024 Buscar y consultar profesionales, RF-025 Solicitar visita, RF-026 Acordar y pagar visita, RF-027 Compartir dirección exacta al profesional contratado, RF-028 Cancelar o reprogramar visita, Épica 4 — Exploración y visitas

### Community 116 - "01-pitch_7c3294d4.md"
Cohesion: 0.29
Nodes (6): Alcance y validación, Modelo de ingresos y decisiones pendientes, Presentación ampliada aproximadamente 2 minutos, Presentación breve 45 60 segundos, Problema y alternativas, Propuesta de valor

### Community 117 - "Épica 3 Catálogo de materiales"
Cohesion: 0.29
Nodes (7): RF 017 Consultar catálogo autorizado, RF 018 Ver ficha técnica y rendimiento, RF 019 Ver precios y vigencia, RF 020 Confirmar disponibilidad con proveedor, RF 021 Administrar referencias de proveedor, RF 022 Consultar procedencia y respaldo de materiales, Épica 3 Catálogo de materiales

### Community 118 - "Épica 4 Exploración y visitas"
Cohesion: 0.29
Nodes (7): RF 023 Explorar proyectos abiertos por zona, RF 024 Buscar y consultar profesionales, RF 025 Solicitar visita, RF 026 Acordar y pagar visita, RF 027 Compartir dirección exacta al profesional contratado, RF 028 Cancelar o reprogramar visita, Épica 4 Exploración y visitas

### Community 119 - "app_badge_visual_test.dart"
Cohesion: 0.40
Nodes (4): package:rivet/core/widgets/app_badge.dart, file, main, _render

### Community 120 - "app_text_field_visual_test.dart"
Cohesion: 0.40
Nodes (4): package:rivet/core/widgets/app_text_field.dart, file, main, _render

### Community 121 - "compare.py"
Cohesion: 0.60
Nodes (4): _flatten(), main(), _pad(), Compara un PNG exportado de Figma con el PNG renderizado por las pruebas.…

### Community 122 - "scaffold_visual_test.dart"
Cohesion: 0.50
Nodes (3): package:rivet/core/widgets/app_bottom_nav.dart, package:rivet/core/widgets/rivet_scaffold.dart, main

## Knowledge Gaps
- **1540 isolated node(s):** `MockData`, `contractors`, `projects`, `proposals`, `materials` (+1535 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **7 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `UserRole` connect `financial_transactions_screen.dart` to `app_shell.dart`, `screen_explorer_screen.dart`, `models.dart`, `login_screen.dart`, `StatelessWidget`?**
  _High betweenness centrality (0.006) - this node is a cross-community bridge._
- **Why does `RvIconData` connect `StatelessWidget` to `rv_surfaces.dart`, `rv_icon_data.dart`?**
  _High betweenness centrality (0.001) - this node is a cross-community bridge._
- **Why does `Contractor` connect `pro_rate_authorization_screen.dart` to `models.dart`, `negotiation_chat_screen.dart`, `contractor_visit_screen.dart`, `../../core/models/models.dart`, `visit_payment_modal.dart`?**
  _High betweenness centrality (0.001) - this node is a cross-community bridge._
- **What connects `MockData`, `contractors`, `projects` to the rest of the system?**
  _1540 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `Win32Window` be split into smaller, more focused modules?**
  _Cohesion score 0.0597567424643046 - nodes in this community are weakly interconnected._
- **Should `screen_explorer_screen.dart` be split into smaller, more focused modules?**
  _Cohesion score 0.06666666666666667 - nodes in this community are weakly interconnected._
- **Should `models.dart` be split into smaller, more focused modules?**
  _Cohesion score 0.044444444444444446 - nodes in this community are weakly interconnected._