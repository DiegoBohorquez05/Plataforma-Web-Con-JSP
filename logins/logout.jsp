<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Limpiar variables de sesión
    session.removeAttribute("idCliente");
    session.removeAttribute("nombreCliente");
    session.removeAttribute("idAdmin");
    session.removeAttribute("usuarioAdmin");
    
    // Invalidar sesión completa
    session.invalidate();
    
    // Regresar al inicio
    response.sendRedirect("../index.jsp");
%>