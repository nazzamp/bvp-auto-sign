import InputBW from "@/components/input-bw/input-bw";
import Toogle from "@/components/toggle/toggle";
import { SelectDepartment } from "./select-department";
import Button3D from "@/components/button-3d/button-3d";
import { useEffect, useState } from "react";
import { SelectSignTypes } from "./select-sign-type";
import Button3DRemove from "@/components/button-3d-remove/button-3d-remove";

function Home() {
  const [departmentData, setDepartmentData] = useState([]);
  const [departmentIdx, setDepartmentIdx] = useState(0);
  const [signTypeIdx, setSignTypeIdx] = useState(0);
  const [userData, setUserData] = useState<any>();
  const [password, setPassword] = useState("");
  const [username, setUsername] = useState("");

  const ipc = window.ipcRenderer as any;

  const readDepartmentData = async () => {
    const data = await ipc.invoke("read-department-data");
    setDepartmentData(data);
  };

  const readUserData = async () => {
    const data = await ipc.invoke("read-user-data");
    setUserData(data);
    setDepartmentIdx(data?.departmentIdx);
    setSignTypeIdx(data?.signTypeIdx);
    setPassword(data?.password);
    setUsername(data?.username);
  };

  useEffect(() => {
    readDepartmentData();
    readUserData();
  }, []);

  // useEffect(() => {
  //   setSignTypeIdx(0);
  // }, [departmentIdx]);

  const startSign = async () => {
    await ipc.invoke("minimize");
    const temp = departmentData[departmentIdx] as any;
    setUserData({ ...userData, isRunning: true, password, username });
    const usernameArr = username.split(" ");
    ipc.invoke("update-user-data", {
      data: {
        departmentIdx,
        signTypeIdx,
        isRunning: true,
        password,
        username,
      },
    });
    await ipc.invoke("run-ahk", {
      path: temp.signType[signTypeIdx].ahkPath,
      agr1: password,
      agr2:
        usernameArr[usernameArr.length - 2] +
        " " +
        usernameArr[usernameArr.length - 1],
    });
  };

  const stopSign = async () => {
    await ipc.invoke("stop-ahk");
    setUserData({ ...userData, isRunning: false });
  };

  return (
    <div className="w-full h-full px-5 py-2 flex flex-col gap-6 mt-6">
      <h1 className="text-3xl mb-2">Cấu hình</h1>
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
        <label className="w-32">Tên bác sĩ</label>
        <InputBW
          placeholder="Nhập tên bác sĩ"
          value={username}
          onChange={setUsername}
        />
      </div>
      <div className="flex gap-3 items-center">
        <label className="w-32">Mật khẩu ký số</label>
        <InputBW
          placeholder="Nhập mật khẩu"
          value={password}
          onChange={setPassword}
        />
      </div>
      <div className="flex gap-3 items-center">
        <label className="w-32">Phím tắt ký số</label>
        <InputBW value="F9" disabled={true} />
      </div>
      <div className="flex gap-3 items-center">
        <label className="w-32">Tự động chạy khi mở máy</label>
        <Toogle />
      </div>
      <div className="mt-4">
        {userData?.isRunning ? (
          <Button3DRemove title="Dừng tự động" onClick={stopSign} />
        ) : (
          <Button3D title="Bắt đầu ký" onClick={startSign} />
        )}
      </div>
    </div>
  );
}

export default Home;
