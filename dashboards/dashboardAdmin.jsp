<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="../WEB-INF/conexion.jspf" %>

<%
    // VALIDACIÓN DE SESIÓN
    if (session.getAttribute("usuarioAdmin") == null) {
        response.sendRedirect("loginAdministrador.jsp");
        return; 
    }

    // LÓGICA PARA RECUPERAR DATOS SI SE VA A EDITAR
    String idEdit = request.getParameter("editId");
    String dDireccion = "", dEstado = "", dCiudad = "", dDescripcion = "", dPrecio = "";
    boolean editando = (idEdit != null);

    if (editando && conexion != null) {
        try {
            Statement stEdit = conexion.createStatement();
            ResultSet rsEdit = stEdit.executeQuery("SELECT * FROM propiedades WHERE id_propiedad = " + idEdit);
            if (rsEdit.next()) {
                dDireccion = rsEdit.getString("direccion");
                dEstado = rsEdit.getString("estado");
                dCiudad = rsEdit.getString("ciudad");
                dDescripcion = rsEdit.getString("descripcion");
                dPrecio = rsEdit.getString("precio");
            }
            stEdit.close();
        } catch (Exception e) { /* Manejar error */ }
    }
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>InmoHome - Panel de Administración</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/4.6.0/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <style>
        .sidebar { background: #212529; min-height: 100vh; color: white; position: fixed; width: 16.666%; }
        .main-content { margin-left: 16.666%; padding: 30px; width: 83.333%; }
        .sidebar a { color: #adb5bd; display: block; padding: 10px; transition: 0.3s; }
        .sidebar a:hover, .sidebar a.active { color: white; background: #343a40; text-decoration: none; }
        .card-edit { border: 2px solid #ffc107 !important; }
    </style>
</head>
<body>

<div class="container-fluid">
    <div class="row">
        <nav class="col-md-2 sidebar p-4">
            <h4 class="text-warning mb-4"><i class="fas fa-home"></i> InmoHome</h4>
            <a href="./dashboardAdmin.jsp" class="active"><i class="fas fa-building mr-2"></i> Propiedades</a>
            <a href="../index.jsp"><i class="fas fa-eye mr-2"></i> Ver Sitio</a>
            <a href="../logins/logout.jsp" class="text-danger mt-5"><i class="fas fa-sign-out-alt mr-2"></i> Salir</a>
        </nav>

        <main class="main-content">
            <h2>Gestión Administrativa</h2>
            <hr>

            <div class="card shadow-sm mb-5 <%= editando ? "card-edit" : "border-primary" %>">
                <div class="card-header <%= editando ? "bg-warning text-dark" : "bg-primary text-white" %>">
                    <%= editando ? "<b>Editando Propiedad ID: " + idEdit + "</b>" : "Registrar Nueva Propiedad" %>
                    <% if(editando) { %> <a href="./dashboardAdmin.jsp" class="float-right text-dark small">Cancelar edición</a> <% } %>
                </div>
                <div class="card-body">
                    <form action="<%= editando ? "../propiedades/actualizarPropiedad.jsp" : "../propiedades/procesarPropiedad.jsp" %>" method="POST" class="row">
                        <% if(editando) { %> <input type="hidden" name="id_propiedad" value="<%= idEdit %>"> <% } %>
                        
                        <div class="col-md-3 mb-2">
                            <label class="small font-weight-bold">Dirección</label>
                            <input type="text" name="direccion" class="form-control" value="<%= dDireccion %>" required>
                        </div>
                        <div class="col-md-2 mb-2">
                            <label class="small font-weight-bold">Estado</label>
                            <select name="estado" class="form-control" required>
                                <option value="Disponible" <%= dEstado.equals("Disponible") ? "selected" : "" %>>Disponible</option>
                                <option value="Arrendado" <%= dEstado.equals("Arrendado") ? "selected" : "" %>>Arrendado</option>
                                <option value="Vendido" <%= dEstado.equals("Vendido") ? "selected" : "" %>>Vendido</option>
                            </select>
                        </div>
                        <div class="col-md-2 mb-2">
                            <label class="small font-weight-bold">Ciudad</label>
                            <input type="text" name="ciudad" class="form-control" value="<%= dCiudad %>" required>
                        </div>
                        <div class="col-md-2 mb-2">
                            <label class="small font-weight-bold">Precio ($)</label>
                            <input type="number" name="precio" class="form-control" value="<%= dPrecio %>" required>
                        </div>
                        <div class="col-md-3 mb-2">
                            <label class="small">&nbsp;</label>
                            <button type="submit" class="btn <%= editando ? "btn-warning" : "btn-success" %> btn-block">
                                <%= editando ? "Actualizar Cambios" : "Guardar Propiedad" %>
                            </button>
                        </div>
                        <div class="col-md-12">
                            <textarea name="descripcion" placeholder="Descripción breve..." class="form-control" rows="2"><%= dDescripcion %></textarea>
                        </div>
                    </form>
                </div>
            </div>

            <div class="card shadow mb-5">
                <div class="card-header bg-dark text-white">Propiedades en el Sistema</div>
                <table class="table table-sm table-hover mb-0">
                    <thead class="thead-light">
                        <tr><th>ID</th><th>Dirección</th><th>Estado</th><th>Ciudad</th><th>Precio</th><th>Acciones</th></tr>
                    </thead>
                    <tbody>
                        <%
                            if (conexion != null) {
                                try {
                                    Statement stProp = conexion.createStatement();
                                    ResultSet rsProp = stProp.executeQuery("SELECT * FROM propiedades ORDER BY id_propiedad DESC");
                                    while(rsProp.next()) {
                                        String estado = rsProp.getString("estado");
                                        String badgeClass = "badge-info";
                                        if ("Vendido".equals(estado)) badgeClass = "badge-danger";
                                        if ("Arrendado".equals(estado)) badgeClass = "badge-warning";
                        %>
                        <tr>
                            <td><%= rsProp.getInt("id_propiedad") %></td>
                            <td><%= rsProp.getString("direccion") %></td>
                            <td><span class="badge <%= badgeClass %>"><%= estado %></span></td>
                            <td><%= rsProp.getString("ciudad") %></td>
                            <td><strong>$ <%= String.format("%,.0f", rsProp.getDouble("precio")) %></strong></td>
                            <td>
                                <a href="dashboardAdmin.jsp?editId=<%= rsProp.getInt("id_propiedad") %>" class="text-warning mr-3" title="Editar"><i class="fas fa-edit"></i></a>
                                <a href="../propiedades/eliminarPropiedad.jsp?id=<%= rsProp.getInt("id_propiedad") %>" class="text-danger" onclick="return confirm('¿Eliminar propiedad?')" title="Eliminar"><i class="fas fa-trash"></i></a>
                            </td>
                        </tr>
                        <% 
                                    }
                                    stProp.close();
                                } catch(Exception e) { 
                                    out.print("<tr><td colspan='6'>Error: " + e.getMessage() + "</td></tr>"); 
                                } 
                            } 
                        %>
                    </tbody>
                </table>
            </div>

            <div class="card shadow">
                <div class="card-header bg-secondary text-white">Gestión de Usuarios (Clientes)</div>
                <div class="card-body p-0">
                    <table class="table table-hover mb-0">
                        <thead>
                            <tr><th>Nombre</th><th>Email</th><th>Estado</th><th class="text-center">Acciones</th></tr>
                        </thead>
                        <tbody>
                            <%
                                if (conexion != null) {
                                    try {
                                        Statement stCli = conexion.createStatement();
                                        ResultSet rsCli = stCli.executeQuery("SELECT id_cliente, nombre, email FROM clientes ORDER BY nombre ASC");
                                        while (rsCli.next()) {
                            %>
                            <tr>
                                <td><strong><%= rsCli.getString("nombre") %></strong></td>
                                <td><%= rsCli.getString("email") %></td>
                                <td><span class="badge badge-success">Activo</span></td>
                                <td class="text-center">
                                    <a href="eliminarCliente.jsp?id=<%= rsCli.getInt("id_cliente") %>" class="btn btn-sm btn-outline-danger" onclick="return confirm('¿Seguro que deseas eliminar la cuenta de este cliente?')">
                                        <i class="fas fa-user-times"></i> Eliminar Cuenta
                                    </a>
                                </td>
                            </tr>
                            <% 
                                        }
                                        stCli.close();
                                        conexion.close();
                                    } catch (Exception e) {
                                        out.println("<tr><td colspan='4' class='text-danger'>Error: " + e.getMessage() + "</td></tr>");
                                    }
                                }
                            %>
                        </tbody>
                    </table>
                </div>
            </div>
        </main>
    </div>
</div>
</body>
</html>