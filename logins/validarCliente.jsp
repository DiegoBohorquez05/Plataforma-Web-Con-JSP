<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="../WEB-INF/conexion.jspf" %>

<%
    // 1. Capturamos los datos del formulario de login de clientes
    String emailForm = request.getParameter("email");
    String passForm = request.getParameter("password");

    if (conexion != null) {
        try {
            // 2. Consulta para validar al cliente
            // IMPORTANTE: Pedimos id_cliente y nombre para la sesión
            String sql = "SELECT id_cliente, nombre FROM clientes WHERE email = ? AND password = ?";
            PreparedStatement ps = conexion.prepareStatement(sql);
            ps.setString(1, emailForm);
            ps.setString(2, passForm);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                // 3. Login Exitoso: Guardamos datos vitales en la sesión
                session.setAttribute("idCliente", rs.getInt("id_cliente"));
                session.setAttribute("nombreCliente", rs.getString("nombre"));
                
                // CERRAMOS la conexión antes de irnos para liberar espacio en Clever Cloud
                conexion.close();
                response.sendRedirect("../index.jsp");
            } else {
                // 4. Login Fallido
                conexion.close(); // También cerramos aquí
                response.sendRedirect("loginCliente.jsp?error=1");
            }

        } catch (Exception e) {
            // En caso de error, intentamos cerrar la conexión si no se cerró arriba
            try { if(conexion != null) conexion.close(); } catch(Exception ex) {}
            out.print("Error en la validación: " + e.getMessage());
        }
    } else {
        out.print("error de conexion: No se pudo conectar a la base de datos.");
    }
%>