Public Class Notifications
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            LoadNotifications()
        End If

    End Sub

    Private Sub LoadNotifications()

        ' ── جيبي الإشعارات من الـ Session ──
        If Session("Notifications") Is Nothing Then
            NoNotification_pnlEmpty.Visible = True
            Exit Sub
        End If

        Dim dt As DataTable = CType(Session("Notifications"), DataTable)

        If dt.Rows.Count = 0 Then
            NoNotification_pnlEmpty.Visible = True
            Exit Sub
        End If

        ' ── اعرضي الإشعارات ──
        rptNotifications.DataSource = dt
        rptNotifications.DataBind()

        ' ── احسبي عدد الغير مقروء ──
        Dim unread = dt.Select("IsRead = '0'").Length
        lblUnread.Text = unread & " Unread"

    End Sub



    ' ── زر Mark All as Read ──
    Protected Sub btnMarkAll_Click(sender As Object, e As EventArgs) Handles btnMarkAll.Click

        If Session("Notifications") IsNot Nothing Then
            Dim dt As DataTable = CType(Session("Notifications"), DataTable)
            For Each row As DataRow In dt.Rows
                row("IsRead") = "1"
            Next
            Session("Notifications") = dt
        End If

        LoadNotifications()

    End Sub

    ' ── فتح الـ Popup ──
    Protected Sub btnView_Click(sender As Object, e As EventArgs)

        Dim btn As Button = CType(sender, Button)

        ' جيبي الـ Index من الـ CommandArgument
        Dim index As Integer = CInt(btn.CommandArgument)
        If Session("Notifications") IsNot Nothing Then

            Dim dt As DataTable = CType(Session("Notifications"), DataTable)

            If index >= 0 AndAlso index < dt.Rows.Count Then

                Dim row As DataRow = dt.Rows(index)

                lblPopupMessage.Text = row("Message").ToString()
                lblDeadline.Text = row("TaskDeadline").ToString
                lblPopupFrom.Text = row("CreatedBy").ToString
                lblPopupTime.Text = row("Time").ToString()



                ' ── علّمي الإشعار كمقروء ──
                row("IsRead") = "1"

                Session("Notifications") = dt
                pnlPopup.Visible = True
                ' ── أعيدي تحميل الإشعارات عشان تتحدث النقطة ──
                LoadNotifications()

            End If
        End If

    End Sub

    ' ── إغلاق الـ Popup ──
    Protected Sub btnClosePopup_Click(sender As Object, e As EventArgs) Handles btnClosePopup.Click
        pnlPopup.Visible = False
        Response.Redirect("Notifications.aspx")

    End Sub
End Class