<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="../WEB-INF/conexion.jspf" %>
<%
    try {
        String comentario = request.getParameter("comentario");
        int puntos = Integer.parseInt(request.getParameter("puntuacion"));
        Integer idCli = (Integer) session.getAttribute("idCliente");

        if (idCli != null) {
            // CORRECCIÓN: Solo usamos las columnas que REALMENTE existen en tu tabla
            String sql = "INSERT INTO resenas (id_cliente, comentario, puntuacion) VALUES (?, ?, ?)";

            java.sql.PreparedStatement ps = conexion.prepareStatement(sql);
            ps.setInt(1, idCli);
            ps.setString(2, comentario);
            ps.setInt(3, puntos);

            ps.executeUpdate();
            
            // Cerrar recursos para evitar el error de conexiones excedidas
            ps.close();
            conexion.close();

            response.sendRedirect("../index.jsp?resena=ok");
        } else {
            response.sendRedirect("../logins/loginCliente.jsp");
        }
    } catch (Exception e) {
        out.print("Error al guardar reseña: " + e.getMessage());
        if(conexion != null) conexion.close();
    }
%>