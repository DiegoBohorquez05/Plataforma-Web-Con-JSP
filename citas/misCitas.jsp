<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ include file="../WEB-INF/conexion.jspf" %>
<%
    // 1. VALIDACIÓN DE SESIÓN (Intacta)
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
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Inter', sans-serif; background-color: #f4f7fa; color: #2d3748; }
        
        /* Navbar estilizada */
        .navbar { background: #1a202c !important; padding: 1rem 0; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        .navbar-brand { font-weight: 700; letter-spacing: 1px; }
        
        /* Contenedor de Título */
        .header-section { margin-top: 40px; margin-bottom: 30px; }
        .header-section h2 { font-weight: 600; color: #1a202c; }
        .header-section p { color: #718096; }

        /* Tarjeta y Tabla */
        .card-table { 
            border: none; 
            border-radius: 15px; 
            overflow: hidden; 
            box-shadow: 0 10px 25px rgba(0,0,0,0.05);
            background: white;
        }
        
        .table { margin-bottom: 0; }
        .table thead th { 
            background: #f8fafc; 
            border-top: none; 
            color: #64748b; 
            font-size: 0.8rem; 
            text-transform: uppercase; 
            letter-spacing: 1px;
            padding: 1.25rem;
        }
        .table td { padding: 1.25rem; vertical-align: middle; border-top: 1px solid #edf2f7; }
        .table tbody tr:hover { background-color: #f9fafb; transition: 0.2s; }

        /* Badges de estado */
        .badge-pill-custom {
            padding: 6px 14px;
            border-radius: 50px;
            font-size: 0.75rem;
            font-weight: 600;
        }
        .status-pendiente { background: #e2e8f0; color: #4a5568; }
        .status-confirmada { background: #c6f6d5; color: #22543d; }
        .status-cancelada { background: #fed7d7; color: #822727; }

        /* Iconos de apoyo */
        .prop-icon { width: 35px; height: 35px; background: #ebf4ff; color: #3182ce; border-radius: 8px; display: inline-flex; align-items: center; justify-content: center; margin-right: 12px; }
        
        footer { margin-top: 60px; color: #a0aec0; }
    </style>
</head>
<body>

<nav class="navbar navbar-expand-lg navbar-dark">
    <div class="container">
        <a class="navbar-brand text-warning" href="../index.jsp">
            <i class="fas fa-home mr-2"></i>INMOHOME
        </a>
        <div class="ml-auto">
            <a href="../index.jsp" class="btn btn-outline-warning btn-sm px-4" style="border-radius: 20px;">
                <i class="fas fa-arrow-left mr-2"></i>Volver a Propiedades
            </a>
        </div>
    </div>
</nav>

<div class="container">
    <div class="header-section text-center text-md-left">
        <div class="d-md-flex align-items-center justify-content-between">
            <div>
                <h2>Mi Historial de Visitas</h2>
                <p>Gestiona y revisa el estado de tus citas agendadas.</p>
            </div>
            <div class="d-none d-md-block">
                <i class="fas fa-calendar-alt fa-3x text-light"></i>
            </div>
        </div>
    </div>

    <%-- MENSAJE DE ÉXITO (Intacto) --%>
    <% if (request.getParameter("msj") != null) { %>
        <div class="alert alert-success alert-dismissible fade show border-0 shadow-sm mb-4" style="border-radius: 12px;">
            <i class="fas fa-check-circle mr-2"></i> 
            <strong>¡Excelente!</strong> Tu cita ha sido agendada. El administrador te contactará pronto.
            <button type="button" class="close" data-dismiss="alert">&times;</button>
        </div>
    <% } %>

    <div class="card card-table">
        <div class="table-responsive">
            <table class="table">
                <thead>
                    <tr>
                        <th>Cita</th>
                        <th>Propiedad / Ubicación</th>
                        <th>Fecha</th>
                        <th>Hora</th>
                        <th class="text-center">Estado</th>
                    </tr>
                </thead>
                <tbody>
                    <% 
                        if (conexion != null) {
                            try {
                                // LÓGICA SQL (Intacta)
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
                                    
                                    // Mapeo de estilos según estado
                                    String statusClass = "status-pendiente";
                                    if (estado.equalsIgnoreCase("Confirmada") || estado.equalsIgnoreCase("Realizada")) statusClass = "status-confirmada";
                                    if (estado.equalsIgnoreCase("Cancelada")) statusClass = "status-cancelada";
                    %>
                    <tr>
                        <td><span class="text-muted small">#<%= rs.getInt("id_cita") %></span></td>
                        <td>
                            <div class="d-flex align-items-center">
                                <div class="prop-icon"><i class="fas fa-building"></i></div>
                                <div>
                                    <div class="font-weight-bold"><%= rs.getString("direccion") %></div>
                                    <div class="small text-muted"><i class="fas fa-map-marker-alt mr-1"></i><%= rs.getString("ciudad") %></div>
                                </div>
                            </div>
                        </td>
                        <td><i class="far fa-calendar-check mr-2 text-primary"></i><%= rs.getString("fecha_cita") %></td>
                        <td><i class="far fa-clock mr-2 text-muted"></i><%= rs.getString("hora_cita") %></td>
                        <td class="text-center">
                            <span class="badge-pill-custom <%= statusClass %>">
                                <%= estado %>
                            </span>
                        </td>
                    </tr>
                    <% 
                                }
                                if (!tieneCitas) {
                    %>
                        <tr>
                            <td colspan="5" class="text-center py-5">
                                <div class="text-muted">
                                    <i class="fas fa-calendar-times fa-3x mb-3"></i>
                                    <p>Aún no has solicitado ninguna cita.</p>
                                    <a href="../index.jsp" class="btn btn-primary btn-sm mt-2">Explorar propiedades</a>
                                </div>
                            </td>
                        </tr>
                    <%
                                }
                                ps.close();
                                conexion.close();
                            } catch (Exception e) {
                                out.print("<tr><td colspan='5' class='text-danger'>Error: " + e.getMessage() + "</td></tr>");
                            }
                        } 
                    %>
                </tbody>
            </table>
        </div>
    </div>
</div>

<footer class="text-center">
    <div class="container">
        <hr class="mb-4">
        <small>© 2026 InmoHome - Todos los derechos reservados.</small>
        <div class="mt-2">
            <i class="fab fa-facebook-f mx-2"></i>
            <i class="fab fa-instagram mx-2"></i>
            <i class="fab fa-twitter mx-2"></i>
        </div>
    </div>
</footer>

<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>