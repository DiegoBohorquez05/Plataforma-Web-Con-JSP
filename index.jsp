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
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600;700&display=swap" rel="stylesheet">
    
    <style>
        :root {
            --primary-dark: #212529;
            --accent-gold: #ffc107;
            --soft-gray: #f4f7f6;
        }

        body { 
            font-family: 'Poppins', sans-serif; 
            background-color: var(--soft-gray);
            color: #444;
        }

        /* Navbar Elevada */
        .navbar {
            background-color: var(--primary-dark) !important;
            border-bottom: 3px solid var(--accent-gold);
            padding: 1rem 0;
        }
        .navbar-brand { font-size: 1.5rem; letter-spacing: 1px; }

        /* Hero Section Impactante */
        .hero-section {
            background: linear-gradient(45deg, rgba(0,0,0,0.7), rgba(0,0,0,0.3)), 
                        url('https://images.unsplash.com/photo-1560518883-ce09059eeffa?auto=format&fit=crop&w=1350&q=80');
            background-size: cover; 
            background-position: center;
            background-attachment: fixed;
            color: white; 
            padding: 120px 0; 
            text-shadow: 2px 2px 4px rgba(0,0,0,0.5);
        }

        /* Filtros con estilo Glassmorphism */
        .filter-box { 
            background: #ffffff; 
            padding: 30px; 
            border-radius: 15px; 
            margin-top: -50px; /* Eleva la caja sobre el hero */
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            border: none;
        }

        /* Cards de Propiedades Modernas */
        .card-propiedad { 
            transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275); 
            border: none; 
            border-radius: 15px;
            overflow: hidden;
        }
        .card-propiedad:hover { 
            transform: translateY(-10px); 
            box-shadow: 0 15px 35px rgba(0,0,0,0.15); 
        }
        .card-propiedad .badge {
            position: absolute;
            top: 15px;
            right: 15px;
            padding: 8px 15px;
            font-size: 0.8rem;
            border-radius: 50px;
        }

        /* Carrusel con bordes suaves */
        #carouselInmo { border-radius: 20px; overflow: hidden; box-shadow: 0 20px 40px rgba(0,0,0,0.2); }
        .carousel-item img { height: 500px; object-fit: cover; }

        /* Reseñas con estilo "Quote" */
        .resena-card { 
            border: none;
            background: white; 
            border-radius: 15px;
            padding: 25px;
            position: relative;
        }
        .resena-card::before {
            content: "\f10d";
            font-family: "Font Awesome 5 Free";
            font-weight: 900;
            position: absolute;
            top: 10px;
            left: 10px;
            color: rgba(255, 193, 7, 0.2);
            font-size: 2rem;
        }

        /* Botones Personalizados */
        .btn-primary { background-color: #007bff; border: none; border-radius: 8px; padding: 10px 20px; font-weight: 600; }
        .btn-warning { background-color: var(--accent-gold); border: none; font-weight: 700; border-radius: 8px; }
        
        /* Sección de formulario */
        .form-resena { 
            background: white; 
            padding: 40px; 
            border-radius: 20px; 
            box-shadow: 0 15px 40px rgba(0,0,0,0.05);
        }
    </style>
</head>
<body>

<nav class="navbar navbar-expand-lg navbar-dark shadow-lg sticky-top">
    <div class="container">
        <a class="navbar-brand text-warning font-weight-bold" href="index.jsp">
            <i class="fas fa-home"></i> INMOHOME
        </a>
        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <div class="ml-auto">
                <% if (session.getAttribute("usuarioAdmin") != null) { %>
                    <a href="dashboards/dashboardAdmin.jsp" class="btn btn-sm btn-warning mr-2">
                        <i class="fas fa-user-shield"></i> Panel Admin
                    </a>
                    <a href="./logins/logout.jsp" class="btn btn-sm btn-outline-danger">Cerrar Sesión</a>
                <% } else if (session.getAttribute("idInmobiliaria") != null) { %>
                    <a href="dashboards/dashboardInmo.jsp" class="btn btn-sm btn-info mr-2">
                        <i class="fas fa-building"></i> Panel Inmobiliaria
                    </a>
                    <a href="./logins/logout.jsp" class="btn btn-sm btn-outline-danger">Cerrar Sesión</a>
                <% } else { %>
                    <% if (session.getAttribute("nombreCliente") != null) { %>
                        <span class="text-white mr-3"><i class="fas fa-user-circle"></i> Hola, <%= session.getAttribute("nombreCliente") %></span>
                        <a href="./citas/misCitas.jsp" class="btn btn-sm btn-outline-light mr-2">Mis Citas</a>
                        <a href="./logins/logout.jsp" class="btn btn-sm btn-danger">Salir</a>
                    <% } else { %>
                        <div class="btn-group">
                            <a href="./logins/loginInmobiliaria.jsp" class="btn btn-sm btn-outline-info">Inmobiliarias</a>
                            <a href="./logins/loginAdministrador.jsp" class="btn btn-sm btn-outline-warning">Admin</a>
                            <a href="./logins/loginCliente.jsp" class="btn btn-sm btn-warning ml-2">Clientes</a>
                        </div>
                    <% } %>
                <% } %>
            </div>
        </div>
    </div>
</nav>

<header class="hero-section">
    <div class="container">
        <h1 class="display-3 font-weight-bold animate__animated animate__fadeInDown">Encuentra tu lugar en el mundo</h1>
        <p class="lead animate__animated animate__fadeInUp">Experiencia, seguridad y los mejores inmuebles a tu disposición.</p>
    </div>
</header>

<div class="container">
    
    <%-- FILTROS ELEVADOS --%>
    <div class="filter-box shadow">
        <h5 class="mb-4 font-weight-bold text-dark"><i class="fas fa-sliders-h text-warning mr-2"></i> BUSCADOR AVANZADO</h5>
        <form action="index.jsp" method="GET" class="form-row">
            <div class="col-md-3 mb-2">
                <div class="input-group">
                    <div class="input-group-prepend"><span class="input-group-text bg-white border-right-0"><i class="fas fa-map-marker-alt text-muted"></i></span></div>
                    <input type="text" name="f_ciudad" class="form-control border-left-0" placeholder="Ciudad..." value="<%= (request.getParameter("f_ciudad") != null) ? request.getParameter("f_ciudad") : "" %>">
                </div>
            </div>
            <div class="col-md-3 mb-2">
                <select name="f_estado" class="form-control">
                    <option value="">Todos los estados</option>
                    <option value="Disponible">Disponible</option>
                    <option value="Vendido">Vendido</option>
                    <option value="Arrendado">Arrendado</option>
                </select>
            </div>
            <div class="col-md-3 mb-2">
                <div class="input-group">
                    <div class="input-group-prepend"><span class="input-group-text bg-white border-right-0"><i class="fas fa-tag text-muted"></i></span></div>
                    <input type="number" name="f_precio" class="form-control border-left-0" placeholder="Precio Máximo" value="<%= (request.getParameter("f_precio") != null) ? request.getParameter("f_precio") : "" %>">
                </div>
            </div>
            <div class="col-md-3 mb-2">
                <button type="submit" class="btn btn-primary btn-block shadow-sm">
                    <i class="fas fa-search mr-2"></i> BUSCAR AHORA
                </button>
            </div>
        </form>
    </div>

    <%-- CARRUSEL --%>
    <div class="mt-5 mb-5">
        <div id="carouselInmo" class="carousel slide" data-ride="carousel">
            <div class="carousel-inner">
                <div class="carousel-item active">
                    <img src="https://images.unsplash.com/photo-1512917774080-9991f1c4c750?auto=format&fit=crop&w=1350&q=80" class="d-block w-100">
                    <div class="carousel-caption d-none d-md-block bg-dark-50 rounded">
                        <h3>Lujosos Apartamentos</h3>
                        <p>Diseños modernos en las mejores zonas de la ciudad.</p>
                    </div>
                </div>
                <div class="carousel-item">
                    <img src="https://images.unsplash.com/photo-1448630360428-65456885c650?auto=format&fit=crop&w=1350&q=80" class="d-block w-100">
                    <div class="carousel-caption d-none d-md-block">
                        <h3>Casas de Ensueño</h3>
                        <p>El espacio perfecto para tu familia.</p>
                    </div>
                </div>
            </div>
            <a class="carousel-control-prev" href="#carouselInmo" role="button" data-slide="prev">
                <span class="carousel-control-prev-icon"></span>
            </a>
            <a class="carousel-control-next" href="#carouselInmo" role="button" data-slide="next">
                <span class="carousel-control-next-icon"></span>
            </a>
        </div>
    </div>

    <%-- PROPIEDADES --%>
    <h2 class="text-center font-weight-bold mb-5 mt-5">Propiedades Destacadas</h2>
    <div class="row">
        <% 
            if (conexion != null) {
                try {
                    String ciudad = request.getParameter("f_ciudad");
                    String fEstado = request.getParameter("f_estado");
                    String precioStr = request.getParameter("f_precio");
                    
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
                        
                        // Color del badge según estado
                        String badgeClass = "badge-warning";
                        if("Vendido".equals(rs.getString("estado"))) badgeClass = "badge-danger";
                        if("Disponible".equals(rs.getString("estado"))) badgeClass = "badge-success";
        %>
        <div class="col-md-4 mb-4">
            <div class="card card-propiedad h-100 shadow-sm">
                <div class="card-body p-4">
                    <span class="badge <%= badgeClass %> shadow-sm"><%= rs.getString("estado") %></span>
                    <h4 class="card-title font-weight-bold mt-3"><%= rs.getString("ciudad") %></h4>
                    <p class="text-primary small font-weight-bold mb-2">
                        <i class="fas fa-building mr-1"></i> <%= nombreInmo %>
                    </p>
                    <p class="text-muted small"><i class="fas fa-map-marker-alt mr-1"></i> <%= rs.getString("direccion") %></p>
                    <h5 class="font-weight-bold text-dark mt-3">$ <%= String.format("%,.0f", rs.getDouble("precio")) %></h5>
                    <p class="small text-secondary mt-2" style="height: 40px; overflow: hidden;"><%= rs.getString("descripcion") %></p>
                    <hr>
                    <% if (session.getAttribute("idCliente") != null) { %>
                        <a href="citas/agendarCita.jsp?id_propiedad=<%= rs.getInt("id_propiedad") %>" class="btn btn-primary btn-block shadow-sm">
                           <i class="far fa-calendar-alt mr-1"></i> Solicitar Cita
                        </a>
                    <% } else { %>
                        <a href="./logins/loginCliente.jsp" class="btn btn-outline-secondary btn-block small">
                           <i class="fas fa-sign-in-alt mr-1"></i> Inicia sesión para agendar
                        </a>
                    <% } %>
                </div>
            </div>
        </div>
        <% 
                    }
                    if(!hayResultados) { out.print("<div class='col-12 text-center py-5'><img src='https://cdn-icons-png.flaticon.com/512/6134/6134065.png' width='100'><p class='mt-3 text-muted'>No encontramos lo que buscas, intenta con otros filtros.</p></div>"); }
                    st.close();
                } catch (Exception e) { out.print("<div class='alert alert-danger'>Error: " + e.getMessage() + "</div>"); }
            } 
        %>
    </div>

    <%-- SECCIÓN DE RESEÑAS --%>
    <div class="bg-white rounded shadow-sm p-5 mt-5">
        <h3 class="text-center font-weight-bold mb-5">Lo que dicen de nosotros</h3>
        <div class="row">
            <% 
                if (conexion != null) {
                    try {
                        Statement stRes = conexion.createStatement();
                        String sqlRes = "SELECT r.comentario, r.puntuacion, c.nombre FROM resenas r JOIN clientes c ON r.id_cliente = c.id_cliente ORDER BY r.id_resena DESC LIMIT 3";
                        ResultSet rsRes = stRes.executeQuery(sqlRes);
                        while (rsRes.next()) {
            %>
            <div class="col-md-4 mb-4 text-center">
                <div class="resena-card h-100 shadow-sm">
                    <div class="text-warning mb-3">
                        <% for(int i=0; i<rsRes.getInt("puntuacion"); i++) { %> <i class="fas fa-star"></i> <% } %>
                    </div>
                    <p class="font-italic text-muted">"<%= rsRes.getString("comentario") %>"</p>
                    <h6 class="font-weight-bold text-primary mt-3">- <%= rsRes.getString("nombre") %></h6>
                </div>
            </div>
            <% } stRes.close(); } catch (Exception e) { } } %>
        </div>

        <%-- FORMULARIO DE RESEÑA --%>
        <% if (session.getAttribute("idCliente") != null) { %>
            <div class="row justify-content-center mt-5">
                <div class="col-md-10">
                    <div class="form-resena border">
                        <h4 class="text-center mb-4 font-weight-bold">Comparte tu experiencia</h4>
                        <form action="reseñas/guardarResena.jsp" method="POST">
                            <div class="form-row">
                                <div class="col-md-8 form-group">
                                    <textarea name="comentario" class="form-control" rows="3" placeholder="¿Cómo fue tu experiencia con InmoHome?" required></textarea>
                                </div>
                                <div class="col-md-4">
                                    <div class="form-group">
                                        <select name="puntuacion" class="form-control" required>
                                            <option value="5">⭐⭐⭐⭐⭐ Excelente</option>
                                            <option value="4">⭐⭐⭐⭐ Muy Bueno</option>
                                            <option value="3">⭐⭐⭐ Bueno</option>
                                            <option value="2">⭐⭐ Regular</option>
                                            <option value="1">⭐ Malo</option>
                                        </select>
                                    </div>
                                    <button type="submit" class="btn btn-warning btn-block shadow-sm">Publicar Opinión</button>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        <% } %>
    </div>

