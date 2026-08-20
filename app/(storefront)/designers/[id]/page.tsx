import type { Metadata } from "next";
import { PagePlaceholder } from "@/components/page-placeholder";

export const metadata: Metadata = { title: "Designer" };

type DesignerPageProps = {
  params: Promise<{ id: string }>;
};

export default async function DesignerProfilePage({ params }: DesignerPageProps) {
  const { id } = await params;

  return (
    <PagePlaceholder
      title="Designer store"
      description={`Designer ${id}. Browse this designer's clothing, fabrics, colors, customizations, delivery cities, and reviews. Chat opens Telegram.`}
      nextSteps={[
        "Load GET /api/designers/:id and nested catalog endpoints",
        "Show Chat with Designer using the stored Telegram username",
      ]}
    />
  );
}
