"use client";

import { ElementRef, forwardRef } from "react";
import { TextProps } from "./Text.type";
import { BaseText } from "./Text.style";

const Text = forwardRef<ElementRef<"span">, TextProps>(
  ({ as = "span", children, ...props }, ref) => {
    // return (
    //   <Slot ref={ref} {...props}>
    //     <Element>{children}</Element>
    //   </Slot>
    // );

    return (
      <BaseText as={as} {...props}>
        {children}
      </BaseText>
    );
  }
);
Text.displayName = "Text";

export default Text;
