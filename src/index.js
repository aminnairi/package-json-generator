import { Elm } from "./Main.elm";

// writeStringToDisk :: String -> IO ()
const writeStringToDisk = string => {
  return Promise.resolve().then(() => {
    if (Object.prototype.toString.call(string) !== "[object String]") {
      return Promise.reject(new Error("Incorrect type of data to write to the disk."));
    }

    if (Object.prototype.toString.call(window.showSaveFilePicker) !== "[object Function]") {
      return Promise.reject(new Error("Device or browser not supported")); 
    }

    const promise = window.showSaveFilePicker({
      suggestedName: "package.json"
    });

    if (Object.prototype.toString.call(promise) !== "[object Promise]") {
      return Promise.reject(new Error("Device or browser incorrectly supports this functionality"));
    }

    return promise;
  }).then(handle => {
    return handle.createWritable();
  }).then(writable => {
    return writable.write(string).then(() => {
      return writable.close();
    });
  });
};

const link = window.document.createElement("link");

link.setAttribute("rel", "stylesheet");
link.setAttribute("href", "https://fonts.googleapis.com/css2?family=Poppins:wght@200;400&display=swap");

window.document.head.appendChild(link);

const elm = Elm.Main.init({
  node: document.getElementById("elm"),
  flags: window.innerWidth
});

elm.ports.vibrate.subscribe(() => {
  window.navigator.vibrate(100);
});

elm.ports.copyToClipboard.subscribe((model) => {
  window.navigator.clipboard.writeText(model).then(() => {
    elm.ports.copyToClipboardNotification.send("Successfully copied to clipboard");
  }).catch(() => {
    elm.ports.copyToClipboardNotification.send("Failed to copy to the clipboard");
  });
});

elm.ports.saveToDisk.subscribe(model => {
  writeStringToDisk(model).then(() => {
    elm.ports.copyToClipboardNotification.send("Successfully saved to disk");
  }).catch(error => {
    elm.ports.copyToClipboardNotification.send(`Failed to save to disk: ${error.message}`);
  });
});
