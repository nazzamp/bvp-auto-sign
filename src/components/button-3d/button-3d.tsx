import React, { ButtonHTMLAttributes, HTMLAttributes } from "react";

interface ButtonProps extends ButtonHTMLAttributes<HTMLButtonElement> {
  title: string;
  onClick?: () => void;
}
import "./button-3d.css";

const Button3DRemove = ({
  title = "Click",
  onClick,
  ...props
}: ButtonProps) => {
  return (
    <button className="button-3d" onClick={onClick} {...props}>
      {title}
    </button>
  );
};

export default Button3DRemove;
