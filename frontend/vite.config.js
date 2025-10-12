import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'
import path from "path";

// https://vite.dev/config/
export default defineConfig({
  plugins: [react()],
  resolve: {
    alias: {
      "data": path.resolve(__dirname, "src/data"),
      "comps": path.resolve(__dirname, "src/components"),
      "pages": path.resolve(__dirname, "src/pages"),
      "css": path.resolve(__dirname, "src/assets/stylesheets"),
      "images": path.resolve(__dirname, "src/assets/images")
    }
  }
})
