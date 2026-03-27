Imports Microsoft.VisualBasic.Devices
Imports WebGrease

Public Class EditPage
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Not IsPostBack Then
            LoadDeptCheckbox()

        End If
    End Sub



    Private Sub LoadDeptUsers()

        Dim selectedDepts = GetSelectedDeptFromCheckBoxList()

        Dim dt As New DataTable
        dt.Columns.Add("ID")
        dt.Columns.Add("Display")

        ' بيانات تجريبية
        Dim users As New DataTable
        users.Columns.Add("ID")
        users.Columns.Add("Name")
        users.Columns.Add("DeptID")
        users.Columns.Add("DeptName")
        users.Columns.Add("Role")

        users.Rows.Add("1", "Ahmad", "1", "CS", "Doctor")
        users.Rows.Add("2", "Lena", "2", "BIT", "Doctor")
        users.Rows.Add("3", "Omar", "3", "AI", "Assistant")
        users.Rows.Add("4", "Sara", "1", "CS", "Doctor")




        For Each row As DataRow In users.Rows
            If selectedDepts.Contains(row("DeptID").ToString()) Then

                Dim displayText As String =
                row("Name") & " - " &
                row("Role") & " (" &
                row("DeptName") & ")"

                dt.Rows.Add(row("ID"), displayText)
            End If
        Next

        chblDeptUsers.DataSource = dt
        chblDeptUsers.DataTextField = "Display"
        chblDeptUsers.DataValueField = "ID"
        chblDeptUsers.DataBind()

    End Sub
    Protected Sub btnAddDeptUsers_Click(sender As Object, e As EventArgs) Handles btnAddDeptUsers.Click

        pnlDeptUsers.Visible = True

        LoadDeptUsers()
        RestoreSelectedUsers()

    End Sub

    Protected Sub btnAddDeptUsersConfirm_Click(sender As Object, e As EventArgs) Handles btnAddDeptUsersConfirm.Click

        Dim dt As DataTable

        If Session("DeptAccess") IsNot Nothing Then
            dt = CType(Session("DeptAccess"), DataTable)
        Else
            dt = New DataTable
            dt.Columns.Add("ID")
            dt.Columns.Add("Name")
            dt.Columns.Add("Role")
            dt.Columns.Add("Department")
        End If

        Dim allUsers As New DataTable
        allUsers.Columns.Add("ID")
        allUsers.Columns.Add("Name")
        allUsers.Columns.Add("Department")
        allUsers.Columns.Add("Role")

        allUsers.Rows.Add("1", "Ahmad", "CS", "Doctor")
        allUsers.Rows.Add("2", "Lena", "BIT", "Doctor")
        allUsers.Rows.Add("3", "Omar", "AI", "Assistant")
        allUsers.Rows.Add("4", "Sara", "CS", "Doctor")

        For Each item As ListItem In chblDeptUsers.Items
            If item.Selected Then

                Dim rows = allUsers.Select("ID='" & item.Value & "'")

                If rows.Length > 0 Then

                    Dim name = rows(0)("Name").ToString()

                    ' 🔥 تحقق إذا موجود مسبقاً
                    Dim exists = dt.Select("ID='" & item.Value & "'")
                    If exists.Length = 0 Then
                        dt.Rows.Add(
                            rows(0)("ID"),
                            rows(0)("Name"),
                            rows(0)("Role"),
                            rows(0)("Department")
                        )
                    End If

                End If

            End If
        Next
        Session("DeptAccess") = dt

        rptDeptAccess.DataSource = dt
        rptDeptAccess.DataBind()

        pnlDeptUsers.Visible = False

    End Sub

    Protected Sub btnCloseDeptUsers_Click(sender As Object, e As EventArgs) Handles btnCloseDeptUsers.Click
        pnlDeptUsers.Visible = False
    End Sub

    Private Sub LoadDeptCheckbox()

        Dim dt As New DataTable()
        dt.Columns.Add("DeptID")
        dt.Columns.Add("DeptName")

        dt.Rows.Add("1", "CS")
        dt.Rows.Add("2", "BIT")
        dt.Rows.Add("3", "AI")

        cblDeptAccess.DataSource = dt
        cblDeptAccess.DataTextField = "DeptName"
        cblDeptAccess.DataValueField = "DeptID"
        cblDeptAccess.DataBind()

    End Sub

    Private Function GetSelectedDeptFromCheckBoxList() As List(Of String)

        Dim list As New List(Of String)

        For Each item As ListItem In cblDeptAccess.Items
            If item.Selected Then
                list.Add(item.Value)
            End If
        Next

        Return list

    End Function

    Private Sub RestoreSelectedUsers()

        If Session("DeptAccess") Is Nothing Then Exit Sub

        Dim dt As DataTable = CType(Session("DeptAccess"), DataTable)

        For Each item As ListItem In chblDeptUsers.Items

            Dim id As String = item.Value

            Dim rows = dt.Select("ID='" & id & "'")
            If rows.Length > 0 Then
                item.Selected = True
            End If

        Next

    End Sub


End Class