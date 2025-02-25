import React from "react";
import "./button-3d.css";

const Button3DRemove = ({
  title = "Click",
  onClick,
}: {
  title?: string;
  onClick: any;
}) => {
  return (
    <button className="button-3d" onClick={onClick}>
      {title}
    </button>
  );
};

export default Button3DRemove;
