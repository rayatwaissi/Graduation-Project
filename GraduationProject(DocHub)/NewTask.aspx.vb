Imports Microsoft.VisualBasic.Devices
Imports WebGrease

Public Class NewTask
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            LoadDeptCheckbox()
        Else
            If Session("DeptAccess") IsNot Nothing Then

                rptDeptAccess.DataSource = CType(Session("DeptAccess"), DataTable)
                'Repeater رجّع عرض اليوزرز داخل الـ 
                rptDeptAccess.DataBind()
            End If
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

    Protected Sub btnSend_Click(sender As Object, e As EventArgs) Handles btnSend.Click
        Page.Validate("task")  ' ← This is the key fix

        If Not Page.IsValid Then
            Exit Sub
        End If

        ' ── جيبي اليوزرين المختارين من الـ Session ──
        If Session("DeptAccess") IsNot Nothing Then

            Dim dt As DataTable = CType(Session("DeptAccess"), DataTable)

            ' ── جيبي اسم المرسل من الـ Session ──
            Dim senderName As String = "Ahmad (Liaison)" ' مؤقتاً، بعدين من Session("UserName")
            Dim TaskName As String = txtName.Text
            Dim deadline As String = txtDate.Text
            Dim TaskType As String = ddlTaskType.SelectedItem.Text

            ' ── جيبي قائمة الإشعارات الحالية أو اعملي جديدة ──
            Dim notifications As DataTable

            If Session("Notifications") IsNot Nothing Then
                notifications = CType(Session("Notifications"), DataTable)
            Else
                notifications = New DataTable
                notifications.Columns.Add("CreatedBy")
                notifications.Columns.Add("ToUserID")
                notifications.Columns.Add("ToUserName")
                notifications.Columns.Add("Message")
                notifications.Columns.Add("Time")
                notifications.Columns.Add("TaskDeadline")
                notifications.Columns.Add("IsRead")
            End If

            ' ── ابعتي إشعار لكل يوزر مختار ──
            For Each row As DataRow In dt.Rows
                notifications.Rows.Add(
                senderName,
                row("ID"),
                row("Name"),
                senderName & " requested you to work this task: " & TaskType & " " & TaskName & " — Due " & deadline,
                DateTime.Now.ToString("MMM dd, yyyy hh:mm tt"),
                deadline,
                "0"
              )
            Next

            Session("Notifications") = notifications
            Session("SenderName") = senderName

        End If


        ' ── امسحي الـ Session بعد الإرسال ──
        Session("DeptAccess") = Nothing

        ' ── روحي لصفحة ثانية أو اعرضي رسالة نجاح ──
        ClientScript.RegisterStartupScript(Me.GetType(), "success", "
               Swal.fire({
                         text: 'Task sent successfully!',
                         icon: 'success',
                         confirmButtonText: 'OK'
                                                 }).then((result) => {
                          if (result.isConfirmed) {window.location.href = 'Notifications.aspx';}
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