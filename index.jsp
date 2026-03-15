<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="./WEB-INF/conexion.jspf" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>InmoHome - Tu hogar ideal</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/4.6.0/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <style>
        .hero-section {
            background: linear-gradient(rgba(0,0,0,0.6), rgba(0,0,0,0.6)), url('https://images.unsplash.com/photo-1560518883-ce09059eeffa?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80');
            background-size: cover;
            background-position: center;
            color: white;
            padding: 80px 0;
            text-align: center;
        }
        .card-propiedad { transition: transform 0.3s; border: none; box-shadow: 0 4px 8px rgba(0,0,0,0.1); }
        .card-propiedad:hover { transform: translateY(-5px); }
        .resena-card { border-left: 5px solid #ffc107; background: #f8f9fa; }
    </style>
</head>
<body>

<nav class="navbar navbar-expand-lg navbar-dark bg-dark shadow-sm">
    <div class="container">
        <a class="navbar-brand text-warning font-weight-bold" href="index.jsp">INMOHOME</a>
        <div class="ml-auto">
            <a href="./logins/loginAdministrador.jsp" class="btn btn-sm btn-outline-warning mr-3"><i class="fas fa-user-shield"></i> Acceso Admin</a>

            <% if (session.getAttribute("nombreCliente") != null) { %>
                <span class="text-white mr-3"><i class="fas fa-user-circle"></i> <%= session.getAttribute("nombreCliente") %></span>
                <a href="./citas/misCitas.jsp" class="btn btn-sm btn-outline-light mr-2">Mis Citas</a>
                <a href="./logins/logout.jsp" class="btn btn-sm btn-danger">Cerrar Sesión</a>
            <% } else { %>
                <a href="./logins/loginCliente.jsp" class="btn btn-sm btn-warning">Iniciar Sesión</a>
            <% } %>
        </div>
    </div>
</nav>

<header class="hero-section">
    <div class="container">
        <h1 class="display-4 font-weight-bold">Tu hogar ideal te espera</h1>
        <p class="lead">Más de 10 años conectando familias con el espacio de sus sueños.</p>
    </div>
</header>

<div class="container mt-5">
    <div class="row align-items-center mb-5">
        <div class="col-md-6 mb-4">
            <img src="https://images.unsplash.com/photo-1486406146926-c627a92ad1ab?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80" class="img-fluid rounded shadow">
        </div>
        <div class="col-md-6">
            <h2 class="text-primary">¿Quiénes Somos?</h2>
            <p>En <strong>InmoHome</strong>, gestionamos activos inmobiliarios con transparencia y seguridad.</p>
            <ul class="list-unstyled">
                <li><i class="fas fa-check-circle text-success"></i> Asesoría legal personalizada.</li>
                <li><i class="fas fa-check-circle text-success"></i> Propiedades verificadas.</li>
                <li><i class="fas fa-check-circle text-success"></i> Atención 24/7.</li>
            </ul>
        </div>
    </div>

    <hr>

    <h3 class="my-4 text-center">Propiedades Disponibles</h3>
    <div class="row">
        <% 
            if (conexion != null) {
                try {
                    Statement st = conexion.createStatement();
                    ResultSet rs = st.executeQuery("SELECT * FROM propiedades WHERE estado = 'Disponible'");
                    while (rs.next()) {
        %>
        <div class="col-md-4 mb-4">
            <div class="card card-propiedad h-100">
                <div class="card-body">
                    <span class="badge badge-warning mb-2"><%= rs.getString("estado") %></span>
                    <h4 class="card-title"><%= rs.getString("ciudad") %></h4>
                    <p class="text-muted"><i class="fas fa-map-marker-alt"></i> <%= rs.getString("direccion") %></p>
                    <p class="small text-secondary"><%= rs.getString("descripcion") %></p>
                    <hr>
                    <% if (session.getAttribute("idCliente") != null) { %>
                        <a href="agendarCita.jsp?id_propiedad=<%= rs.getInt("id_propiedad") %>" class="btn btn-primary btn-block">
                            <i class="fas fa-calendar-alt mr-2"></i>Solicitar Cita
                        </a>
                    <% } else { %>
                        <a href="./login/loginCliente.jsp" class="btn btn-outline-secondary btn-block">Inicia sesión para agendar</a>
                    <% } %>
                </div>
            </div>
        </div>
        <% 
                    }
                    st.close();
                } catch (Exception e) {
                    out.print("<p class='text-danger'>Error: " + e.getMessage() + "</p>");
                }
            } 
        %>
    </div>

    <hr class="my-5">

    <h3 class="text-center mb-4">Reseñas de Clientes</h3>
    <div class="row">
        <% 
            if (conexion != null) {
                try {
                    Statement stRes = conexion.createStatement();
                    String sqlRes = "SELECT r.comentario, r.puntuacion, c.nombre FROM resenas r " +
                                   "JOIN clientes c ON r.id_cliente = c.id_cliente ORDER BY r.id_resena DESC LIMIT 3";
                    ResultSet rsRes = stRes.executeQuery(sqlRes);
                    while (rsRes.next()) {
        %>
        <div class="col-md-4 mb-4">
            <div class="card resena-card h-100 shadow-sm">
                <div class="card-body">
                    <div class="text-warning mb-2">
                        <% for(int i=0; i<rsRes.getInt("puntuacion"); i++) { %> <i class="fas fa-star"></i> <% } %>
                    </div>
                    <p class="font-italic">"<%= rsRes.getString("comentario") %>"</p>
                    <footer class="blockquote-footer text-primary font-weight-bold"><%= rsRes.getString("nombre") %></footer>
                </div>
            </div>
        </div>
        <% 
                    }
                    stRes.close();
                } catch (Exception e) {
                    out.print("<p class='text-muted text-center col-12'>No hay reseñas aún.</p>");
                } finally {
                    if (conexion != null) conexion.close();
                }
            }
        %>
    </div>
</div>

<footer class="bg-dark text-white text-center py-4 mt-5">
    <p class="mb-0">© 2026 InmoHome Profesional - Todos los derechos reservados.</p>
</footer>

</body>
</html>