import type { Metadata } from "next";
import { PagePlaceholder } from "@/components/page-placeholder";

export const metadata: Metadata = { title: "Order" };

type OrderPageProps = {
  params: Promise<{ id: string }>;
};

export default async function OrderDetailPage({ params }: OrderPageProps) {
  const { id } = await params;

  return (
    <PagePlaceholder
      title="Order tracking"
      description={`Order ${id}. Status flows PENDING_PAYMENT → PAID → PROCESSING → IN_PRODUCTION → READY_FOR_DELIVERY → OUT_FOR_DELIVERY → DELIVERED.`}
      nextSteps={[
        "GET /api/orders/:id",
        "Modify, cancel, or leave a 1–5 star review after delivery",
      ]}
    />
  );
}
