import InputBW from "@/components/input-bw/input-bw";
import Toogle from "@/components/toggle/toggle";
import { SelectDepartment } from "./select-department";
import Button3D from "@/components/button-3d/button-3d";
import { useEffect, useState } from "react";
import { SelectSignTypes } from "./select-sign-type";
import Button3DRemove from "@/components/button-3d-remove/button-3d-remove";
import { useFormik } from "formik";
import { SelectScreenType } from "./select-screen-type";
import "./home.css";
import AdditionalFields from "./addtional-fields";
import { MdBrowserUpdated } from "react-icons/md";
import packageJson from "@/../package.json";

function Home() {
  const [configs, setConfigs] = useState<any>({});
  const [additionValues, setAdditionalValues] = useState([]);
  const [isAutoStart, setIsAutoStart] = useState(false);
  const [isRunning, setIsRunning] = useState(false);

  const form = useFormik({
    initialValues: {
      departmentIdx: 0,
      signTypeIdx: 0,
      password: "",
      username: "",
      screenType: 0,
    },
    onSubmit: () => {},
  });

  const departData = configs.departments?.[form.values?.departmentIdx];
  const additionalFields =
    departData?.signType[form.values?.signTypeIdx]?.additionalFields;

  const ipc = window.ipcRenderer as any;

  const readDepartmentData = async () => {
    const data = await ipc.invoke("read-department-data");
    setConfigs(data);
  };

  const readUserData = async () => {
    const data = await ipc.invoke("read-user-data");
    form.setValues(data);
  };

  const checkIsAutoStart = async () => {
    const result = await ipc.invoke("check-auto-launch");
    setIsAutoStart(result);
  };

  const checkAutoHotkeyIsRunning = async () => {
    const result = await ipc.invoke("check-auto-hotkey-running");
    setIsRunning(result);
  };

  const checkUpdate = async () => {
    const result = await ipc.invoke("check-update");
  };

  useEffect(() => {
    readDepartmentData();
    readUserData();
    checkIsAutoStart();
    checkAutoHotkeyIsRunning();
    checkUpdate();
  }, []);

  const sign = async (additionalFields = []) => {
    setIsRunning(true);
    await ipc.invoke("minimize");
    const temp = configs.departments[form.values.departmentIdx] as any;
    ipc.invoke("update-user-data", {
      data: {
        ...form.values,
      },
    });
    await ipc.invoke("run-ahk", {
      path: temp.signType[form.values.signTypeIdx].ahkPath,
      agrArr: [
        form.values.password,
        configs.screenTypes[form.values.screenType].path,
        ...additionalFields,
      ],
    });
  };

  const startSign = () => {
    if (additionalFields) {
      sign(additionValues);
      return;
    }
    sign();
  };

  const stopSign = async () => {
    await ipc.invoke("stop-ahk");
    setIsRunning(false);
  };

  const setFormValue = (formKey: string) => (value: string) => {
    form.setFieldValue(formKey, value);
  };

  const toogleAutoStart = async (enable: boolean) => {
    const result = await ipc.invoke("toggle-auto-launch", enable);
    return result;
  };

  useEffect(() => {
    const statusListener = (_: any, running: boolean) => {
      setIsRunning(running);
    };
    ipc.on("ahk-status", statusListener);

    return () => {
      ipc?.removeListener?.("ahk-status", statusListener);
    };
  }, []);

  return (
    <div id="home" className="h-full px-5 flex flex-col gap-6">
      <div className="flex justify-between items-center flex-row flex-shrink-1">
        <h1 className="text-2xl mb-0 mt-6">Cấu hình ký</h1>
        <div className="flex items-center gap-2 px-3 py-1 rounded-full bg-zinc-100">
          <MdBrowserUpdated size={20} />
          <span>Phiên bản {packageJson.version}</span>
        </div>
      </div>
      {configs.departments?.length > 0 && (
        <>
          <SelectScreenType
            data={configs.screenTypes}
            screenType={form.values.screenType}
            setScreenType={setFormValue("screenType")}
          />
          <SelectDepartment
            data={configs.departments}
            department={form.values.departmentIdx}
            setDepartment={(value: number) =>
              form.setFieldValue("departmentIdx", value)
            }
          />
          <SelectSignTypes
            departmentData={configs.departments}
            departmentIdx={form.values.departmentIdx}
            signType={form.values.signTypeIdx}
            setSignType={(value: number) =>
              form.setFieldValue("signTypeIdx", value)
            }
          />
          {additionalFields && (
            <AdditionalFields
              additionalFields={additionalFields}
              additionValues={additionValues}
              setAdditionalValues={setAdditionalValues}
            />
          )}
        </>
      )}
      <div className="flex gap-3 items-center">
        <label className="w-32">Tên bác sĩ</label>
        <InputBW
          placeholder="Nhập tên bác sĩ"
          value={form.values.username}
          onChange={(value: number) => form.setFieldValue("username", value)}
        />
      </div>
      <div className="flex gap-3 items-center">
        <label className="w-32">Mật khẩu ký số</label>
        <InputBW
          placeholder="Nhập mật khẩu"
          value={form.values.password}
          onChange={(value: number) => form.setFieldValue("password", value)}
        />
      </div>
      <div className="flex gap-3 items-center">
        <label className="w-32">Phím tắt ký số</label>
        <InputBW value="F9" disabled={true} />
      </div>
      <div className="flex gap-3 items-center">
        <label className="w-32">Tự động chạy khi mở máy</label>
        <Toogle
          enabled={isAutoStart}
          setEnabled={setIsAutoStart}
          toogleAutoStart={toogleAutoStart}
        />
      </div>
      <div className="mt-2">
        {isRunning ? (
          <Button3DRemove title="Dừng tự động" onClick={stopSign} />
        ) : (
          <Button3D title="Bắt đầu ký" onClick={startSign} />
        )}
      </div>
    </div>
  );
}

export default Home;
