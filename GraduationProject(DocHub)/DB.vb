Imports System.Data
Imports System.Data.SqlClient
Imports System.Configuration

Public Class DB

    Private Shared Function GetConnection() As SqlConnection
        Dim connStr As String = ConfigurationManager.ConnectionStrings("DocHubDB").ConnectionString
        Return New SqlConnection(connStr)
    End Function

    Public Shared Function GetData(sql As String, Optional params As Dictionary(Of String, Object) = Nothing) As DataTable
        Dim dt As New DataTable()
        Using conn As SqlConnection = GetConnection()
            Using cmd As New SqlCommand(sql, conn)
                If params IsNot Nothing Then
                    For Each p In params
                        cmd.Parameters.AddWithValue(p.Key, If(p.Value Is Nothing, DBNull.Value, p.Value))
                    Next
                End If
                conn.Open()
                Using da As New SqlDataAdapter(cmd)
                    da.Fill(dt)
                End Using
            End Using
        End Using
        Return dt
    End Function

    Public Shared Function Execute(sql As String, Optional params As Dictionary(Of String, Object) = Nothing) As Integer
        Using conn As SqlConnection = GetConnection()
            Using cmd As New SqlCommand(sql, conn)
                If params IsNot Nothing Then
                    For Each p In params
                        cmd.Parameters.AddWithValue(p.Key, If(p.Value Is Nothing, DBNull.Value, p.Value))
                    Next
                End If
                conn.Open()
                Return cmd.ExecuteNonQuery()
            End Using
        End Using
    End Function

    Public Shared Function ExecuteWithID(sql As String, Optional params As Dictionary(Of String, Object) = Nothing) As Integer
        Using conn As SqlConnection = GetConnection()
            Using cmd As New SqlCommand(sql & "; SELECT SCOPE_IDENTITY()", conn)
                If params IsNot Nothing Then
                    For Each p In params
                        cmd.Parameters.AddWithValue(p.Key, If(p.Value Is Nothing, DBNull.Value, p.Value))
                    Next
                End If
                conn.Open()
                Dim result = cmd.ExecuteScalar()
                Return CInt(result)
            End Using
        End Using
    End Function

End Class