<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
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
            background-size: cover; background-position: center;
            color: white; padding: 80px 0; text-align: center;
        }
        .card-propiedad { transition: transform 0.3s; border: none; box-shadow: 0 4px 8px rgba(0,0,0,0.1); }
        .card-propiedad:hover { transform: translateY(-5px); }
        .resena-card { border-left: 5px solid #ffc107; background: #f8f9fa; }
        .form-resena { background: #fff; padding: 25px; border-radius: 8px; box-shadow: 0 2px 15px rgba(0,0,0,0.1); border: 1px solid #eee; }
        .carousel-item img { height: 450px; object-fit: cover; border-radius: 10px; }
        .filter-box { background: #f1f1f1; padding: 20px; border-radius: 8px; margin-bottom: 30px; }
    </style>
</head>
<body>

<nav class="navbar navbar-expand-lg navbar-dark bg-dark shadow-sm">
    <div class="container">
        <a class="navbar-brand text-warning font-weight-bold" href="index.jsp">INMOHOME</a>
        <div class="ml-auto">
            <%-- 1. LÓGICA PARA EL ADMINISTRADOR --%>
            <% if (session.getAttribute("usuarioAdmin") != null) { %>
                <a href="dashboards/dashboardAdmin.jsp" class="btn btn-sm btn-warning mr-3">
                    <i class="fas fa-user-shield"></i> Volver al Panel
                </a>
                <span class="text-white small mr-2">| Modo Admin Activo |</span>
                <a href="./logins/logout.jsp" class="btn btn-sm btn-danger">Cerrar Sesión</a>

            <%-- 2. LÓGICA PARA INMOBILIARIA --%>
            <% } else if (session.getAttribute("idInmobiliaria") != null) { %>
                <a href="dashboards/dashboardInmo.jsp" class="btn btn-sm btn-info mr-3">
                    <i class="fas fa-building"></i> Panel Inmobiliaria
                </a>
                <a href="./logins/logout.jsp" class="btn btn-sm btn-danger">Cerrar Sesión</a>

            <%-- 3. LÓGICA PARA EL CLIENTE O VISITANTE --%>
            <% } else { %>
                <% if (session.getAttribute("nombreCliente") != null) { %>
                    <span class="text-white mr-3"><i class="fas fa-user-circle"></i> <%= session.getAttribute("nombreCliente") %></span>
                    <a href="./citas/misCitas.jsp" class="btn btn-sm btn-outline-light mr-2">Mis Citas</a>
                    <a href="./logins/logout.jsp" class="btn btn-sm btn-danger">Cerrar Sesión</a>
                <% } else { %>
                    <a href="./logins/loginInmobiliaria.jsp" class="btn btn-sm btn-outline-info mr-2">
                        <i class="fas fa-building"></i> Inmobiliarias
                    </a>
                    <a href="./logins/loginAdministrador.jsp" class="btn btn-sm btn-outline-warning mr-2">
                        <i class="fas fa-user-shield"></i> Admin
                    </a>
                    <a href="./logins/loginCliente.jsp" class="btn btn-sm btn-warning">
                        <i class="fas fa-user"></i> Iniciar Sesión Cliente
                    </a>
                <% } %>
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
    
    <%-- CARRUSEL --%>
    <div id="carouselInmo" class="carousel slide shadow mb-5" data-ride="carousel" data-interval="5000">
        <div class="carousel-inner">
            <div class="carousel-item active">
                <img src="https://images.unsplash.com/photo-1512917774080-9991f1c4c750?auto=format&fit=crop&w=1350&q=80" class="d-block w-100">
            </div>
            <div class="carousel-item">
                <img src="https://images.unsplash.com/photo-1448630360428-65456885c650?auto=format&fit=crop&w=1350&q=80" class="d-block w-100">
            </div>
            <div class="carousel-item">
                <img src="https://images.unsplash.com/photo-1613490493576-7fde63acd811?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80" class="d-block w-100">
            </div>
        </div>
        <a class="carousel-control-prev" href="#carouselInmo" data-slide="prev">
            <span class="carousel-control-prev-icon"></span>
        </a>
        <a class="carousel-control-next" href="#carouselInmo" data-slide="next">
            <span class="carousel-control-next-icon"></span>
        </a>
    </div>

    <%-- FILTROS --%>
    <div class="filter-box shadow-sm">
        <h4 class="mb-3"><i class="fas fa-search text-primary"></i> Filtrar Propiedades</h4>
        <form action="index.jsp" method="GET" class="form-row">
            <div class="col-md-3 mb-2">
                <input type="text" name="f_ciudad" class="form-control" placeholder="Ciudad" value="<%= (request.getParameter("f_ciudad") != null) ? request.getParameter("f_ciudad") : "" %>">
            </div>
            <div class="col-md-3 mb-2">
                <select name="f_estado" class="form-control">
                    <option value="">Cualquier Estado</option>
                    <option value="Disponible">Disponible</option>
                    <option value="Vendido">Vendido</option>
                    <option value="Arrendado">Arrendado</option>
                </select>
            </div>
            <div class="col-md-2 mb-2">
                <input type="number" name="f_precio" class="form-control" placeholder="Precio Máximo" value="<%= (request.getParameter("f_precio") != null) ? request.getParameter("f_precio") : "" %>">
            </div>
            <div class="col-md-4 mb-2">
                <div class="btn-group w-100">
                    <button type="submit" class="btn btn-primary"><i class="fas fa-filter"></i> Filtrar</button>
                    <a href="index.jsp" class="btn btn-secondary"><i class="fas fa-sync-alt"></i> Limpiar</a>
                </div>
            </div>
        </form>
    </div>

    <%-- PROPIEDADES --%>
    <div class="row">
        <% 
            if (conexion != null) {
                try {
                    String ciudad = request.getParameter("f_ciudad");
                    String fEstado = request.getParameter("f_estado");
                    String precioStr = request.getParameter("f_precio");
                    
                    // SQL MODIFICADO PARA JOIN CON LA TABLA CORRECTA
                    String sql = "SELECT p.*, i.nombre_empresa FROM propiedades p " +
                                 "LEFT JOIN inmobiliaria i ON p.fk_inmobiliaria = i.id_inmobiliaria " +
                                 "WHERE 1=1";
                    
                    if(ciudad != null && !ciudad.isEmpty()) { sql += " AND p.ciudad LIKE '%" + ciudad + "%'"; }
                    if(fEstado != null && !fEstado.isEmpty()) { sql += " AND p.estado = '" + fEstado + "'"; }
                    if(precioStr != null && !precioStr.isEmpty()) { sql += " AND p.precio <= " + precioStr; }
                    sql += " ORDER BY p.id_propiedad DESC";

                    Statement st = conexion.createStatement();
                    ResultSet rs = st.executeQuery(sql);
                    boolean hayResultados = false;
                    while (rs.next()) {
                        hayResultados = true;
                        String nombreInmo = rs.getString("nombre_empresa");
                        if(nombreInmo == null) nombreInmo = "InmoHome Oficial";
        %>
        <div class="col-md-4 mb-4">
            <div class="card card-propiedad h-100 shadow-sm">
                <div class="card-body">
                    <span class="badge badge-warning mb-2"><%= rs.getString("estado") %></span>
                    <h4 class="card-title font-weight-bold"><%= rs.getString("ciudad") %></h4>
                    
                    <p class="small text-primary mb-2">
                        <i class="fas fa-building"></i> 
                        <strong><%= nombreInmo %></strong>
                    </p>
                    
                    <p class="text-muted small">
                        <i class="fas fa-map-marker-alt"></i> <%= rs.getString("direccion") %>
                    </p>
                    
                    <h5 class="font-weight-bold text-success">
                        $ <%= String.format("%,.0f", rs.getDouble("precio")) %>
                    </h5>
                    
                    <p class="small text-secondary text-truncate" title="<%= rs.getString("descripcion") %>">
                        <%= rs.getString("descripcion") %>
                    </p>
                    
                    <hr>

                    <% if (session.getAttribute("idCliente") != null) { %>
                        <a href="citas/agendarCita.jsp?id_propiedad=<%= rs.getInt("id_propiedad") %>" 
                           class="btn btn-primary btn-block shadow-sm">
                           <i class="far fa-calendar-alt"></i> Solicitar Cita
                        </a>
                    <% } else { %>
                        <a href="./logins/loginCliente.jsp" 
                           class="btn btn-outline-secondary btn-block">
                           <i class="fas fa-user-lock"></i> Inicia sesión para agendar
                        </a>
                    <% } %>
                </div>
            </div>
        </div>
        <% 
                    }
                    if(!hayResultados) { out.print("<div class='col-12 text-center'><p class='alert alert-info'>No se encontraron inmuebles.</p></div>"); }
                    st.close();
                } catch (Exception e) { out.print("<p class='alert alert-danger'>Error: " + e.getMessage() + "</p>"); }
            } 
        %>
    </div>

    <hr class="my-5">

    <%-- SECCIÓN DE OPINIONES --%>
    <h3 class="text-center mb-4">Opiniones de nuestros clientes</h3>
    <div class="row">
        <% 
            if (conexion != null) {
                try {
                    Statement stRes = conexion.createStatement();
                    String sqlRes = "SELECT r.comentario, r.puntuacion, c.nombre FROM resenas r JOIN clientes c ON r.id_cliente = c.id_cliente ORDER BY r.id_resena DESC LIMIT 3";
                    ResultSet rsRes = stRes.executeQuery(sqlRes);
                    while (rsRes.next()) {
        %>
        <div class="col-md-4 mb-4">
            <div class="card resena-card h-100 shadow-sm p-3">
                <div class="text-warning mb-2">
                    <% for(int i=0; i<rsRes.getInt("puntuacion"); i++) { %> <i class="fas fa-star"></i> <% } %>
                </div>
                <p class="font-italic">"<%= rsRes.getString("comentario") %>"</p>
                <footer class="blockquote-footer text-primary font-weight-bold"><%= rsRes.getString("nombre") %></footer>
            </div>
        </div>
        <% } stRes.close(); } catch (Exception e) { } } %>
    </div>
</div> 

<footer class="bg-dark text-white text-center py-4 mt-5">
    <p>© 2026 InmoHome Profesional - Calidad y Confianza.</p>
</footer>

<script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.0/dist/js/bootstrap.bundle.min.js"></script>

<%-- CIERRE DE CONEXIÓN --%>
<%
    if (conexion != null && !conexion.isClosed()) {
        conexion.close();
    }
%>
</body>
</html>