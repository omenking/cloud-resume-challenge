import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'
import path from "path";

const mock_server = {
  name: "mock-counter",
  configureServer(server) {
    let count = 0; // in-memory mock state

    server.middlewares.use("/counter", async (req, res, next) => {
      res.setHeader("Content-Type", "application/json");

      if (req.method === "GET") {
        res.end(JSON.stringify({ count }));
        return;
      }

      if (req.method === "POST") {
        count += 1;
        res.end(JSON.stringify({ count }));
        return;
      }

      next();
    });
  },
}
// https://vite.dev/config/
export default defineConfig({
  plugins: [react(),mock_server],
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
