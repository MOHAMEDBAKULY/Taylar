import type { Metadata } from "next";
import { PagePlaceholder } from "@/components/page-placeholder";

export const metadata: Metadata = { title: "Checkout" };

export default function CheckoutPage() {
  return (
    <PagePlaceholder
      title="Checkout"
      description="Review itemized prices in KES, choose a delivery city (Mombasa, Nairobi, or Nakuru), then pay 100% upfront with Stripe. The backend price is authoritative."
      nextSteps={[
        "POST /api/pricing/calculate then POST /api/orders",
        "Start Stripe Checkout via POST /api/payments/create-checkout",
      ]}
    />
  );
}
