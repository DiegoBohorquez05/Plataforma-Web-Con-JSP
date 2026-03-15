<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="../WEB-INF/conexion.jspf" %>

<%
    // 1. Recuperar los datos del formulario
    String idStr = request.getParameter("id_propiedad");
    String direccion = request.getParameter("direccion");
    String estado = request.getParameter("estado");
    String ciudad = request.getParameter("ciudad");
    String precioStr = request.getParameter("precio");
    String descripcion = request.getParameter("descripcion");

    if (idStr != null && conexion != null) {
        try {
            // 2. Convertir valores numéricos
            int id = Integer.parseInt(idStr);
            double precio = Double.parseDouble(precioStr);

            // 3. Preparar la consulta SQL de actualización
            // Usamos PreparedStatement para mayor seguridad contra Inyección SQL
            String sql = "UPDATE propiedades SET direccion = ?, estado = ?, ciudad = ?, precio = ?, descripcion = ? WHERE id_propiedad = ?";
            
            java.sql.PreparedStatement ps = conexion.prepareStatement(sql);
            ps.setString(1, direccion);
            ps.setString(2, estado);
            ps.setString(3, ciudad);
            ps.setDouble(4, precio);
            ps.setString(5, descripcion);
            ps.setInt(6, id);

            // 4. Ejecutar la actualización
            int filasAfectadas = ps.executeUpdate();

            ps.close();
            conexion.close();

            // 5. Redirigir al dashboard con éxito
            if (filasAfectadas > 0) {
                response.sendRedirect("../dashboards/dashboardAdmin.jsp?res=ok_update");
            } else {
                response.sendRedirect("../dashboards/dashboardAdmin.jsp?res=error");
            }

        } catch (Exception e) {
            out.print("Error al actualizar: " + e.getMessage());
            // En caso de error, es vital cerrar la conexión si sigue abierta
            if(conexion != null) conexion.close();
        }
    } else {
        response.sendRedirect("../dashboards/dashboardAdmin.jsp?res=id_missing");
    }
%>