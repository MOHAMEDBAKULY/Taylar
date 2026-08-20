import type { Metadata } from "next";
import { PagePlaceholder } from "@/components/page-placeholder";

export const metadata: Metadata = { title: "Search" };

export default function SearchPage() {
  return (
    <PagePlaceholder
      title="Search"
      description="Search designs, categories, and the designer store. Available to guests."
      nextSteps={["Wire search input to catalog queries once the public APIs are implemented"]}
    />
  );
}
