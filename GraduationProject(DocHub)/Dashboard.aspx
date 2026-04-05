<%@ Page Language="vb"
    MasterPageFile="~/CommonBar.Master"
    CodeBehind="Dashboard.aspx.vb"
    Inherits="GraduationProject_DocHub_.Dashboard"
%>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@300;400;500;600;700&family=Playfair+Display:wght@600&display=swap" rel="stylesheet"/>
    <style>
    :root 
    {
  --blue-900:#0a2342; --blue-800:#1a3a5c; --blue-700:#1e4d8c;
  --blue-600:#1f6fb2; --blue-500:#2589d6; --blue-400:#4da6e8;
  --blue-100:#e8f4fd; --blue-50:#f0f8ff;
  --white:#ffffff; --gray-50:#f8fafc; --gray-100:#f1f5f9;
  --gray-200:#e2e8f0; --gray-300:#cbd5e1; --gray-400:#94a3b8;
  --gray-500:#64748b; --gray-700:#334155; --gray-900:#0f172a;
  --success:#16a34a; --warning:#d97706; --danger:#dc2626; /*ألوان الحالات*/
  --shadow-sm:0 1px 3px rgba(0,0,0,0.08);/*smail--X Y Blur Color(0,0,0)+ الشفافية*/
  --shadow-md:0 4px 16px rgba(10,35,66,0.10);/*medium*/
  --shadow-lg:0 8px 32px rgba(10,35,66,0.14);/*Large*/
  --radius:10px; --radius-lg:16px;
    }
     *{box-sizing:border-box;margin:0;padding:0;}
     body{font-family:'DM Sans',sans-serif;background:#e8eef5;color:var(--gray-900);}
    .page{display:block;min-height:100vh;}
    .app-layout{display:flex;min-height:calc(100vh - 90vh);}
    .main-content{flex:1;background:var(--gray-50);overflow:auto;}
    .content-area{padding:24px;}
    .stats-grid{display:grid;gap:14px;margin-bottom:20px;}
    .stats-4{grid-template-columns:repeat(4,1fr);}/*fraction*/
    .stat-card{background:var(--white);border-radius:var(--radius-lg);padding:18px;border:1px solid var(--gray-200);}
    .card{background:var(--white);border-radius:var(--radius-lg);box-shadow:var(--shadow-sm);border:1px solid var(--gray-200);overflow:hidden;}
    .card-header{padding:14px 18px;border-bottom:1px solid var(--gray-100);display:flex;align-items:center;justify-content:space-between;}
    .stat-value{font-size:24px;font-weight:700;color:var(--blue-900);}
    .stat-label{font-size:12px;color:var(--gray-500);margin-top:2px;}
    .stat-icon{width:40px;height:40px;border-radius:10px;display:flex;align-items:center;justify-content:center;font-size:18px;margin-bottom:10px;}
    .table-wrap{overflow-x:auto;}
    table{width:100%;border-collapse:collapse;font-size:13px;}
    thead th{background:var(--gray-50);padding:10px 14px;text-align:left;font-size:11px;font-weight:700;color:var(--gray-500);text-transform:uppercase;letter-spacing:.5px;border-bottom:1px solid var(--gray-200);}
    tbody tr{border-bottom:1px solid var(--gray-100);transition:background .1s;}/*animation*/
    tbody tr:hover{background:var(--blue-50);}
    tbody td{padding:11px 14px;color:var(--gray-700);vertical-align:middle;}
    tbody tr:last-child{border-bottom:none;}/*نستهدف اخر سطر*/
    .stat-icon.purple{background:#f3e8ff;}
    .stat-icon.orange{background:#fff7ed;}
    .stat-icon.green{background:#dcfce7;}
    .stat-icon.blue{background:var(--blue-100);}
    .notif-item{display:flex;gap:12px;padding:13px 18px;border-bottom:1px solid var(--gray-100);transition:background .1s;}
    .notif-item.unread{background:#f0f8ff;}
    .badge{display:inline-flex;align-items:center;padding:2px 9px;border-radius:16px;font-size:11px;font-weight:600;}
    .badge-orange{background:#fff7ed;color:#c2410c;}
    .badge-gray{background:var(--gray-100);color:var(--gray-500);}
    .notif-dot{width:8px;height:8px;border-radius:50%;background:var(--blue-500);margin-top:5px;flex-shrink:0;}
    .notif-dot.read{background:var(--gray-200);}
    .btn{display:inline-flex;align-items:center;gap:5px;padding:7px 16px;border-radius:8px;font-size:13px;font-family:'DM Sans',sans-serif;font-weight:600;cursor:pointer;border:none;transition:all .15s;}
    .btn-outline{background:transparent;border:1.5px solid var(--blue-600);color:var(--blue-600);}
    .btn-sm{padding:5px 11px;font-size:12px;}
</style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
<div id="page-dean-dashboard" class="page">
  <div class="app-layout">
    <main class="main-content">
      <div class="content-area">
        <!-- Welcome -->
        <div style="background:linear-gradient(135deg,var(--blue-800),var(--blue-600));border-radius:var(--radius-lg);padding:22px 26px;margin-bottom:20px;color:#fff;display:flex;align-items:center;justify-content:space-between;">
          <div>
            <div style="font-size:11px;opacity:.6;text-transform:uppercase;letter-spacing:.8px;margin-bottom:3px;">Welcome back</div>
            <asp:Label ID="lblUserName" runat="server" style="display:block;font-weight:700;" Text="" />
            <asp:Label ID="lblUserRole" runat="server" style=" display:block;font-size:12.5px;opacity:.65;margin-top:3px;" Text="" />
          </div>
        </div>
 
        <!-- Stats -->
        <div class="stats-grid stats-4">
          <div class="stat-card">
              <div class="stat-icon blue">🏛</div>
              <div>
                  <asp:Label ID="lblDeptNum" runat="server" CssClass="stat-value" Text=""/>
              </div>
              <div class="stat-label">Departments</div>
          </div>
          <div class="stat-card">
              <div class="stat-icon green">📄</div>
              <div>
                  <asp:Label ID="lblTotalDoc" runat="server" CssClass="stat-value" Text="" />
              </div>
              <div class="stat-label">Total Documents</div>
          </div>
          <div class="stat-card">
              <div class="stat-icon orange">📋</div>
              <div>
                  <asp:Label ID="lblActiveTasks" runat="server" CssClass="stat-value" Text="" />
              </div>
              <div class="stat-label">Active Tasks</div>
          </div>
          <div class="stat-card">
              <div class="stat-icon purple">👥</div>
              <div>
                  <asp:Label ID="lblTotalUsers" runat="server" CssClass="stat-value" Text="" />
              </div>
              <div class="stat-label">Total Users</div>
          </div>
        </div>
 
        <!-- Dept Overview -->
        <div class="card" style="margin-bottom:20px;">
          <div class="card-header">
              <h3>Departments Overview</h3>
          </div>
          <div class="table-wrap">
            <table>
              <thead>
                  <tr>
                      <th>Department</th>
                      <th>Programs</th>
                      <th>Documents</th>
                      <th>Active Tasks</th>
                      <th>Liaison Officer</th>
                  </tr>
              </thead>
              <tbody><!--يعني الـ Repeater + Eval بيشتغلوا مع بعض هيك:-->
              <asp:Repeater ID="repDeptOverView" runat="server">
                  <ItemTemplate>
                      <tr>
                          <td>
                              <strong><%# Eval("DeptName")  %></strong>
                          </td>
                          <td>
                              <%# Eval("ProgramsNum") %> Programs
                          </td>
                          <td>
                              <%# Eval("DocNum") %> Documents
                          </td>
                          <td>
                              <span class="badge badge-orange"><%# Eval("ActiveTasksNum") %></span> Tasks
                          </td>
                          <td>
                              <%# Eval("LiaisonName") %>
                          </td>
                       </tr>
                     </ItemTemplate>
              </asp:Repeater>
              </tbody>
            </table>
          </div>
        </div>
 
        <!-- Recent-->
        <div style="display:grid;grid-template-columns:1fr 1fr;gap:16px;">
          <div class="card">
            <div class="card-header">
                <h3>Recent Documents</h3>
                <button class="btn btn-outline btn-sm">View All</button>
            </div>
            <div class="table-wrap">
              <table>
                <thead>
                    <tr>
                        <th>File</th>
                        <th>Dept</th>
                        <th>Ver.</th>
                    </tr>
                </thead>
                <tbody>
                    <asp:Repeater ID="repRecentDoc" runat="server">
                        <ItemTemplate>
                            <tr>
                                <td>
                                    <div style="display:flex;align-items:center;gap:7px;">
                                        <%# Eval("DocName") %>
                                    </div>
                                </td>
                                <td>
                                    <span style="display:flex;align-items:center;gap:7px;">
                                        <%# Eval("DocDept") %>
                                    </span>
                                </td>
                                <td>
                                    <span style="display:flex;align-items:center;gap:7px;">
                                        <%# Eval("DocVersion") %>
                                    </span>
                                </td>
                            </tr>
                        </ItemTemplate>
                    </asp:Repeater>
                </tbody>
              </table>
            </div>
          </div>

          <!-- Notifications-->
          <div class="card">
            <div class="card-header">
                <h3>Recent Notifications</h3>
            </div>
            <asp:Repeater ID="Repeater1" runat="server">
                <ItemTemplate>
                    <div class='notif-item <%# IIf(Eval("IsRead"), "", "unread") %>'>
                        <div>
                            <div style="font-size:13px;color:var(--gray-700);">
                                <%# Eval("MessText") %>
                                <strong><%# Eval("UserName") %></strong>
                                in <%# Eval("DeptName") %>
                            </div>
                       </div>
                        <div style="font-size:11px;color:var(--gray-400);">
                            <%# Eval("MessTime") %>
                        </div>
                   </div>
              </ItemTemplate>
           </asp:Repeater>
         </div>
        </div>
      </div>
    </main>
  </div>
</div>   
</asp:Content>
