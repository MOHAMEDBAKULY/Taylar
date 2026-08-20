# TailorFit MVP — Final Technical Specification

**Version:** 1.1 — Final  
**Status:** Ready for Architecture & Implementation  
**Platform:** Responsive Web Application  
**Currency:** KES  
**MVP:** One designer  
**Future:** Multi-designer marketplace  

*No further product questions are required. The decisions below are considered final for the MVP.*

---

## 1. Product Architecture

TailorFit is a responsive web application with two primary experiences:
- **Customer storefront**
- **Designer dashboard**

The system is built as a single-designer MVP but is multi-designer ready.

```
                         ┌──────────────────────┐
                         │     Customer Web     │
                         │   Responsive App     │
                         └──────────┬───────────┘
                                    │
                                    ▼
                         ┌──────────────────────┐
                         │      Application     │
                         │       Backend        │
                         └──────────┬───────────┘
                                    │
          ┌─────────────────────────┼─────────────────────────┐
          │                         │                         │
          ▼                         ▼                         ▼
   ┌─────────────┐          ┌─────────────┐          ┌─────────────┐
   │  Supabase   │          │   Stripe    │          │   Resend    │
   │ Auth + DB   │          │  Payments   │          │   Emails    │
   │ + Storage   │          └─────────────┘          └─────────────┘
   └─────────────┘
          │
          ▼
   ┌─────────────┐
   │  Telegram   │
   │ Communication│
   └─────────────┘

                         ┌──────────────────────┐
                         │  Designer Dashboard  │
                         │       Web App        │
                         └──────────────────────┘
```

---

## 2. Final Technology Stack

### Frontend
- **Framework:** React, Next.js (TypeScript)
- **Styling:** Tailwind CSS
- **Design:** Responsive web design

### Backend
- **BaaS / Database:** Supabase (PostgreSQL, Supabase Auth, Supabase Storage, Row Level Security)

### Authentication
- Google OAuth through Supabase Auth

### Payments
- Stripe (Stripe Checkout, Stripe Webhooks, Stripe Refunds)

### Email
- Resend

### Communication
- Telegram

### Deployment
- **Frontend / Application:** Vercel
- **Backend Infrastructure:** Supabase

### Currency
- KES (Kenyan Shilling)

---

## 3. Application Requirements

### 3.1 Guest Browsing
Customers can use the storefront without authentication.

**Guests can:**
- Browse designers
- Browse categories
- Browse clothing
- View product details
- View fabrics
- View colors
- View customization options
- View prices
- View reviews
- View designer profiles

**Authentication is required when the user attempts to:**
- Save measurements
- Create an order
- Make a payment
- Track an order
- Leave a review

---

## 4. Customer Features

### 4.1 Homepage
The homepage includes:
- Featured designs
- Categories
- Designer discovery
- Search
- Featured reviews
- Call-to-action to start shopping

---

## 5. Designer Selection

The customer can select a designer. Even though the MVP has one designer:

```
Customer ──> Choose Designer ──> Browse Designer's Store ──> Select Clothing
```

Every designer has independent:
- Designs
- Fabrics
- Colors
- Customizations
- Pricing
- Measurement requirements
- Delivery rules
- Telegram contact
- Reviews

---

## 6. Clothing Catalog

