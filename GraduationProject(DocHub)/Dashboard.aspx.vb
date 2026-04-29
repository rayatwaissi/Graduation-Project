Public Class Dashboard
    Inherits System.Web.UI.Page
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        ' إذا ما في session يرجعه للـ Login
        If Session("UserID") Is Nothing Then
            Response.Redirect("Login.aspx")
        End If

        ' بناءً على الـ RoleID تعرض محتوى مختلف
        Dim roleID As Integer = Session("RoleID")
    End Sub


End Class
