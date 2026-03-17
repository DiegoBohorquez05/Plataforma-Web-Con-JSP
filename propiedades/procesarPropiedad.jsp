<%-- Importación de clases SQL necesaria --%>
<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="../WEB-INF/conexion.jspf" %>

<%
    // 1. Captura del ID de la inmobiliaria desde la SESIÓN
    // Usamos el nombre que definimos en el loginInmobiliaria.jsp
    Integer idInmoSesion = (Integer) session.getAttribute("idInmobiliaria");

    // Si no hay sesión iniciada, redirigimos al login por seguridad
    if (idInmoSesion == null) {
        response.sendRedirect("../logins/loginInmobiliaria.jsp");
        return;
    }

    // 2. Captura de parámetros del formulario
    String dir = request.getParameter("direccion");
    String ciu = request.getParameter("ciudad");
    String des = request.getParameter("descripcion");
    String estForm = request.getParameter("estado");
    
    // Captura del precio
    String precioStr = request.getParameter("precio");
    double precio = 0.0;
    try {
        if (precioStr != null) precio = Double.parseDouble(precioStr);
    } catch (NumberFormatException e) {
        precio = 0.0;
    }

    // Validación de seguridad para el estado
    String est = "Disponible"; 
    if (estForm != null) {
        if (estForm.equals("Disponible") || estForm.equals("Arrendado") || estForm.equals("Vendido")) {
            est = estForm;
        }
    }

    if (conexion != null) {
        try {
            // 3. Consulta preparada INCLUYENDO la llave foránea (fk_inmobiliaria o id_inmobiliaria)
            // Asegúrate de que el nombre de la columna en tu tabla 'propiedades' coincida (ej: fk_inmobiliaria)
            String sql = "INSERT INTO propiedades (direccion, estado, ciudad, descripcion, precio, fk_inmobiliaria) VALUES (?, ?, ?, ?, ?, ?)";
            PreparedStatement ps = conexion.prepareStatement(sql);
            
            ps.setString(1, dir);
            ps.setString(2, est);
            ps.setString(3, ciu);
            ps.setString(4, des);
            ps.setDouble(5, precio);
            ps.setInt(6, idInmoSesion); // Aquí guardamos quién registra la propiedad

            // 4. Ejecución
            ps.executeUpdate();
            
            // Cerrar recursos
            ps.close();
            conexion.close();
            
            // Redirección al dashboard de la inmobiliaria con mensaje de éxito
            response.sendRedirect("../dashboards/dashboardInmo.jsp?success=1"); 
            
        } catch (Exception e) {
            if (conexion != null && !conexion.isClosed()) conexion.close();
            out.print("Error al guardar: " + e.getMessage());
        }
    } else {
        out.print("Error: Sin conexión a la base de datos.");
    }
%>