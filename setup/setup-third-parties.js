const runScript = async () => {
  const { exec } = await import("child_process");
  const path = await import("path");
  const { fileURLToPath } = await import("url");

  const __filename = fileURLToPath(import.meta.url);
  const __dirname = path.dirname(__filename);

  const psFilePath = path.join(
    __dirname,
    "win-unpacked/resources/configs/setup.ps1"
  );

  const bat = exec(
    `powershell -Command "Start-Process powershell -ArgumentList '-NoExit -File \"${psFilePath}\"' -Verb runAs"`
  );

  bat.stdout.on("data", (data) => {
    console.log(data);
  });

  bat.stderr.on("data", (data) => {
    console.error(data);
  });
};

// Export the function using module.exports
export default runScript;
