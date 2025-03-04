import { app, BrowserWindow, shell, ipcMain, Tray, Menu } from "electron";
import { createRequire } from "node:module";
import { fileURLToPath } from "node:url";
import path from "node:path";
import os from "node:os";
import { update } from "./update";
import isDev from "electron-is-dev";
import fs from "fs";
import { exec, execFile } from "node:child_process";
import AutoLaunch from "auto-launch";
import psList from "ps-list";
import { updateElectronApp } from "update-electron-app";

updateElectronApp();

// Configure auto-launcher
const appLauncher = new AutoLaunch({
  name: "bvp-auto-sign",
  isHidden: false,
});

const require = createRequire(import.meta.url);
const __dirname = path.dirname(fileURLToPath(import.meta.url));

// The built directory structure
//
// ├─┬ dist-electron
// │ ├─┬ main
// │ │ └── index.js    > Electron-Main
// │ └─┬ preload
// │   └── index.mjs   > Preload-Scripts
// ├─┬ dist
// │ └── index.html    > Electron-Renderer
//
process.env.APP_ROOT = path.join(__dirname, "../..");

export const MAIN_DIST = path.join(process.env.APP_ROOT, "dist-electron");
export const RENDERER_DIST = path.join(process.env.APP_ROOT, "dist");
export const VITE_DEV_SERVER_URL = process.env.VITE_DEV_SERVER_URL;

process.env.VITE_PUBLIC = VITE_DEV_SERVER_URL
  ? path.join(process.env.APP_ROOT, "public")
  : RENDERER_DIST;

// Disable GPU Acceleration for Windows 7
if (os.release().startsWith("6.1")) app.disableHardwareAcceleration();

// Set application name for Windows 10+ notifications
if (process.platform === "win32") app.setAppUserModelId(app.getName());

if (!app.requestSingleInstanceLock()) {
  app.quit();
  process.exit(0);
}

let win: BrowserWindow | null = null;
const preload = path.join(__dirname, "../preload/index.mjs");
const indexHtml = path.join(RENDERER_DIST, "index.html");

let isQuiting = false;

async function createWindow() {
  win = new BrowserWindow({
    title: "Main window",
    icon: path.join(process.env.VITE_PUBLIC, "favicon.ico"),
    webPreferences: {
      preload,
      // Warning: Enable nodeIntegration and disable contextIsolation is not secure in production
      // nodeIntegration: true,

      // Consider using contextBridge.exposeInMainWorld
      // Read more on https://www.electronjs.org/docs/latest/tutorial/context-isolation
      // contextIsolation: false,
    },
    width: 720,
    height: 680,
    autoHideMenuBar: true,
  });

  win.webContents.session.spellCheckerEnabled = false;

  if (VITE_DEV_SERVER_URL) {
    // #298
    win.loadURL(VITE_DEV_SERVER_URL);
    // Open devTool if the app is not packaged
    win.webContents.openDevTools();
  } else {
    win.loadFile(indexHtml);
  }

  // Test actively push message to the Electron-Renderer
  win.webContents.on("did-finish-load", () => {
    win?.webContents.send("main-process-message", new Date().toLocaleString());
  });

  // Make all links open with the browser, not with the application
  win.webContents.setWindowOpenHandler(({ url }) => {
    if (url.startsWith("https:")) shell.openExternal(url);
    return { action: "deny" };
  });

  win.on("close", (event) => {
    if (!isQuiting) {
      event.preventDefault();
      win?.hide();
    }
  });

  // Auto update
  // update(win);
  // resetStaus();
}

app.on("ready", createWindow);

app.on("window-all-closed", () => {
  // if (process.platform !== "darwin") {
  //     app.quit();
  // }
});

const handleQuit = async () => {
  // win?.close();
  await resetStaus();
  stopAhk();
  isQuiting = true;
  app.quit();
};

// app.whenReady().then(createWindow);
app.whenReady().then(() => {
  const tray = new Tray(path.join(process.env.VITE_PUBLIC, "favicon.ico"));
  const contextMenu = Menu.buildFromTemplate([
    { label: "Thoát", type: "normal", click: handleQuit },
  ]);
  tray.setToolTip("Tự động ký - Bệnh viện Phổi");
  tray.setContextMenu(contextMenu);
  tray.addListener("click", () => createWindow());
});

app.on("window-all-closed", () => {
  win = null;
  if (process.platform !== "darwin") app.quit();
});

app.on("second-instance", () => {
  if (win) {
    // Focus on the main window if the user tried to open another
    if (win.isMinimized()) win.restore();
    win.focus();
  }
});

app.on("activate", () => {
  const allWindows = BrowserWindow.getAllWindows();
  if (allWindows.length) {
    allWindows[0].focus();
  } else {
    createWindow();
  }
});

// New window example arg: new windows url
ipcMain.handle("open-win", (_, arg) => {
  const childWindow = new BrowserWindow({
    webPreferences: {
      preload,
      nodeIntegration: true,
      contextIsolation: false,
    },
  });

  if (VITE_DEV_SERVER_URL) {
    childWindow.loadURL(`${VITE_DEV_SERVER_URL}#${arg}`);
  } else {
    childWindow.loadFile(indexHtml, { hash: arg });
  }
});

