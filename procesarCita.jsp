<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="conexion.jspf" %>
<%
    try {
        int idCliente = (Integer) session.getAttribute("idCliente");
        int idPropiedad = Integer.parseInt(request.getParameter("id_propiedad"));
        String fecha = request.getParameter("fecha");
        String hora = request.getParameter("hora");
        String fechaHoraStr = fecha + " " + hora + ":00";

        String sql = "INSERT INTO citas (id_cliente, id_propiedad, fecha_cita, estado) VALUES (?, ?, ?, 'Pendiente')";
        PreparedStatement ps = conexion.prepareStatement(sql);
        ps.setInt(1, idCliente);
        ps.setInt(2, idPropiedad);
        ps.setString(3, fechaHoraStr);

        ps.executeUpdate();
        conexion.close();
        
        response.sendRedirect("misCitas.jsp?msg=ok");
    } catch (Exception e) {
        out.print("Error al agendar: " + e.getMessage());
    }
%>