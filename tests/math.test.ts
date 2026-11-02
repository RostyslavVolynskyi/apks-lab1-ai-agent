import { describe, expect, it } from "vitest";
import { add } from "../src/math";

describe("BasicAddition", () => {
  it("adds two numbers", () => {
    expect(add(2, 3)).toBe(5);
  });
});
