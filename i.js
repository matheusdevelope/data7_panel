const Valor = {
  columns: [
    {
      name: "Name",
      label: "Label",
      toolTip: "ToolTip",
      isOrderColumn: false,
      hide: false,
      fontSize: 14.0,
    },
  ],
  rows: [
    {
      data: [
        {
          field: "Field",
          value: "Value",
        },
      ],
      options: {
        color: "#FF00FF",
        backgroundColor: "#FFF",
        fontSize: 14,
      },
    },
  ],
};

console.log(JSON.stringify(Valor));
