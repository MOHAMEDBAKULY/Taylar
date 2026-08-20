import type { Metadata } from "next";
import { PagePlaceholder } from "@/components/page-placeholder";

export const metadata: Metadata = { title: "Pricing" };

export default function DesignerPricingPage() {
  return (
    <PagePlaceholder
      title="Pricing management"
      description="Control fabric pricing, customization modifiers, custom design tiers (Simple, Moderate, Complex), delivery rules, and production time."
      nextSteps={["POST and PATCH /api/designer/pricing-rules"]}
    />
  );
}
