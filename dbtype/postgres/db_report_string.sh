#!/usr/bin/env bash
db_report_string() {
  _deployment_type="$1"

  _table_exists=`${db_binary} ${deployment_db} ${server_flag} ${user_flag} ${port_flag} -1 -X -q -A -t -c "
  SELECT EXISTS (
    SELECT 1 
    FROM   pg_catalog.pg_class c
    JOIN   pg_catalog.pg_namespace n ON n.oid = c.relnamespace
    WHERE  n.nspname = 'public'
    AND    c.relname = 'deployment_tracker'
    AND    c.relkind = 'r'    -- only tables(?)
  );"`

  if [ "${_table_exists}" = 't' ]
  then 
  
    ${db_binary} ${deployment_db} ${server_flag} ${user_flag} ${port_flag} -1 -X -q -A -t -c "
    SELECT CONCAT('${db_basedir}/',dbname,'/',deployment_type,'/',deployment_name) 
    FROM deployment_tracker 
    WHERE dbname = '${dbname}' 
    AND deployment_type = '${_deployment_type}' 
    AND deployment_outcome in ('OK','SKIP')
    AND is_active is true;" | sort -rn
    
    if [ $? -ne 0 ] 
    then
      return_val=1
    else
      return_val=0
    fi
  else
    if [ "${dbname}" = "${deployment_db}" ]
    then
      return_val=0
    else
      return_val=1
    fi
  fi

  unset _table_exists
  unset _deployment_type

  return ${return_val}
}
