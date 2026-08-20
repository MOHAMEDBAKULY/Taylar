import type { Metadata } from "next";
import { PagePlaceholder } from "@/components/page-placeholder";

export const metadata: Metadata = { title: "Reviews" };

export default function DesignerReviewsPage() {
  return (
    <PagePlaceholder
      title="Reviews"
      description="Customers can review a delivered order once. Reviews cannot be edited. You may respond; customers cannot reply in the MVP."
      nextSteps={["POST /api/designer/reviews/:id/respond"]}
    />
  );
}
