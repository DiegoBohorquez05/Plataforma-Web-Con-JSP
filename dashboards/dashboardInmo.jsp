<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ include file="../WEB-INF/conexion.jspf" %>

<%
    // 1. VALIDACIÓN DE SESIÓN
    Integer idInmo = (Integer) session.getAttribute("idInmobiliaria");
    if (idInmo == null) {
        response.sendRedirect("../logins/loginInmobiliaria.jsp");
        return;
    }
    String nombreInmo = (String) session.getAttribute("nombreInmo");

    // 2. LÓGICA DE EDICIÓN UNIFICADA
    String idEdit = request.getParameter("editId");
    String tituloForm = "Publicar Propiedad";
    String colorHeader = "bg-info";
    String actionForm = "procesarPropiedad.jsp"; // Archivo para guardar nuevo
    
    String edDireccion = "", edCiudad = "", edDesc = "", edEstado = "Disponible";
    double edPrecio = 0;

    // Si detectamos un ID para editar, cargamos los datos
    if (idEdit != null && !idEdit.isEmpty()) {
        tituloForm = "Editando Propiedad ID: " + idEdit;
        colorHeader = "bg-warning text-dark";
        actionForm = "modificarPropiedad.jsp"; // Archivo para actualizar existente
        
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
    <title>Panel InmoHome</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/4.6.0/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <style>
        body { background-color: #f8f9fa; }
        .navbar-inmo { background: #2c3e50; color: white; }
        .card { border: none; shadow: 0 0.125rem 0.25rem rgba(0,0,0,0.075); margin-bottom: 20px; }
        .section-title { border-left: 5px solid #17a2b8; padding-left: 15px; margin-bottom: 20px; }
    </style>
</head>
<body>

<nav class="navbar navbar-dark navbar-inmo shadow-sm mb-4">
    <div class="container">
        <a class="navbar-brand" href="../index.jsp">INMOHOME</a>
        <div class="ml-auto">
            <span class="text-white mr-3">Hola, <strong><%= nombreInmo %></strong></span>
            <a href="../logins/logout.jsp" class="btn btn-outline-light btn-sm">Cerrar Sesión</a>
        </div>
    </div>
</nav>

<div class="container">
    <div class="row">
        <div class="col-md-4">
            <div class="card shadow-sm">
                <div class="card-header <%= colorHeader %> font-weight-bold">
                    <i class="fas fa-edit"></i> <%= tituloForm %>
                </div>
                <div class="card-body">
                    <form action="<%= actionForm %>" method="POST">
                        <% if(idEdit != null) { %>
                            <input type="hidden" name="id_propiedad" value="<%= idEdit %>">
                        <% } %>
                        <div class="form-group small">
                            <label>Dirección</label>
                            <input type="text" name="direccion" class="form-control" value="<%= edDireccion %>" required>
                        </div>
                        <div class="form-group small">
                            <label>Ciudad</label>
                            <input type="text" name="ciudad" class="form-control" value="<%= edCiudad %>" required>
                        </div>
                        <div class="form-group small">
                            <label>Precio</label>
                            <input type="number" name="precio" class="form-control" value="<%= (int)edPrecio %>" required>
                        </div>
                        <div class="form-group small">
                            <label>Estado</label>
                            <select name="estado" class="form-control">
                                <option value="Disponible" <%= edEstado.equals("Disponible")?"selected":"" %>>Disponible</option>
                                <option value="Arrendado" <%= edEstado.equals("Arrendado")?"selected":"" %>>Arrendado</option>
                                <option value="Vendido" <%= edEstado.equals("Vendido")?"selected":"" %>>Vendido</option>
                            </select>
                        </div>
                        <div class="form-group small">
                            <label>Descripción</label>
                            <textarea name="descripcion" class="form-control" rows="3"><%= edDesc %></textarea>
                        </div>
                        <button type="submit" class="btn btn-block font-weight-bold <%= idEdit != null ? "btn-warning" : "btn-info" %>">
                            <%= idEdit != null ? "Guardar Cambios" : "Publicar Inmueble" %>
                        </button>
                        <% if(idEdit != null) { %>
                            <a href="dashboardInmo.jsp" class="btn btn-link btn-block btn-sm text-muted">Cancelar</a>
                        <% } %>
                    </form>
                </div>
            </div>
        </div>

        <div class="col-md-8">
            <h4 class="section-title">Gestión de Citas</h4>
            <div class="card shadow-sm">
                <div class="card-body p-0">
                    <table class="table table-sm table-hover mb-0">
                        <thead class="thead-dark small">
                            <tr><th>Cliente</th><th>Ciudad</th><th>Estado</th><th>Acción</th></tr>
                        </thead>
                        <tbody>
                            <%
                                try {
                                    String sqlCit = "SELECT c.id_cita, cl.nombre, p.ciudad, c.estado FROM citas c " +
                                                   "JOIN clientes cl ON c.id_cliente = cl.id_cliente " +
                                                   "JOIN propiedades p ON c.id_propiedad = p.id_propiedad " +
                                                   "WHERE p.fk_inmobiliaria = ?";
                                    PreparedStatement psCit = conexion.prepareStatement(sqlCit);
                                    psCit.setInt(1, idInmo);
                                    ResultSet rsCit = psCit.executeQuery();
                                    while(rsCit.next()){
                            %>
                            <tr class="small">
                                <td><%= rsCit.getString("nombre") %></td>
                                <td><%= rsCit.getString("ciudad") %></td>
                                <td><span class="badge badge-secondary"><%= rsCit.getString("estado") %></span></td>
                                <td>
                                    <form action="../citas/actualizarCita.jsp" method="POST">
                                        <input type="hidden" name="id_cita" value="<%= rsCit.getInt("id_cita") %>">
                                        <select name="nuevo_estado" class="form-control form-control-sm" onchange="this.form.submit()">
                                            <option value="" disabled selected>Cambiar...</option>
                                            <option value="Pendiente">Pendiente</option>
                                            <option value="Realizada">Realizada</option>
                                            <option value="Cancelada">Cancelada</option>
                                        </select>
                                    </form>
                                </td>
                            </tr>
                            <% } } catch(Exception e) { out.print(e.getMessage()); } %>
                        </tbody>
                    </table>
                </div>
            </div>

            <h4 class="section-title">Mis Propiedades</h4>
            <div class="card shadow-sm">
                <div class="card-body p-0">
                    <table class="table table-sm table-hover mb-0">
                        <thead class="bg-light small">
                            <tr><th>Dirección</th><th>Precio</th><th>Estado</th><th>Acciones</th></tr>
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
                            <tr class="small">
                                <td><%= rsP.getString("direccion") %></td>
                                <td>$<%= String.format("%,.0f", rsP.getDouble("precio")) %></td>
                                <td><span class="badge badge-warning"><%= rsP.getString("estado") %></span></td>
                                <td>
                                    <a href="dashboardInmo.jsp?editId=<%= rsP.getInt("id_propiedad") %>" class="text-warning mr-2"><i class="fas fa-edit"></i></a>
                                    <a href="../propiedades/eliminarPropiedad.jsp?id=<%= rsP.getInt("id_propiedad") %>" class="text-danger" onclick="return confirm('¿Eliminar?')"><i class="fas fa-trash"></i></a>
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

<% if (conexion != null) conexion.close(); %>
</body>
</html>