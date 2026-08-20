import { z } from "zod";
import { NextResponse } from "next/server";
import { calculatePrice, type PriceInput } from "@/lib/pricing/calculate";

const lineItemSchema = z.object({
  isCustom: z.boolean(),
  fabricKes: z.number().nonnegative(),
  customizationKes: z.number().nonnegative(),
  customDesignCategoryKes: z.number().nonnegative().optional(),
});

const bodySchema = z.object({
  items: z.array(lineItemSchema).min(1),
  deliveryKes: z.number().nonnegative(),
  storeCreditKes: z.number().nonnegative().optional(),
});

export async function POST(request: Request) {
  let json: unknown;

  try {
    json = await request.json();
  } catch {
    return NextResponse.json(
      { error: "Price Calculation Failed", message: "Request body must be JSON." },
      { status: 400 },
    );
  }

  const parsed = bodySchema.safeParse(json);
  if (!parsed.success) {
    return NextResponse.json(
      { error: "Price Calculation Failed", issues: parsed.error.flatten() },
      { status: 400 },
    );
  }

  const breakdown = calculatePrice(parsed.data as PriceInput);
  return NextResponse.json(breakdown);
}
