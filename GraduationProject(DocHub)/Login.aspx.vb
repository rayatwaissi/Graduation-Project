Imports System.Data
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

        ' تشفير الباسوورد
        Dim hashedPassword As String = HashSHA256(password)

        ' جيب اليوزر من الداتابيس
        Dim sql As String = "SELECT UserID, FullName, RoleID, DeptID FROM Users 
                             WHERE Email = @Email AND PasswordHash = @Pass"

        Dim params As New Dictionary(Of String, Object) From {
            {"@Email", email},
            {"@Pass", hashedPassword}
        }

        Dim dt As DataTable = DB.GetData(sql, params)

        If dt.Rows.Count = 1 Then
            ' حفظ بيانات اليوزر في Session
            Session("UserID") = dt.Rows(0)("UserID")
            Session("FullName") = dt.Rows(0)("FullName")
            Session("RoleID") = dt.Rows(0)("RoleID")
            Session("DeptID") = dt.Rows(0)("DeptID")

            Response.Redirect("Dashboard.aspx")
        Else
            pnlError.Visible = True
            lblError.Text = "Invalid email or password."
        End If

    End Sub

    Private Function HashSHA256(input As String) As String
        Using sha256 As SHA256 = SHA256.Create()
            Dim bytes As Byte() = Encoding.UTF8.GetBytes(input)
            Dim hash As Byte() = sha256.ComputeHash(bytes)
            Return BitConverter.ToString(hash).Replace("-", "").ToUpper()
        End Using
    End Function

End Class