export type MeasurementValidationInput = {
  name: string;
  value: unknown;
  min: number;
  max: number;
  required: boolean;
};

export type MeasurementValidationError = {
  name: string;
  code:
    | "Required Measurement Missing"
    | "Invalid Number"
    | "Below Minimum"
    | "Above Maximum";
  message: string;
};

export function validateMeasurement(
  input: MeasurementValidationInput,
): MeasurementValidationError | null {
  if (input.value === null || input.value === undefined || input.value === "") {
    if (input.required) {
      return {
        name: input.name,
        code: "Required Measurement Missing",
        message: `${input.name} is required.`,
      };
    }
    return null;
  }

  const value = typeof input.value === "number" ? input.value : Number(input.value);

  if (!Number.isFinite(value)) {
    return {
      name: input.name,
      code: "Invalid Number",
      message: `${input.name} must be a number in cm.`,
    };
  }

  if (value < 0) {
    return {
      name: input.name,
      code: "Invalid Number",
      message: `${input.name} cannot be negative.`,
    };
  }

  if (value < input.min) {
    return {
      name: input.name,
      code: "Below Minimum",
      message: `${input.name} must be at least ${input.min} cm.`,
    };
  }

  if (value > input.max) {
    return {
      name: input.name,
      code: "Above Maximum",
      message: `${input.name} must be at most ${input.max} cm.`,
    };
  }

  return null;
}

export function validateMeasurements(inputs: MeasurementValidationInput[]) {
  return inputs
    .map(validateMeasurement)
    .filter((error): error is MeasurementValidationError => error !== null);
}
