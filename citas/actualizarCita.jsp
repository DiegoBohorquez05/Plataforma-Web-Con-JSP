<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ include file="../WEB-INF/conexion.jspf" %>

<%
    String idCita = request.getParameter("id_cita");
    String nuevoEstado = request.getParameter("nuevo_estado");

    if (idCita != null && nuevoEstado != null) {
        try {
            // 1. Actualización (Esto ya te funciona, el error es lo que sigue)
            String sql = "UPDATE citas SET estado = ? WHERE id_cita = ?";
            PreparedStatement ps = conexion.prepareStatement(sql);
            ps.setString(1, nuevoEstado);
            ps.setInt(2, Integer.parseInt(idCita));
            ps.executeUpdate();
            ps.close();

            // 2. LA SOLUCIÓN AL 404: 
            // Usamos una ruta relativa simple. Si están en la misma carpeta, solo pon el nombre.
            response.sendRedirect("../dashboards/dashboardInmo.jsp"); 

        } catch (Exception e) {
            out.print("Error: " + e.getMessage());
        }
    }
%>