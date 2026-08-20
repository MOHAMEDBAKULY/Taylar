import type { Metadata } from "next";
import { PagePlaceholder } from "@/components/page-placeholder";

export const metadata: Metadata = { title: "Fabrics" };

export default function DesignerFabricsPage() {
  return (
    <PagePlaceholder
      title="Fabrics"
      description="Manage fabric names, textures, and KES prices used in the pricing engine."
      nextSteps={["POST /api/designer/fabrics", "PATCH /api/designer/fabrics/:id"]}
    />
  );
}
