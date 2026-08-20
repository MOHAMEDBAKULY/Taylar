import type { Metadata } from "next";
import { PagePlaceholder } from "@/components/page-placeholder";

export const metadata: Metadata = { title: "Customizations" };

export default function DesignerCustomizationsPage() {
  return (
    <PagePlaceholder
      title="Customizations"
      description="Configure sleeves, neckline, length, and other options. Each option can carry a price modifier in KES."
      nextSteps={["POST /api/designer/customizations", "PATCH /api/designer/customizations/:id"]}
    />
  );
}
