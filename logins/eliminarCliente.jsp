<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="../WEB-INF/conexion.jspf" %>

<%
    String id = request.getParameter("id");
    if (id != null && conexion != null) {
        try {
            // Nota: Si el cliente tiene citas o reseñas, 
            // la base de datos podría dar error de llave foránea.
            String sql = "DELETE FROM clientes WHERE id_cliente = ?";
            java.sql.PreparedStatement ps = conexion.prepareStatement(sql);
            ps.setInt(1, Integer.parseInt(id));
            ps.executeUpdate();
            ps.close();
            conexion.close();
            response.sendRedirect("../dashboards/dashboardAdmin.jsp?res=client_deleted");
        } catch (Exception e) {
            out.print("Error: No se puede eliminar el cliente (posiblemente tiene citas activas). " + e.getMessage());
        }
    }
%>