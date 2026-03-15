<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="../WEB-INF/conexion.jspf" %>

<%
    // VALIDACIÓN DE SESIÓN
    if (session.getAttribute("usuarioAdmin") == null) {
        response.sendRedirect("loginAdministrador.jsp");
        return; 
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
    </style>
</head>
<body>

<div class="container-fluid">
    <div class="row">
        <nav class="col-md-2 sidebar p-4">
            <h4 class="text-warning mb-4"><i class="fas fa-home"></i> InmoHome</h4>
            <a href="dashboardAdmin.jsp" class="active"><i class="fas fa-building mr-2"></i> Propiedades</a>
            <a href="../index.jsp"><i class="fas fa-eye mr-2"></i> Ver Sitio</a>
            <a href="../logins/logout.jsp" class="text-danger mt-5"><i class="fas fa-sign-out-alt mr-2"></i> Salir</a>
        </nav>

        <main class="main-content">
            <h2>Gestión Administrativa</h2>
            <hr>

            <div class="card shadow-sm mb-5 border-primary">
                <div class="card-header bg-primary text-white">Registrar Nueva Propiedad</div>
                <div class="card-body">
                    <form action="../propiedades/procesarPropiedad.jsp" method="POST" class="row">
                        <div class="col-md-4 mb-2"><input type="text" name="direccion" placeholder="Dirección" class="form-control" required></div>
                        <div class="col-md-3 mb-2">
                            <select name="estado" class="form-control" required>
                                <option value="Disponible">Disponible</option>
                                <option value="Arrendado">Arrendado</option>
                                <option value="Vendido">Vendido</option>
                            </select>
                        </div>
                        <div class="col-md-3 mb-2"><input type="text" name="ciudad" placeholder="Ciudad" class="form-control" required></div>
                        <div class="col-md-2 mb-2"><button type="submit" class="btn btn-success btn-block">Guardar</button></div>
                        <div class="col-md-12"><textarea name="descripcion" placeholder="Descripción breve..." class="form-control" rows="2"></textarea></div>
                    </form>
                </div>
            </div>

            <div class="card shadow mb-5">
                <div class="card-header bg-dark text-white">Propiedades en el Sistema</div>
                <table class="table table-sm table-hover mb-0">
                    <thead class="thead-light">
                        <tr><th>Dirección</th><th>Estado</th><th>Ciudad</th><th>Acción</th></tr>
                    </thead>
                    <tbody>
                        <%
                            if (conexion != null) {
                                try {
                                    Statement stProp = conexion.createStatement();
                                    // Consulta corregida
                                    ResultSet rsProp = stProp.executeQuery("SELECT * FROM propiedades ORDER BY id_propiedad DESC");
                                    while(rsProp.next()) {
                                        String estado = rsProp.getString("estado");
                                        // Lógica de colores para el badge
                                        String badgeClass = "badge-info";
                                        if ("Vendido".equals(estado)) badgeClass = "badge-danger";
                                        if ("Arrendado".equals(estado)) badgeClass = "badge-warning";
                        %>
                        <tr>
                            <td><%= rsProp.getString("direccion") %></td>
                            <td><span class="badge <%= badgeClass %>"><%= estado %></span></td>
                            <td><%= rsProp.getString("ciudad") %></td>
                            <td>
                                <a href="eliminarPropiedad.jsp?id=<%= rsProp.getInt("id_propiedad") %>" class="text-danger" onclick="return confirm('¿Eliminar?')"><i class="fas fa-trash"></i></a>
                            </td>
                        </tr>
                        <% 
                                    } 
                                    stProp.close(); // Cerrar el statement individual
                                } catch(Exception e) { 
                                    out.print("<tr><td colspan='4'>Error Propiedades: " + e.getMessage() + "</td></tr>"); 
                                } 
                            } 
                        %>
                    </tbody>
                </table>
            </div>

            <div class="card shadow">
                <div class="card-header bg-secondary text-white">Clientes Registrados</div>
                <div class="card-body p-0">
                    <table class="table table-hover mb-0">
                        <thead>
                            <tr><th>Nombre</th><th>Email</th><th class="text-center">Estado</th></tr>
                        </thead>
                        <tbody>
                            <%
                                if (conexion != null) {
                                    try {
                                        Statement stCli = conexion.createStatement();
                                        ResultSet rsCli = stCli.executeQuery("SELECT nombre, email FROM clientes ORDER BY nombre ASC");
                                        while (rsCli.next()) {
                            %>
                            <tr>
                                <td><strong><%= rsCli.getString("nombre") %></strong></td>
                                <td><%= rsCli.getString("email") %></td>
                                <td class="text-center"><span class="badge badge-success">Activo</span></td>
                            </tr>
                            <% 
                                        }
                                        stCli.close(); // Cerrar statement
                                        conexion.close(); // Cerrar conexión global al final
                                    } catch (Exception e) {
                                        out.println("<tr><td colspan='3' class='text-danger'>Error Clientes: " + e.getMessage() + "</td></tr>");
                                        if(conexion != null) conexion.close();
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