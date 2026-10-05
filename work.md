# Cahier des Charges — Inventory & Sales Management App
### For a Building Materials Seller in Togo

| | |
|---|---|
| **Project** | Inventory, sales and reporting app for a building-materials depot |
| **Client** | Building materials seller, Togo |
| **Platforms** | Windows desktop app + Android app (Flutter), installed directly by the developer (no app store) |
| **Backend** | Node.js (TypeScript, NestJS) + PostgreSQL, self-hosted on a Linux VPS |
| **Mode** | Works fully offline, syncs automatically when online |
| **Notifications** | Daily summary and alerts to the owner via WhatsApp (Meta WhatsApp Cloud API); monthly report as Excel/CSV by email |
| **Currency** | FCFA (XOF), no decimals |
| **Languages** | French (default), English |
| **Version** | 1.0 — Draft for client review |
| **Date** | October 2026 |

---

## Table of contents

1. Context and objectives
2. Users and roles
3. Golden rule: simplicity ("a 9-year-old can use it")
4. Platforms and architecture (online / offline)
5. Functional modules
6. Reports and dashboard
7. Non-functional requirements
8. Security and permissions
9. Data model (main entities)
10. Delivery phases
11. Acceptance criteria
12. Deliverables
13. Questions to confirm with the client

---

## 1. Context and objectives

### 1.1 Context
The client sells building materials in Togo (cement, iron rods, roofing sheets, wire, gravel, sand, plumbing, electrical, paint, etc.). He sells to individuals and to contractors, both retail and wholesale, often with delivery to construction sites and sometimes on credit.

Today, management is done on paper, in notebooks or in spreadsheets. This causes:
- No clear view of stock in real time
- Losses and theft that cannot be detected
- Customer debts that are forgotten or disputed
- No reliable reports on profit
- Owner must be physically present to know what happens in the depot

### 1.2 Objectives
1. Know at any moment **what is in stock**, in each depot, in the right units.
2. Record **every sale** quickly (cash, Flooz, Mixx by Yas, bank, credit).
3. Track **who owes money** and **to whom the business owes money**.
4. Give the owner **all reports**, anywhere, on his phone or computer.
5. Keep working **without internet** and **sync automatically** when the connection returns.
6. Be **so simple** that a new employee (or a child) can use it after 10 minutes.

### 1.3 Market reference
The app is inspired by tools already used by sellers in Togo and West Africa (JustOK, FiaVia, Avobi, XStoreApp, mPulse, ProCom, Lotus V5), but adapted specifically to building materials (multiple units, wholesale/retail prices, quotes, deliveries, credit).

---

## 2. Users and roles

| Role | Who | What they can do |
|---|---|---|
| **Owner (Patron)** | The client | Everything. Sees all reports, all depots, all money. Manages users, prices and settings. |
| **Manager (Gérant)** | Depot manager | Sales, purchases, stock receipts, deliveries, customer credit, depot reports. Cannot delete history or see owner-only reports (e.g. global profit) unless allowed. |
| **Cashier / Seller (Vendeur)** | Counter staff | Make sales, receive payments, view stock (no purchase prices). |
| **Storekeeper (Magasinier)** | Warehouse staff | Receive goods, record stock exits, do inventory counts. |
| **Delivery person (Livreur)** | Driver | See own delivery list on Android, mark delivered, take photo/signature. |

The owner can create custom roles by ticking permissions (see section 8).

---

## 3. Golden rule: simplicity ("a 9-year-old can use it")

This is a **mandatory requirement**, not a nice-to-have. Every screen will be tested against it.

### 3.1 Design rules
1. **Big buttons with icons and text.** Minimum touch target 56 × 56 dp on Android, large buttons on desktop.
2. **Home screen = 4 to 6 big tiles maximum**, for example:
   - 🛒 **Vendre** (Sell)
   - 📦 **Stock**
   - 🚚 **Recevoir marchandise** (Receive goods)
   - 👥 **Clients / Dettes**
   - 📊 **Rapports** (owner/manager only)
   - ⚙️ **Paramètres** (owner only)
3. **Product photos everywhere.** A seller can find "Ciment CIMTOGO" by its picture, not only by name.
4. **Minimal typing.** Use number pads, + / − buttons, lists to tap, and search with suggestions. No long forms.
5. **One action = one screen.** No screen with more than one main task.
6. **Maximum 3 taps** to complete a simple cash sale of one product.
7. **Clear colors with meaning:**
   - Green = OK / paid / in stock
   - Orange = warning / low stock / partially paid
   - Red = problem / out of stock / overdue debt
