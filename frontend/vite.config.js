import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'
import path from "path";

// https://vite.dev/config/
export default defineConfig({
  plugins: [react()],
  resolve: {
    alias: {
      "comps": path.resolve(__dirname, "src/components"),
      "pages": path.resolve(__dirname, "src/pages"),
      "css": path.resolve(__dirname, "src/assets/stylesheets"),
    }
  }
})
