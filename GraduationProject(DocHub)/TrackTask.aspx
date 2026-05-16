
<%@ Page Title="" Language="vb" AutoEventWireup="true"  MasterPageFile="~/CommonBar.Master"  CodeBehind="TrackTask.aspx.vb"   Inherits="GraduationProject_DocHub_.TrackTask" %>

<asp:Content ID="Content3" ContentPlaceHolderID="HeadContent" runat="server">
    <link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@400;500;600;700&display=swap" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        .pageTitle { font-size: 22px; font-weight: 700; color: #0a2241; margin-bottom: 20px; }
        .searchBar { display: flex; gap: 10px; margin-bottom: 16px; align-items: center; }
        .searchInput { flex: 1; max-width: 380px; padding: 9px 14px; border: 1.5px solid #d5ddea; border-radius: 8px; font-size: 13px; color: #0a2241; background: white; }
        .searchBtn { background: #0f70b7; color: white; border: none; border-radius: 8px; padding: 9px 18px; font-size: 13px; cursor: pointer; }
        .taskCard { background: white; border-radius: 10px; border: 1.5px solid #d5ddea; margin-bottom: 18px;  }
        .taskHeader { display: flex; justify-content: space-between; align-items: center; padding: 13px 20px; border-bottom: 1px solid #eef1f6; }
        .taskName { font-size: 15px; font-weight: 600; color: #0a2241; }
        .taskHeaderRight { display: flex; align-items: center; gap: 10px; }
        .badge { border-radius: 20px; padding: 3px 12px; font-size: 11px; font-weight: 500; }
        .badge-progress { background: #fff3e0; color: #e65100; }
        .badge-done { background: #e8f5e9; color: #2e7d32; }
        .btnViewTask { background: #0f70b7; color: white; border: none; border-radius: 7px; padding: 6px 14px; font-size: 12px; cursor: pointer; }
        .btnViewTask:hover { background: #0d5fa0; }
        .taskMeta { display: flex; gap: 30px; padding: 9px 20px; background: #fafbfd; border-bottom: 1px solid #eef1f6; font-size: 12px; color: #555; flex-wrap: wrap; }
        .taskMeta b { color: #0a2241; }
        .deadlineRed { color: #e53935; font-weight: 600; }
        .progressWrap { padding: 10px 20px 6px; }
        .progressBar { height: 6px; background: #e8edf3; border-radius: 4px;  }
        .progressFill { height: 100%; border-radius: 4px; }
        .progressLabel { font-size: 11px; color: #888; margin-top: 4px; }
        .tableHeader { display: grid; grid-template-columns: 1fr 1fr 1fr 1fr; padding: 8px 20px; background: #f1f3f5; border-top: 1px solid #e0e5ed; border-bottom: 1.5px solid #d5ddea; font-size: 11px; font-weight: 600; color: #607d8b; text-transform: uppercase; letter-spacing: 1.5px; }
        .assigneeRow { display: grid; grid-template-columns: 1fr 1fr 1fr 1fr ; padding: 10px 20px; border-bottom: 1px solid #f0f4f8; align-items: center; font-size: 13px; }
        .assigneeRow:last-child { border-bottom: none; }
        .assigneeRow:hover { background: #f7f9fb; }
        .avatar { width: 28px; height: 28px; border-radius: 50%; display: inline-flex; align-items: center; justify-content: center; font-size: 10px; font-weight: 600; color: white; margin-right: 8px; flex-shrink: 0; }
        .staffCell { display: flex; align-items: center; }
        .typeTag { display: inline-block; border-radius: 20px; padding: 2px 10px; font-size: 11px; font-weight: 500; }
        .type-upload { background: #e3f2fd; color: #1565c0; }
        .type-link { background: #f3e5f5; color: #6a1b9a; }
        .type-edit { background: #e8f5e9; color: #2e7d32; }
        .fileLink { color: #1565c0; font-size: 12px; text-decoration: underline; cursor: pointer; }
        .reviewed { color: #2e7d32; font-size: 12px; font-weight: 500; }
        .noFile { color: #aaa; font-size: 12px; }
        .statusDone { color: #2e7d32; font-size: 12px; font-weight: 500; }
        .statusPend { color: #e65100; font-size: 12px; font-weight: 500; }
        .noTasks { text-align: center; padding: 40px; color: #aaa; font-size: 14px; }
        .content { min-height: calc(100vh - 70px); }
        .paginationBar { display: flex; justify-content: center; align-items: center; gap: 16px; margin-top: 10px; padding: 10px; }
        .btnPag { background: white; color: #0f70b7; border: 1.5px solid #0f70b7; border-radius: 8px; padding: 7px 18px; font-size: 13px; cursor: pointer; }
        .btnPag:hover { background: #0f70b7; color: white; }
        .pageInfo { font-size: 13px; color: #607d8b; }
    </style>
</asp:Content>

<asp:Content ID="Content4" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="pageTitle">Track Tasks</div>

    <div class="searchBar">
        <asp:TextBox ID="txtSearch" runat="server" CssClass="searchInput" placeholder="Search by task name..." />
        <asp:Button ID="btnSearch" runat="server" Text="Search" CssClass="searchBtn" OnClick="btnSearch_Click" />
    </div>

    <asp:Repeater ID="rptTasks" runat="server" OnItemDataBound="rptTasks_ItemDataBound">
        <ItemTemplate>
            <div class="taskCard">

                <div class="taskHeader">
                    <div class="taskName">
                        <asp:Label ID="lblTaskIcon" runat="server" />
                        <asp:Label ID="lblTaskName" runat="server" />
                    </div>
                    <div class="taskHeaderRight">
                        <asp:Label ID="lblBadge" runat="server" />
                       
                    </div>
                </div>

                <div class="taskMeta">
                    <span><b>Program:</b> <asp:Label ID="lblProgram" runat="server" /></span>
                    <span><b>Deadline:</b> <asp:Label ID="lblDeadline" runat="server" /></span>
                    <span><b>Progress:</b> <asp:Label ID="lblProgress" runat="server" /></span>
                </div>

                <div class="progressWrap">
                    <div class="progressBar">
                        <asp:Panel ID="pnlProgressFill" runat="server" CssClass="progressFill" />
                    </div>
                    <asp:Label ID="lblProgressLabel" runat="server" CssClass="progressLabel" />
                </div>

                <div class="tableHeader">
                    <div>Staff Member</div>
                    <div>Task Type</div>
                    <div>Document/Link</div>
                    <div>Status</div>
             
                </div>

                <asp:Repeater ID="rptAssignees" runat="server" OnItemDataBound="rptAssignees_ItemDataBound">
                    <ItemTemplate>
                        <div class="assigneeRow">

                            <div class="staffCell">
                                <asp:Label ID="lblAvatar" runat="server" CssClass="avatar" />
                                <asp:Label ID="lblFullName" runat="server" />
                            </div>

                            <div>
                                <asp:Label ID="lblTypeTag" runat="server" />
                            </div>

                            <div>
                                <asp:Label ID="lblFileStatus" runat="server" />
                            </div>

                            <div>
                                <asp:Label ID="lblStatus" runat="server" />
                            </div>

                            

                        </div>
                    </ItemTemplate>
                </asp:Repeater>

            </div>
        </ItemTemplate>
    </asp:Repeater>

    <div class="paginationBar">
        <asp:Button ID="btnPrev" runat="server" Text="← Previous" CssClass="btnPag" OnClick="btnPrev_Click" Visible="false" />
        <asp:Label ID="lblPageInfo" runat="server" CssClass="pageInfo" />
        <asp:Button ID="btnNext" runat="server" Text="Next →" CssClass="btnPag" OnClick="btnNext_Click" Visible="false" />
    </div>

    <asp:Panel ID="pnlNoTasks" runat="server" CssClass="noTasks" Visible="false">
        No tasks found.
    </asp:Panel>

</asp:Content>