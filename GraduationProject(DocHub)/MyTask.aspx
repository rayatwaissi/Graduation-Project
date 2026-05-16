<%@ Page Title="" Language="vb" AutoEventWireup="true" MasterPageFile="~/CommonBar.Master" CodeBehind="MyTask.aspx.vb" Inherits="GraduationProject_DocHub_.MyTask" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@400;500;600;700&display=swap" rel="stylesheet" />
    <style>

        .pageTitle {
            font-size: 22px;
            font-weight: 700;
            color: #0a2241;
            margin-bottom: 20px;
        }

        .statsRow {
            display: grid;
            grid-template-columns: 1fr 1fr 1fr;
            gap: 12px;
            margin-bottom: 20px;
        }

        .statCard {
            background: white;
            border-radius: 10px;
            padding: 14px 18px;
            border: 1px solid #d5ddea;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .statIcon {
            width: 38px;
            height: 38px;
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 20px;
        }

        .statIcon.pending { background: #fff3e0; }
        .statIcon.done    { background: #e8f5e9; }
        .statIcon.total   { background: #e3f2fd; }

        .statNum {
            font-size: 24px;
            font-weight: 700;
            color: #0a2241;
            line-height: 1;
        }

        .statLabel {
            font-size: 12px;
            color: #607d8b;
            margin-top: 2px;
        }

        .sectionCard {
            background: white;
            border-radius: 10px;
            border: 1px solid #d5ddea;
            margin-bottom: 16px;
        }

        .sectionHeader {
            padding: 12px 16px;
            border-bottom: 1px solid #eef1f5;
            font-weight: 700;
            font-size: 14px;
            color: #0a2241;
        }

       .pendingGrid {
    display: grid;
    grid-template-columns: 1fr;
}

.pendingGrid .taskItem {
    border-right: none;
    border-bottom: 1px solid #f0f2f5;
    padding: 14px 16px;
}

.pendingGrid .taskItem:last-child {
    border-bottom: none;
}

.btnUpload {
    background: #0f70b7;
    color: white;
    border: none;
    border-radius: 6px;
    padding: 7px 16px;
    font-size: 12px;
    font-weight: 600;
    cursor: pointer;
    font-family: 'DM Sans', sans-serif;
    text-decoration :none;
}

.btnLink {
    background: #534AB7;
    color: white;
    border: none;
    border-radius: 6px;
    padding: 7px 16px;
    font-size: 12px;
    font-weight: 600;
    cursor: pointer;
    font-family: 'DM Sans', sans-serif;

text-decoration :none;
}

.btnEdit {
    background: #3B6D11;
    color: white;
    border: none;
    border-radius: 6px;
    padding: 7px 16px;
    font-size: 12px;
    font-weight: 600;
    cursor: pointer;
    font-family: 'DM Sans', sans-serif;
    text-decoration :none;
}

.btnMark {
    background: white;
    color: #3B6D11;
    border: 1.5px solid #3B6D11;
    border-radius: 6px;
    padding: 7px 16px;
    font-size: 12px;
    font-weight: 600;
    cursor: pointer;
    font-family: 'DM Sans', sans-serif;
    text-decoration: none;
    display: inline-block;
}

        .taskName {
            font-weight: 700;
            font-size: 15px;
            color: #0a2241;
            margin-bottom: 3px;
        }

        .taskMeta {
            font-size: 12px;
    color: #607d8b;
    margin-bottom: 8px;
    display: flex;
    justify-content: space-between;
    align-items: center;
        }

        .taskMeta .requester {
            color: #1565c0;
            font-weight: 600;
        }

        .badges {
            display: flex;
    align-items: center;
    gap: 6px;
    flex-wrap: wrap;
        }

        .badge {
            padding: 3px 10px;
            border-radius: 20px;
            font-size: 11px;
            font-weight: 500;
        }

        .badge.warn     { background: #fff3e0; color: #e65100; }
        .badge.ok       { background: #e8f5e9; color: #2e7d32; }
        .badge.reminder { background: #f3e5f5; color: #6a1b9a; }
        .badge.formTag  { background: #e3f2fd; color: #1565c0; }

        .instructions {
            background: #f8fafc;
            border-left: 3px solid #0f70b7;
            border-right : 3px solid #0f70b7;
            border-radius: 0 6px 6px 0;
            padding: 8px 12px;
            font-size: 11px;
            color: #37474f;
            margin-bottom: 10px;
        }

        .instrLabel {
            font-weight: 700;
            font-size: 12px;
            color: #0f70b7;
            margin-bottom: 3px;
        }

        .taskBtns {
            display: flex;
            justify-content :flex-end ;
            gap: 8px;
            flex-wrap: wrap;
        }

     

        .completedTable {
            width: 100%;
            border-collapse: collapse;
            font-size: 13px;
        }

        .completedTable th {
            text-align: left;
            padding: 10px 16px;
            font-size: 11px;
            font-weight: 700;
            color: #607d8b;
            letter-spacing: 0.5px;
            background: #f8fafc;
            border-bottom: 1px solid #eef1f5;
        }

        .completedTable td {
            padding: 10px 16px;
            border-bottom: 1px solid #f0f2f5;
            color: #0a2241;
        }

        .completedTable tr:last-child td {
            border-bottom: none;
        }

        .badgeDone {
            background: #e8f5e9;
            color: #2e7d32;
            padding: 3px 10px;
            border-radius: 20px;
            font-size: 11px;
            font-weight: 600;
        }

        .emptyState {
            padding: 30px;
            text-align: center;
            color: #607d8b;
            font-size: 13px;
        }

    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="pageTitle">My Tasks</div>

    <div class="statsRow">
        <div class="statCard">
            <div class="statIcon pending">⏳</div>
            <div>
                <div class="statNum"><asp:Label ID="lblPendingCount" runat="server" Text="0"></asp:Label></div>
                <div class="statLabel">Pending</div>
            </div>
        </div>
        <div class="statCard">
            <div class="statIcon done">✅</div>
            <div>
                <div class="statNum"><asp:Label ID="lblCompletedCount" runat="server" Text="0"></asp:Label></div>
                <div class="statLabel">Completed</div>
            </div>
        </div>
        <div class="statCard">
            <div class="statIcon total">📋</div>
            <div>
                <div class="statNum"><asp:Label ID="lblTotalCount" runat="server" Text="0"></asp:Label></div>
                <div class="statLabel">Total</div>
            </div>
        </div>
    </div>

    <div class="sectionCard">
        <div class="sectionHeader">
            ⏳ Pending Tasks (<asp:Label ID="lblPendingHeader" runat="server" Text="0"></asp:Label>)
        </div>

        <div class="pendingGrid">
            <asp:Repeater ID="rptPending" runat="server">
                <ItemTemplate>
                    <div class="taskItem">
                        <div class="taskName"><%# Eval("TaskName") %></div>
                        <div class="taskMeta">
                            <div>
                            Requested by:
                            <span class="requester"><%# Eval("RequestedBy") %></span>
                            on <%# Eval("RequestedDate") %>
</div>
                            <div class="badges">
    <span class='badge warn'>Due ·<%# Eval("DaysLeft") %> days left</span>
 
    <%# If(CBool(Eval("HasMSForm")), "<span class='badge formTag'>🔗 Link Attached</span>", "") %>

</div>
                        </div>
                        
                        <div class="instructions">
                            <div class="instrLabel">★ Instructions</div>
                            <%# Eval("Instruction") %>
                        </div>
                       <div class="taskBtns">
 <%# GetActionButton(Eval("TaskType").ToString(), Eval("TaskLink").ToString(), Eval("AssigneeID").ToString()) %>

    <asp:LinkButton
        runat="server"
        CssClass="btnMark"
        CommandName="MarkDone"
        CommandArgument='<%# Eval("AssigneeID") %>'
        Visible='<%# Eval("TaskType").ToString() = "link" %>'
        OnCommand="MarkDone_Click">✓ Mark as Done</asp:LinkButton>
</div>                        </div>
                    
                </ItemTemplate>
            </asp:Repeater>
        </div>

        <asp:Panel ID="pnlNoPending" runat="server" Visible="false">
            <div class="emptyState">No pending tasks.</div>
        </asp:Panel>
    </div>

    <div class="sectionCard">
        <div class="sectionHeader">
            ✅ Completed Tasks (<asp:Label ID="lblCompletedHeader" runat="server" Text="0"></asp:Label>)
        </div>

        <asp:Panel ID="pnlCompletedTable" runat="server">
            <table class="completedTable">
                <thead>
                    <tr>
                        <th>DOCUMENT</th>
                        <th>REQUESTED BY</th>
                        <th>DEADLINE</th>
                        <th>COMPLETED</th>
                    </tr>
                </thead>
                <tbody>
                    <asp:Repeater ID="rptCompleted" runat="server">
                        <ItemTemplate>
                            <tr>
                                <td><%# Eval("TaskName") %></td>
                                <td><%# Eval("RequestedBy") %></td>
                                <td><%# Eval("Deadline") %></td>
                                <td><span class="badgeDone">✓ <%# Eval("CompletedDate") %></span></td>
                            </tr>
                        </ItemTemplate>
                    </asp:Repeater>
                </tbody>
            </table>
        </asp:Panel>

        <asp:Panel ID="pnlNoCompleted" runat="server" Visible="false">
            <div class="emptyState">No completed tasks yet.</div>
        </asp:Panel>
    </div>

</asp:Content>