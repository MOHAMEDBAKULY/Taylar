export const APP_NAME = "TailorFit";
export const CURRENCY = "KES";
export const CURRENCY_LABEL = "Kenyan Shilling";

export const MVP_CITIES = ["Mombasa", "Nairobi", "Nakuru"] as const;
export type DeliveryCity = (typeof MVP_CITIES)[number];

export const DEFAULT_DELIVERY_FEE_KES = 400;

export const CUSTOM_DESIGN_TIERS = ["Simple", "Moderate", "Complex"] as const;
export type CustomDesignTier = (typeof CUSTOM_DESIGN_TIERS)[number];

export const ORDER_STATUSES = [
  "PENDING_PAYMENT",
  "PAID",
  "PROCESSING",
  "IN_PRODUCTION",
  "READY_FOR_DELIVERY",
  "OUT_FOR_DELIVERY",
  "DELIVERED",
  "CANCELLED",
] as const;
export type OrderStatus = (typeof ORDER_STATUSES)[number];

export const CANCELLABLE_STATUSES: OrderStatus[] = [
  "PENDING_PAYMENT",
  "PAID",
  "PROCESSING",
];

export const MODIFICATION_WINDOW_HOURS = 24;

export const SEED_DESIGNER_ID = "22222222-2222-2222-2222-222222222222";

export const STOREFRONT_NAV = [
  { href: "/", label: "Home" },
  { href: "/designers", label: "Designers" },
  { href: "/search", label: "Search" },
  { href: "/cart", label: "Cart" },
] as const;

export const CUSTOMER_NAV = [
  { href: "/account", label: "Account" },
  { href: "/measurements", label: "Measurements" },
  { href: "/orders", label: "Orders" },
  { href: "/store-credit", label: "Store credit" },
] as const;

export const DESIGNER_NAV = [
  { href: "/designer", label: "Overview" },
  { href: "/designer/designs", label: "Designs" },
  { href: "/designer/fabrics", label: "Fabrics" },
  { href: "/designer/customizations", label: "Customizations" },
  { href: "/designer/pricing", label: "Pricing" },
  { href: "/designer/measurements", label: "Measurements" },
  { href: "/designer/delivery", label: "Delivery" },
  { href: "/designer/orders", label: "Orders" },
  { href: "/designer/reviews", label: "Reviews" },
] as const;
