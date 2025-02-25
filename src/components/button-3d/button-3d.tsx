import React from "react";
import "./button-3d.css";

const Button3D = ({ title = "Click" }: { title?: string }) => {
  return <button className="button-3d">{title}</button>;
};

export default Button3D;
