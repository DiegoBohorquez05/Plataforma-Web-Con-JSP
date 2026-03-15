<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="../WEB-INF/conexion.jspf" %>
<%
    // Verificamos sesión activa para proteger la página
    Integer idCli = (Integer) session.getAttribute("idCliente");
    if (idCli == null) {
        response.sendRedirect("../login/loginCliente.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Mis Citas - InmoHome</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/4.6.0/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
</head>
<body class="bg-light">

<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
    <div class="container">
        <a class="navbar-brand text-warning font-weight-bold" href="../index.jsp">INMOHOME</a>
        <div class="ml-auto">
            <a href="../index.jsp" class="btn btn-outline-light btn-sm">Volver al Inicio</a>
        </div>
    </div>
</nav>

<div class="container mt-5">
    <h2 class="mb-4"><i class="fas fa-calendar-check text-primary"></i> Mi Historial de Visitas</h2>

    <% if (request.getParameter("msj") != null) { %>
        <div class="alert alert-success alert-dismissible fade show">
            ¡Cita agendada correctamente! El administrador revisará tu solicitud.
            <button type="button" class="close" data-dismiss="alert">&times;</button>
        </div>
    <% } %>

    <div class="table-responsive shadow-sm bg-white rounded">
        <table class="table table-hover mb-0">
            <thead class="thead-dark">
                <tr>
                    <th>ID</th>
                    <th>Propiedad (Dirección)</th>
                    <th>Ciudad</th>
                    <th>Fecha de Visita</th>
                    <th>Hora</th>
                    <th>Estado</th>
                </tr>
            </thead>
            <tbody>
                <% 
                    if (conexion != null) {
                        try {
                            // Consultamos las citas del cliente actual uniendo con propiedades
                            String sql = "SELECT c.id_cita, p.direccion, p.ciudad, c.fecha_cita, c.hora_cita, c.estado " +
                                         "FROM citas c " +
                                         "JOIN propiedades p ON c.id_propiedad = p.id_propiedad " +
                                         "WHERE c.id_cliente = ? " +
                                         "ORDER BY c.fecha_cita DESC";
                            
                            PreparedStatement ps = conexion.prepareStatement(sql);
                            ps.setInt(1, idCli);
                            ResultSet rs = ps.executeQuery();

                            boolean tieneCitas = false;
                            while (rs.next()) {
                                tieneCitas = true;
                                String estado = rs.getString("estado");
                                String badgeClass = "badge-secondary"; // Pendiente
                                if (estado.equals("Confirmada")) badgeClass = "badge-success";
                                if (estado.equals("Cancelada")) badgeClass = "badge-danger";
                %>
                <tr>
                    <td><strong>#<%= rs.getInt("id_cita") %></strong></td>
                    <td><%= rs.getString("direccion") %></td>
                    <td><%= rs.getString("ciudad") %></td>
                    <td><%= rs.getString("fecha_cita") %></td>
                    <td><%= rs.getString("hora_cita") %></td>
                    <td><span class="badge <%= badgeClass %> p-2"><%= estado %></span></td>
                </tr>
                <% 
                            }
                            if (!tieneCitas) {
                                out.print("<tr><td colspan='6' class='text-center py-4'>No has solicitado citas aún.</td></tr>");
                            }
                            ps.close();
                            conexion.close();
                        } catch (Exception e) {
                            out.print("<tr><td colspan='6' class='text-danger'>Error al cargar citas: " + e.getMessage() + "</td></tr>");
                        }
                    } 
                %>
            </tbody>
        </table>
    </div>
</div>

<footer class="text-center py-4 mt-5 text-muted">
    <small>© 2026 InmoHome - Gestión de Citas Inmobiliarias</small>
</footer>

<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>