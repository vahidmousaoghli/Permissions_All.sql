drop table if exists #temp
/*
	Date :1402/12/07 
	Wrting By : Hadi and Vahid
*/
--Server Permision Server_principals 
SELECT
	S.name as loginname, 
	S.type_desc,
	isNull (x.name,'Unknown') as rolename ,
	S.is_disabled,
	S.sid as LoginSID
into #temp
FROM sys.server_principals AS S
left join
(SELECT s.name, r.member_principal_id FROM sys.server_role_members As r
inner join sys.server_principals as s
on r.role_principal_id = s.principal_id
where s.type = 'R') as x
	ON S.principal_id = x.member_principal_id
--------------------------------------*******************------------------------
--Database Permision

SELECT
	 d.name as Database_UserName
	,d.type_desc as user_type
	,isNull (x.name,'Unknown') as database_rolename
	,isnull(t.loginname, 'Orphan') as login_name
	,t.rolename as server_rolename
	,t.type_desc as login_type
	,prd.object_name
	,prd.object_type
	,prd.column_name
	,prd.permission_name
	,prd.state_desc
FROM
	sys.database_principals AS D
left join
	(
		SELECT
			 s.name
			,r.member_principal_id
		FROM
			sys.database_role_members As r
		inner join
			sys.database_principals as s
				on r.role_principal_id = s.principal_id
		where
			s.type = 'R'
	) as x
		ON d.principal_id = x.member_principal_id
left join #temp as t
	on D.sid = t.LoginSID
-------------------------Table and all object Permission -------------------------------------
left join
(
SELECT
	d.name userorrolename,
	d.type_desc,
	d.sid,
	o.name as object_name,
	o.type_desc as object_type,
	o.modify_date,
	c.name as column_name,
	p.permission_name,
	p.state_desc
FROM sys.database_permissions as p
	inner join 
		sys.database_principals as d
		on p.grantee_principal_id = d.principal_id
left join
	sys.objects as o
		on p.major_id = o.object_id
left  join 
	sys.columns as c
		on p.minor_id = c.column_id and p.major_id = c.object_id
where
	d.type in ('R','S','U')
) as prd
on d.sid = prd.sid
GO
--------------------------------------------------------------



--WHERE major_id = 1602104748
--AND c.object_id = 1602104748

----select * from sys.objects where object_id = object_id('sales.salesorderheader')

--select * FROM sys.database_principals
--select * FROM sys.database_permissions

--select * from sys.database_principals






--select * from sys.database_permissions
--select * from sys.database_principals
--select * from sys.objects where object_id = 664389436
--select * from sys.database_role_members
--select * from sys.database_principals
