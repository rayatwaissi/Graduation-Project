Public Class TrackTask
    Inherits System.Web.UI.Page

    Private Const PageSize As Integer = 3

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        If Not IsPostBack Then
            Session("CurrentPage") = 1
            LoadTasks("")
        End If
    End Sub

    Private Sub LoadTasks(searchText As String)

        Dim tasks As New DataTable
        tasks.Columns.Add("TaskID")
        tasks.Columns.Add("RequestedDocName")
        tasks.Columns.Add("Deadline")
        tasks.Columns.Add("MicrosoftFormLink")
        tasks.Columns.Add("ProgramName")
        tasks.Columns.Add("OverallStatus")
        tasks.Columns.Add("ProgressText")
        tasks.Columns.Add("ProgressPercent")

        tasks.Rows.Add("1", "خطة مادة البرمجة", "2025-03-20", DBNull.Value, "بكالوريوس تقنية معلومات", "In Progress", "2 of 3 uploaded", "66")
        tasks.Rows.Add("2", "استبيان تقييم المنهج", "2025-03-22", "https://forms.microsoft.com/xxx", "بكالوريوس علوم حاسوب", "In Progress", "1 of 2 reviewed", "50")
        tasks.Rows.Add("3", "خطة مادة قواعد البيانات", "2025-03-10", DBNull.Value, "بكالوريوس علوم حاسوب", "Completed", "2 of 2 uploaded", "100")
        tasks.Rows.Add("4", "تقرير نهاية الفصل", "2025-04-01", DBNull.Value, "بكالوريوس تقنية معلومات", "In Progress", "0 of 2 uploaded", "0")
        tasks.Rows.Add("5", "استبيان رضا الطلاب", "2025-04-05", "https://forms.microsoft.com/yyy", "بكالوريوس علوم حاسوب", "In Progress", "1 of 3 reviewed", "33")

        Dim allTasks As DataTable
        If searchText <> "" Then
            Dim filtered = tasks.Select("RequestedDocName LIKE '%" & searchText & "%'")
            If filtered.Length = 0 Then
                pnlNoTasks.Visible = True
                rptTasks.Visible = False
                btnPrev.Visible = False
                btnNext.Visible = False
                lblPageInfo.Text = ""
                Exit Sub
            End If
            allTasks = filtered.CopyToDataTable()
        Else
            allTasks = tasks
        End If

        Dim currentPage As Integer = If(Session("CurrentPage") IsNot Nothing, CInt(Session("CurrentPage")), 1)
        Dim totalPages As Integer = CInt(Math.Ceiling(allTasks.Rows.Count / PageSize))

        If currentPage < 1 Then currentPage = 1
        If currentPage > totalPages Then currentPage = totalPages
        Session("CurrentPage") = currentPage

        Dim startIndex As Integer = (currentPage - 1) * PageSize
        Dim pagedTasks As DataTable = allTasks.Clone()
        For i As Integer = startIndex To Math.Min(startIndex + PageSize - 1, allTasks.Rows.Count - 1)
            pagedTasks.ImportRow(allTasks.Rows(i))
        Next

        rptTasks.DataSource = pagedTasks
        pnlNoTasks.Visible = False
        rptTasks.Visible = True
        rptTasks.DataBind()

        btnPrev.Visible = (currentPage > 1)
        btnNext.Visible = (currentPage < totalPages)
        lblPageInfo.Text = "Page " & currentPage & " of " & totalPages

    End Sub

    Protected Sub rptTasks_ItemDataBound(sender As Object, e As RepeaterItemEventArgs)

        If e.Item.ItemType <> ListItemType.Item AndAlso
           e.Item.ItemType <> ListItemType.AlternatingItem Then Exit Sub

        Dim row As DataRowView = CType(e.Item.DataItem, DataRowView)
        Dim taskID As String = row("TaskID").ToString()
        Dim formLink As String = If(IsDBNull(row("MicrosoftFormLink")), "", row("MicrosoftFormLink").ToString())
        Dim status As String = row("OverallStatus").ToString()
        Dim percent As String = row("ProgressPercent").ToString()
        Dim deadline As String = row("Deadline").ToString()

        Dim lblTaskIcon As Label = CType(e.Item.FindControl("lblTaskIcon"), Label)
        lblTaskIcon.Text = If(formLink = "", "📄 ", "🔗 ")

        Dim lblTaskName As Label = CType(e.Item.FindControl("lblTaskName"), Label)
        lblTaskName.Text = row("RequestedDocName").ToString()

        Dim lblBadge As Label = CType(e.Item.FindControl("lblBadge"), Label)
        If status = "Completed" Then
            lblBadge.CssClass = "badge badge-done"
        Else
            lblBadge.CssClass = "badge badge-progress"
        End If
        lblBadge.Text = status

        Dim lblProgram As Label = CType(e.Item.FindControl("lblProgram"), Label)
        lblProgram.Text = row("ProgramName").ToString()

        Dim lblDeadline As Label = CType(e.Item.FindControl("lblDeadline"), Label)
        Dim d As DateTime
        If DateTime.TryParse(deadline, d) Then
            Dim daysLeft As Integer = (d - DateTime.Today).Days
            If daysLeft > 0 Then
                lblDeadline.Text = d.ToString("MMMM dd") & " · " & daysLeft & " days left"
                lblDeadline.CssClass = "deadlineRed"
            ElseIf daysLeft = 0 Then
                lblDeadline.Text = d.ToString("MMMM dd") & " · Today!"
                lblDeadline.CssClass = "deadlineRed"
            Else
                lblDeadline.Text = d.ToString("MMMM dd") & " · Overdue"
                lblDeadline.CssClass = ""
            End If
        End If

        Dim lblProgress As Label = CType(e.Item.FindControl("lblProgress"), Label)
        lblProgress.Text = row("ProgressText").ToString()

        Dim pnlProgressFill As Panel = CType(e.Item.FindControl("pnlProgressFill"), Panel)
        Dim p As Integer = 0
        Integer.TryParse(percent, p)
        pnlProgressFill.Style("width") = percent & "%"
        pnlProgressFill.Style("background") = If(p = 100, "#2e7d32", "#0f70b7")

        Dim lblProgressLabel As Label = CType(e.Item.FindControl("lblProgressLabel"), Label)
        lblProgressLabel.Text = percent & "% completed"

        Dim assignees As New DataTable
        assignees.Columns.Add("AssigneeID")
        assignees.Columns.Add("UserID")
        assignees.Columns.Add("FullName")
        assignees.Columns.Add("CanUpload")
        assignees.Columns.Add("CanEdit")
        assignees.Columns.Add("Status")
        assignees.Columns.Add("UploadedDocID")
        assignees.Columns.Add("DocumentName")
        assignees.Columns.Add("FormLink")

        If taskID = "1" Then
            assignees.Rows.Add("1", "101", "Dr. Raya", "1", "0", "Done", "10", "خطة_رايا.pdf", "")
            assignees.Rows.Add("2", "102", "Dr. Tasnim", "1", "0", "Done", "11", "خطة_السلام.pdf", "")
            assignees.Rows.Add("3", "103", "Dr. Yasmeen", "1", "0", "Pending", "", "", "")
        ElseIf taskID = "2" Then
            assignees.Rows.Add("4", "104", "Dr. Omar", "0", "0", "Done", "", "", formLink)
            assignees.Rows.Add("5", "105", "Dr. Sara", "0", "0", "Pending", "", "", formLink)
        ElseIf taskID = "3" Then
            assignees.Rows.Add("6", "101", "Dr. Ahmad", "1", "0", "Done", "12", "db_plan_ahmad.pdf", "")
            assignees.Rows.Add("7", "102", "Dr. Lena", "1", "0", "Done", "13", "db_plan_lena.pdf", "")
        ElseIf taskID = "4" Then
            assignees.Rows.Add("8", "103", "Dr. Yasmeen", "1", "0", "Pending", "", "", "")
            assignees.Rows.Add("9", "104", "Dr. Omar", "1", "0", "Pending", "", "", "")
        ElseIf taskID = "5" Then
            assignees.Rows.Add("10", "101", "Dr. Raya", "0", "0", "Done", "", "", formLink)
            assignees.Rows.Add("11", "102", "Dr. Tasnim", "0", "0", "Pending", "", "", formLink)
            assignees.Rows.Add("12", "105", "Dr. Sara", "0", "0", "Pending", "", "", formLink)
        End If

        Dim rptAssignees As Repeater = CType(e.Item.FindControl("rptAssignees"), Repeater)
        rptAssignees.DataSource = assignees
        rptAssignees.DataBind()

    End Sub

    Protected Sub rptAssignees_ItemDataBound(sender As Object, e As RepeaterItemEventArgs)

        If e.Item.ItemType <> ListItemType.Item AndAlso
           e.Item.ItemType <> ListItemType.AlternatingItem Then Exit Sub

        Dim row As DataRowView = CType(e.Item.DataItem, DataRowView)
        Dim fullName As String = row("FullName").ToString()
        Dim canEdit As String = row("CanEdit").ToString()
        Dim fLink As String = row("FormLink").ToString()
        Dim assigneeStatus As String = row("Status").ToString()
        Dim docName As String = row("DocumentName").ToString()
        Dim assigneeID As String = row("AssigneeID").ToString()
        Dim uploadedDocID As String = row("UploadedDocID").ToString()

        Dim lblAvatar As Label = CType(e.Item.FindControl("lblAvatar"), Label)
        Dim colors() As String = {"#1565c0", "#00897b", "#6a1b9a", "#e65100", "#c62828", "#2e7d32", "#0277bd"}
        Dim colorIndex As Integer = Math.Abs(fullName.GetHashCode()) Mod colors.Length
        lblAvatar.Style("background") = colors(colorIndex)
        Dim parts = fullName.Trim().Split(" "c)
        Dim initials As String = ""
        If parts.Length >= 2 Then
            initials = parts(0)(0).ToString().ToUpper() & parts(1)(0).ToString().ToUpper()
        ElseIf parts.Length = 1 AndAlso parts(0).Length > 0 Then
            initials = parts(0)(0).ToString().ToUpper()
        End If
        lblAvatar.Text = initials

        Dim lblFullName As Label = CType(e.Item.FindControl("lblFullName"), Label)
        lblFullName.Text = fullName

        Dim lblTypeTag As Label = CType(e.Item.FindControl("lblTypeTag"), Label)
        If fLink <> "" Then
            lblTypeTag.CssClass = "typeTag type-link"
            lblTypeTag.Text = "Link"
        ElseIf canEdit = "1" Then
            lblTypeTag.CssClass = "typeTag type-edit"
            lblTypeTag.Text = "Edit"
        Else
            lblTypeTag.CssClass = "typeTag type-upload"
            lblTypeTag.Text = "Upload"
        End If

        Dim lblFileStatus As Label = CType(e.Item.FindControl("lblFileStatus"), Label)
        If fLink <> "" Then
            If assigneeStatus = "Done" Then
                lblFileStatus.CssClass = "reviewed"
                lblFileStatus.Text = "✅ Link Reviewed"
            Else
                lblFileStatus.CssClass = "noFile"
                lblFileStatus.Text = "Not reviewed yet"
            End If
        ElseIf canEdit = "1" Then
            If assigneeStatus = "Done" Then
                lblFileStatus.CssClass = "reviewed"
                lblFileStatus.Text = "✅ Edit Submitted"
            Else
                lblFileStatus.CssClass = "noFile"
                lblFileStatus.Text = "Not edited yet"
            End If
        Else
            If assigneeStatus = "Done" AndAlso docName <> "" Then
                lblFileStatus.CssClass = "fileLink"
                lblFileStatus.Text = docName
            Else
                lblFileStatus.CssClass = "noFile"
                lblFileStatus.Text = "Not uploaded yet"
            End If
        End If

        Dim lblStatus As Label = CType(e.Item.FindControl("lblStatus"), Label)
        If assigneeStatus = "Done" Then
            lblStatus.CssClass = "statusDone"
            lblStatus.Text = "✅ Done"
        Else
            lblStatus.CssClass = "statusPend"
            lblStatus.Text = "⏳ Pending"
        End If



    End Sub

    Protected Sub btnSearch_Click(sender As Object, e As EventArgs)
        Session("CurrentPage") = 1
        LoadTasks(txtSearch.Text.Trim())
    End Sub

    Protected Sub btnPrev_Click(sender As Object, e As EventArgs)
        Dim currentPage As Integer = If(Session("CurrentPage") IsNot Nothing, CInt(Session("CurrentPage")), 1)
        Session("CurrentPage") = currentPage - 1
        LoadTasks(txtSearch.Text.Trim())
    End Sub

    Protected Sub btnNext_Click(sender As Object, e As EventArgs)
        Dim currentPage As Integer = If(Session("CurrentPage") IsNot Nothing, CInt(Session("CurrentPage")), 1)
        Session("CurrentPage") = currentPage + 1
        LoadTasks(txtSearch.Text.Trim())
    End Sub



    Protected Sub btnView_Click(sender As Object, e As EventArgs)
        Dim btn As Button = CType(sender, Button)
        Dim docID As String = btn.CommandArgument
        ' بعدين: Response.Redirect("ViewDocument.aspx?id=" & docID)
    End Sub

    Protected Sub btnRemind_Click(sender As Object, e As EventArgs)
        Dim btn As Button = CType(sender, Button)
        Dim assigneeID As String = btn.CommandArgument
        ' بعدين: إرسال إشعار تذكير للداتابيس
    End Sub

    Protected Sub rptTasks_ItemCommand(source As Object, e As RepeaterCommandEventArgs) Handles rptTasks.ItemCommand

    End Sub
End Class