8. **Simple words.** "Vendre" not "Créer une transaction de vente". No technical words (no "sync", "database", "SKU" shown to users).
9. **Confirmation before anything important** ("Voulez-vous vraiment annuler cette vente ?") with big Oui / Non buttons.
10. **Undo** for the last action when possible.
11. **Numbers formatted for FCFA**: `125 000 FCFA` (space as thousands separator, no decimals).
12. **Always visible connection status** as a small friendly icon: ☁️✅ "Tout est enregistré" / ☁️⏳ "En attente d'internet — vos données sont sauvées sur l'appareil".
13. **Guided first use**: short animated tutorial (3–5 screens) and a "?" help button on each screen.
14. **Same layout on Android and desktop**, so someone who knows one knows the other.
15. **Large fonts option** and good contrast for outdoor/sunlight use.

### 3.2 Simplicity test (acceptance)
- A person who has never seen the app must, **without help**, after the tutorial:
  - make a cash sale of 10 bags of cement in **under 1 minute**;
  - find how many iron rods of 12 remain in stock in **under 20 seconds**;
  - record a credit sale for a named customer in **under 2 minutes**.
- Test with at least **5 people**, including a non-technical employee and a child around 9–12 years old. At least 4 of 5 must succeed.

---

## 4. Platforms and architecture (online / offline)

### 4.1 Platforms
| Platform | Minimum | Notes |
|---|---|---|
| **Android app** | Android 8.0+ (minSdk 26), 2 GB RAM, low-end phones and tablets | Signed release APK, **installed manually by the developer** on each device. Not published on Google Play. Updates delivered in-app (see 4.8). |
| **Windows desktop app** | Windows 10 / 11, 64-bit | Inno Setup installer (.exe), **installed manually by the developer**. Supports receipt printer, barcode scanner, A4 printer. Updates delivered in-app (see 4.8). |
| **Web dashboard (optional, phase 3)** | Any browser | For the owner to view reports from any computer |

### 4.2 Technical stack (fixed — use exactly this)

**Client apps (one Flutter codebase → Android + Windows)**
| Concern | Choice |
|---|---|
| Framework | Flutter (latest stable), Dart; build targets `android` and `windows` |
| State management | Riverpod |
| Local database | SQLite via **Drift**, encrypted with SQLCipher |
| Languages | `flutter_localizations` + ARB files: `fr` (default) and `en`. **No hard-coded user-facing strings.** Language switch in Settings, applied instantly. Numbers/dates formatted per locale; FCFA always without decimals. |
| PDF (receipts A4, invoices, quotes, reports) | `pdf` + `printing` packages |
| Thermal printing | ESC/POS (58/80 mm): Bluetooth on Android, USB/network on Windows |
| Barcode | Phone camera on Android (`mobile_scanner`); USB scanners on Windows act as keyboard input |
| Excel export | `excel` package |
| Sharing | `share_plus` (send PDFs to WhatsApp, email…) |
| HTTP | `dio` with gzip, retries and timeouts |
| Windows installer | Inno Setup |
| Android signing | One release keystore owned by the developer, **backed up in 2 safe places** (losing it makes updates impossible) |

**Backend**
| Concern | Choice |
|---|---|
| Runtime | Node.js 22 LTS, TypeScript (strict) |
| Framework | NestJS |
| Database | PostgreSQL 16 |
| ORM & migrations | Prisma (all schema changes through versioned migrations) |
| API | REST + JSON, versioned under `/api/v1` |
| Auth | JWT access token (short) + refresh token; each device registered and revocable |
| Validation | `class-validator` DTOs on every endpoint |
| Scheduled jobs | `@nestjs/schedule` (daily WhatsApp summary, monthly email report, cleanup) + `whatsapp_outbox` and `email_outbox` tables for retries — no Redis needed |
| WhatsApp | **Meta WhatsApp Cloud API called directly** (no reseller). Pre-approved **utility templates** in French and English (daily summary, low-stock alert, negative-stock alert). Delivery status received by webhook and logged. |
| Email | Nodemailer over SMTP through a **transactional email provider** (e.g. Brevo, Amazon SES or Resend) — never sent directly from the VPS, to avoid landing in spam. Sender on the business domain with SPF, DKIM and DMARC configured. |
| Excel / CSV generation | `exceljs` for .xlsx (formatted, one sheet per report); CSV in UTF-8 with BOM and `;` separator so it opens correctly in French Excel |
| Logging | Structured JSON logs (pino), rotated |
| Tests | Jest unit tests for business rules (units conversion, stock, totals, sync) + e2e tests for sync endpoints |

