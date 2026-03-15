<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="conexion.jspf" %>

<%
    String idProp = request.getParameter("id");

    if (conexion != null && idProp != null) {
        try {
            String sql = "DELETE FROM propiedades WHERE id_propiedad = ?";
            PreparedStatement ps = conexion.prepareStatement(sql);
            ps.setInt(1, Integer.parseInt(idProp));
            ps.executeUpdate();
            conexion.close();
            response.sendRedirect("dashboardAdmin.jsp");
        } catch (Exception e) {
            out.print("Error al eliminar: " + e.getMessage());
        }
    }
%>