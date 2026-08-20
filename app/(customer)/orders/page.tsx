import type { Metadata } from "next";
import { PagePlaceholder } from "@/components/page-placeholder";

export const metadata: Metadata = { title: "Orders" };

export default function OrdersPage() {
  return (
    <PagePlaceholder
      title="Orders"
      description="Track production from payment through delivery. Cancel before production starts for a full refund. Modify within 24 hours if production has not started."
      nextSteps={["List GET /api/orders", "Open an order for status, modify, cancel, or review"]}
    />
  );
}