**Server / hosting**
| Concern | Choice |
|---|---|
| Server | One Linux VPS, Ubuntu 24.04 LTS, 2 vCPU / 4 GB RAM / 40 GB+ SSD (e.g. Hetzner), EU region |
| Deployment | Docker Compose: `api`, `postgres`, `caddy` |
| HTTPS | Caddy with automatic Let's Encrypt certificates, on a domain name (e.g. `api.<business>.com`) |
| Security | SSH key-only login, root login disabled, firewall open only on 80/443 (+ SSH), fail2ban, automatic security updates, PostgreSQL **not** exposed to the internet |
| Backups | Nightly `pg_dump`, compressed and encrypted, **copied off the server** (S3-compatible storage or Hetzner Storage Box). Keep 30 daily + 12 monthly. Weekly VPS snapshot. A documented restore procedure, tested before go-live. |
| Monitoring | Health endpoint `/api/v1/health` + uptime monitor that alerts the developer on WhatsApp/email |
| Update files | Served by the same server under `/updates/` (see 4.8) |

### 4.3 Offline-first principle
The app must work **100% offline** for all daily operations. Internet is only needed to share data between devices and to back up.

| Feature | Offline | Online |
|---|---|---|
| Sell, receive payments, print receipt | ✅ | ✅ |
| Receive goods, stock exits, inventory count | ✅ | ✅ |
| Customer credit and repayments | ✅ | ✅ |
| Quotes, invoices, delivery notes | ✅ | ✅ |
| Reports on data stored on the device | ✅ | ✅ |
| Reports combining all devices / depots | Last synced data | ✅ Live |
| WhatsApp reports and alerts (sent by the server) | Generated by server from synced data | ✅ |
| New user login on a new device | ❌ (first login needs internet) | ✅ |

### 4.4 Synchronization rules
1. Every operation is **saved locally first**, then sent to the server in the background.
2. Sync runs **automatically** when internet is available (Wi-Fi or mobile data), plus a manual "Envoyer maintenant" button.
3. Each record has a **unique ID generated on the device** (UUID) so no duplicates are created.
4. Stock is calculated from **movements** (entries and exits), never by overwriting a quantity. This means two devices selling offline at the same time never "erase" each other — movements are simply added together.
5. **Conflict rules:**
   - Sales, payments, stock movements: never conflict (append-only).
   - Product details / prices: the **most recent change wins**, and the change is logged.
   - Customer details: most recent change wins, logged.
6. If offline sales make stock go **negative** after sync, the app shows an alert to the manager/owner ("Stock négatif : Ciment CIMTOGO −5 sacs — vérifier").
7. Sync must work on **slow / unstable connections** (2G/3G): small data packets, resume after interruption.
8. A device can stay offline for **at least 30 days** without data loss.
9. Users see only a simple status (☁️✅ / ☁️⏳), never technical errors. Detailed sync logs are available to the owner in Settings.

### 4.5 Devices and depots
- Several devices can work in the **same depot** at the same time.
- The business can have **several depots / shops / warehouses**. Each device is linked to one depot by default (can be changed by owner).

### 4.6 Sync protocol (custom — must be implemented exactly)
There is no third-party sync engine. The backend and the apps implement this protocol:

**Common columns on every synced table**
`id` (UUID v7, generated on the device), `business_id`, `depot_id`, `created_at`, `updated_at`, `created_by` (user id), `device_id`, `deleted` (soft delete, boolean), `server_seq` (bigint, assigned by the server only), `server_received_at`.