function getDepartmentDataPath() {
  return isDev
    ? path.join(__dirname, "../../src/configs/department-config.json") // Dev: Project directory
    : path.join(process.resourcesPath, "configs/department-config.json"); // Prod: Resources folder
}

ipcMain.handle("read-department-data", async () => {
  try {
    const dataPath = getDepartmentDataPath();
    const rawData = await fs.promises.readFile(dataPath, "utf8");
    return JSON.parse(rawData);
  } catch (error) {
    console.error("Error reading data:", error);
    return null;
  }
});

function getUserDataPath() {
  return isDev
    ? path.join(__dirname, "../../src/configs/user-config.json") // Dev: Project directory
    : path.join(process.resourcesPath, "configs/user-config.json"); // Prod: Resources folder
}

ipcMain.handle("read-user-data", async () => {
  try {
    const dataPath = getUserDataPath();
    const rawData = await fs.promises.readFile(dataPath, "utf8");
    return JSON.parse(rawData);
  } catch (error) {
    console.error("Error reading data:", error);
    return null;
  }
});

ipcMain.handle("update-user-data", async (events, { data }) => {
  try {
    const updatedData = JSON.stringify(data, null, 2);
    fs.writeFile(getUserDataPath(), updatedData, "utf8", (err) => {
      if (err) {
        console.error("Error writing to the file:", err);
        return;
      }
      console.log("Successfully updated running to true.");
    });
  } catch (error) {
    console.error("Error reading data:", error);
    return null;
  }
});

const ahkPath = "C:\\Program Files\\AutoHotkey\\v2\\AutoHotkey64.exe"; // Adjust if needed

function getAhkPath() {
  return isDev
    ? path.join(__dirname, "../../src/ahks") // Dev: Project directory
    : path.join(process.resourcesPath, "ahks"); // Prod: Resources folder
}

const autoFillAhk = (autoSignPath: string, agrArr: Array<string>) =>
  new Promise((resolve, reject) => {
    const executePath = path.join(getAhkPath(), autoSignPath);

    execFile(
      ahkPath,
      [executePath, ...agrArr],
      (error: any, stdout: any, stderr: any) => {
        win?.webContents.send("ahk-status", false);
        if (error) {
          console.error(`Error: ${error.message}`);
          reject();
          return;
        }
        if (stderr) {
          console.error(`AHK Error: ${stderr}`);
          reject();
          return;
        }
        console.log("AHK done!");
        resolve("done");
      }
    );

    win?.webContents.send("ahk-status", true);
  });

ipcMain.handle("run-ahk", async (events, { path, agrArr }) => {
  try {
    const result = await autoFillAhk(path, agrArr);
    console.log({ result });
  } catch (error) {
    console.error("Error reading data:", error);
    return null;
  }
});

const stopAhk = async () => {
  try {
    exec("taskkill /IM AutoHotkey64.exe /F", (error, stdout, stderr) => {
      if (error) {
        console.error(`Error: ${error.message}`);
        return;
      }
      if (stderr) {
        console.error(`stderr: ${stderr}`);
        return;
      }
      console.log(`stdout: ${stdout}`);
    });
  } catch (error) {
    console.error("Error reading data:", error);
    return null;
  }
};

ipcMain.handle("stop-ahk", stopAhk);

ipcMain.handle("minimize", async (event) => {
  try {
    win?.hide();
  } catch (error) {
    console.error("Error reading data:", error);
    return null;
  }
});

const resetStaus = async () => {
  try {
    const dataPath = getUserDataPath();
    const rawData = await fs.promises.readFile(dataPath, "utf8");
    const data = JSON.parse(rawData);
    const resetStatusData = { ...data, isRunning: false };
    exec("taskkill /IM AutoHotkey64.exe /F", (error, stdout, stderr) => {
      if (error) {
        console.error(`Error: ${error.message}`);
        return;
      }
      if (stderr) {
        console.error(`stderr: ${stderr}`);
        return;
      }
      console.log(`stdout: ${stdout}`);
    });

    const updatedData = JSON.stringify(resetStatusData, null, 2);
    fs.writeFile(getUserDataPath(), updatedData, "utf8", (err) => {
      if (err) {
        console.error("Error writing to the file:", err);
        return;
      }
      console.log("Successfully updated running to true.");
    });
  } catch (error) {
    console.error("Error reading data:", error);
    return null;
  }
};

ipcMain.handle("toggle-auto-launch", async (event, enable) => {
  try {
    if (enable) {
      await appLauncher.enable();
    } else {
      await appLauncher.disable();
    }
    return true;
  } catch (error) {
    console.error("Auto-launch error:", error);
    return false;
  }
});

ipcMain.handle("check-auto-launch", async () => {
  const result = await appLauncher.isEnabled();
  return result;
});

const checkAutoHotkey = async () => {
  try {
    const processes = await psList();
    const ahkProcesses = processes.filter(
      (p) =>
        p.name.toLowerCase() === "autohotkey64.exe" ||
        p.name.toLowerCase() === "autohotkey"
    );

    return ahkProcesses.length > 0;
  } catch (error) {
    console.error("Process check error:", error);
    return false;
  }
};

ipcMain.handle("check-auto-hotkey-running", async () => {
  const result = await checkAutoHotkey();
  return result;
});
