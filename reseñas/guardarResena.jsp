<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="../WEB-INF/conexion.jspf" %>
<%
    try {
        String comentario = request.getParameter("comentario");
        int puntos = Integer.parseInt(request.getParameter("puntuacion"));
        Integer idCli = (Integer) session.getAttribute("idCliente");

        if (idCli != null) {
            // Incluimos id_cliente y fk_resena_cliente según tu estructura
            String sql = "INSERT INTO resenas (id_cliente, comentario, puntuacion, fk_resena_cliente) VALUES (?, ?, ?, ?)";
            
            PreparedStatement ps = conexion.prepareStatement(sql);
            ps.setInt(1, idCli);
            ps.setString(2, comentario);
            ps.setInt(3, puntos);
            ps.setInt(4, idCli); // Llena la columna obligatoria fk_resena_cliente

            ps.executeUpdate();
            ps.close();
            conexion.close();
            response.sendRedirect("index.jsp?resena=ok");
        }
    } catch (Exception e) {
        out.print("Error al guardar reseña: " + e.getMessage());
    }
%>