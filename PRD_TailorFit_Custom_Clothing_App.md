# TailorFit — Product Requirements Document (PRD)

## 1. Product Name & Overview
**TailorFit — Custom Clothing Ordering App**
A mobile-first clothing shopping app that allows women and girls to order custom-made clothing from a designer without needing to visit the designer physically.

* **MVP:** Single designer execution
* **Future:** Multi-designer marketplace expansion

---

## 2. Problem Statement
Ordering custom-made clothing traditionally requires physical visits, design discussions, manual measurement, fabric selection, price negotiation, and frequent manual follow-ups.

This process introduces friction regarding:
* Choosing designs & selecting fabrics
* Providing accurate measurements
* Price transparency & locked estimation
* Clear delivery timelines & order status tracking
* Direct communication channels

TailorFit digitizes this workflow end-to-end: customize clothing, submit measurements, receive automated pricing, process payment, and track fulfillment online.

---

## 3. Target Users

### Primary Users: Customers
Women and young girls ordering custom-made clothing.
* Browse predefined clothing designs
* Order for self or third parties
* Submit measurements in centimeters (cm)
* Customize colors, fabrics, and style details
* Upload custom reference images and instructions
* Complete online payments via Stripe
* Track order production and delivery status
* Request post-submission order modifications

### Secondary User: Designer
Admin managing fulfillment and catalog operations.
* Manage clothing designs, categories, and fabric options
* Configure automated pricing rules
* Review and process incoming paid orders
* Access customer measurement profiles
* Update production and delivery statuses
* Oversee fulfillment logistics

---

## 4. Core Features

### A. Customer Authentication
* Sign up / Log in via Email & Password
* Customer Profile & Saved Delivery Information
* Row Level Security (RLS) enforcement

### B. Clothing Catalog
Predefined designs grouped by categories (*Dresses, Suits, Skirts, Tops, Trousers, Other*). Each entry includes:
* Image gallery, Name, and Description
* Available customization rules (colors, fabrics, style options)
* Base pricing rules & Estimated production lead time

### C. Custom Design Upload
* Upload custom clothing reference images
* Include additional design specifications/notes
* Integrated designer review flow attached to the order

### D. Clothing Customization
* In-app selection of designer-provided fabrics, textures, colors, and design variants
* Customization constraints enforced based on designer availability

### E. Measurements & Profiles
* Measurement entry strictly in centimeters (**cm**)
* Guided measurement hints for accuracy (Bust, Waist, Hips, Shoulder, Sleeve length, Dress length, Trouser length)
* **Measurement Profiles:** Save multiple profiles (e.g., *Self, Daughter, Mother*) for rapid re-ordering

### F. Automatic Pricing Engine
* Dynamic price calculation:
  $$\text{Final Price} = \text{Base Price} + \text{Fabric Cost} + \text{Customization Cost} + \text{Delivery Fee}$$
* Admin-configurable pricing rules
* **Price Lock Rule:** Once paid, the original order price is locked. 
* **Modification Adjustments:** Subsequent order modifications recalculate totals, showing a clear delta (additional charge or refund/credit) requiring customer confirmation before applying.

### G. Order Placement
Pre-payment summary detailing selected design, reference upload, color, fabric, customization options, targeted measurement profile, delivery address, timeline, and calculated total.

### H. Stripe Payments
* Upfront payment processing via Stripe Checkout / Payment Intents
* Webhook synchronization recording Payment Status, Transaction ID, Amount, and Timestamp
* Strict rule: Orders enter production **only** upon confirmed payment.

### I. Order Tracking
Real-time milestone progression:
1. `Order Placed`
2. `Payment Confirmed`
3. `Order Processing`
4. `In Production`
5. `Ready for Delivery`
6. `Out for Delivery`
7. `Delivered`

### J. Order Modification
* Post-submission change requests (color, measurements, design adjustments)
* Automated price delta recalculation
* Mandatory customer re-confirmation step

