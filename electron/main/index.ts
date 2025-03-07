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

// Types
interface UserConfig {
  isRunning: boolean;
  [key: string]: any;
}

// Constants
const APP_NAME = "bvp-auto-sign";
const AHK_EXECUTABLE = "AutoHotkey64.exe";
const AHK_PATH = "C:\\Program Files\\AutoHotkey\\v2\\AutoHotkey64.exe";

// File paths and environment setup
const require = createRequire(import.meta.url);
const __dirname = path.dirname(fileURLToPath(import.meta.url));
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

// Auto Launch configuration
const appLauncher = new AutoLaunch({
  name: APP_NAME,
  isHidden: false,
});

// Path utilities
const getConfigPath = (filename: string): string => {
  return isDev
    ? path.join(__dirname, `../../src/configs/${filename}`)
    : path.join(process.resourcesPath, `configs/${filename}`);
};

const getAhkPath = (): string => {
  return isDev
    ? path.join(__dirname, "../../src/ahks")
    : path.join(process.resourcesPath, "ahks");
};

// Window management
async function createWindow() {
  win = new BrowserWindow({
    title: "Main window",
    icon: path.join(process.env.VITE_PUBLIC, "favicon.ico"),
    webPreferences: {
      preload,
    },
    width: 720,
    height: 680,
    autoHideMenuBar: true,
  });

  win.webContents.session.spellCheckerEnabled = false;

  if (VITE_DEV_SERVER_URL) {
    await win.loadURL(VITE_DEV_SERVER_URL);
    win.webContents.openDevTools();
  } else {
    await win.loadFile(indexHtml);
  }

  setupWindowEvents(win);
  update(win);
}

function setupWindowEvents(window: BrowserWindow) {
  window.webContents.on("did-finish-load", () => {
    window?.webContents.send(
      "main-process-message",
      new Date().toLocaleString()
    );
  });

  window.webContents.setWindowOpenHandler(({ url }) => {
    if (url.startsWith("https:")) shell.openExternal(url);
    return { action: "deny" };
  });

  window.on("close", (event) => {
    if (!isQuiting) {
      event.preventDefault();
      window?.hide();
    }
  });
}

// File operations
async function readJsonFile<T>(filePath: string): Promise<T | null> {
  try {
    const rawData = await fs.promises.readFile(filePath, "utf8");
    return JSON.parse(rawData);
  } catch (error) {
    console.error("Error reading file:", error);
    return null;
  }
}

async function writeJsonFile<T>(filePath: string, data: T): Promise<void> {
  try {
    const jsonData = JSON.stringify(data, null, 2);
    await fs.promises.writeFile(filePath, jsonData, "utf8");
  } catch (error) {
    console.error("Error writing file:", error);
  }
}

// AutoHotkey operations
const autoFillAhk = async (
  autoSignPath: string,
  agrArr: string[]
): Promise<string> => {
  return new Promise((resolve, reject) => {
    const executePath = path.join(getAhkPath(), autoSignPath);
    win?.webContents.send("ahk-status", true);

    execFile(AHK_PATH, [executePath, ...agrArr], (error, stdout, stderr) => {
      win?.webContents.send("ahk-status", false);

      if (error || stderr) {
        console.error(error || stderr);
        reject(error || stderr);
        return;
      }

      console.log("AHK done!");
      resolve("done");
    });
  });
};

const stopAhk = async (): Promise<void> => {
  try {
    await new Promise<void>((resolve, reject) => {
      exec(`taskkill /IM ${AHK_EXECUTABLE} /F`, (error, stdout, stderr) => {
        if (error || stderr) {
          console.error(error || stderr);
          reject(error || stderr);
          return;
        }
        console.log(`AHK stopped: ${stdout}`);
        resolve();
      });
    });
  } catch (error) {
    console.error("Failed to stop AHK:", error);
  }
};

const checkAutoHotkey = async (): Promise<boolean> => {
  try {
    const processes = await psList();
    return processes.some(
      (p) =>
        p.name.toLowerCase() === AHK_EXECUTABLE.toLowerCase() ||
        p.name.toLowerCase() === "autohotkey"
    );
  } catch (error) {
    console.error("Process check error:", error);
    return false;
  }
};

// Status management
const resetStatus = async (): Promise<void> => {
  try {
    const configPath = getConfigPath("user-config.json");
    const data = await readJsonFile<UserConfig>(configPath);
    if (data) {
      await stopAhk();
      await writeJsonFile(configPath, { ...data, isRunning: false });
    }
  } catch (error) {
    console.error("Error resetting status:", error);
  }
};

// Application event handlers
const handleQuit = async () => {
  await resetStatus();
  await stopAhk();
  isQuiting = true;
  app.quit();
};

// IPC Handlers
function setupIpcHandlers() {
  ipcMain.handle("read-common-data", () =>
    readJsonFile(getConfigPath("common-config.json"))
  );

  ipcMain.handle("read-user-data", () =>
    readJsonFile(getConfigPath("user-config.json"))
  );

  ipcMain.handle("update-user-data", async (_, { data }) =>
    writeJsonFile(getConfigPath("user-config.json"), data)
  );

  ipcMain.handle("run-ahk", async (_, { path, agrArr }) => {
    try {
      return await autoFillAhk(path, agrArr);
    } catch (error) {
      console.error("Error running AHK:", error);
      return null;
    }
  });

  ipcMain.handle("stop-ahk", stopAhk);

  ipcMain.handle("minimize", () => win?.hide());

  ipcMain.handle("toggle-auto-launch", async (_, enable) => {
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

  ipcMain.handle("check-auto-launch", () => appLauncher.isEnabled());

  ipcMain.handle("check-auto-hotkey-running", checkAutoHotkey);

  ipcMain.handle("get-electron-version", () => app.getVersion());
}

// Application initialization
function initializeApp() {
  if (os.release().startsWith("6.1")) {
    app.disableHardwareAcceleration();
  }

  if (process.platform === "win32") {
    app.setAppUserModelId(app.getName());
  }

  if (!app.requestSingleInstanceLock()) {
    app.quit();
    process.exit(0);
  }

  setupIpcHandlers();
}

// Application event listeners
function setupAppEventListeners() {
  app.on("ready", createWindow);

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
      if (win.isMinimized()) win.restore();
      win.focus();
    }
  });

  app.on("activate", () => {
    if (BrowserWindow.getAllWindows().length) {
      BrowserWindow.getAllWindows()[0].focus();
    } else {
      createWindow();
    }
  });
}

// Initialize application
initializeApp();
setupAppEventListeners();
