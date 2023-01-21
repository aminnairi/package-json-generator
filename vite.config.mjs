import {defineConfig} from "vite";
import {plugin as elm} from "vite-plugin-elm";

export default defineConfig({
  root: "src",
  base: "https://aminnairi.github.io/package-json-generator/",
  server: {
    port: process.env.VITE_SERVER_PORT,
    host: process.env.VITE_SERVER_HOST
  },
  build: {
    outDir: "../docs",
    emptyOutDir: true
  },
  plugins: [
    elm()
  ]
});
