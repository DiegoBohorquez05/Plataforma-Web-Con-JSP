<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="../WEB-INF/conexion.jspf" %>
<%
    try {
        // Captura de datos
        String idProp = request.getParameter("id_propiedad");
        String fecha = request.getParameter("txtFecha");
        String hora = request.getParameter("txtHora");
        Integer idCli = (Integer) session.getAttribute("idCliente");

        if (idCli != null && idProp != null && fecha != null) {
            // SQL corregido con los nombres exactos de tus imágenes
            String sql = "INSERT INTO citas (id_cliente, id_propiedad, fecha_cita, hora_cita, estado, fk_cita_cliente, fk_cita_propiedad) VALUES (?, ?, ?, ?, 'Pendiente', ?, ?)";
            
            PreparedStatement ps = conexion.prepareStatement(sql);
            ps.setInt(1, idCli);
            ps.setInt(2, Integer.parseInt(idProp));
            ps.setString(3, fecha);
            ps.setString(4, hora); // Soluciona error hora_cita
            ps.setInt(5, idCli);   // Llena fk_cita_cliente
            ps.setInt(6, Integer.parseInt(idProp)); // Llena fk_cita_propiedad

            ps.executeUpdate();
            ps.close();
            conexion.close();
            response.sendRedirect("misCitas.jsp?res=ok");
        } else {
            response.sendRedirect("loginCliente.jsp");
        }
    } catch (Exception e) {
        out.print("Error al agendar: " + e.getMessage());
    }
%>