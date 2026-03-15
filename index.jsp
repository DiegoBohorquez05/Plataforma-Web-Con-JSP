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
            color: white; padding: 80px 0; text-align: center;
        }
        .card-propiedad { transition: transform 0.3s; border: none; box-shadow: 0 4px 8px rgba(0,0,0,0.1); }
        .card-propiedad:hover { transform: translateY(-5px); }
        .resena-card { border-left: 5px solid #ffc107; background: #f8f9fa; }
        .form-resena { background: #fff; padding: 20px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        .carousel-item img { height: 450px; object-fit: cover; border-radius: 10px; }
        .filter-box { background: #f1f1f1; padding: 20px; border-radius: 8px; margin-bottom: 30px; }
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
            <img src="https://images.unsplash.com/photo-1486406146926-c627a92ad1ab?auto=format&fit=crop&w=800&q=80" class="img-fluid rounded shadow">
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

    <div id="carouselInmo" class="carousel slide shadow mb-5" data-ride="carousel" data-interval="3000">
        <ol class="carousel-indicators">
            <li data-target="#carouselInmo" data-slide-to="0" class="active"></li>
            <li data-target="#carouselInmo" data-slide-to="1"></li>
            <li data-target="#carouselInmo" data-slide-to="2"></li>
        </ol>
        <div class="carousel-inner">
            <div class="carousel-item active">
                <img src="https://images.unsplash.com/photo-1512917774080-9991f1c4c750?auto=format&fit=crop&w=1350&q=80" class="d-block w-100" alt="Lujo">
            </div>
            <div class="carousel-item">
                <img src="https://images.unsplash.com/photo-1448630360428-65456885c650?auto=format&fit=crop&w=1350&q=80" class="d-block w-100" alt="Moderno">
            </div>
            <div class="carousel-item">
                <img src="https://images.unsplash.com/photo-1613490493576-7fde63acd811?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80" class="d-block w-100" alt="Hogar">
            </div>
        </div>
        <a class="carousel-control-prev" href="#carouselInmo" role="button" data-slide="prev">
            <span class="carousel-control-prev-icon" aria-hidden="true"></span>
            <span class="sr-only">Anterior</span>
        </a>
        <a class="carousel-control-next" href="#carouselInmo" role="button" data-slide="next">
            <span class="carousel-control-next-icon" aria-hidden="true"></span>
            <span class="sr-only">Siguiente</span>
        </a>
    </div>

    <hr>

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

    <div class="row">
        <% 
            if (conexion != null) {
                try {
                    String ciudad = request.getParameter("f_ciudad");
                    String fEstado = request.getParameter("f_estado");
                    String precioStr = request.getParameter("f_precio");
                    String sql = "SELECT * FROM propiedades WHERE 1=1";
                    if(ciudad != null && !ciudad.isEmpty()) { sql += " AND ciudad LIKE '%" + ciudad + "%'"; }
                    if(fEstado != null && !fEstado.isEmpty()) { sql += " AND estado = '" + fEstado + "'"; }
                    if(precioStr != null && !precioStr.isEmpty()) { sql += " AND precio <= " + precioStr; }
                    sql += " ORDER BY id_propiedad DESC";

                    Statement st = conexion.createStatement();
                    ResultSet rs = st.executeQuery(sql);
                    boolean hayResultados = false;
                    while (rs.next()) {
                        hayResultados = true;
        %>
        <div class="col-md-4 mb-4">
            <div class="card card-propiedad h-100">
                <div class="card-body">
                    <span class="badge badge-warning mb-2"><%= rs.getString("estado") %></span>
                    <h4 class="card-title"><%= rs.getString("ciudad") %></h4>
                    <p class="text-muted"><i class="fas fa-map-marker-alt"></i> <%= rs.getString("direccion") %></p>
                    <p class="font-weight-bold text-success">$ <%= String.format("%,.0f", rs.getDouble("precio")) %></p>
                    <p class="small text-secondary"><%= rs.getString("descripcion") %></p>
                    <hr>
                    <% if (session.getAttribute("idCliente") != null) { %>
                        <a href="agendarCita.jsp?id_propiedad=<%= rs.getInt("id_propiedad") %>" class="btn btn-primary btn-block">Solicitar Cita</a>
                    <% } else { %>
                        <a href="./logins/loginCliente.jsp" class="btn btn-outline-secondary btn-block">Inicia sesión</a>
                    <% } %>
                </div>
            </div>
        </div>
        <% 
                    }
                    if(!hayResultados) { out.print("<div class='col-12 text-center'><p class='alert alert-info'>No se encontraron inmuebles.</p></div>"); }
                    st.close();
                } catch (Exception e) {
                    out.print("<p class='text-danger'>Error SQL: " + e.getMessage() + "</p>");
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
                    String sqlRes = "SELECT r.comentario, r.puntuacion, c.nombre FROM resenas r JOIN clientes c ON r.id_cliente = c.id_cliente ORDER BY r.id_resena DESC LIMIT 3";
                    ResultSet rsRes = stRes.executeQuery(sqlRes);
                    while (rsRes.next()) {
        %>
        <div class="col-md-4 mb-4">
            <div class="card resena-card h-100 shadow-sm">
                <div class="card-body">
                    <div class="text-warning mb-2"><% for(int i=0; i<rsRes.getInt("puntuacion"); i++) { %> <i class="fas fa-star"></i> <% } %></div>
                    <p class="font-italic">"<%= rsRes.getString("comentario") %>"</p>
                    <footer class="blockquote-footer text-primary font-weight-bold"><%= rsRes.getString("nombre") %></footer>
                </div>
            </div>
        </div>
        <% } stRes.close(); } catch (Exception e) { } } %>
    </div>

    <% if (session.getAttribute("idCliente") != null) { %>
        <div class="row justify-content-center mt-5">
            <div class="col-md-8">
                <div class="form-resena border">
                    <h4 class="text-center mb-4"><i class="fas fa-pen-nib text-warning"></i> Déjanos tu opinión</h4>
                    <form action="guardarResena.jsp" method="POST">
                        <div class="form-group"><textarea name="comentario" class="form-control" rows="3" placeholder="Escribe tu comentario aquí..." required></textarea></div>
                        <div class="form-group">
                            <select name="puntuacion" class="form-control" required>
                                <option value="5">5 estrellas</option><option value="4">4 estrellas</option><option value="3">3 estrellas</option><option value="2">2 estrellas</option><option value="1">1 estrella</option>
                            </select>
                        </div>
                        <button type="submit" class="btn btn-warning btn-block font-weight-bold">Enviar Reseña</button>
                    </form>
                </div>
            </div>
        </div>
    <% } %>

    <% if (conexion != null) { try { conexion.close(); } catch (Exception e) {} } %>
</div>

<footer class="bg-dark text-white text-center py-4 mt-5">
    <p class="mb-0">© 2026 InmoHome Profesional - Todos los derechos reservados.</p>
</footer>

<script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.0/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>