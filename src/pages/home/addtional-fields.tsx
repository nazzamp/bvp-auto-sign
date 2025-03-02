import React, { useEffect } from "react";
import { DatePickerWithRange } from "./date-picker";
import { DateRange } from "react-day-picker";
import { format, subDays } from "date-fns";

const AdditionalFields = ({
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
      format(date?.from + "000000" || "", "yyyyMMdd"),
      format(date?.to + "000000" || "", "yyyyMMdd"),
    ]);
  }, [date]);

  const renderItem = (item: string, index: number) => {
    if (item === "timeRange")
      return (
        <div className="flex gap-3 items-center">
          <label className="w-32">Trong khoảng</label>
          <DatePickerWithRange date={date} setDate={setDate} />
        </div>
      );
    return;
  };

  return <div>{additionalFields.map(renderItem)}</div>;
};

export default AdditionalFields;
