import {
  Select,
  SelectContent,
  SelectGroup,
  SelectItem,
  SelectTrigger,
} from "@/components/ui/select";
import { BiImages } from "react-icons/bi";

export function SelectScreenType({
  data,
  screenType,
  setScreenType,
}: {
  data: any;
  screenType: number;
  setScreenType: any;
}) {
  const renderSelection = () => (
    <Select value={screenType.toString()} onValueChange={setScreenType}>
      <SelectTrigger className="w-[280px] bg-white">
        <label>{data[screenType].name}</label>
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
      <div className="flex items-center gap-2 w-32">
        <BiImages size={20} />
        <label className="font-medium">Màn hình</label>
      </div>
      {renderSelection()}
    </div>
  );
}
