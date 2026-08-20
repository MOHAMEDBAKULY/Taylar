import type { Metadata } from "next";
import { PagePlaceholder } from "@/components/page-placeholder";

export const metadata: Metadata = { title: "Measurements" };

export default function MeasurementsPage() {
  return (
    <PagePlaceholder
      title="Measurement profiles"
      description="Save multiple profiles in centimetres — for yourself, a daughter, mother, or sister. Each order copies a snapshot so later edits never change history."
      nextSteps={[
        "List, create, update, and delete profiles via /api/measurement-profiles",
        "Validate min/max and required measurements per clothing category",
      ]}
    />
  );
}
