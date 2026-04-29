Imports System.Data.SqlClient
Imports System.Security.Cryptography
Imports System.Text

Public Class Login
    Inherits System.Web.UI.Page

    Private Function HashPassword(password As String) As String
        Using sha256 As SHA256 = SHA256.Create()
            Dim bytes As Byte() = sha256.ComputeHash(Encoding.UTF8.GetBytes(password))
            Dim sb As New StringBuilder()
            For Each b As Byte In bytes
                sb.Append(b.ToString("X2"))
            Next
            Return sb.ToString()
        End Using
    End Function

    Protected Sub btnLogin_Click(sender As Object, e As EventArgs) Handles btnLogin.Click
        Dim email As String = txtEmail.Text.Trim()
        Dim password As String = txtPassword.Text.Trim()
        Dim hashedPassword As String = HashPassword(password)

        Dim connStr As String = ConfigurationManager.ConnectionStrings("DocHubDB").ConnectionString

        Using conn As New SqlConnection(connStr)
            Dim query As String = "SELECT UserID, FullName, RoleID, DeptID FROM Users 
                                   WHERE Email = @Email AND PasswordHash = @Password"
            Using cmd As New SqlCommand(query, conn)
                cmd.Parameters.AddWithValue("@Email", email)
                cmd.Parameters.AddWithValue("@Password", hashedPassword)
                conn.Open()

                Dim reader As SqlDataReader = cmd.ExecuteReader()

                If reader.Read() Then
                    ' حفظ بيانات اليوزر في الـ Session
                    Session("UserID") = reader("UserID")
                    Session("FullName") = reader("FullName")
                    Session("RoleID") = reader("RoleID")
                    Session("DeptID") = reader("DeptID")

                    Response.Redirect("Dashboard.aspx")
                Else
                    pnlError.Visible = True
                    lblError.Text = "Invalid email or password."
                End If
            End Using
        End Using
    End Sub

End Class