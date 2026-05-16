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

    Protected Sub lnkNotifications_Click(sender As Object, e As EventArgs) Handles lnkNotifications.Click
        Response.Redirect("Notifications.aspx")

    End Sub

    Protected Sub lnknewRequest_Click(sender As Object, e As EventArgs) Handles lnknewRequest.Click
        Response.Redirect("NewTask.aspx")

    End Sub

    Protected Sub lnkmyTask_Click(sender As Object, e As EventArgs) Handles lnkmyTask.Click
        Response.Redirect("MyTask.aspx")
    End Sub
End Class