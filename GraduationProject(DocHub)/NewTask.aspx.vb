Imports System.Data

Public Class NewTask
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Session("UserID") Is Nothing Then
            Response.Redirect("Login.aspx")
        End If

        If Not IsPostBack Then
            LoadDepartments()
            LoadPrograms()
            LoadCategories()
            LoadDeptCheckbox()
            LoadDocuments()
        Else
            SaveCurrentPermissions()  ' ← أول شي بالـ PostBack، قبل أي DataBind
            If Session("DeptAccess") IsNot Nothing Then
                rptDeptAccess.DataSource = CType(Session("DeptAccess"), DataTable)
                rptDeptAccess.DataBind()
                RestorePermissions()
            End If
        End If
    End Sub

    Private Sub LoadDocuments()
        Dim roleID As Integer = CInt(Session("RoleID"))

        Dim sql As String
        Dim params As New Dictionary(Of String, Object)

        If roleID <= 3 Then
            ' Dean, Vice Dean, Vice Dean Quality, Quality Office
            ' يشوفوا كل الدوكيمنتس
            sql = "SELECT DocumentID, DocumentName 
               FROM Documents 
               WHERE IsDeleted = 0
               ORDER BY DocumentName"

        ElseIf roleID = 4 OrElse roleID = 5 Then
            ' Department Head, Quality Liaison Officer
            ' يشوفوا دوكيمنتس قسمهم بس
            Dim deptID As Integer = CInt(Session("DeptID"))
            sql = "SELECT DocumentID, DocumentName 
               FROM Documents 
               WHERE IsDeleted = 0 
               AND DeptID = @DeptID
               ORDER BY DocumentName"
            params.Add("@DeptID", deptID)
        Else
            ' Staff - ما يشوف شي
            Exit Sub
        End If

        Dim dt = DB.GetData(sql, params)
        ddlTargetDoc.Items.Clear()
        ddlTargetDoc.DataSource = dt
        ddlTargetDoc.DataTextField = "DocumentName"
        ddlTargetDoc.DataValueField = "DocumentID"
        ddlTargetDoc.DataBind()
        ddlTargetDoc.Items.Insert(0, New ListItem("Select Document", ""))
    End Sub
    Private Sub LoadDepartments()
        Dim sql As String = "SELECT DeptID, DeptName FROM Departments"
        Dim dt As DataTable = DB.GetData(sql)
        ddlDept.Items.Clear()
        ddlDept.DataSource = dt
        ddlDept.DataTextField = "DeptName"
        ddlDept.DataValueField = "DeptID"
        ddlDept.DataBind()
        ddlDept.Items.Insert(0, New ListItem("Select Department", ""))
    End Sub

    Private Sub LoadPrograms()
        Dim sql As String = "SELECT ProgramID, ProgramName FROM Programs"
        Dim dt As DataTable = DB.GetData(sql)
        ProgramList.Items.Clear()
        ProgramList.DataSource = dt
        ProgramList.DataTextField = "ProgramName"
        ProgramList.DataValueField = "ProgramID"
        ProgramList.DataBind()
        ProgramList.Items.Insert(0, New ListItem("Select Program", ""))
    End Sub

    Private Sub LoadCategories()
        Dim sql As String = "SELECT CategoryID, CategoryName FROM Categories"
        Dim dt As DataTable = DB.GetData(sql)
        CategoryList.Items.Clear()
        CategoryList.DataSource = dt
        CategoryList.DataTextField = "CategoryName"
        CategoryList.DataValueField = "CategoryID"
        CategoryList.DataBind()
        CategoryList.Items.Insert(0, New ListItem("Select Category", ""))
    End Sub

    Private Sub LoadDeptCheckbox()
        Dim sql As String = "SELECT DeptID, DeptName FROM Departments"
        Dim dt As DataTable = DB.GetData(sql)
        cblDeptAccess.DataSource = dt
        cblDeptAccess.DataTextField = "DeptName"
        cblDeptAccess.DataValueField = "DeptID"
        cblDeptAccess.DataBind()
    End Sub

    Private Sub LoadDeptUsers()
        Dim selectedDepts = GetSelectedDeptFromCheckBoxList()

        If selectedDepts.Count = 0 Then
            chblDeptUsers.DataSource = Nothing
            chblDeptUsers.DataBind()
            Exit Sub
        End If

        Dim paramNames As New List(Of String)
        Dim params As New Dictionary(Of String, Object)

        For i As Integer = 0 To selectedDepts.Count - 1
            Dim pName = "@d" & i
            paramNames.Add(pName)
            params.Add(pName, selectedDepts(i))
        Next

        Dim sql As String = "SELECT U.UserID, U.FullName, D.DeptName, R.RoleName 
                             FROM Users U
                             INNER JOIN Departments D ON U.DeptID = D.DeptID
                             INNER JOIN Roles R ON U.RoleID = R.RoleID
                             WHERE U.DeptID IN (" & String.Join(",", paramNames) & ")"

        Dim dt As DataTable = DB.GetData(sql, params)
        dt.Columns.Add("Display", GetType(String))
        For Each row As DataRow In dt.Rows
            row("Display") = row("FullName") & " - " & row("RoleName") & " (" & row("DeptName") & ")"
        Next

        chblDeptUsers.DataSource = dt
        chblDeptUsers.DataTextField = "Display"
        chblDeptUsers.DataValueField = "UserID"
        chblDeptUsers.DataBind()
    End Sub

    Private Sub LoadAllUsers()
        Dim sql As String = "SELECT U.UserID, U.FullName, D.DeptName, R.RoleName 
                         FROM Users U
                         INNER JOIN Departments D ON U.DeptID = D.DeptID
                         INNER JOIN Roles R ON U.RoleID = R.RoleID"
        Dim dt As DataTable = DB.GetData(sql)
        dt.Columns.Add("Display", GetType(String))
        For Each row As DataRow In dt.Rows
            row("Display") = row("FullName") & " - " & row("RoleName") & " (" & row("DeptName") & ")"
        Next
        chblDeptUsers.DataSource = dt
        chblDeptUsers.DataTextField = "Display"
        chblDeptUsers.DataValueField = "UserID"
        chblDeptUsers.DataBind()
    End Sub

    Protected Sub btnAddDeptUsers_Click(sender As Object, e As EventArgs) Handles btnAddDeptUsers.Click
        pnlDeptUsers.Visible = True
        LoadAllUsers()
        RestoreSelectedUsers()
    End Sub

    Protected Sub cblDeptAccess_SelectedIndexChanged(sender As Object, e As EventArgs) Handles cblDeptAccess.SelectedIndexChanged
        pnlDeptUsers.Visible = True

        Dim selectedDepts = GetSelectedDeptFromCheckBoxList()

        If selectedDepts.Count = 0 Then
            LoadAllUsers()
        Else
            LoadDeptUsers()
        End If

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

        ' أضيفي عمود Permission إذا ما موجود
        If Not dt.Columns.Contains("Permission") Then
            dt.Columns.Add("Permission", GetType(String))
            For Each row As DataRow In dt.Rows
                row("Permission") = "View"
            Next
        End If

        For Each item As ListItem In chblDeptUsers.Items
            If item.Selected Then
                Dim exists = dt.Select("ID='" & item.Value & "'")
                If exists.Length = 0 Then
                    Dim sql As String = "SELECT U.UserID, U.FullName, D.DeptName, R.RoleName 
                                        FROM Users U
                                        INNER JOIN Departments D ON U.DeptID = D.DeptID
                                        INNER JOIN Roles R ON U.RoleID = R.RoleID
                                        WHERE U.UserID = @UID"
                    Dim params As New Dictionary(Of String, Object) From {{"@UID", item.Value}}
                    Dim userDt As DataTable = DB.GetData(sql, params)

                    If userDt.Rows.Count > 0 Then
                        dt.Rows.Add(
                            userDt.Rows(0)("UserID"),
                            userDt.Rows(0)("FullName"),
                            userDt.Rows(0)("RoleName"),
                            userDt.Rows(0)("DeptName"),
                            "View"  ' ← default للـ يوزر الجديد
                        )
                    End If
                End If
            End If
        Next

        Session("DeptAccess") = dt
        rptDeptAccess.DataSource = dt
        rptDeptAccess.DataBind()
        RestorePermissions()
        pnlDeptUsers.Visible = False
    End Sub

    Protected Sub btnCloseDeptUsers_Click(sender As Object, e As EventArgs) Handles btnCloseDeptUsers.Click
        pnlDeptUsers.Visible = False
    End Sub

    Protected Sub lnkDelete_Click(sender As Object, e As EventArgs)
        Dim btn As LinkButton = CType(sender, LinkButton)
        Dim userID As String = btn.CommandArgument

        If Session("DeptAccess") IsNot Nothing Then
            Dim dt As DataTable = CType(Session("DeptAccess"), DataTable)
            Dim rows = dt.Select("ID='" & userID & "'")
            If rows.Length > 0 Then
                rows(0).Delete()
                dt.AcceptChanges()
            End If
            Session("DeptAccess") = dt
            rptDeptAccess.DataSource = dt
            rptDeptAccess.DataBind()
            RestorePermissions()
        End If
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
            Dim rows = dt.Select("ID='" & item.Value & "'")
            If rows.Length > 0 Then
                item.Selected = True
            End If
        Next
    End Sub

    Private Sub SaveCurrentPermissions()
        If Session("DeptAccess") Is Nothing Then Exit Sub
        Dim dt As DataTable = CType(Session("DeptAccess"), DataTable)

        If Not dt.Columns.Contains("Permission") Then
            dt.Columns.Add("Permission", GetType(String))
            For Each row As DataRow In dt.Rows
                row("Permission") = "View"
            Next
        End If

        ' اقرئي من الـ Request مباشرة قبل أي DataBind
        For Each item As RepeaterItem In rptDeptAccess.Items
            Dim ddl As DropDownList = CType(item.FindControl("ddlPermission"), DropDownList)
            If ddl IsNot Nothing Then
                Dim val As String = Request.Form(ddl.UniqueID)
                If Not String.IsNullOrEmpty(val) Then
                    dt.Rows(item.ItemIndex)("Permission") = val
                End If
            End If
        Next

        Session("DeptAccess") = dt
    End Sub

    Private Sub RestorePermissions()
        If Session("DeptAccess") Is Nothing Then Exit Sub
        Dim dt As DataTable = CType(Session("DeptAccess"), DataTable)
        If Not dt.Columns.Contains("Permission") Then Exit Sub

        For Each item As RepeaterItem In rptDeptAccess.Items
            Dim ddl As DropDownList = CType(item.FindControl("ddlPermission"), DropDownList)
            If ddl IsNot Nothing Then
                Dim savedPerm As String = dt.Rows(item.ItemIndex)("Permission").ToString()
                Dim listItem = ddl.Items.FindByValue(savedPerm)
                If listItem IsNot Nothing Then
                    listItem.Selected = True
                End If
            End If
        Next
    End Sub

    Private Function GetPermissions(selectedValue As String) As Dictionary(Of String, Integer)
        Dim p As New Dictionary(Of String, Integer) From {
        {"CanRead", 1}, {"CanUpload", 0}, {"CanEdit", 0},
        {"CanDownload", 0}, {"CanDelete", 0}
    }
        Select Case selectedValue
            Case "Download"
                p("CanDownload") = 1
            Case "Upload"
                p("CanUpload") = 1
            Case "Edit"
                p("CanEdit") = 1
            Case "DownloadEdit"
                p("CanDownload") = 1 : p("CanEdit") = 1
            Case "Delete"
                p("CanDelete") = 1
            Case "FullAccess"
                p("CanUpload") = 1 : p("CanEdit") = 1
                p("CanDownload") = 1 : p("CanDelete") = 1
        End Select
        Return p
    End Function

    Protected Sub btnSend_Click(sender As Object, e As EventArgs) Handles btnSend.Click
        Page.Validate("task")
        If Not Page.IsValid Then Exit Sub

        If Session("DeptAccess") Is Nothing Then Exit Sub
        Dim dt As DataTable = CType(Session("DeptAccess"), DataTable)
        If dt.Rows.Count = 0 Then Exit Sub

        Dim createdBy As Integer = CInt(Session("UserID"))

        Dim sqlTask As String = "INSERT INTO Document_Tasks 
                             (RequestedDocName, Instructions, Deadline, ReminderEvery, ReminderUnit,
                              MicrosoftFormLink, DeptID, ProgramID, CategoryID, CreatedBy, CreatedAt)
                             VALUES 
                             (@Name, @Instructions, @Deadline, @Reminder, @ReminderUnit,
                              @Link, @DeptID, @ProgramID, @CategoryID,  @CreatedBy, GETDATE())"

        Dim taskParams As New Dictionary(Of String, Object) From {
            {"@Name", txtName.Text.Trim()},
            {"@Instructions", txtInstruction.Text.Trim()},
            {"@Deadline", CDate(txtDate.Text)},
            {"@Reminder", CInt(txtEvery.Text.Trim())},
            {"@ReminderUnit", ddlReminderPeriod.SelectedValue},
            {"@Link", If(link.Text.Trim() = "", DBNull.Value, link.Text.Trim())},
            {"@DeptID", CInt(ddlDept.SelectedValue)},
            {"@ProgramID", CInt(ProgramList.SelectedValue)},
            {"@CategoryID", CInt(CategoryList.SelectedValue)},
            {"@CreatedBy", createdBy}
        }

        Dim taskID As Integer = DB.ExecuteWithID(sqlTask, taskParams)


        For Each item As RepeaterItem In rptDeptAccess.Items
            Dim ddl As DropDownList = CType(item.FindControl("ddlPermission"), DropDownList)
            Dim perm = GetPermissions(ddl.SelectedValue)
            Dim userID As Integer = CInt(dt.Rows(item.ItemIndex)("ID"))

            ' ← هاد الجديد
            Dim targetDocID As Object = DBNull.Value
            If perm("CanEdit") = 1 AndAlso ddlTargetDoc.SelectedValue <> "" Then
                targetDocID = CInt(ddlTargetDoc.SelectedValue)
            End If

            Dim sqlAssignee As String = "INSERT INTO Task_Assignees 
         (TaskID, UserID, CanRead, CanUpload, CanEdit, 
          CanDownload, CanDelete, Status, TargetDocumentID, UploadedDocID)
         VALUES 
         (@TaskID, @UserID, @CanRead, @CanUpload, @CanEdit,
          @CanDownload, @CanDelete, 'Pending', @TargetDocID, NULL)"

            Dim assigneeParams As New Dictionary(Of String, Object) From {
        {"@TaskID", taskID},
        {"@UserID", userID},
        {"@CanRead", perm("CanRead")},
        {"@CanUpload", perm("CanUpload")},
        {"@CanEdit", perm("CanEdit")},
        {"@CanDownload", perm("CanDownload")},
        {"@CanDelete", perm("CanDelete")},
        {"@TargetDocID", targetDocID}
    }
            DB.Execute(sqlAssignee, assigneeParams)
        Next

        Session("DeptAccess") = Nothing

        ClientScript.RegisterStartupScript(Me.GetType(), "success", "
        Swal.fire({
            text: 'Task sent successfully!',
            icon: 'success',
            confirmButtonText: 'OK'
        }).then((result) => {
            if (result.isConfirmed) { window.location.href = 'Dashboard.aspx'; }
        });", True)
    End Sub

    Protected Sub cvUsers_ServerValidate(source As Object, args As ServerValidateEventArgs) Handles cvUsers.ServerValidate
        If Session("DeptAccess") Is Nothing Then
            args.IsValid = False
            Exit Sub
        End If
        Dim dt As DataTable = CType(Session("DeptAccess"), DataTable)
        args.IsValid = (dt.Rows.Count > 0)
    End Sub

End Class