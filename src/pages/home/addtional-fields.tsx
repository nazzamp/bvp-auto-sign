import AdditionalFieldRange from "./additional-field-range";
import AdditionalFieldTime from "./additional-field-time";

const AdditionalFields = (props: any) => {
  if (!props?.additionalFields?.length) {
    return;
  }

  return (
    <>
      {props?.additionalFields.includes("time") && (
        <AdditionalFieldTime {...props} />
      )}
      {props?.additionalFields.includes("timeRange") && (
        <AdditionalFieldRange {...props} />
      )}
    </>
  );
};

export default AdditionalFields;
