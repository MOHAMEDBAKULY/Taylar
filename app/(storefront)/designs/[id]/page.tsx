import type { Metadata } from "next";
import { PagePlaceholder } from "@/components/page-placeholder";

export const metadata: Metadata = { title: "Design" };

type DesignPageProps = {
  params: Promise<{ id: string }>;
};

export default async function DesignDetailPage({ params }: DesignPageProps) {
  const { id } = await params;

  return (
    <PagePlaceholder
      title="Clothing details"
      description={`Design ${id}. Guests can view images, fabrics, colors, customization options, price pieces, and production time. Sign in is required to save measurements or order.`}
      nextSteps={[
        "Load GET /api/designs/:id",
        "Collect fabric, color, customizations, measurement profile, and delivery city before add-to-cart",
      ]}
    />
  );
}
