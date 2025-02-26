import {
  Select,
  SelectContent,
  SelectGroup,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";

export function SelectDepartment({
  data,
  department,
  setDepartment,
}: {
  data: any;
  department: number;
  setDepartment: any;
}) {
  const renderSelection = () => (
    <Select
      value={department.toString()}
      onValueChange={(value) => {
        setDepartment(value);
      }}
    >
      <SelectTrigger className="w-[280px]">
        <label>{data?.[department]?.name}</label>
      </SelectTrigger>
      <SelectContent>
        <SelectGroup>{data.map(renderSelectItem)}</SelectGroup>
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
      <label className="w-32">Phòng ban</label>
      {renderSelection()}
    </div>
  );
}
