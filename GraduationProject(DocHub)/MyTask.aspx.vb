Imports System.Data
Imports System.Data.SqlClient

Public Class MyTask
    Inherits System.Web.UI.Page

    Private ReadOnly ConnStr As String =
        ConfigurationManager.ConnectionStrings("DocHubDB").ConnectionString

    Private ReadOnly Property CurrentUserID As Integer
        Get
            If Session("UserID") IsNot Nothing Then
                Return Convert.ToInt32(Session("UserID"))
            End If
            Return 0
        End Get
    End Property

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If CurrentUserID = 0 Then
            Response.Redirect("Login.aspx")
            Return
        End If
        If Not IsPostBack Then
            LoadMyTasks()
        End If
    End Sub

    Private Sub LoadMyTasks()
        Dim sql As String = "
            SELECT
                ta.AssigneeID,
                dt.TaskID,
                dt.RequestedDocName   AS TaskName,
                dt.Deadline,
                dt.ReminderEvery,
                dt.MicrosoftFormLink,
                dt.Instructions,
                ta.Status,
                ta.CompletedAt,
                ta.CanUpload,
                ta.CanEdit,
                creator.FullName      AS CreatedByName,
                dt.CreatedAt          AS RequestedDate
            FROM  Task_Assignees  ta
            JOIN  Document_Tasks  dt      ON ta.TaskID    = dt.TaskID
            JOIN  Users           creator ON dt.CreatedBy = creator.UserID
            WHERE ta.UserID = @UserID
            ORDER BY dt.Deadline ASC
        "

        Dim pending As New DataTable
        Dim completed As New DataTable

        For Each tbl As DataTable In {pending, completed}
            tbl.Columns.Add("AssigneeID", GetType(Integer))
            tbl.Columns.Add("TaskID", GetType(Integer))
            tbl.Columns.Add("TaskName")
            tbl.Columns.Add("RequestedBy")
            tbl.Columns.Add("RequestedDate")
            tbl.Columns.Add("DaysLeft", GetType(Integer))
            tbl.Columns.Add("ReminderPeriod")
            tbl.Columns.Add("HasMSForm", GetType(Boolean))
            tbl.Columns.Add("Instruction")
            tbl.Columns.Add("TaskType")
            tbl.Columns.Add("TaskLink")
            tbl.Columns.Add("Deadline")
            tbl.Columns.Add("CompletedDate")
        Next

        Using conn As New SqlConnection(ConnStr)
            Using cmd As New SqlCommand(sql, conn)
                cmd.Parameters.AddWithValue("@UserID", CurrentUserID)
                conn.Open()
                Using reader As SqlDataReader = cmd.ExecuteReader()
                    While reader.Read()
                        Dim deadline As DateTime = Convert.ToDateTime(reader("Deadline"))
                        Dim daysLeft As Integer = (deadline - DateTime.Today).Days
                        Dim deadlineStr As String = deadline.ToString("MMM d, yyyy")

                        Dim formLink As String = If(IsDBNull(reader("MicrosoftFormLink")), "",
                                                    reader("MicrosoftFormLink").ToString())
                        Dim hasMSForm As Boolean = (formLink <> "")
                        Dim canUpload As Boolean = Convert.ToBoolean(reader("CanUpload"))
                        Dim canEdit As Boolean = Convert.ToBoolean(reader("CanEdit"))

                        ' تحديد نوع التاسك
                        Dim taskType As String
                        If formLink <> "" Then
                            taskType = "link"
                        ElseIf canEdit Then
                            taskType = "edit"
                        Else
                            taskType = "upload"
                        End If

                        Dim requestedDate As String =
                            Convert.ToDateTime(reader("RequestedDate")).ToString("MMM d, yyyy")

                        Dim completedDate As String = ""
                        If Not IsDBNull(reader("CompletedAt")) Then
                            completedDate = Convert.ToDateTime(reader("CompletedAt")).ToString("MMM d, yyyy")
                        End If

                        Dim rowData() As Object = {
                            CInt(reader("AssigneeID")),
                            CInt(reader("TaskID")),
                            reader("TaskName").ToString(),
                            reader("CreatedByName").ToString(),
                            requestedDate,
                            daysLeft,
                            "Every " & reader("ReminderEvery").ToString() & " days",
                            hasMSForm,
                            reader("Instructions").ToString(),
                            taskType,
                            formLink,
                            deadlineStr,
                            completedDate
                        }

                        If reader("Status").ToString() = "Done" Then
                            completed.Rows.Add(rowData)
                        Else
                            pending.Rows.Add(rowData)
                        End If
                    End While
                End Using
            End Using
        End Using

        ' Bind البيانات
        rptPending.DataSource = pending
        rptPending.DataBind()
        rptCompleted.DataSource = completed
        rptCompleted.DataBind()

        ' تحديث الأرقام
        lblPendingCount.Text = pending.Rows.Count.ToString()
        lblCompletedCount.Text = completed.Rows.Count.ToString()
        lblTotalCount.Text = (pending.Rows.Count + completed.Rows.Count).ToString()
        lblPendingHeader.Text = pending.Rows.Count.ToString()
        lblCompletedHeader.Text = completed.Rows.Count.ToString()

        ' إظهار/إخفاء الـ empty states
        pnlNoPending.Visible = (pending.Rows.Count = 0)
        pnlNoCompleted.Visible = (completed.Rows.Count = 0)
        pnlCompletedTable.Visible = (completed.Rows.Count > 0)
    End Sub

    ' MarkDone - بيتشغل لما الشخص يضغط "Mark as Done" على تاسك من نوع link
    Protected Sub MarkDone_Click(sender As Object, e As CommandEventArgs)
        Dim assigneeID As Integer = Convert.ToInt32(e.CommandArgument)

        Using conn As New SqlConnection(ConnStr)
            Dim sql = "UPDATE Task_Assignees
                       SET Status = 'Done', CompletedAt = GETDATE()
                       WHERE AssigneeID = @ID AND UserID = @UserID"
            Using cmd As New SqlCommand(sql, conn)
                cmd.Parameters.AddWithValue("@ID", assigneeID)
                cmd.Parameters.AddWithValue("@UserID", CurrentUserID)
                conn.Open()
                cmd.ExecuteNonQuery()
            End Using
        End Using

        LoadMyTasks()
    End Sub

    ' دالة مساعدة لتوليد زر الأكشن حسب نوع التاسك
    Protected Function GetActionButton(taskType As String, taskLink As String, assigneeID As String) As String
        Select Case taskType.ToLower()
            Case "upload"
                Return "<a href='UploadTask.aspx?assigneeID=" & assigneeID & "' class='btnUpload'>↑ Upload File</a>"
            Case "link"
                Return String.Format("<button class='btnLink' onclick=""window.open('{0}','_blank');return false;"">🔗 Open Link</button>",
                                 Server.HtmlEncode(taskLink))
            Case "edit"
                Return "<a href='EditPage.aspx?assigneeID=" & assigneeID & "' class='btnEdit'>✎ Edit Document</a>"
            Case Else
                Return ""
        End Select
    End Function

End Class