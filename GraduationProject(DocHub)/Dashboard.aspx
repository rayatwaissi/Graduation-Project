<%@ Page Title="" Language="vb"
    AutoEventWireup="true"
    MasterPageFile="~/CommonBar.Master"
    CodeBehind="Dashboard.aspx.vb"
    Inherits="GraduationProject_DocHub_.Dashboardaspx"
%>



<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
<header>
    <link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@300;400;500;600;700&family=Playfair+Display:wght@600&display=swap" rel="stylesheet"/>
</header>
<style>
    :root {
  --blue-900:#0a2342; --blue-800:#1a3a5c; --blue-700:#1e4d8c;
  --blue-600:#1f6fb2; --blue-500:#2589d6; --blue-400:#4da6e8;
  --blue-100:#e8f4fd; --blue-50:#f0f8ff;
  --white:#ffffff; --gray-50:#f8fafc; --gray-100:#f1f5f9;
  --gray-200:#e2e8f0; --gray-300:#cbd5e1; --gray-400:#94a3b8;
  --gray-500:#64748b; --gray-700:#334155; --gray-900:#0f172a;
  --success:#16a34a; --warning:#d97706; --danger:#dc2626;
  --shadow-sm:0 1px 3px rgba(0,0,0,0.08);
  --shadow-md:0 4px 16px rgba(10,35,66,0.10);
  --shadow-lg:0 8px 32px rgba(10,35,66,0.14);
  --radius:10px; --radius-lg:16px;
}
*{box-sizing:border-box;margin:0;padding:0;}
body{font-family:'DM Sans',sans-serif;background:#e8eef5;color:var(--gray-900);}
    .page{display:block;min-height:100vh;}
    .app-layout{display:flex;min-height:calc(100vh - 48px);}
    .main-content{flex:1;background:var(--gray-50);overflow:auto;}
    .content-area{padding:24px;}
    .stats-grid{display:grid;gap:14px;margin-bottom:20px;}
    .stats-4{grid-template-columns:repeat(4,1fr);}
    .stat-card{background:var(--white);border-radius:var(--radius-lg);padding:18px;border:1px solid var(--gray-200);}
    .card{background:var(--white);border-radius:var(--radius-lg);box-shadow:var(--shadow-sm);border:1px solid var(--gray-200);overflow:hidden;}
    .card-header{padding:14px 18px;border-bottom:1px solid var(--gray-100);display:flex;align-items:center;justify-content:space-between;}
    .stat-value{font-size:24px;font-weight:700;color:var(--blue-900);}
    .stat-label{font-size:12px;color:var(--gray-500);margin-top:2px;}
    .stat-icon{width:40px;height:40px;border-radius:10px;display:flex;align-items:center;justify-content:center;font-size:18px;margin-bottom:10px;}
    .table-wrap{overflow-x:auto;}
    table{width:100%;border-collapse:collapse;font-size:13px;}
    thead th{background:var(--gray-50);padding:10px 14px;text-align:left;font-size:11px;font-weight:700;color:var(--gray-500);text-transform:uppercase;letter-spacing:.5px;border-bottom:1px solid var(--gray-200);}
    tbody tr{border-bottom:1px solid var(--gray-100);transition:background .1s;}
    tbody tr:hover{background:var(--blue-50);}
    tbody td{padding:11px 14px;color:var(--gray-700);vertical-align:middle;}
    tbody tr:last-child{border-bottom:none;}
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
<div id="page-dean-dashboard" class="page">
  <div class="app-layout">
    <main class="main-content">
      <div class="content-area">
        <!-- Welcome -->
        <div style="background:linear-gradient(135deg,var(--blue-800),var(--blue-600));border-radius:var(--radius-lg);padding:22px 26px;margin-bottom:20px;color:#fff;display:flex;align-items:center;justify-content:space-between;">
          <div>
            <div style="font-size:11px;opacity:.6;text-transform:uppercase;letter-spacing:.8px;margin-bottom:3px;">Welcome back</div>
            <div style="font-size:20px;font-weight:700;font-family:'Playfair Display',serif;">Dr. Khalid — Dean</div>
            <div style="font-size:12.5px;opacity:.65;margin-top:3px;">Full access · All Departments</div>
          </div>
        </div>
 
        <!-- Stats -->
        <div class="stats-grid stats-4">
          <div class="stat-card">
              <div class="stat-icon blue">🏛</div>
              <div class="stat-value">3</div>
              <div class="stat-label">Departments</div>
          </div>
          <div class="stat-card">
              <div class="stat-icon green">📄</div>
              <div class="stat-value">312</div>
              <div class="stat-label">Total Documents</div>
              <div class="stat-change">↑ 24 this month</div>
          </div>
          <div class="stat-card">
              <div class="stat-icon orange">📋</div>
              <div class="stat-value">8</div>
              <div class="stat-label">Active Tasks</div>
          </div>
          <div class="stat-card">
              <div class="stat-icon purple">👥</div>
              <div class="stat-value">47</div>
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
              <tbody>
                <tr>
                    <td><strong>CS</strong> — Computer Science</td>
                    <td>4 programs</td><td>128 files</td>
                    <td><span class="badge badge-orange">3 tasks</span></td>
                    <td>Ahmad (Liaison)</td>
                </tr>
                <tr>
                    <td><strong>BIT</strong> — Business IT</td>
                    <td>2 programs</td><td>98 files</td>
                    <td><span class="badge badge-orange">3 tasks</span></td>
                    <td>Sara (Liaison)</td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>
 
        <!-- Recent + Notifs -->
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
                  <tr>
                      <td><div style="display:flex;align-items:center;gap:7px;">Syllabus BIT 2025</div></td>
                      <td><span>BIT</span></td><td><span class="badge badge-gray">v3</span></td>
                  </tr>
                  <tr>
                      <td><div style="display:flex;align-items:center;gap:7px;">CS Annual Report</div></td>
                      <td><span>CS</span></td><td><span class="badge badge-gray">v1</span></td>
                  </tr>
                  <tr>
                      <td><div style="display:flex;align-items:center;gap:7px;">MIS Grade Sheet</div></td>
                      <td><span>MIS</span></td><td><span class="badge badge-gray">v2</span></td>
                  </tr>
                </tbody>
              </table>
            </div>
          </div>
          <div class="card">
            <div class="card-header">
                <h3>Recent Notifications</h3>
            </div>
            <div class="notif-item unread">
                <div class="notif-dot"></div>
                <div>
                    <div style="font-size:13px;color:var(--gray-700);">New task completed by <strong>Dr. Sara</strong> in BIT</div>
                    <div style="font-size:11px;color:var(--gray-400);">2 hours ago</div>
                </div>
            </div>
            <div class="notif-item unread">
                <div class="notif-dot"></div>
                <div>
                    <div style="font-size:13px;color:var(--gray-700);"><strong>Ahmad</strong> uploaded <em>CS Syllabus v2</em></div>
                    <div style="font-size:11px;color:var(--gray-400);">5 hours ago</div>
                </div>
            </div>
            <div class="notif-item">
                <div class="notif-dot read"></div>
                <div>
                    <div style="font-size:13px;color:var(--gray-700);">Task deadline approaching: <em>QA Survey</em></div>
                    <div style="font-size:11px;color:var(--gray-400);">Yesterday</div>
                </div>
            </div>
          </div>
        </div>
      </div>
    </main>
  </div>
</div>
    
</asp:Content>
