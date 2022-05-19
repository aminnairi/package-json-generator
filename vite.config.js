import { defineConfig } from "vite";
import elm from "vite-plugin-elm";

export default defineConfig({
  root: "src",
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
