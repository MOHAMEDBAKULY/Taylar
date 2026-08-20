import type { Metadata } from "next";
import { PagePlaceholder } from "@/components/page-placeholder";

export const metadata: Metadata = { title: "Designs" };

export default function DesignerDesignsPage() {
  return (
    <PagePlaceholder
      title="Product management"
      description="Create, edit, and archive designs. Upload images and assign categories, fabrics, colors, and customizations."
      nextSteps={["POST /api/designer/designs", "PATCH and DELETE /api/designer/designs/:id"]}
    />
  );
}
