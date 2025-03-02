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

function Home() {
  const [configs, setConfigs] = useState<any>({});
  const [additionValues, setAdditionalValues] = useState([]);

  const form = useFormik({
    initialValues: {
      departmentIdx: 0,
      signTypeIdx: 0,
      password: "",
      username: "",
      isRunning: false,
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

  useEffect(() => {
    readDepartmentData();
    readUserData();
  }, []);

  const sign = async (additionalFields = []) => {
    form.setValues({ ...form.values, isRunning: true });
    await ipc.invoke("minimize");
    const temp = configs.departments[form.values.departmentIdx] as any;
    ipc.invoke("update-user-data", {
      data: {
        ...form.values,
        isRunning: true,
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
    form.setValues({ ...form.values, isRunning: false });
  };

  const setFormValue = (formKey: string) => (value: string) => {
    form.setFieldValue(formKey, value);
  };

  return (
    <div id="home" className="w-full h-full px-5 flex flex-col gap-6">
      <h1 className="text-2xl mb-2 mt-6">Cấu hình ký</h1>
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
        <Toogle />
      </div>
      <div className="mt-4">
        {form.values?.isRunning ? (
          <Button3DRemove title="Dừng tự động" onClick={stopSign} />
        ) : (
          <Button3D title="Bắt đầu ký" onClick={startSign} />
        )}
      </div>
    </div>
  );
}

export default Home;
