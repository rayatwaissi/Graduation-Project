Public Class CommonBar
    Inherits System.Web.UI.MasterPage

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

    End Sub

    Protected Sub lnkUpload_Click(sender As Object, e As EventArgs)

    End Sub

    Protected Sub lnkDocLib_Click(sender As Object, e As EventArgs)

    End Sub

    Protected Sub btnSignOut_Click(sender As Object, e As EventArgs) Handles btnSignOut.Click
        Response.Redirect("Login.aspx")
    End Sub
End Class