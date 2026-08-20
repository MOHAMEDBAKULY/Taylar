import type { Metadata } from "next";
import { PagePlaceholder } from "@/components/page-placeholder";

export const metadata: Metadata = { title: "Store credit" };

export default function StoreCreditPage() {
  return (
    <PagePlaceholder
      title="Store credit"
      description="Price decreases from order modifications are issued as store credit, not an immediate refund. Credit can be applied to a later order. The frontend cannot edit the balance."
      nextSteps={["GET /api/store-credit and GET /api/store-credit/transactions"]}
    />
  );
}
