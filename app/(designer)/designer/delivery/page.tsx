import type { Metadata } from "next";
import { PagePlaceholder } from "@/components/page-placeholder";

export const metadata: Metadata = { title: "Delivery" };

export default function DesignerDeliveryPage() {
  return (
    <PagePlaceholder
      title="Delivery management"
      description="MVP cities are Mombasa, Nairobi, and Nakuru. Default delivery price is KES 400, stored per designer for future marketplace pricing."
      nextSteps={["POST and PATCH /api/designer/delivery-rules"]}
    />
  );
}
