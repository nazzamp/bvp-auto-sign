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
      value={department}
      onValueChange={(value) => {
        setDepartment(value);
      }}
    >
      <SelectTrigger className="w-[180px]">
        <SelectValue />
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
      <label className="w-28">Phòng ban</label>
      {renderSelection()}
    </div>
  );
}
