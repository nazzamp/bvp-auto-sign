import React from "react";
import "./input-bw.css";

const InputBW = ({
  placeholder,
  name,
  type = "text",
}: {
  placeholder?: string;
  name?: string;
  type?: string;
}) => {
  return (
    <input
      placeholder={placeholder}
      className="input"
      name={name}
      type={type}
    />
  );
};

export default InputBW;