**Two kinds of tables**
- **Append-only (events):** sales, sale_lines, sale_payments, stock_movements, customer_payments, supplier_payments, expenses, cash_sessions, inventory_lines, deliveries status events, audit_log. Rows are **never updated after creation**; a correction is a new row (e.g. a sale cancellation is a cancellation record + reversing stock movements). On push, the server inserts and **ignores duplicates by `id`** (idempotent).
- **Master data:** products, product_units, categories, customers, suppliers, users, depots, settings. On push, **last write wins by `updated_at`** (corrected with the device's clock offset); the overwritten values are written to `audit_log`.

**Push (device → server)**
1. Every local change is written in the same local transaction to a `sync_outbox` table.
2. `POST /api/v1/sync/push` sends batches of up to 500 outbox rows, gzipped.
3. The server processes the batch in one DB transaction and returns the list of accepted ids (and rejected ids with a reason code).
4. The device deletes accepted rows from the outbox. Rejected rows are kept, flagged, and visible to the owner in Settings → Synchronisation.
5. Pushing the same batch twice must have no effect (idempotency is mandatory).

**Pull (server → device)**
1. A PostgreSQL sequence + trigger sets `server_seq` on every insert/update.
2. `GET /api/v1/sync/pull?since=<cursor>&limit=1000` returns rows with `server_seq > cursor`, filtered to what the device may see (its business; its depot unless the user is owner/manager of several; no purchase prices for roles without permission).
3. The device applies rows in a transaction, saves the new cursor, and repeats until no more rows.
4. Pull always runs **after** push.

**Stock**
- Stock quantities are **never synced as numbers**. Stock = sum of `stock_movements` (in the product's base unit). A cached stock table is maintained locally and on the server and can always be rebuilt from movements.
- After each sync, the server checks for negative stock and creates an alert (in-app + WhatsApp to owner).

**Document numbering offline**
- Receipts, invoices, quotes and delivery notes are numbered `<DEPOT>-<DEVICE>-<YEAR>-<counter>` (e.g. `AGO-02-2026-000153`), the counter being per device. This guarantees unique numbers without internet.

**Clock**
- At each sync the server returns its time; the device stores the offset and uses it to correct `updated_at`. Both device time and `server_received_at` are kept for audits.

**When sync runs**
- App start, 5 seconds after any change (debounced), every 2 minutes while online, and on the manual "Envoyer maintenant" button. Exponential backoff on errors (max 5 minutes). Never blocks the user interface.

**Compatibility**
- Every request carries the app version. The server refuses sync from versions older than `min_supported_version` with a clear code, and the app then asks the user to update (see 4.8).

### 4.7 Device installation and pairing
Apps are installed by the developer, not downloaded from a store.
1. Developer installs the APK (Android) or runs the installer (Windows).
2. On first launch, the app shows a simple setup screen: language (Français / English) → server address (pre-filled in the build) → **pairing code**.
3. The owner generates a 6-digit pairing code in Settings → Appareils, choosing the depot. The code expires after 15 minutes.
4. The device is registered (name, depot), downloads its data (first sync, internet required), then shows the user login (photo + PIN).
5. The owner can rename, move or **revoke** any device from Settings → Appareils. A revoked device is logged out and stops syncing.

### 4.8 In-app updates (no app store)
- The server hosts `/updates/latest.json`:
  ```json
  {
    "version": "1.3.0",
    "min_supported_version": "1.2.0",
    "android": { "url": "https://…/app-1.3.0.apk", "sha256": "…" },
    "windows": { "url": "https://…/setup-1.3.0.exe", "sha256": "…" },
    "notes": { "fr": "…", "en": "…" }
  }
  ```
- When online, the app checks at start and once a day. If a newer version exists, it shows a friendly message ("Une nouvelle version est disponible") with **Mettre à jour** / **Plus tard**.
- The app downloads the file, **verifies the SHA-256**, then launches the installer (Android: system package installer, `REQUEST_INSTALL_PACKAGES` permission; Windows: runs the installer silently and restarts the app).
- If the installed version is below `min_supported_version`, the app keeps working offline but must update before syncing again; the message explains this simply.
- Local data is **always kept** across updates (Drift schema migrations).
- The developer publishes a new version by uploading the files and editing `latest.json` (documented script).

---

## 5. Functional modules

### 5.1 Products (Articles)
- Create / edit / archive products (no hard delete if history exists).
- Fields: name, photo, category, brand, supplier(s), barcode (optional), internal code (auto), description.
- **Categories (pre-filled, editable):** Ciment, Fer à béton, Tôles, Fil de fer, Bois, Agrégats (sable, gravier), Plomberie, Électricité, Peinture, Carrelage, Quincaillerie, Outillage, Divers.
- **Brands/variants:** e.g. Ciment CIMTOGO / CIMCO / Dangote / Diamant; Fer de 6 / 8 / 10 / 12 / 14 / 16; Tôle by thickness/color/length.
- **Multiple units with conversions** (essential for building materials):
  - Base unit (stock unit), e.g. *bag* for cement, *bar* for iron.
  - Sale/purchase units with conversion factor, e.g.:
    - Cement: 1 tonne = 20 bags (50 kg)
    - Iron rod 12: 1 tonne = X bars (configurable per diameter)
    - Wire: 1 roll = X kg
    - Sand / gravel: 1 truck (chargement) = X m³ / brouettes
  - Seller can sell in any allowed unit; stock is converted automatically.
- **Prices per unit:**
  - Purchase price (cost), visible only to authorized roles
  - Retail price
  - Wholesale price (with minimum quantity, e.g. from 5 tonnes)
  - Optional special price for specific customers (contractors)
- Minimum stock level (alert threshold) per product and per depot.
- Price history (who changed what, when).

### 5.2 Stock
- Real-time stock per product, per depot, shown in the base unit **and** in larger units (e.g. "250 sacs = 12,5 tonnes").
- Stock value (at cost price and at sale price).
- **Stock movements** (all logged with date, time, user, device, depot, reason):
  - Entry: purchase/reception, customer return, transfer in, adjustment +
  - Exit: sale, delivery, transfer out, loss/breakage, internal use, adjustment −
- **Transfers between depots** (send → in transit → received).
- **Inventory count (Inventaire):**
  - Full or partial (by category).
  - Counting screen with big + / − buttons, works offline.
  - App shows difference between counted and expected, owner validates adjustments.
- **Low stock alerts** (orange) and **out of stock** (red), on screen in the app and by WhatsApp to the owner (sent by the server after sync).
- Product history screen: every movement for one product (to detect losses/theft).

### 5.3 Sales (Vendre)
- **Quick sale flow** (target: 3 taps for simple cash sale):
  1. Tap product (photo grid or search)
  2. Choose quantity + unit with number pad
  3. Tap "Payer" → choose payment → done (receipt printed/shared)
- Cart with several products, edit quantities, remove items.
- Customer: anonymous (walk-in) or selected/created quickly (name + phone).
- Automatic choice of retail or wholesale price according to quantity / customer type; manual discount only if permitted (with max %).
- **Payment methods** (configurable list):
  - Espèces (cash) — with change calculation
  - **Flooz** (Moov Africa)
  - **Mixx by Yas** (ex T-Money)
  - Virement bancaire / chèque
  - **Crédit** (to pay later)
  - **Mixed payment** (e.g. part cash + part Flooz + rest on credit)
- For mobile money: field to enter the transaction ID/reference (phase 1); automatic payment confirmation via aggregator API (phase 3, optional).
- Receipt (ticket) on thermal printer 58/80 mm, A4 invoice, or PDF shared on WhatsApp.
- Cancel / return a sale: only with permission, reason required, stock automatically restored, logged.
- Sales held "on pause" (customer comes back later).

### 5.4 Quotes, invoices and delivery notes (Devis / Facture / Bon de livraison)
- Create a **quote (devis)** for a construction site, with validity date.
- Convert quote → sale/invoice in one tap.
- **Invoice** with business logo, address, NIF/RCCM, numbering per year.
- **Delivery note (bon de livraison)** for goods leaving the depot, with signature on delivery.
- Partial deliveries: customer pays for 100 bags, takes 40 now, 60 later → app tracks "remaining to deliver" (marchandise payée non livrée).
- Share as PDF via WhatsApp, email, or print.

### 5.5 Deliveries (Livraisons)
- Create delivery from a sale: address/site, contact phone, date, vehicle, driver.
- Delivery fee (free above a threshold, configurable — e.g. free in Lomé from 5 tonnes).
- Delivery status: À livrer → En route → Livré (or Problème).
- Driver Android view: today's deliveries, call customer button, open map, mark delivered with photo and/or signature — works offline.
- Report: deliveries per driver, per vehicle, delivery fees collected.

### 5.6 Customers and credit (Clients / Dettes)
- Customer file: name, phone, type (individual / contractor / company), address, notes.
- **Credit limit** per customer (optional) — warning when exceeded.
- **Debt tracking:** every credit sale, every repayment, current balance.
- Record repayment (cash, Flooz, Mixx, bank) — partial or full.
- Due date and **overdue debts** in red.
- Customer statement (relevé) as PDF to send on WhatsApp.
- Optional **reminder message** prepared by the app (in French or English) and opened in the phone's WhatsApp with one tap, ready to send to the customer.
- Customer deposits/advances (avances) used on future purchases.

### 5.7 Suppliers and purchases (Fournisseurs / Achats)
- Supplier file: name, phone, products supplied, notes.
- Purchase order (bon de commande) → reception (full or partial).
- Reception updates stock and cost price (weighted average cost).
- Additional costs on a purchase: transport, unloading, customs → spread on product cost (optional).
- **Supplier debts:** what the business owes, payments made, balance.
- Reorder suggestions based on minimum stock and recent sales.

### 5.8 Cash and expenses (Caisse / Dépenses)
- Opening and closing of the cash register per day/per cashier (fond de caisse).
- End-of-day closing: expected vs counted, separated by **cash / Flooz / Mixx / bank**; differences recorded.
- Expenses: transport, unloading (déchargement), fuel, rent, electricity, salaries, repairs, other — with photo of receipt.
- Cash withdrawals by owner (retraits) and deposits to bank.

### 5.9 Users and staff
- Create users with name, phone, role, depot, **PIN code**.
- Quick user switch on a shared device (tap your photo + PIN).
- Activity per user (sales, cancellations, discounts, cash differences).

### 5.10 Settings
- Business info: name, logo, address, phone, NIF, RCCM (printed on documents).
- Depots / shops.
- Payment methods list.
- Units and conversions.
- Receipt/invoice templates.
- Taxes (TVA 18% — enable/disable, prices TTC or HT).
- Language, font size, theme.
- Backup / export (Excel, PDF), restore.
- Alerts: which alerts, to which WhatsApp number(s), summary time, summary language (FR/EN).
- Monthly email report: recipient email addresses, format (Excel / CSV / both), day and time, per-depot or combined, language.
- Appareils (devices): pairing codes, rename, move, revoke.
- Synchronisation: status, last sync per device, rejected items.

---

## 6. Reports and dashboard

### 6.1 Owner dashboard (home of Rapports)
Simple cards with big numbers, for **Today / This week / This month / Custom period**, and filter by depot:
- 💰 Ventes (sales total) — split: Espèces / Flooz / Mixx / Banque / Crédit
- 📈 Bénéfice (gross profit) and margin %
- 📦 Valeur du stock
- ⚠️ Produits en rupture / stock faible (count, tap to see list)
- 👥 Total des dettes clients (and overdue)
- 🏭 Total dû aux fournisseurs
- 💸 Dépenses
- 🧾 Number of sales, average basket
- Small chart: sales of the last 7 / 30 days

### 6.2 Detailed reports
| # | Report | Content |
|---|---|---|
| R1 | **Daily sales journal** | All sales of the day, with time, seller, customer, payment method |
| R2 | **Sales by payment method** | Cash / Flooz / Mixx / bank / credit, per day and period |
| R3 | **Sales by product / category / brand** | Quantity (in chosen unit) and amount |
| R4 | **Best and worst sellers** | Top 10 / bottom 10 products |
| R5 | **Profit report** | Sales − cost of goods = gross profit; − expenses = net result |
| R6 | **Margin per product** | Cost price, sale price, margin %, total margin |
| R7 | **Current stock** | Per depot, in units and value |
| R8 | **Stock movements** | Every entry/exit, filter by product, user, type, date |
| R9 | **Inventory differences** | Counted vs expected, losses value |
| R10 | **Low stock / reorder list** | Products below minimum, suggested quantity |
| R11 | **Customer debts** | Who owes, how much, since when, overdue first |
| R12 | **Customer statement** | Full history for one customer |
| R13 | **Supplier debts and purchases** | What was bought, from whom, what is owed |
| R14 | **Expenses report** | By category and period |
| R15 | **Cash closing report** | Expected vs counted per cashier per day |
| R16 | **Sales by employee** | Amount sold, number of sales, discounts, cancellations |
| R17 | **Cancellations and discounts** | Who cancelled/discounted what, and why (fraud control) |
| R18 | **Deliveries report** | Per driver/vehicle, delivered, pending, fees |
| R19 | **Goods paid but not delivered** | Customer remaining quantities |
| R20 | **Comparison by depot** | Sales, profit, stock per depot |
| R21 | **Period comparison** | This month vs last month, this year vs last year |

### 6.3 Report features
- Filters: period, depot, product, category, customer, user, payment method.
- Export: **PDF** and **Excel**; share on WhatsApp/email; print.
- **Automatic daily summary to the owner** at a chosen time (e.g. 20:00), sent by the server via WhatsApp (approved utility template, in French or English). The summary covers data synced up to that time; devices still offline are listed ("2 appareils pas encore synchronisés").
  > *Résumé du 04/10 — Dépôt Agoè : Ventes 1 250 000 FCFA (Espèces 700 000 · Flooz 200 000 · Mixx 250 000 · Crédit 100 000). Bénéfice 185 000 FCFA. 3 produits en stock faible.*
- **Automatic monthly report by email** to the owner (and other addresses he chooses):
  - Sent automatically on the **1st of each month at 07:00** (Africa/Lomé) for the previous month; time and day configurable.
  - Format chosen in Settings: **Excel (.xlsx)** (default), **CSV**, or both. Language FR or EN.
  - **Excel file**, one sheet per report: Résumé (key figures like the dashboard), Ventes par jour, Ventes par mode de paiement, Ventes par produit, Bénéfice, Stock en fin de mois (quantities and value), Mouvements de stock, Dettes clients, Dettes fournisseurs, Dépenses, Ventes par employé, Annulations et remises. Headers in bold, frozen first row, FCFA number format, totals row.
  - **CSV option**: one CSV file per report, sent as a single .zip attachment.
  - Email body: short summary in plain words (total sales, profit, stock value, debts) + the attachment. One email per depot or one combined email (setting).
  - If the file is larger than the provider's attachment limit, the email contains a secure download link (expires after 7 days) instead.
  - Covers data synced up to the sending time; the email warns if some devices had not synced.
  - The owner can also tap **"Envoyer le rapport par email"** in Rapports to receive any period on demand.
  - Every sent email logged in `email_outbox` (status, attempts); failed sends retried and shown in Settings.
- Reports available offline on data already synced to the device.

---

## 7. Non-functional requirements

| Area | Requirement |
|---|---|
| **Performance** | App opens in < 3 s on a low-end Android phone. Product search results in < 0.5 s for 5,000 products. Sale saved in < 1 s offline. |
| **Capacity** | At least 10,000 products, 1,000,000 movements, 20 devices, 10 depots without slowdown. |
| **Offline** | All daily operations offline; ≥ 30 days offline without data loss. |
| **Low bandwidth** | Sync works on 2G/3G; data compressed; resume after interruption. |
| **Battery / storage** | Light app (< 50 MB install target on Android); efficient background sync. |
| **Reliability** | No data loss if app crashes, phone shuts down or power cut on desktop (transactions committed immediately). |
| **Availability (server)** | 99.5% monthly uptime target. |
| **Backups** | Server: automatic daily backups kept 30 days. Local: export on demand + automatic local backup on desktop. |
| **Hardware (desktop)** | Thermal receipt printer (USB/Bluetooth, ESC/POS, 58 & 80 mm), A4 printer, USB barcode scanner, cash drawer (optional). |
| **Hardware (Android)** | Bluetooth thermal printer, camera as barcode scanner. |
| **Languages** | French and English; texts externalized so other languages (e.g. Ewe audio help) can be added later. |
| **Accessibility** | Large font option, high contrast, icons with text labels. |
| **Updates** | In-app updater (section 4.8), no app store; data kept after update. |
| **Time zone** | Africa/Lomé (UTC+0). |

---

## 8. Security and permissions

- Login with **photo/name + PIN** on a paired device; owner account with password + one-time code sent by **WhatsApp** for sensitive actions (new device pairing, user management, deleting data).
- Only paired devices can talk to the API (device token + user token).
- Auto-lock after inactivity (configurable, e.g. 5 minutes).
- **Permissions per role**, configurable by the owner, including:
  - See purchase prices / profit
  - Give discounts (and max %)
  - Cancel a sale / make a return
  - Sell on credit / above credit limit
  - Change prices
  - Adjust stock / validate inventory
  - See reports (which ones)
  - Manage users and settings
- **Audit log** (journal) that cannot be deleted: every sensitive action with user, date, time, device, old value → new value.
- Data encrypted in transit (HTTPS/TLS) and local database encrypted on the device.
- If a phone is lost/stolen: owner can **disable the device** remotely; data is safe on the server.
- Each business's data is isolated (if the platform later serves several clients).
- Compliance with Togolese personal data law (Loi n°2019-014 relative à la protection des données à caractère personnel).

---

## 9. Data model (main entities)

```
Business ─┬─ Depot ─┬─ Device
          │         └─ CashSession
          ├─ User (role, depot, PIN)
          ├─ Category
          ├─ Product ─┬─ ProductUnit (unit, factor, retail price, wholesale price, min qty)
          │           ├─ ProductStockLevel (depot, min level)
          │           └─ PriceHistory
          ├─ StockMovement (product, depot, qty in base unit, type, reason, ref doc, user, device, uuid, datetime)
          ├─ Customer ─┬─ CustomerPayment
          │            └─ CustomerBalance (calculated)
          ├─ Supplier ─┬─ PurchaseOrder ─ Reception
          │            └─ SupplierPayment
          ├─ Sale ─┬─ SaleLine (product, unit, qty, unit price, discount)
          │        ├─ SalePayment (method: cash/flooz/mixx/bank/credit, amount, reference)
          │        └─ Delivery ─ DeliveryLine
          ├─ Quote ─ QuoteLine
          ├─ Transfer ─ TransferLine
          ├─ InventoryCount ─ InventoryLine
          ├─ Expense
          ├─ AuditLog
          ├─ PairingCode (server)
          ├─ WhatsAppOutbox (server: template, recipient, payload, status, attempts)
          ├─ EmailOutbox (server: recipients, subject, attachment path, period, status, attempts)
          ├─ Alert (low stock, negative stock, sync problem)
          └─ SyncOutbox + SyncState (cursor, clock offset) (device only)
```

Rules:
- Stock = sum of `StockMovement` (never stored as a single editable number; a cached value may be kept for speed).
- All amounts stored as **integers in FCFA**.
- All synced records carry the common columns of section 4.6 (`id` UUID v7, `business_id`, `depot_id`, `created_at`, `updated_at`, `created_by`, `device_id`, `deleted`, `server_seq`, `server_received_at`).

---

## 10. Delivery phases

### Phase 1 — MVP (core, offline-first)
- Products with photos, categories, **multiple units**, retail/wholesale prices
- Stock: entries, exits, real-time stock, low-stock alerts, movement history
- Sales: quick sale, cart, **cash / Flooz / Mixx / bank / credit / mixed**, receipts (print + PDF/WhatsApp)
- Customers and **credit/debt tracking**, repayments
- Users, roles, PIN
- Owner dashboard + reports R1, R2, R3, R5, R7, R8, R10, R11
- **Offline mode + automatic sync**
- Android app + Windows desktop app
- Daily cash closing

### Phase 2 — Building materials business
- Quotes, invoices, delivery notes, partial deliveries
- Deliveries module with driver view
- Suppliers, purchase orders, receptions, supplier debts
- Expenses
- Inventory counts
- Multi-depot + transfers
- All remaining reports (R4, R6, R9, R12–R21)
- Automatic daily WhatsApp summary
- Automatic monthly Excel/CSV report by email

### Phase 3 — Extras
- Web dashboard for owner
- Automatic mobile money payment confirmation (Flooz / Mixx API via aggregator)
- Barcode label printing
- Sales forecasts and reorder suggestions
- Ewe/Mina voice help
- Online catalogue / WhatsApp catalogue link

---

## 11. Acceptance criteria

The app is accepted when:
1. All Phase features work on **Android (low-end phone)** and **Windows desktop**.
2. **Offline test:** two devices sell the same product offline for one full day, then reconnect → no data lost, no duplicates, stock is correct, negative-stock alert shown if needed.
3. **Interrupted connection test:** cutting internet during sync does not lose or duplicate any record.
4. **Unit test (business):** selling 1 tonne of cement reduces stock by 20 bags; selling 1 tonne of iron 12 reduces the correct number of bars.
5. **Money test:** end-of-day report totals (cash / Flooz / Mixx / bank / credit) match the sum of individual sales exactly.
6. **Simplicity test** of section 3.2 passed.
7. **Performance targets** of section 7 met on a reference low-end phone.
8. **Permissions test:** a seller cannot see purchase prices, profit, or cancel a sale without permission.
9. Reports export correctly to PDF and Excel and open on phone and PC; the monthly email arrives in the inbox (not spam) with a correct Excel/CSV file whose totals match the app.
10. Client has used the app in real conditions for **2 weeks** (pilot) with no blocking bug.

---

## 12. Deliverables

- Android release APK (signed) + safely stored keystore
- Windows installer (Inno Setup)
- In-app update system + script to publish new versions
- Node.js/PostgreSQL backend deployed on the VPS with Docker Compose, HTTPS, firewall, monitoring
- Automated off-server backups + **written and tested restore procedure**
- WhatsApp Cloud API configured (business number, approved FR/EN templates)
- Transactional email provider configured (domain verified, SPF/DKIM/DMARC), monthly report tested
- Server operations guide (deploy, update, backup, restore, rotate secrets)
- Source code and technical documentation
- Simple **user guide in French** (with screenshots), and short video tutorials (1–2 min each)
- Training session for owner and staff (on site in Togo or remote)
- Data import of existing products, customers and debts (from Excel/notebook)
- Warranty / bug-fix period: **3 months** after acceptance (to be agreed)
- Maintenance and hosting contract proposal (to be agreed)

---

## 13. Questions to confirm with the client

1. How many **depots / shops / warehouses** today? Planned in the next 2 years?
2. How many **staff** will use the app, and in which roles?
3. How many **products** approximately? Does he have photos/barcodes?
4. Which **units** does he use per product (bag, tonne, bar, roll, truck, m³, brouette…) and exact conversions?
5. Does he sell at **different prices** (retail, wholesale, contractor)? From which quantities?
6. Does he sell **on credit**? To whom? Does he want credit limits?
7. Does he **deliver**? Own trucks or hired? How is the delivery fee calculated?
8. Does he give **quotes** to contractors?
9. Which **payment methods** does he accept (Flooz, Mixx, bank, cheque)? Does he have merchant numbers?
10. Does he need **TVA** on invoices? Does he have NIF/RCCM to print?
11. Which **reports** matter most to him? At what time does he want the daily summary?
12. Which **devices** does he already have (phones, PC, printers)?
13. How is **internet** at the depot (none / mobile data / Wi-Fi)? Frequent power cuts?
14. Who will **pay for the VPS, domain and WhatsApp messages** after delivery? Which phone number will be the business WhatsApp sender (it cannot stay on the normal WhatsApp app)? Which **email address(es)** should receive the monthly report, and Excel or CSV?
15. Any existing **data** (Excel, notebooks) to import?
16. **Budget** and **target launch date**?

---

*End of document.*