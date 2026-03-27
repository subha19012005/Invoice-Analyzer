import { defineConfig } from "vite";
import react from "@vitejs/plugin-react-swc";
import path from "path";
import { componentTagger } from "lovable-tagger";

export default defineConfig(({ mode }) => ({
  server: {
    host: "::",
    port: 8080,
    hmr: { overlay: false },
    proxy: {
      "/auth": {
        target: "http://localhost:8000",
        changeOrigin: true,
        secure: false,
      },
      "/dev-login": {
        target: "http://localhost:8000",
        changeOrigin: true,
        secure: false,
      },
      "/dev-validate": {
        target: "http://localhost:8000",
        changeOrigin: true,
        secure: false,
      },
      "/dev-switch": {
        target: "http://localhost:8000",
        changeOrigin: true,
        secure: false,
      },
      "/invoices": {
        target: "http://localhost:8000",
        changeOrigin: true,
        secure: false,
      },
      "/users": {
        target: "http://localhost:8000",
        changeOrigin: true,
        secure: false,
      },
      "/logs": {
        target: "http://localhost:8000",
        changeOrigin: true,
        secure: false,
      },
      "/metrics": {
        target: "http://localhost:8000",
        changeOrigin: true,
        secure: false,
      },
      "/ingestion": {
        target: "http://localhost:8000",
        changeOrigin: true,
        secure: false,
      },
      "/ingestion-logs": {
        target: "http://localhost:8000",
        changeOrigin: true,
        secure: false,
      },
    },
  },
  plugins: [react(), mode === "development" && componentTagger()].filter(Boolean),
  resolve: {
    alias: {
      "@": path.resolve(__dirname, "./frontend"),
    },
  },
  root: "./frontend",
}));