Clothing is organized into categories (e.g., *Dresses, Suits, Skirts, Tops, Trousers, Other women's clothing*).

A designer can create multiple designs within each category. Multiple designers can eventually sell the same design. Therefore:

$$	ext{Designer} + 	ext{Design}$$

defines ownership rather than *Design only*.

---

## 7. Clothing Customization

Each design can provide predefined customization options.

**Examples:**
- **Sleeves:** Sleeveless, Short sleeve, Long sleeve
- **Neck:** Round, V-neck, Square, High neck
- **Length:** Short, Medium, Long, Other
- **Other:** Pockets, Buttons, Embroidery, Fitting style

*Each customization option can have a price modifier.*

---

## 8. Measurements

Measurements are recorded exclusively in **cm**.

The designer configures which measurements are required for each clothing category. The platform provides sensible defaults.

### Examples
- **Dress:** Bust, Waist, Hips, Shoulder, Neck, Arm circumference, Sleeve length, Dress length
- **Suit Jacket:** Bust, Waist, Shoulder, Neck, Arm circumference, Sleeve length, Jacket length
- **Skirt:** Waist, Hips, Skirt length
- **Trousers:** Waist, Hips, Thigh, Knee, Inseam, Outseam

The designer can modify these requirements.

---

## 9. Measurement Validation

Each measurement has:
- Name
- Unit
- Minimum
- Maximum
- Required (Yes/No)
- Instructions

**Example (Bust):**
- **Unit:** cm
- **Minimum:** 50
- **Maximum:** 200
- **Required:** Yes

**The system rejects:**
- Negative values
- Non-numeric values
- Values below minimum
- Values above maximum
- Missing required measurements

---

## 10. Measurement Profiles

Customers can store multiple profiles (e.g., *My Measurements, Daughter, Mother, Sister*).

**Each profile contains:**
- Person name
- Relationship
- Measurements
- Last updated date

The customer selects a measurement profile when ordering.

---

## 11. Measurement Snapshot

When an order is created, measurements are copied into the order.

```
Saved Measurements ──> Order Snapshot
```

*Changes to saved measurements must never modify historical orders.*

---

## 12. Custom Design Orders

Customers can upload one reference image and provide a description.

> **Example Description:** "Make the sleeves longer and use a loose fit."

Custom designs use designer-defined categories:
- **Simple**
- **Moderate**
- **Complex**

Each category has a configured price. Customers can pay immediately — **no designer approval is required before payment**.

---

## 13. Pricing Engine

All prices are in **KES**.

### Standard Design
$$	ext{Fabric} + 	ext{Customization} + 	ext{Delivery} = 	ext{Total}$$

### Custom Design
$$	ext{Custom Design Category} + 	ext{Fabric} + 	ext{Customization} + 	ext{Delivery} = 	ext{Total}$$

The backend is responsible for calculating the authoritative price. The frontend cannot determine or override the final payable amount.

---

## 14. Delivery Pricing

Delivery is city-based.

**MVP cities:**
- Mombasa
- Nairobi
- Nakuru

The customer selects one city. The standard delivery price is **KES 400** (e.g., Mombasa → KES 400, Nairobi → KES 400, Nakuru → KES 400).

The system stores delivery rules per designer because future designers may have different pricing.

---

## 15. Multiple Clothing Items Per Checkout

The MVP supports a cart containing multiple clothing items.

```
Cart
├── Evening Dress
├── Skirt
└── Women's Suit
```

Each item can have a different design, fabric, color, customization, measurements, and recipient. The customer can check out all items together.

---

## 16. Important Cart Rule

Each cart item must contain its own customization and measurement information:

```
Cart
│
├── Dress
│   ├── Fabric
│   ├── Color
│   ├── Customization
│   └── Daughter's Measurements
│
└── Suit
    ├── Fabric
    ├── Color
    ├── Customization
    └── My Measurements
```

*This prevents measurements from accidentally being shared across unrelated clothing items.*

---

## 17. Order Structure

One checkout creates one order containing multiple order items.

```
Order
├── Order Item 1
├── Order Item 2
├── Order Item 3
├── Delivery
├── Payment
└── Order Status
```

All items in a checkout must belong to the same designer. This is recommended for the MVP because each designer controls their own pricing, production, delivery, and fulfillment.

---

## 18. Stripe Payments

Customers pay 100% upfront. The designer absorbs Stripe transaction fees.

```
Customer Pays KES X ──> Stripe Deducts Fee ──> Designer Receives Remaining Amount
```

The customer-facing price does not include the Stripe fee.

---

## 19. Stripe Payment Flow

```
Cart
 ↓
Backend calculates price
 ↓
Order created as PENDING_PAYMENT
 ↓
Stripe Checkout Session
 ↓
Customer pays
 ↓
Stripe webhook
 ↓
Verify webhook
 ↓
Payment = PAID
 ↓
Order = PAID
```

*The redirect back from Stripe is not sufficient to mark an order paid. The verified Stripe webhook is authoritative.*

---

## 20. Cancellation

Customers can cancel an order before production starts. Cancellation results in a **Full Refund**.

| Order Status | Cancellation Allowed |
| :--- | :--- |
| `PENDING_PAYMENT` | Yes |
| `PAID` | Yes |
| `PROCESSING` | Yes |
| `IN_PRODUCTION` | No |
| `READY_FOR_DELIVERY` | No |
| `OUT_FOR_DELIVERY` | No |
| `DELIVERED` | No |

---

## 21. Designer Cancellation

If the designer cannot fulfill an order:

```
Designer cannot fulfill ──> Order cancelled ──> Full customer refund
```

The cancellation reason should be stored.

---

## 22. Order Modification

Customers have a **24-hour modification window**.

```
Order Created ──> 24-hour Modification Window ──> Modification Locked
```

Modification is also automatically disabled once production begins.

---

## 23. Modification With Price Increase

**Example:**
- Original Order = KES 5,000
- Modified Order = KES 5,800
- **Difference = KES 800**

Customer must pay KES 800 before the modification is applied:

```
Request Modification ──> Recalculate ──> KES 800 Difference ──> Customer Pays ──> Modification Applied
```

---

## 24. Modification With Price Decrease

**Example:**
- Original = KES 5,000
- Modified = KES 4,500
- **Difference = KES 500**

The customer receives **KES 500 Store Credit**. The difference is not immediately refunded.

---

## 25. Store Credit

Store credit should be associated with the customer account:

```
Customer
 └── Store Credit (KES 500)
```

Store credit can be applied to future orders. The system maintains a credit transaction history:
- `+ KES 500` (Modification Credit)
- `- KES 300` (Used on Order #123)

---

## 26. Order Status Flow

```
PENDING_PAYMENT ──> PAID ──> PROCESSING ──> IN_PRODUCTION ──> READY_FOR_DELIVERY ──> OUT_FOR_DELIVERY ──> DELIVERED
```

**Cancellation Transitions:**
- `PENDING_PAYMENT` ──> `CANCELLED`
- `PAID` ──> `CANCELLED`
- `PROCESSING` ──> `CANCELLED`

*Production prevents customer cancellation.*

---

## 27. Designer Dashboard

### Overview
- Orders, Revenue, Pending orders, Production orders, Delivery orders, Completed orders, Reviews

### Product Management
- Create, edit, archive designs
- Upload images
- Assign categories
- Configure fabrics, colors, customizations

---

## 28. Pricing Management

Designer controls:
- Fabric pricing
- Customization pricing
- Custom design categories (`Simple`, `Moderate`, `Complex` - each with its own price)
- Delivery rules
- Production time

---

## 29. Measurement Management

Designer can configure:
- Measurement types
- Required measurements
- Minimum / Maximum values
- Instructions
- Clothing-category associations

---

## 30. Delivery Management

Designer manages delivery availability.
- **MVP Cities:** Mombasa, Nairobi, Nakuru
- **Default Price:** KES 400

---

## 31. Order Management

Designer can:
- View orders, order items, measurements, reference images, customer details, payment status, modification history
- Accept/process orders
- Update production status
- Mark orders ready, out for delivery, delivered
- Cancel orders when unable to fulfill

---

## 32. Telegram Integration

The designer's Telegram username is stored. The customer sees a **"Chat with Designer"** button, which opens the designer's Telegram profile. The MVP does not implement messaging inside TailorFit.

---

## 33. Reviews

Customers can submit reviews after delivery.

**Review Structure:**
- **Rating:** 1–5 stars
- **Comment:** Optional

**Rules:**
- Only delivered orders can be reviewed
- One review per order
- Reviews cannot be edited after submission
- Designer can respond to reviews
- Customers cannot respond to designer responses in MVP

---

## 34. Email Notifications

**Provider:** Resend

Notifications sent for:
- Payment confirmation
- Order confirmation
- Order processing
- Production started
- Ready for delivery / Out for delivery / Delivered
- Cancellation / Refund
- Modification confirmation
- Store-credit notification

---

## 35. Database Entities

1. `users`
2. `designers`
3. `customer_profiles`
4. `categories`
5. `designs`
6. `design_images`
7. `fabrics`
8. `colors`
9. `customization_options`
10. `measurement_types`
11. `category_measurements`
12. `measurement_profiles`
13. `measurement_values`
14. `custom_design_categories`
15. `carts`
16. `cart_items`
17. `orders`
18. `order_items`
19. `order_measurements`
20. `order_customizations`
21. `order_reference_images`
22. `pricing_rules`
23. `delivery_rules`
24. `payments`
25. `refunds`
26. `store_credits`
27. `store_credit_transactions`
28. `order_status_history`
29. `order_modifications`
30. `reviews`
31. `review_responses`
32. `notification_events`

---

## 36. Important Relationships

```
USER
│
├── CUSTOMER PROFILE
│      │
│      ├── Measurement Profiles
│      ├── Cart
│      ├── Orders
│      ├── Reviews
│      └── Store Credit
│
└── DESIGNER
       │
       ├── Designs
       ├── Fabrics
       ├── Colors
       ├── Customizations
       ├── Measurements
       ├── Pricing Rules
       ├── Delivery Rules
       ├── Orders
       └── Reviews
```

---

## 37. Cart Requirements

The cart must:
- Support multiple items
- Preserve item-specific customization, measurements, reference images
- Calculate subtotal, delivery, and total
- Prevent mixing designers in one checkout

> **Validation Error:** *"Your cart contains items from another designer. Please checkout first or start a new cart."*

---

## 38. Database Requirements

**Engine:** PostgreSQL through Supabase.

### Required Characteristics
- UUID primary keys
- Foreign keys & Unique constraints
- Check constraints
- Timestamps & Indexes
- Transactions for critical operations
- Soft deletion / Archive states
- Audit / History tables

### Important Indexes
- `designs.designer_id`, `designs.category_id`
- `orders.customer_id`, `orders.designer_id`, `orders.status`, `orders.created_at`
- `cart_items.cart_id`
- `measurement_profiles.customer_id`
- `payments.order_id`, `payments.stripe_payment_id`
- `reviews.order_id`, `reviews.designer_id`
- `store_credit_transactions.customer_id`

---

## 39. Authentication & Roles

- **Authentication:** Supabase Auth + Google OAuth
- **Guest:** Browsing only
- **Authenticated Customer:** Can order, pay, save measurements, track orders, manage store credit, review orders
- **Designer:** Can manage their store and fulfill orders
- **Admin:** Reserved for platform-level management

---

## 40. API Requirements

### Public
- `GET /designers`
- `GET /designers/:id`
- `GET /designers/:id/designs`
- `GET /categories`
- `GET /designs/:id`
- `GET /designers/:id/fabrics`
- `GET /designers/:id/customizations`
- `GET /designers/:id/delivery-rules`
- `GET /designers/:id/reviews`

### Customer
- `GET /me`
- `GET /measurement-profiles`
- `POST /measurement-profiles`
- `PATCH /measurement-profiles/:id`
- `DELETE /measurement-profiles/:id`
- `GET /cart`
- `POST /cart/items`
- `PATCH /cart/items/:id`
- `DELETE /cart/items/:id`
- `POST /pricing/calculate`
- `POST /orders`
- `GET /orders`
- `GET /orders/:id`
- `POST /orders/:id/modify`
- `POST /orders/:id/cancel`
- `GET /store-credit`
- `GET /store-credit/transactions`
- `POST /orders/:id/review`

### Payments
- `POST /payments/create-checkout`
- `POST /webhooks/stripe`

### Designer
- `GET /designer/orders`
- `GET /designer/orders/:id`
- `POST /designer/designs`
- `PATCH /designer/designs/:id`
- `DELETE /designer/designs/:id`
- `POST /designer/fabrics`
- `PATCH /designer/fabrics/:id`
- `POST /designer/customizations`
- `PATCH /designer/customizations/:id`
- `POST /designer/pricing-rules`
- `PATCH /designer/pricing-rules/:id`
- `POST /designer/delivery-rules`
- `PATCH /designer/delivery-rules/:id`
- `PATCH /designer/orders/:id/status`
- `POST /designer/orders/:id/cancel`
- `POST /designer/reviews/:id/respond`

---

## 41. Security Requirements

### Authentication & Authorization
- Google OAuth, secure sessions, session expiration, server-side authorization.
- Customers can only access their own data; Designers can only manage their own store.

### Payment Security
- Never store card numbers or CVV.
- Never trust frontend prices.
- Verify Stripe webhooks and use Stripe idempotency keys.
- Keep secret keys server-side.
- Maintain payment and refund records to prevent duplicate processing.

### Store Credit Security
- Not editable by frontend; controlled via backend operations (`ADD`, `REMOVE`, `REFUND`).
- Audit trail required per transaction.

### File Security
- Reference images: file size limits, MIME type validation, private storage, signed URLs, server-side validation, generated filenames.

---

## 42. Error Handling

- **Payment:** `Payment Failed`, `Payment Cancelled`, `Payment Pending`, `Payment Already Completed`, `Webhook Invalid`, `Webhook Duplicate`, `Refund Failed`
- **Order:** `Order Not Found`, `Order Already Cancelled`, `Order Already Delivered`, `Modification Window Expired`, `Production Already Started`, `Invalid Status Transition`
- **Pricing:** `Invalid Fabric`, `Invalid Customization`, `Invalid Delivery Location`, `Invalid Design Category`, `Pricing Rule Missing`, `Price Calculation Failed`
- **Measurements:** `Required Measurement Missing`, `Invalid Number`, `Below Minimum`, `Above Maximum`

---

## 43. Testing Requirements

### Unit Tests
- Pricing engine, delivery calculation, measurement validation, cart calculations, order calculations, modification calculations, store-credit calculations, cancellation rules, modification deadline, permission rules.

> **Pricing Test Example:**  
> Fabric (KES 1,000) + Customization (KES 500) + Delivery (KES 400) = **KES 1,900**

### Payment Testing
- Successful payment, failed payment, cancelled checkout, duplicate/delayed webhook, duplicate payment request, refund, partial price adjustment.

### Modification Testing
- Price increase handling
- Price decrease (store credit) handling
- Expired window (> 24 hours rejection)

---

## 44. End-to-End Tests

### Standard E2E Journey
```
Guest ──> Browse ──> Select Designer ──> Select Design ──> Customize ──> Choose Measurement Profile ──> Choose Delivery City ──> Add To Cart ──> Add More Clothing ──> Review Cart ──> Google Login ──> Calculate Final Price ──> Stripe Checkout ──> Payment Confirmed ──> Order Created ──> Email Confirmation ──> Designer Processes ──> Production ──> Ready For Delivery ──> Out For Delivery ──> Delivered ──> Customer Reviews ──> Designer Responds
```

### Custom Design E2E Journey
```
Select Designer ──> Upload Reference Image ──> Choose Tier (Simple/Moderate/Complex) ──> Add Description ──> Select Fabric ──> Select Customization ──> Select Measurements ──> Select Delivery City ──> Calculate Price ──> Add To Cart ──> Checkout ──> Stripe Payment ──> Order Confirmed
```

---

## 45. Non-Functional Requirements

- **Performance:** Initial load target $\le$ 3 seconds, API responses $\le$ 2 seconds, Price calculation $\le$ 1 second. Optimized images and lazy loading.
- **Responsive Design:** Mobile, Tablet, Laptop, Desktop browsers.
- **Accessibility:** Keyboard navigation, proper labels, sufficient contrast, alt text, clear error messages, screen-reader friendly.

---

## 46. Final MVP Business Rules Summary

| Area | Final Rule |
| :--- | :--- |
| **Currency** | KES |
| **Platform** | Responsive web app |
| **Authentication** | Google OAuth |
| **Guest browsing** | Yes |
| **Designers** | One initially (Future: Marketplace) |
| **Cart** | Multiple items (One designer per checkout) |
| **Payment** | 100% upfront (Stripe) |
| **Stripe Fee** | Designer pays |
| **Cancellation** | Full refund (Customer: before production; Designer: anytime if unfulfillable) |
| **Modification** | Allowed within 24 hours (not allowed after production starts) |
| **Modification Delta** | Price increase: Customer pays difference; Price decrease: Store credit |
| **Custom Designs** | Simple / Moderate / Complex tiers (One reference image, no prior approval required) |
| **Measurements** | Configurable in cm with platform defaults |
| **Delivery** | City-based (Mombasa, Nairobi, Nakuru @ KES 400) |
| **Communication** | Telegram profile redirect |
| **Email** | Resend |
| **Reviews** | After delivery (1 per order, non-editable, designer response allowed) |

---

## 47. Final MVP Definition

The MVP is technical baseline contract complete. The next engineering artifacts should be derived in this order:

$$	ext{Database ERD} \longrightarrow 	ext{PostgreSQL schema} \longrightarrow 	ext{API contract} \longrightarrow 	ext{Application architecture} \longrightarrow 	ext{UI/Page specification} \longrightarrow 	ext{Implementation}$$
