<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="../WEB-INF/conexion.jspf" %>

<%
    // 1. Capturamos los datos del formulario de login
    String userForm = request.getParameter("adminUser");
    String passForm = request.getParameter("adminPass");

    if (conexion != null) {
        try {
            // 2. Consulta usando las columnas de tu nueva tabla 'administradores'
            // Usamos Prepared Statement para evitar inyección SQL
            String sql = "SELECT usuario FROM administradores WHERE usuario = ? AND password = ?";
            PreparedStatement ps = conexion.prepareStatement(sql);
            ps.setString(1, userForm);
            ps.setString(2, passForm);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                // 3. Si los datos son correctos, creamos la sesión
                session.setAttribute("usuarioAdmin", rs.getString("usuario"));
                response.sendRedirect("../dashboards/dashboardAdmin.jsp");
            } else {
                // 4. Si fallan los datos, regresamos con error
                response.sendRedirect("loginAdministrador.jsp?error=1");
            }
            
            // IMPORTANTE: Cerramos la conexión después de procesar todo para evitar 
            // el error de 'max_user_connections'
            conexion.close();

        } catch (Exception e) {
            // Manejo de errores sin cerrar la conexión prematuramente
            out.print("Error en la validación: " + e.getMessage());
        }
    } else {
        out.print("Error: No se pudo establecer la conexión con la base de datos.");
    }
%>