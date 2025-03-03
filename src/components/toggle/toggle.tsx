import React from "react";
import "./toggle.css";

const Toggle = ({ enabled, setEnabled, toogleAutoStart }: any) => {
  const toogleStart = async () => {
    await toogleAutoStart(!enabled);
    setEnabled((prev: any) => !prev);
  };

  return (
    <label className="switch">
      <input type="checkbox" onChange={toogleStart} checked={enabled} />
      <span className="slider"></span>
    </label>
  );
};

export default Toggle;