</div> 

<footer class="bg-dark text-white text-center py-5 mt-5">
    <div class="container">
        <div class="row">
            <div class="col-md-4">
                <h5 class="text-warning">INMOHOME</h5>
                <p class="small text-muted">Tu aliado confiable en el sector inmobiliario desde 2016.</p>
            </div>
            <div class="col-md-4">
                <h5>Enlaces</h5>
                <ul class="list-unstyled small text-muted">
                    <li><a href="#" class="text-muted">Inicio</a></li>
                    <li><a href="#" class="text-muted">Nosotros</a></li>
                    <li><a href="#" class="text-muted">Contacto</a></li>
                </ul>
            </div>
            <div class="col-md-4">
                <h5>Síguenos</h5>
                <div class="d-flex justify-content-center">
                    <a href="#" class="text-white mx-2"><i class="fab fa-facebook-f"></i></a>
                    <a href="#" class="text-white mx-2"><i class="fab fa-instagram"></i></a>
                    <a href="#" class="text-white mx-2"><i class="fab fa-twitter"></i></a>
                </div>
            </div>
        </div>
        <hr class="bg-secondary mt-4">
        <p class="small mb-0 mt-4">© 2026 InmoHome Profesional. Todos los derechos reservados.</p>
    </div>
</footer>

<script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.0/dist/js/bootstrap.bundle.min.js"></script>

<%
    if (conexion != null && !conexion.isClosed()) {
        conexion.close();
    }
%>
</body>
</html>