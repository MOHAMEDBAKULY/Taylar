import type { Metadata } from "next";
import { PagePlaceholder } from "@/components/page-placeholder";

export const metadata: Metadata = { title: "Designers" };

export default function DesignersPage() {
  return (
    <PagePlaceholder
      title="Designers"
      description="Guests can browse designers without signing in. The MVP seeds one designer: Amina Atelier."
      nextSteps={[
        "List designers from GET /api/designers",
        "Open a designer store to browse their clothing, fabrics, and reviews",
      ]}
    />
  );
}
