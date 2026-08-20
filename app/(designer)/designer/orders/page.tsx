import type { Metadata } from "next";
import { PagePlaceholder } from "@/components/page-placeholder";

export const metadata: Metadata = { title: "Designer orders" };

export default function DesignerOrdersPage() {
  return (
    <PagePlaceholder
      title="Order management"
      description="View paid orders with measurements, reference images, and payment status. Move status through processing, production, and delivery. Cancel with a full refund if you cannot fulfill."
      nextSteps={[
        "GET /api/designer/orders",
        "PATCH /api/designer/orders/:id/status",
        "POST /api/designer/orders/:id/cancel",
      ]}
    />
  );
}
