import type { Metadata } from "next";
import { PagePlaceholder } from "@/components/page-placeholder";

export const metadata: Metadata = { title: "Category" };

type CategoryPageProps = {
  params: Promise<{ slug: string }>;
};

export default async function CategoryPage({ params }: CategoryPageProps) {
  const { slug } = await params;

  return (
    <PagePlaceholder
      title="Category"
      description={`Category “${slug}”. Clothing is grouped as Dresses, Suits, Skirts, Tops, Trousers, and Other.`}
      nextSteps={["Filter published designs by category slug from GET /api/categories"]}
    />
  );
}
