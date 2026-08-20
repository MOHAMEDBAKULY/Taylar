import type { Metadata } from "next";
import { PagePlaceholder } from "@/components/page-placeholder";

export const metadata: Metadata = { title: "Measurements" };

export default function DesignerMeasurementsPage() {
  return (
    <PagePlaceholder
      title="Measurement management"
      description="Configure which measurements each clothing category requires, with min/max values in cm and customer-facing instructions."
      nextSteps={["Load platform defaults, then save designer overrides per category"]}
    />
  );
}
