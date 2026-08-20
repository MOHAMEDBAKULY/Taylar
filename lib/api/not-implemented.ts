import { NextResponse } from "next/server";

export function notImplemented(method: string, path: string) {
  return NextResponse.json(
    {
      error: "Not implemented",
      method,
      path,
      message:
        "This endpoint is part of the TailorFit API contract and will be implemented after the scaffold.",
    },
    { status: 501 },
  );
}
