<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="../WEB-INF/conexion.jspf" %>

<%
    // 1. Recibimos los datos del formulario
    String nombreForm = request.getParameter("nombre");
    String emailForm  = request.getParameter("email");
    // Cambiamos el nombre de la variable a 'passForm' para evitar 
    // el error de duplicidad con la variable 'pass' de conexion.jspf
    String passForm   = request.getParameter("password");

    if (conexion != null) {
        try {
            // 2. Consulta para insertar el nuevo cliente
            // Asegúrate de que los nombres de las columnas coincidan con tu tabla 'clientes'
            String sql = "INSERT INTO clientes (nombre, email, password) VALUES (?, ?, ?)";
            
            PreparedStatement ps = conexion.prepareStatement(sql);
            ps.setString(1, nombreForm);
            ps.setString(2, emailForm);
            ps.setString(3, passForm);
            
            // 3. Ejecutar la inserción en la base de datos
            int filasInsertadas = ps.executeUpdate();

            if (filasInsertadas > 0) {
                // Registro exitoso -> Redirigir al login con mensaje de éxito
                response.sendRedirect("loginCliente.jsp?registro=exito");
            } else {
                out.print("No se pudo completar el registro. Inténtalo de nuevo.");
            }
            
            // 4. Cerrar conexión para liberar recursos
            conexion.close();
            
        } catch (Exception e) {
            // Mostrar error detallado en caso de fallo en el SQL
            out.print("Error al registrar en la base de datos: " + e.getMessage());
        }
    } else {
        out.print("Error: No se pudo establecer conexión con la base de datos.");
    }
%>