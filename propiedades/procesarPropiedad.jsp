<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="../WEB-INF/conexion.jspf" %>

<%
    // 1. Captura de parámetros del formulario
    String dir = request.getParameter("direccion");
    String ciu = request.getParameter("ciudad");
    String des = request.getParameter("descripcion");
    String estForm = request.getParameter("estado"); // Capturamos el estado
    
    // Captura del precio (obligatorio en la nueva tabla)
    String precioStr = request.getParameter("precio");
    double precio = 0.0;
    
    try {
        if (precioStr != null) precio = Double.parseDouble(precioStr);
    } catch (NumberFormatException e) {
        precio = 0.0;
    }

    // 2. Validación de seguridad para el ENUM 'estado'
    // Esto evita el error "Data truncated" si el valor no coincide exactamente
    String est = "Disponible"; // Valor por defecto
    if (estForm != null) {
        if (estForm.equals("Disponible") || estForm.equals("Arrendado") || estForm.equals("Vendido")) {
            est = estForm;
        }
    }

    if (conexion != null) {
        try {
            // 3. Consulta preparada con los 5 campos
            String sql = "INSERT INTO propiedades (direccion, estado, ciudad, descripcion, precio) VALUES (?, ?, ?, ?, ?)";
            PreparedStatement ps = conexion.prepareStatement(sql);
            
            ps.setString(1, dir);
            ps.setString(2, est);    // Usamos la variable validada
            ps.setString(3, ciu);
            ps.setString(4, des);
            ps.setDouble(5, precio);

            // 4. Ejecución
            ps.executeUpdate();
            
            // IMPORTANTE: Cerrar conexión antes de redirigir para evitar errores de saturación
            conexion.close();
            
            response.sendRedirect("../dashboards/dashboardAdmin.jsp?success=1"); 
            
        } catch (Exception e) {
            // Si hay error, intentamos cerrar la conexión si sigue abierta
            if (!conexion.isClosed()) conexion.close();
            out.print("Error al guardar: " + e.getMessage());
        }
    } else {
        out.print("Error: Sin conexión a la base de datos.");
    }
%>