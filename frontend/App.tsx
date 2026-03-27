import React from 'react';
import { Toaster } from "@/components/ui/toaster";
import { Toaster as Sonner } from "@/components/ui/sonner";
import { TooltipProvider } from "@/components/ui/tooltip";
import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import { BrowserRouter, Routes, Route, Navigate } from "react-router-dom";
import { AuthProvider } from "@/hooks/useAuth";
import DevRoleSwitcher from "./components/dev/DevRoleSwitcher";

// Pages
import Index from "./pages/Index";
import Login from "./pages/Login";
import NotFound from "./pages/NotFound";
import NotAuthorized from "./pages/NotAuthorized";

// Admin Pages
import AdminDashboard from "./pages/admin/AdminDashboard";
import UserManagement from "./pages/admin/UserManagement";
import SystemLogs from "./pages/admin/SystemLogs";

// Reviewer Pages
import ReviewerDashboard from "./pages/reviewer/ReviewerDashboard";
import ReviewQueue from "./pages/reviewer/ReviewQueue";
import DecisionHistory from "./pages/reviewer/DecisionHistory";
import InvoiceReview from "./pages/reviewer/InvoiceReview";

// Layout
import DashboardLayout from "./components/layout/DashboardLayout";

const queryClient = new QueryClient();

const App = () => (
  <QueryClientProvider client={queryClient}>
    <AuthProvider>
      <TooltipProvider>
        <Toaster />
        <Sonner />
        <DevRoleSwitcher />
        <BrowserRouter>
          <Routes>
            <Route path="/" element={<Index />} />

            <Route path="/login" element={<Login />} />

            {/* Not authorized — shown on 403 */}
            <Route path="/not-authorized" element={<NotAuthorized />} />

            {/* Admin routes — protected, admin role required */}
            <Route element={<DashboardLayout requiredRole="admin" />}>
              <Route path="/admin" element={<AdminDashboard />} />
              <Route path="/admin/users" element={<UserManagement />} />
              <Route path="/admin/logs" element={<SystemLogs />} />
            </Route>

            {/* Reviewer routes — protected, reviewer role required */}
            <Route element={<DashboardLayout requiredRole="reviewer" />}>
              <Route path="/reviewer" element={<ReviewerDashboard />} />
              <Route path="/reviewer/queue" element={<ReviewQueue />} />
              <Route path="/reviewer/history" element={<DecisionHistory />} />
              <Route path="/reviewer/invoice/:id" element={<InvoiceReview />} />
            </Route>

            <Route path="*" element={<NotFound />} />
          </Routes>
        </BrowserRouter>
      </TooltipProvider>
    </AuthProvider>
  </QueryClientProvider>
);

export default App;
