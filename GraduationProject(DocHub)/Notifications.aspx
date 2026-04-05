<%@ Page Title="" Language="vb" AutoEventWireup="true" MasterPageFile="~/CommonBar.Master" CodeBehind="Notifications.aspx.vb" Inherits="GraduationProject_DocHub_.Notifications" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@400;500;600;700&display=swap" rel="stylesheet" />

    <style>

        .pageTitle {
            font-size: 22px;
            font-weight: 700;
            color: #0a2241;
            margin-bottom: 20px;
        }

        .notifCard {
            background: white;
            border-radius: 10px;
            border: 2px solid #d5ddea;
            max-width: 1500px;
        }

        .cardHeader {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 14px 20px;
            border-bottom: 1px solid #d5ddea;
        }
        .CardHeaderleftTitle{
            display:flex;
            align-items:center; 
            gap:10px;
        }
        .cardHeader span {
            font-weight: 700;
            font-size: 15px;
            color: #0a2241;
        }


        .unreadBadge {
            background-color: #1565c0;
            color: white;
            border-radius: 20px;
            padding: 2px 12px;
            font-size: 12px;
        }

        .markAllBtn {
            background: none;
            border: 1px solid #1565c0;
            color: #1565c0;
            border-radius: 6px;
            padding: 5px 12px;
            font-size: 12px;
            cursor: pointer;
        }

            .markAllBtn:hover {
                background-color: #1565c0;
                color: white;
            }

        /* صف الإشعار */
        .notifRow {
            display: flex;
            align-items: flex-start;
            gap: 14px;
            padding: 14px 20px;
            border-bottom: 1px solid #f0f4f8;
        }

            .notifRow:last-child {
                border-bottom: none;
            }

            .notifRow:hover {
                background-color: #f7f9fb;
            }

        /* النقطة الزرقاء للغير مقروء */
        .dot {
            width: 10px;
            height: 10px;
            border-radius: 50%;
            background-color: #1565c0;
            margin-top: 5px;
            flex-shrink: 0;
        }

        .dotRead {
            width: 10px;
            height: 10px;
            border-radius: 50%;
            background-color: transparent;
            margin-top: 5px;
            flex-shrink: 0;
        }

        .notifBody {
            flex: 1;
        }

        .notifMessage {
            font-size: 14px;
            color: #0a2241;
            margin-bottom: 4px;
        }

        .notifTime {
            font-size: 12px;
            color: #888;
        }

        .notifAction {
            margin-left: auto;
        }
                /* زر View */

        .btnView {
            background-color: #1565c0;
            color: white;
            border: none;
            border-radius: 6px;
            padding: 7px 14px;
            font-size: 13px;
            cursor: pointer;
            white-space: nowrap;
        }

            .btnView:hover {
                 background-color: white;
                 color: #1565c0;
             border: 1px solid #1565c0;

            }

        

        .noNotif {
            padding: 30px;
            text-align: center;
            color: #888;
            font-size: 14px;
        }

        /* POPUP */
.popupOverlay {
    position: fixed;
    top: 0; left: 0;
    width: 100%; height: 100%;
    background: rgba(0,0,0,0.4);
    display: flex;
    align-items: center;
    justify-content: center;
}

.popupBox {
    background: white;
    border-radius: 12px;
    width: 480px;
    border: 2px solid #d5ddea;
}

.popupHeader {
    background-color: #0f70b7;
    color: white;
    padding: 14px 20px;
    display: flex;
    align-items: center;
    gap: 10px;
}

.popupTitle {
    font-size: 16px;
    font-weight: 700;
    color: white;
    flex: 1;
}

.btnClose {
    text-decoration: none;
   background :none;
   border:none;
    
}

.btnClose i {
    cursor: pointer;
    color: red;
    background: white;
    font-size: 16px;
    padding: 4px 6px;
    border-radius: 4px;
    border: 1px solid red;
}


.btnClose i:hover {
    color: white;
    background: red;
}

.popupBody {
    padding: 20px;
    display: flex;
    flex-direction: column;
    gap: 14px;
}

.popupRow {
    display: flex;
    gap: 10px;
    align-items: flex-start;
    border-bottom: 1px solid #f0f4f8;
    padding-bottom: 10px;
}

.popupLabel {
    font-weight: 600;
    color: #0a2241;
    font-size: 13px;
}

.popupValue {
    color: #444;
    font-size: 13px;
}



    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="pageTitle">Notifications</div>

    <div class="notifCard">

        <div class="cardHeader">
            <div class="CardHeaderleftTitle">
                <span>All Notifications</span>
                <asp:Label ID="lblUnread" runat="server" CssClass="unreadBadge" Text="0 Unread"/>
            </div>
            <asp:Button ID="btnMarkAll" runat="server" Text="✓ Mark All as Read" CssClass="markAllBtn"/>
        </div>

        <!-- قائمة الإشعارات -->
        <asp:Repeater ID="rptNotifications" runat="server">
                <ItemTemplate>

                    <div class="notifRow">

                        <%-- النقطة: زرقاء إذا غير مقروء، شفافة إذا مقروء --%>
                        <div class='<%# If(Eval("IsRead").ToString() = "0", "dot", "dotRead") %>'></div>
                        <div class="notifBody">
                            <div class="notifMessage">
                                <asp:Label ID="lblIcon" runat="server" Text="🏷️ " />
                                <%# Eval("Message") %>
                            </div>
                            <div class="notifTime"><%# Eval("Time") %></div>
                        </div>

                        <div class="notifAction">
                            <div class="notifAction">
                                <asp:Button  ID="btnView" runat="server" Text="View" CssClass="btnView"  OnClick="btnView_Click"   CommandArgument='<%# Container.ItemIndex %>'/>
                            </div>

                        </div>
                        </div>
                </ItemTemplate>
            </asp:Repeater>

            <asp:Panel ID="NoNotification_pnlEmpty" runat="server" CssClass="noNotif" Visible="false">
                No notifications yet.
       
            </asp:Panel>

        </div>


    <!-- POPUP  to apear Notification Details -->
<asp:Panel ID="pnlPopup" runat="server" Visible="false" CssClass="popupOverlay">
    <div class="popupBox">

        <div class="popupHeader">
            <span id="popupIcon" runat="server">🔔</span>
            <asp:Label ID="lblPopupTitle" runat="server" CssClass="popupTitle" Text="Notification Details"/>
            <asp:LinkButton ID="btnClosePopup" runat="server" CssClass="btnClose"><i class="fa-solid fa-xmark" ></i></asp:LinkButton>
        </div>
        
        <div class="popupBody">

            <div class="popupRow">
                <span class="popupLabel">Message:</span>
                <asp:Label ID="lblPopupMessage" runat="server" CssClass="popupValue"/>
            </div>

            <div class="popupRow">
                <span class="popupLabel">Deadline:</span>
                <asp:Label ID="lblDeadline" runat="server" CssClass="popupValue" />
            </div>

            <div class="popupRow">
                <span class="popupLabel">From: &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;           </span>
                <asp:Label ID="lblPopupFrom" runat="server" CssClass="popupValue"/>
            </div>


            <div class="popupRow">
                <span class="popupLabel">Time:  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;          </span>
                <asp:Label ID="lblPopupTime" runat="server" CssClass="popupValue"/>
            </div>


        </div>

        

    </div>
</asp:Panel>
        </asp:Content>