### K. Telegram Integration
* Third-party conversation layer for customer ↔ designer direct queries
* Single source of truth rule: Formal order state and financial parameters strictly remain within the application.

### L. Delivery Management
* Capture receiver details (Name, Phone Number, Delivery Address, Specific Instructions)
* Designer status transitions (`Out for Delivery` → `Delivered`)

---

## 5. User Stories

### Customer
* **Browsing:** As a customer, I want to browse clothing designs so that I can find an outfit I like.
* **Customization:** As a customer, I want to customize a design so that I can get an outfit matching my preferences.
* **Reference Upload:** As a customer, I want to upload custom reference images so the designer can tailor custom designs.
* **Fabric & Color:** As a customer, I want to select fabrics and colors offered by the designer to personalize my order.
* **Measurements:** As a customer, I want to enter measurements in centimeters so my clothing fits correctly.
* **Profiles:** As a customer, I want to save multiple measurement profiles to order for myself or others easily.
* **Transparent Pricing:** As a customer, I want to review an itemized price prior to checkout.
* **Online Payment:** As a customer, I want to pay online securely to initiate production.
* **Tracking:** As a customer, I want real-time order tracking to follow production progress.
* **Modifications:** As a customer, I want to request order changes with price adjustment visibility.
* **Communication:** As a customer, I want to chat via Telegram for quick operational updates.
* **Delivery:** As a customer, I want direct-to-door delivery without physical store visits.

### Designer
* **Catalog Management:** As a designer, I want to manage designs, fabrics, and options available to customers.
* **Pricing Control:** As a designer, I want to configure pricing rules to automate calculations.
* **Order Processing:** As a designer, I want to receive paid orders with complete measurement specifications to start production.
* **Status Updates:** As a designer, I want to update order and delivery milestones to keep customers informed.

---

## 6. Out of Scope (MVP)
* Multi-designer marketplace (Architecture must maintain `designer_id` entity abstractions for future compatibility)
* AI body measurement or phone camera measurement
* Virtual try-on / AR
* Social features, reviews, or loyalty programs
* International shipping & multi-currency support
* Advanced inventory, automated fabric purchasing, or native in-app chat

---

## 7. Technical Architecture & Stack

| Layer | Technology | Responsibilities |
| :--- | :--- | :--- |
| **Mobile App** | React Native (Expo), TypeScript, React Navigation, NativeWind | Customer interface, catalog browsing, measurement profiles, order submission, tracking |
| **Admin Dashboard** | Next.js, TypeScript, Tailwind CSS | Designer catalog management, pricing rules, order management, status updates |
| **Backend / DB** | Supabase (PostgreSQL), Storage, RLS | Data persistence, authentication, file storage for reference uploads, security rules |
| **Payments** | Stripe | Payment Intents, Checkout, Webhooks |
| **Communication** | Telegram | External chat integration |
| **Deployment** | Expo / EAS (Mobile), Vercel (Web), Supabase (Backend) | Infrastructure hosting and CI/CD |

---

## 8. Success Metrics

### Key Performance Indicators (KPIs)

| Metric | MVP Target |
| :--- | :--- |
| **Completed Orders** | 50+ in first 3 months |
| **Customization → Order Conversion** | ≥ 60% |
| **Repeat Customers** | ≥ 25% |
| **On-Time Order Deliveries** | ≥ 90% |
| **Successful Payment Rate** | ≥ 95% |
| **Order Cancellation Rate** | < 10% |

---

## 9. Definition of Done (DoD)
- [x] Functional authentication and user profile management
- [x] Catalog display filtered by categories with customization/fabric options
- [x] Design reference upload functionality
- [x] Measurement input (cm) with saved profile capability
- [x] Automated dynamic pricing calculation
- [x] Stripe payment integration & webhook-driven order confirmation
- [x] Admin dashboard for catalog, pricing, and order status updates
- [x] Order modification, price adjustments, and customer confirmation flow
- [x] Direct Telegram messaging link integrated
- [x] Complete end-to-end flow: **Select → Customize → Measure → Pay → Produce → Deliver**
