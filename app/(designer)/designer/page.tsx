import type { Metadata } from "next";
import { PagePlaceholder } from "@/components/page-placeholder";

export const metadata: Metadata = { title: "Designer overview" };

export default function DesignerOverviewPage() {
  return (
    <PagePlaceholder
      title="Overview"
      description="Orders, revenue, pending production, delivery, completed orders, and reviews for this designer store."
      nextSteps={["Summarize GET /api/designer/orders once order management is implemented"]}
    />
  );
}
