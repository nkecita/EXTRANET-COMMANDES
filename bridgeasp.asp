<%
Session("login") = request.querystring("client")
Session("langue") = request.querystring("langue")
session("tarif") = request.querystring("tarif")
if request.querystring("frais") <>"" then
    session("frais") = request.querystring("frais")
Else
    session("frais") = 0
End if   

if request.querystring("tva") <>"" then
    session("tva") = request.querystring("tva")
Else
    session("tva") = 0
End if 
 
response.redirect(request.querystring("page"))

%>