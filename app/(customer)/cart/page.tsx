import type { Metadata } from "next";
import { PagePlaceholder } from "@/components/page-placeholder";

export const metadata: Metadata = { title: "Cart" };

export default function CartPage() {
  return (
    <PagePlaceholder
      title="Cart"
      description="Multiple clothing items can share one checkout, but every item keeps its own fabric, color, customizations, and measurements. All items must belong to the same designer."
      nextSteps={[
        "Load GET /api/cart",
        "Show the mix-designer error: checkout first or start a new cart",
      ]}
    />
  );
}
