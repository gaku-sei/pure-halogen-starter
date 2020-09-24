const Main = (() => {
  if (process.env.NODE_ENV === "production") {
    return require("./dce-output/Main");
  } else {
    return require("./output/Main");
  }
})();

function main() {
  Main.main({
    apiUrl: process.env.API_URL,
    globalMessage: process.env.GLOBAL_MESSAGE,
  })();
}

main();
