<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/CommonBar.Master" CodeBehind="EditPage.aspx.vb" Inherits="GraduationProject_DocHub_.EditPage" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">

    <style>
        

        .pageHeader {
            background-color: white;
            border-top-left-radius: 10px;
            border-top-right-radius: 10px;
            border-bottom: 1px solid #b9c3d4;
        }

            .pageHeader h1 {
                margin: 0;
                font-size: 22px;
                font-weight: 600;
                padding: 5px 20px;
            }

        .card {
            background: white;
            border-radius: 10px;
            margin: auto;
            max-width: 1500px;
            border: 3px solid #d5ddea;
        }

        .formRow {
            display: flex;
            gap: 20px;
            padding-right: 30px;
            padding-left: 30px;
        }

        .formGroup {
            display: flex;
            flex-direction: column;
            flex: 1;
            padding-bottom: 10px;
        }

        .input {
            padding: 10px;
            border: 2px solid #edf1f6;
            border-radius: 6px;
            margin-top: 10px;
            margin-bottom: 10px;
        }

        .UploadBox {
            border: 2px dashed #ccc;
            padding: 20px;
            text-align: center;
            border-radius: 8px;
            color: #777;
            margin-top: 10px;
            height: 90px;
        }

        .info {
            background: #2c4659;
            height: auto;
            margin-bottom: 10px;
            margin-top: 0px;
            padding-top: 10px;
            padding-bottom: 10px;
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 10px;
        }

        .infoItem {
            display: flex;
            gap: 4px;
        }

            .infoItem h5 {
                margin: 0; /*افتراضيا يكون  20*/
                font-size: 14px;
                color: #f5f8f8;
                font-weight: 200;
                font-size: 15px;
            }

        .sectionCard {
            background: white;
            border-radius: 12px;
            margin-top: 20px;
            border: 1px solid #d5ddea;
        }

        .deptHeader {
            background: #e5eaee;
            padding: 12px 15px;
            border-top-left-radius: 10px;
            border-top-right-radius: 10px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .leftTitle {
            font-weight: 700;
            color: #495057;
        }



        .buttons {
            display: flex;
            padding-left: 510px;
            gap: 20px;
            padding-bottom: 10px;
        }

        .btnCancel {
            background: #607d8b;
            border-radius: 15px;
            border: 1px solid #e5eaee;
            width: 75px;
            font-size: 13px;
            color: white;
            height: 35px;
        }

        .btnsave {
            background: #2196f3;
            border-radius: 15px;
            border: 1px solid #0288d1;
            width: 75px;
            font-size: 13px;
            color: white;
            height: 35px;
        }

        .accessdiv {
            display: flex;
            justify-content: flex-start;
            align-items: center;
            gap: 150px;
            padding: 7px 30px;
            font-weight: 600;
            color: black;
            border-bottom: 1px solid #eee;
        }



        .btnAdd {
            border: none;
            background: #0f70b7;
            padding: 6px 12px;
            border-radius: 6px;
            color: white;
            height: 30px;    
            
        }

        .popup {
           width:450px;
            position: fixed;
            padding: 15px 8px;
            background: #c3d0de;
            border-radius: 10px;
            border: 2px inset #000819;
            top: 20%;
            right: 35%;
        }      

        .selectUser {
            padding-top:6px;
            padding-bottom:6px;
            
            
        }
        .selectUser h4{
            margin:0;
        }

        .scroll {
            overflow-y: auto; /* للسكرول*/
            max-height: 70px; /* ارتفاع ثابت */
            background:white;
            border-radius:6px;
            margin-bottom:10px;
            border:1px solid #5d97c1;
            padding:10px 6px;
            
        }
        .btnAddALign{
            display:flex;
            justify-content:center;
        }


        .deptCheckList label {
            margin-right: 70px;
            font-size: 15px;
            color: #095994;
            font-weight: 400;
        }

        .accessHeader {
            display: grid;
            grid-template-columns: 1.5fr 1.5fr 1.5fr 1.5fr 0.5fr;
            align-items: center;
            padding: 10px 30px;
            background: #f1f3f5;
            border-bottom: 2px solid #d5ddea;
            font-weight: 600;
        }

            .accessHeader .col {
                min-width: 120px;
            }

      

        .col {
            min-width: 140px;
            font-size: 14px;
        }

        .name {
            font-size: 13px;
            color: #0a2241;
        }

        .role {
            color: #0a2241;
            font-size: 13px;
        }

        .dept {
            color: #0a2241;
            font-size: 13px;
        }

        .ddlpermission {
            color: #0a2241;
            font-size: 13px;
        }

        .accessRow {
            display: grid;
            grid-template-columns: 1.5fr 1.5fr 1.5fr 1.5fr 0.5fr;
            align-items: center;
            padding: 10px 30px;
            border-bottom: 1px solid #eee;
        }

            .accessRow:hover {
                background: #f9fbfd;
            }

        .searchWrapper {
           display:flex;
           justify-content:center;
           margin-top:3px;
        }

        .searchInput {
            width: 100%;
            padding: 8px;
            border: 1px solid #ccc;
            border-radius: 6px;
        }

        .cancelfix {
            display: flex;
            justify-content: flex-end;
        }
    </style>
   
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <!-- page Title-->
    <div class="card">
        <div class="pageHeader">
            <h1>Edit Document</h1>
        </div>

        <!-- Origin Information to Document-->
        <asp:Panel ID="Panel1" runat="server" CssClass="info">

            <div class="infoItem">
                <h5>Currently Editing:</h5>
                <asp:Label ID="lblCurrentlyEditing" runat="server"><h5>Syllabus_Discrate</h5></asp:Label>
            </div>

            <div class="infoItem">
                <h5>Last Edited:</h5>
                <asp:Label ID="lblLastEdited" runat="server"><h5>Jan 15 By Dr.Lena</h5></asp:Label>
            </div>

            <div class="infoItem">
                <h5>Version:</h5>
                <asp:Label ID="lblVersion" runat="server"><h5>V2</h5></asp:Label>
            </div>

        </asp:Panel>

        <!-- Form -->
        <div class="formRow">
            <div class="formGroup">

                <asp:Label ID="DocName" runat="server" Text="Document Name"></asp:Label>
                <asp:TextBox ID="txtName" runat="server" CssClass="input"></asp:TextBox>

            </div>
            <div class="formGroup">
                <asp:Label ID="lblDept" runat="server" Text="Department"></asp:Label>
                <asp:DropDownList ID="ddlDept" runat="server" CssClass="input"></asp:DropDownList>
            </div>
            <div class="formGroup">
                <asp:Label ID="Year" runat="server" Text="Academic Year"></asp:Label>
                <asp:DropDownList ID="yearList" runat="server" CssClass="input">
                    <asp:ListItem>2022/2023</asp:ListItem>
                    <asp:ListItem>2023/2024</asp:ListItem>
                    <asp:ListItem>2024/2025</asp:ListItem>
                    <asp:ListItem>2025/2026</asp:ListItem>
                </asp:DropDownList>
            </div>
        </div>


        <div class="formRow">
            <div class="formGroup">
                <asp:Label ID="Progrmas" runat="server" Text="Program"></asp:Label>
                <asp:DropDownList ID="ProgramList" runat="server" CssClass="input"></asp:DropDownList>
            </div>

            <div class="formGroup">
                <asp:Label ID="Category" runat="server" Text="Category"></asp:Label>
                <asp:DropDownList ID="CategoryList" runat="server" CssClass="input"></asp:DropDownList>
            </div>
        </div>

        <div class="formRow">
            <div class="formGroup">

                <asp:Label ID="description" runat="server" Text="Description"></asp:Label>
                <asp:TextBox ID="txtdesc" runat="server" CssClass="input" TextMode="MultiLine" Rows="3"></asp:TextBox>
            </div>
        </div>

        <div class="formRow">
            <div class="formGroup">
                <asp:Label ID="upload" runat="server" Text="Upload New File Version"></asp:Label>
                <div class="UploadBox">
                    <br />
                    Drag & Drop file here or click to upload
          <br />
                    <asp:FileUpload ID="FileUpload" runat="server" />
                </div>
            </div>
        </div>
        <!-- Access Control -->
        <div class="formRow">
            <div class="formGroup">
                
                <asp:Panel ID="PanelDeptUsers" runat="server" CssClass="sectionCard">
                    <div class="deptHeader">

                        <div class="leftTitle">
                            <i class="fa-solid fa-shield"></i>
                            Access Control
                        </div>

                        <asp:Button ID="btnAddDeptUsers" runat="server" Text="+ Add Users" CssClass="btnAdd" />
                    </div>


                    <div class="accessdiv">
                        <div>Select Departments</div>

                        <asp:CheckBoxList ID="cblDeptAccess" runat="server" CssClass="deptCheckList"
                            RepeatDirection="Horizontal"
                            RepeatLayout="Flow">
                        </asp:CheckBoxList>
                    </div>

                    <div class="accessHeader">
                        <div>Name</div>
                        <div>Role</div>
                        <div>Department</div>
                        <div>Permission</div>
                        <div>Action</div>
                    </div>

                    <asp:Repeater ID="rptDeptAccess" runat="server">
                        <ItemTemplate>

                            <asp:Panel runat="server" CssClass="accessRow">

                                <div class="name">
                                    <%# Eval("Name") %>
                                </div>

                                <div class="role">
                                    <%# Eval("Role") %>
                                </div>

                                <div class="dept">
                                    <%# Eval("Department") %>
                                </div>

                                <div>
                                    <asp:DropDownList ID="ddlPermission" runat="server" CssClass="ddlpermission">
                                        <asp:ListItem>View</asp:ListItem>
                                        <asp:ListItem>Download</asp:ListItem>
                                        <asp:ListItem>Edit</asp:ListItem>
                                        <asp:ListItem>View & Download</asp:ListItem>
                                        <asp:ListItem>Download & Edit</asp:ListItem>
                                        <asp:ListItem>Edit & View</asp:ListItem>
                                        <asp:ListItem>Delete</asp:ListItem>
                                    </asp:DropDownList>
                                </div>

                                <div>
                                    <asp:LinkButton runat="server" ID="lnkdelete">
                                        <i class="fa-solid fa-rectangle-xmark" style="color:red; font-size:20px;"></i>
                                    </asp:LinkButton>
                                </div>
                            </asp:Panel>

                        </ItemTemplate>
                    </asp:Repeater>

                </asp:Panel>
            </div>
        </div>

        <!--  User List-->
        <asp:Panel ID="pnlDeptUsers" runat="server" CssClass="popup" Visible="false">
          
            <div class="cancelfix">
            <asp:LinkButton ID="btnCloseDeptUsers" runat="server">
            <i class="fa-solid fa-rectangle-xmark" style="color:red; font-size:20px;"></i>
                </asp:LinkButton>
           </div>

            <div class="searchWrapper">
                <asp:TextBox ID="txtSearchUsers" runat="server" CssClass="searchInput" placeholder="Search user..."
                    onkeyup="filterUsers()"
                    ClientIDMode="Static" />
            </div>

            <div class="selectUser">
                <h4>
                    <i class="fa-solid fa-users"></i>
                    Select Users
                </h4>
            </div>

            <div class="scroll">

                <asp:CheckBoxList ID="chblDeptUsers" runat="server" ClientIDMode="Static">
                </asp:CheckBoxList>
            </div>

            <div class="btnAddALign">
                <asp:Button ID="btnAddDeptUsersConfirm" runat="server"  Text="Add Selected" CssClass="btnAdd" />
             </div>
            

        </asp:Panel>
        <!-- Final Buttons -->
        <div class="formRow">
            <div class="buttons">
                <asp:Button ID="btnCancel" runat="server" Text="Cancel" CssClass="btnCancel" />
                <asp:Button ID="btnsave" runat="server" Text="Save" CssClass="btnsave" />

            </div>
        </div>
    </div>
    <script>
        <!-- function to search -->
    function filterUsers() {
    var input = document.getElementById("txtSearchUsers").value.toLowerCase();
    var list = document.getElementById("chblDeptUsers");
    var rows = list.getElementsByTagName("tr");

    for (var i = 0; i < rows.length; i++) {
        var label = rows[i].getElementsByTagName("label")[0];
        if (!label) continue;

        var text = label.innerText.toLowerCase();
        rows[i].style.display = text.includes(input) ? "" : "none";
    }
}</script>
</asp:Content>

