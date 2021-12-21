module.exports = (srv) => {
  console.log(`>>>Service name: ${srv.name}, is served at path ${srv.path}`);

  srv.after("READ", "Competitions", (data) => {
    const newComp = [];

    data.forEach((item) => {
      if (item.country === "Romania") {
        item.description =
          "10% off from the registration fee >>>" + item.description;
      }

      newComp.push(item);
    });
    console.log(newComp);
    return newComp;
  });
};
