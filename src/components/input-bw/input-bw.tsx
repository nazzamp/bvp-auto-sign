import React from "react";
import "./input-bw.css";

const InputBW = ({
  placeholder,
  name,
  type = "text",
  value,
  onChange,
  disabled = false,
}: {
  placeholder?: string;
  name?: string;
  type?: string;
  value?: string;
  onChange?: any;
  disabled?: boolean;
}) => {
  return (
    <input
      placeholder={placeholder}
      className="input-bw"
      name={name}
      type={type}
      value={value}
      onChange={(e) => {
        onChange(e.target.value);
      }}
      disabled={disabled}
      style={{ opacity: disabled ? 0.6 : 1 }}
    />
  );
};

export default InputBW;
