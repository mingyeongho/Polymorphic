import { ComponentPropsWithoutRef, ElementRef } from "react";

export type TextAsType =
  | "div"
  | "span"
  | "h1"
  | "h2"
  | "h3"
  | "h4"
  | "h5"
  | "h6"
  | "label"
  | "p";

type TextElementProps<T extends TextAsType> = {
  as?: T;
} & ComponentPropsWithoutRef<T>;

export type TextProps =
  | TextElementProps<"div">
  | TextElementProps<"span">
  | TextElementProps<"h1">
  | TextElementProps<"h2">
  | TextElementProps<"h3">
  | TextElementProps<"h4">
  | TextElementProps<"h5">
  | TextElementProps<"h6">
  | TextElementProps<"label">
  | TextElementProps<"p">;
