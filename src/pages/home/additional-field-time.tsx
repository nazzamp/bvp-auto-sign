import React, { useEffect } from "react";
import { DatePickerWithRange } from "./date-picker";
import { DateRange } from "react-day-picker";
import { DateValues, format, subDays } from "date-fns";
import { DatePickerSingle } from "./date-picker-single";

const AdditionalFieldTime = ({
  additionalFields,
  additionValues,
  setAdditionalValues,
}: {
  additionalFields: Array<string>;
  additionValues: any;
  setAdditionalValues: any;
}) => {
  const [date, setDate] = React.useState<any>(new Date());

  useEffect(() => {
    setAdditionalValues([format(date, "dd/MM/yyyy")]);
  }, [date]);

  const renderItem = (item: string, index: number) => {
    return (
      <div className="flex gap-3 items-center" key={index}>
        <label className="w-32">Chọn ngày</label>
        <DatePickerSingle date={date} setDate={setDate} />
      </div>
    );
  };

  return <div>{additionalFields.map(renderItem)}</div>;
};

export default AdditionalFieldTime;
