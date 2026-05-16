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
        If Not IsPostBack Then
            If CurrentUserID = 0 Then
                Response.Redirect("Login.aspx")
                Return
            End If
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

        For Each dt As DataTable In {pending, completed}
            dt.Columns.Add("AssigneeID", GetType(Integer))
            dt.Columns.Add("TaskID", GetType(Integer))
            dt.Columns.Add("TaskName")
            dt.Columns.Add("RequestedBy")
            dt.Columns.Add("RequestedDate")
            dt.Columns.Add("DaysLeft", GetType(Integer))
            dt.Columns.Add("ReminderPeriod")
            dt.Columns.Add("HasMSForm", GetType(Boolean))
            dt.Columns.Add("Instruction")
            dt.Columns.Add("TaskType")
            dt.Columns.Add("TaskLink")
            dt.Columns.Add("Deadline")
            dt.Columns.Add("CompletedDate")
        Next

        Using conn As New SqlConnection(ConnStr)
            Using cmd As New SqlCommand(sql, conn)
                cmd.CommandTimeout = 60
                cmd.Parameters.AddWithValue("@UserID", CurrentUserID)
                conn.Open()
                Using reader As SqlDataReader = cmd.ExecuteReader()
                    While reader.Read()
                        Dim deadline As DateTime = Convert.ToDateTime(reader("Deadline"))
                        Dim daysLeft As Integer = (deadline - DateTime.Today).Days
                        Dim deadlineStr As String = deadline.ToString("MMM d, yyyy")
                        Dim reminderDays As Integer = Convert.ToInt32(reader("ReminderEvery"))
                        '''''''''''''----------------------------
                        Dim reminderStr As String = "every " & reminderDays & " days"
                        Dim formLink As String = If(IsDBNull(reader("MicrosoftFormLink")), "", reader("MicrosoftFormLink").ToString())
                        Dim hasMSForm As Boolean = (formLink <> "")
                        Dim canEdit As Boolean = Convert.ToBoolean(reader("CanEdit"))

                        Dim taskType As String
                        If formLink <> "" Then
                            taskType = "link"
                        ElseIf canEdit Then
                            taskType = "edit"
                        Else
                            taskType = "upload"
                        End If

                        Dim requestedDate As String = Convert.ToDateTime(reader("RequestedDate")).ToString("MMM d, yyyy")
                        Dim completedDate As String = ""
                        If Not IsDBNull(reader("CompletedAt")) Then
                            completedDate = Convert.ToDateTime(reader("CompletedAt")).ToString("MMM d, yyyy")
                        End If

                        Dim rowData() As Object = {
                            reader("AssigneeID"),
                            reader("TaskID"),
                            reader("TaskName").ToString(),
                            reader("CreatedByName").ToString(),
                            requestedDate,
                            daysLeft,
                            reminderStr,
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

        rptPending.DataSource = pending
        rptPending.DataBind()
        rptCompleted.DataSource = completed
        rptCompleted.DataBind()

        lblPendingCount.Text = pending.Rows.Count.ToString()
        lblCompletedCount.Text = completed.Rows.Count.ToString()
        lblTotalCount.Text = (pending.Rows.Count + completed.Rows.Count).ToString()
        lblPendingHeader.Text = pending.Rows.Count.ToString()
        lblCompletedHeader.Text = completed.Rows.Count.ToString()

        pnlNoPending.Visible = (pending.Rows.Count = 0)
        pnlNoCompleted.Visible = (completed.Rows.Count = 0)
        pnlCompletedTable.Visible = (completed.Rows.Count > 0)
    End Sub

    Protected Sub MarkDone_Click(sender As Object, e As CommandEventArgs)
        Dim assigneeID As Integer = Convert.ToInt32(e.CommandArgument)

        Using conn As New SqlConnection(ConnStr)
            Dim sql = "UPDATE Task_Assignees
                       SET Status='Done', CompletedAt=GETDATE()
                       WHERE AssigneeID=@ID AND UserID=@UserID"
            Using cmd As New SqlCommand(sql, conn)
                cmd.Parameters.AddWithValue("@ID", assigneeID)
                cmd.Parameters.AddWithValue("@UserID", CurrentUserID)
                conn.Open()
                cmd.ExecuteNonQuery()
            End Using
        End Using

        LoadMyTasks()
    End Sub



    Protected Function GetActionButton(taskType As String, taskLink As String) As String
        Select Case taskType.ToLower()
            Case "upload"
                Return "<button class='btnUpload'>↑ Upload File</button>"
            Case "link"
                Return String.Format("<button class='btnLink' onclick=""window.open('{0}','_blank')"">🔗 Open Link</button>",
                                     Server.HtmlEncode(taskLink))
            Case "edit"
                Return "<button class='btnEdit'>✎ Edit Document</button>"
            Case Else
                Return ""
        End Select
    End Function

End Class