import type {
  CustomDesignTier,
  DeliveryCity,
  OrderStatus,
} from "@/lib/constants";

export type UserRole = "customer" | "designer" | "admin";

export type PaymentStatus =
  | "PENDING"
  | "PAID"
  | "FAILED"
  | "CANCELLED"
  | "REFUNDED";

export type User = {
  id: string;
  email: string;
  fullName: string | null;
  role: UserRole;
  avatarUrl: string | null;
};

export type Designer = {
  id: string;
  userId: string | null;
  displayName: string;
  bio: string | null;
  telegramUsername: string | null;
  productionTimeDays: number;
  isActive: boolean;
};

export type CustomerProfile = {
  id: string;
  userId: string;
  phone: string | null;
  defaultDeliveryCity: DeliveryCity | null;
  deliveryAddress: string | null;
  deliveryInstructions: string | null;
};

export type Category = {
  id: string;
  name: string;
  slug: string;
  description: string | null;
};

export type Design = {
  id: string;
  designerId: string;
  categoryId: string;
  name: string;
  description: string | null;
  estimatedProductionDays: number;
  isPublished: boolean;
};

export type Fabric = {
  id: string;
  designerId: string;
  name: string;
  texture: string | null;
  priceKes: number;
};

export type Color = {
  id: string;
  designerId: string;
  name: string;
  hexCode: string | null;
};

export type CustomizationOption = {
  id: string;
  designerId: string;
  groupName: string;
  name: string;
  priceModifierKes: number;
};

export type MeasurementType = {
  id: string;
  name: string;
  unit: "cm";
  defaultMin: number;
  defaultMax: number;
  defaultRequired: boolean;
  defaultInstructions: string | null;
};

export type MeasurementProfile = {
  id: string;
  customerId: string;
  personName: string;
  relationship: string;
  lastUpdatedAt: string;
};

export type CartItem = {
  id: string;
  cartId: string;
  designerId: string;
  designId: string | null;
  isCustom: boolean;
  customDesignCategoryId: string | null;
  fabricId: string | null;
  colorId: string | null;
  measurementProfileId: string | null;
  customizationOptionIds: string[];
  customDescription: string | null;
  referenceImagePath: string | null;
};

export type Order = {
  id: string;
  customerId: string;
  designerId: string;
  status: OrderStatus;
  deliveryCity: DeliveryCity;
  deliveryFeeKes: number;
  subtotalKes: number;
  storeCreditAppliedKes: number;
  totalKes: number;
  modificationWindowEndsAt: string;
};

export type Review = {
  id: string;
  orderId: string;
  customerId: string;
  designerId: string;
  rating: number;
  comment: string | null;
};

export type CustomDesignCategory = {
  id: string;
  designerId: string;
  tier: CustomDesignTier;
  priceKes: number;
};

export type DeliveryRule = {
  id: string;
  designerId: string;
  city: DeliveryCity;
  priceKes: number;
  isAvailable: boolean;
};

export type StoreCredit = {
  id: string;
  customerId: string;
  balanceKes: number;
};
