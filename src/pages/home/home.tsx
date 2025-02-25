import InputBW from "@/components/input-bw/input-bw";
import Toogle from "@/components/toggle/toggle";
import { SelectDepartment } from "./select-department";
import Button3D from "@/components/button-3d/button-3d";
import { useEffect, useState } from "react";
import { SelectSignTypes } from "./select-sign-type";

function Home() {
  const [departmentData, setDepartmentData] = useState([]);
  const [departmentIdx, setDepartmentIdx] = useState(0);
  const [signTypeIdx, setSignTypeIdx] = useState(0);

  const ipc = window.ipcRenderer as any;

  const readDepartmentData = async () => {
    const data = await ipc.invoke("read-department-data");
    setDepartmentData(data);
  };

  useEffect(() => {
    readDepartmentData();
  }, []);

  useEffect(() => {
    setSignTypeIdx(0);
  }, [departmentIdx]);

  return (
    <div className="w-full h-full px-5 py-4 flex flex-col gap-6">
      {departmentData.length > 0 && (
        <>
          <SelectDepartment
            data={departmentData}
            department={departmentIdx}
            setDepartment={setDepartmentIdx}
          />
          <SelectSignTypes
            departmentData={departmentData}
            data={departmentIdx}
            signType={signTypeIdx}
            setSignType={setSignTypeIdx}
          />
        </>
      )}
      <div className="flex gap-3 items-center">
        <label className="w-28">Mật khẩu ký số</label>
        <InputBW placeholder="Nhập mật khẩu" />
      </div>
      <div className="flex gap-3 items-center">
        <label className="w-28">Phím tắt ký số</label>
        <InputBW placeholder="Nhập phím" />
      </div>
      <div className="flex gap-3 items-center">
        <label className="w-28">Tự động chạy khi mở máy</label>
        <Toogle />
      </div>
      <Button3D title="Bắt đầu ký" />
    </div>
  );
}

export default Home;
