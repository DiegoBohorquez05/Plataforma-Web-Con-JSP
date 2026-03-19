<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ include file="../WEB-INF/conexion.jspf" %>

<%
    // 1. VALIDACIÓN DE SESIÓN (Intacta)
    Integer idInmo = (Integer) session.getAttribute("idInmobiliaria");
    if (idInmo == null) {
        response.sendRedirect("../logins/loginInmobiliaria.jsp");
        return;
    }
    String nombreInmo = (String) session.getAttribute("nombreInmo");

    // 2. LÓGICA DE EDICIÓN UNIFICADA (Intacta)
    String idEdit = request.getParameter("editId");
    String tituloForm = "Publicar Propiedad";
    String colorHeader = "bg-primary text-white";
    String actionForm = "../propiedades/procesarPropiedad.jsp"; 
    
    String edDireccion = "", edCiudad = "", edDesc = "", edEstado = "Disponible";
    double edPrecio = 0;

    if (idEdit != null && !idEdit.isEmpty()) {
        tituloForm = "Modificar Propiedad";
        colorHeader = "bg-warning text-dark";
        actionForm = "../propiedades/actualizarPropiedad.jsp"; 
        
        try {
            String sqlEd = "SELECT * FROM propiedades WHERE id_propiedad = ?";
            PreparedStatement psEd = conexion.prepareStatement(sqlEd);
            psEd.setInt(1, Integer.parseInt(idEdit));
            ResultSet rsEd = psEd.executeQuery();
            if(rsEd.next()){
                edDireccion = rsEd.getString("direccion");
                edCiudad = rsEd.getString("ciudad");
                edPrecio = rsEd.getDouble("precio");
                edDesc = rsEd.getString("descripcion");
                edEstado = rsEd.getString("estado");
            }
        } catch(Exception e) { }
    }
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Panel InmoHome | <%= nombreInmo %></title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/4.6.0/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Inter', sans-serif; background-color: #f0f2f5; color: #334155; }
        
        /* Navbar con estilo moderno */
        .navbar-inmo { background: #1e293b; padding: 1rem 0; }
        .navbar-brand { font-weight: 700; letter-spacing: 1px; color: #fbbf24 !important; }
        
        /* Contenedores y Tarjetas */
        .card { border: none; border-radius: 12px; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.1); overflow: hidden; margin-bottom: 25px; }
        .card-header { border-bottom: none; font-weight: 600; padding: 15px 20px; }
        
        /* Títulos de sección */
        .section-title { 
            font-size: 1.1rem; 
            font-weight: 700; 
            color: #1e293b; 
            margin-bottom: 20px; 
            display: flex; 
            align-items: center; 
        }
        .section-title::before { 
            content: ""; 
            width: 4px; 
            height: 20px; 
            background: #3b82f6; 
            margin-right: 10px; 
            border-radius: 2px; 
        }

        /* Formularios */
        .form-control { border-radius: 8px; border: 1px solid #e2e8f0; padding: 10px 15px; font-size: 0.9rem; }
        .form-control:focus { box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1); border-color: #3b82f6; }
        label { font-weight: 600; color: #64748b; margin-bottom: 5px; font-size: 0.8rem; text-transform: uppercase; }

        /* Tablas */
        .table thead th { background: #f8fafc; border-top: none; color: #64748b; font-size: 0.75rem; text-transform: uppercase; letter-spacing: 0.5px; padding: 12px 20px; }
        .table td { padding: 15px 20px; vertical-align: middle; border-top: 1px solid #f1f5f9; }
        
        .badge-status { padding: 5px 10px; border-radius: 6px; font-size: 0.75rem; font-weight: 600; }
        
        /* Botones */
        .btn-publish { border-radius: 8px; padding: 12px; transition: all 0.3s; }
        .btn-publish:hover { transform: translateY(-1px); box-shadow: 0 4px 12px rgba(0,0,0,0.1); }
        
        .action-icon { width: 32px; height: 32px; display: inline-flex; align-items: center; justify-content: center; border-radius: 8px; transition: 0.2s; }
        .action-icon:hover { background: #f1f5f9; text-decoration: none; }
    </style>
</head>
<body>

<nav class="navbar navbar-dark navbar-inmo shadow-sm mb-5">
    <div class="container">
        <a class="navbar-brand" href="../index.jsp"><i class="fas fa-home mr-2"></i>INMOHOME</a>
        <div class="ml-auto d-flex align-items-center">
            <div class="text-right mr-3 d-none d-sm-block">
                <small class="text-muted d-block" style="line-height: 1">Inmobiliaria</small>
                <span class="text-white font-weight-bold"><%= nombreInmo %></span>
            </div>
            <a href="../logins/logout.jsp" class="btn btn-sm btn-outline-danger px-3" style="border-radius: 20px;">
                <i class="fas fa-sign-out-alt mr-1"></i> Salir
            </a>
        </div>
    </div>
</nav>

<div class="container">
    <div class="row">
        <div class="col-lg-4">
            <div class="card shadow-sm">
                <div class="card-header <%= colorHeader %>">
                    <i class="fas <%= idEdit != null ? "fa-pen-square" : "fa-plus-circle" %> mr-2"></i> <%= tituloForm %>
                </div>
                <div class="card-body">
                    <form action="<%= actionForm %>" method="POST">
                        <% if(idEdit != null) { %>
                            <input type="hidden" name="id_propiedad" value="<%= idEdit %>">
                        <% } %>
                        
                        <div class="form-group">
                            <label>Dirección exacta</label>
                            <input type="text" name="direccion" class="form-control" placeholder="Ej: Calle 10 # 5-20" value="<%= edDireccion %>" required>
                        </div>
                        
                        <div class="row">
                            <div class="col-md-6 form-group">
                                <label>Ciudad</label>
                                <input type="text" name="ciudad" class="form-control" placeholder="Ciudad" value="<%= edCiudad %>" required>
                            </div>
                            <div class="col-md-6 form-group">
                                <label>Precio ($)</label>
                                <input type="number" name="precio" class="form-control" placeholder="0.00" value="<%= (int)edPrecio %>" required>
                            </div>
                        </div>

                        <div class="form-group">
                            <label>Estado de disponibilidad</label>
                            <select name="estado" class="form-control">
                                <option value="Disponible" <%= edEstado.equals("Disponible")?"selected":"" %>>🟢 Disponible</option>
                                <option value="Arrendado" <%= edEstado.equals("Arrendado")?"selected":"" %>>🟡 Arrendado</option>
                                <option value="Vendido" <%= edEstado.equals("Vendido")?"selected":"" %>>🔴 Vendido</option>
                            </select>
                        </div>

                        <div class="form-group">
                            <label>Descripción detallada</label>
                            <textarea name="descripcion" class="form-control" rows="4" placeholder="Describe las características principales..."><%= edDesc %></textarea>
                        </div>

                        <button type="submit" class="btn btn-block font-weight-bold btn-publish <%= idEdit != null ? "btn-warning" : "btn-primary" %>">
                            <%= idEdit != null ? "ACTUALIZAR DATOS" : "PUBLICAR AHORA" %>
                        </button>
                        
                        <% if(idEdit != null) { %>
                            <a href="dashboardInmo.jsp" class="btn btn-link btn-block btn-sm text-secondary mt-2">Cancelar edición</a>
                        <% } %>
                    </form>
                </div>
            </div>
        </div>

        <div class="col-lg-8">
            
            <div class="section-title">Citas de Clientes Interesados</div>
            <div class="card shadow-sm">
                <div class="table-responsive">
                    <table class="table table-hover mb-0">
                        <thead>
                            <tr>
                                <th>Cliente</th>
                                <th>Propiedad</th>
                                <th>Estado Actual</th>
                                <th width="180">Gestionar</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                try {
                                    String sqlCit = "SELECT c.id_cita, cl.nombre, p.ciudad, p.direccion, c.estado FROM citas c " +
                                                   "JOIN clientes cl ON c.id_cliente = cl.id_cliente " +
                                                   "JOIN propiedades p ON c.id_propiedad = p.id_propiedad " +
                                                   "WHERE p.fk_inmobiliaria = ? ORDER BY c.id_cita DESC";
                                    PreparedStatement psCit = conexion.prepareStatement(sqlCit);
                                    psCit.setInt(1, idInmo);
                                    ResultSet rsCit = psCit.executeQuery();
                                    if(!rsCit.isBeforeFirst()){
                                        out.print("<tr><td colspan='4' class='text-center text-muted p-4'>No hay citas registradas aún.</td></tr>");
                                    }
                                    while(rsCit.next()){
                                        String colorBadge = "badge-secondary";
                                        if(rsCit.getString("estado").equals("Realizada")) colorBadge = "badge-success";
                                        if(rsCit.getString("estado").equals("Cancelada")) colorBadge = "badge-danger";
                            %>
                            <tr>
                                <td>
                                    <div class="font-weight-bold text-dark"><%= rsCit.getString("nombre") %></div>
                                    <small class="text-muted">Interesado</small>
                                </td>
                                <td>
                                    <div class="small"><%= rsCit.getString("direccion") %></div>
                                    <div class="small text-primary"><%= rsCit.getString("ciudad") %></div>
                                </td>
                                <td><span class="badge badge-status <%= colorBadge %>"><%= rsCit.getString("estado") %></span></td>
                                <td>
                                    <form action="../citas/actualizarCita.jsp" method="POST">
                                        <input type="hidden" name="id_cita" value="<%= rsCit.getInt("id_cita") %>">
                                        <select name="nuevo_estado" class="form-control form-control-sm" onchange="this.form.submit()" style="height: 30px; font-size: 0.8rem;">
                                            <option value="" disabled selected>Cambiar estado...</option>
                                            <option value="Pendiente">Pendiente</option>
                                            <option value="Realizada">Realizada</option>
                                            <option value="Cancelada">Cancelada</option>
                                        </select>
                                    </form>
                                </td>
                            </tr>
                            <% } } catch(Exception e) { } %>
                        </tbody>
                    </table>
                </div>
            </div>

            <div class="section-title">Mis Inmuebles Publicados</div>
            <div class="card shadow-sm">
                <div class="table-responsive">
                    <table class="table table-hover mb-0">
                        <thead>
                            <tr>
                                <th>Ubicación</th>
                                <th>Precio</th>
                                <th>Estado</th>
                                <th class="text-center">Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                try {
                                    String sqlP = "SELECT * FROM propiedades WHERE fk_inmobiliaria = ? ORDER BY id_propiedad DESC";
                                    PreparedStatement psP = conexion.prepareStatement(sqlP);
                                    psP.setInt(1, idInmo);
                                    ResultSet rsP = psP.executeQuery();
                                    while(rsP.next()){
                            %>
                            <tr>
                                <td>
                                    <div class="font-weight-bold text-dark"><%= rsP.getString("direccion") %></div>
                                    <div class="small text-muted"><%= rsP.getString("ciudad") %></div>
                                </td>
                                <td>
                                    <div class="text-success font-weight-bold">$<%= String.format("%,.0f", rsP.getDouble("precio")) %></div>
                                </td>
                                <td><span class="badge badge-status badge-light border text-dark"><%= rsP.getString("estado") %></span></td>
                                <td class="text-center">
                                    <a href="dashboardInmo.jsp?editId=<%= rsP.getInt("id_propiedad") %>" class="action-icon text-warning" title="Editar">
                                        <i class="fas fa-edit"></i>
                                    </a>
                                    <a href="../propiedades/eliminarPropiedad.jsp?id=<%= rsP.getInt("id_propiedad") %>" class="action-icon text-danger" onclick="return confirm('¿Seguro que deseas eliminar esta propiedad?')" title="Eliminar">
                                        <i class="fas fa-trash"></i>
                                    </a>
                                </td>
                            </tr>
                            <% } } catch(Exception e) { } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

<footer class="text-center p-4 mt-4 text-muted small">
    &copy; 2026 InmoHome Business - Panel de Control Inmobiliario
</footer>

<% if (conexion != null) conexion.close(); %>
</body>
</html>