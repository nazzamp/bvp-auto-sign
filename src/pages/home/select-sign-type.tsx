import {
  Select,
  SelectContent,
  SelectGroup,
  SelectItem,
  SelectTrigger,
} from "@/components/ui/select";

export function SelectSignTypes({
  departmentIdx,
  departmentData,
  signType,
  setSignType,
}: {
  departmentIdx: any;
  departmentData: any;
  signType: any;
  setSignType: any;
}) {
  const signTypeList = departmentData[departmentIdx].signType;

  const renderSelection = () => (
    <Select
      value={signType}
      onValueChange={(value) => {
        setSignType(value);
      }}
    >
      <SelectTrigger className="w-[280px] bg-white">
        <label>{signTypeList?.[signType]?.name}</label>
      </SelectTrigger>
      <SelectContent>
        <SelectGroup>{signTypeList.map(renderSelectItem)}</SelectGroup>
      </SelectContent>
    </Select>
  );

  const renderSelectItem = (data: any, index: number) => {
    return (
      <SelectItem value={index.toString()} key={index}>
        {data.name}
      </SelectItem>
    );
  };

  return (
    <div className="flex gap-3 items-center">
      <label className="w-32">Loại chữ ký</label>
      {renderSelection()}
    </div>
  );
}
