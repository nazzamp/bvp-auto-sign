import React, { useEffect } from "react";
import { DatePickerWithRange } from "./date-picker";
import { DateRange } from "react-day-picker";
import { format, subDays } from "date-fns";

const AdditionalFieldRange = ({
  additionalFields,
  additionValues,
  setAdditionalValues,
}: {
  additionalFields: Array<string>;
  additionValues: any;
  setAdditionalValues: any;
}) => {
  const [date, setDate] = React.useState<DateRange | undefined>({
    from: subDays(new Date(), 5),
    to: new Date(),
  });

  useEffect(() => {
    setAdditionalValues([
      date?.from ? format(date?.from + "000000", "yyyyMMdd") : "20001010000000",
      date?.to ? format(date?.to + "000000", "yyyyMMdd") : "20001010000000",
    ]);
  }, [date]);

  const renderItem = (item: string, index: number) => {
    if (item === "timeRange")
      return (
        <div className="flex gap-3 items-center" key={index}>
          <label className="w-32">Trong khoảng</label>
          <DatePickerWithRange date={date} setDate={setDate} />
        </div>
      );
    return;
  };

  return <div>{additionalFields.map(renderItem)}</div>;
};

export default AdditionalFieldRange;
