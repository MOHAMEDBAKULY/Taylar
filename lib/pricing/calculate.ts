export type LineItemPriceInput = {
  isCustom: boolean;
  fabricKes: number;
  customizationKes: number;
  customDesignCategoryKes?: number;
};

export type PriceInput = {
  items: LineItemPriceInput[];
  deliveryKes: number;
  storeCreditKes?: number;
};

export type PriceBreakdown = {
  currency: "KES";
  items: Array<{
    fabricKes: number;
    customizationKes: number;
    customDesignCategoryKes: number;
    itemTotalKes: number;
  }>;
  subtotalKes: number;
  deliveryKes: number;
  storeCreditKes: number;
  totalKes: number;
};

function roundKes(value: number) {
  return Math.round(value * 100) / 100;
}

/**
 * Authoritative pricing formulas (Technical Spec §13):
 * Standard: Fabric + Customization + Delivery
 * Custom: Custom Design Category + Fabric + Customization + Delivery
 *
 * Delivery is charged once per order. Line items do not include delivery.
 * The frontend must never override the payable total.
 */
export function calculatePrice(input: PriceInput): PriceBreakdown {
  const items = input.items.map((item) => {
    const customDesignCategoryKes = item.isCustom
      ? item.customDesignCategoryKes ?? 0
      : 0;
    const itemTotalKes = roundKes(
      customDesignCategoryKes + item.fabricKes + item.customizationKes,
    );

    return {
      fabricKes: roundKes(item.fabricKes),
      customizationKes: roundKes(item.customizationKes),
      customDesignCategoryKes: roundKes(customDesignCategoryKes),
      itemTotalKes,
    };
  });

  const subtotalKes = roundKes(items.reduce((sum, item) => sum + item.itemTotalKes, 0));
  const deliveryKes = roundKes(input.deliveryKes);
  const storeCreditKes = roundKes(Math.max(0, input.storeCreditKes ?? 0));
  const totalKes = roundKes(Math.max(0, subtotalKes + deliveryKes - storeCreditKes));

  return {
    currency: "KES",
    items,
    subtotalKes,
    deliveryKes,
    storeCreditKes,
    totalKes,
  };
}
