<?php

/**
 

 */
class DB{

  public function __construct(string $host = null, string $user = null, string $pass = null, string $database = null){
    $this->host = $host;
    $this->user = $user;
    $this->pass = $pass;
    $this->database = $database;
    $this->db = new mysqli($this->host, $this->user, $this->pass, $this->database);
  }

  private function where($where){
    $_where = "";
    $_values = [];
    // If where type is number
    if(is_numeric($where)){
      $_where = "id = ?";
      $_values = [$where];
    }
    // If where type is array
    if(is_array($where)){
      $_where = "";
      $_isFirst = true;
      foreach($where as $key => $value){
        $_values[] = $value;
        if($_isFirst){
          $_where .= "$key = ? ";
        }else{
          $_where .= "and $key = ? ";
        }
        $_isFirst = false;
      }
    }
    return [$_where, $_values];
  }

  public function get(string $table, $where=null){
    $query = "SELECT * FROM $table";
    $_where_values = $this->where($where);
    $_where = $_where_values[0];
    $_values = $_where_values[1];

    if($_where != ""){
      $query .= " WHERE $_where";
    }
    $query .= " LIMIT 1";

    $stmt = $this->db->prepare($query);
    // Check _where is empty
    if($_where != ""){
      $stmt->bind_param("".str_repeat("s", count($_values)), ...$_values);
    }
    $stmt->execute();
    $result = $stmt->get_result();
    $row = $result->fetch_assoc();
    $stmt->close();
    return $row;
  }

  public function all(string $table, $where=null){
    $query = "SELECT * FROM $table";
    $_where_values = $this->where($where);
    $_where = $_where_values[0];
    $_values = $_where_values[1];

    if($_where != ""){
      $query .= " WHERE $_where";
    }
    
    $stmt = $this->db->prepare($query);
    // Check _where is empty
    if($_where != ""){
      $stmt->bind_param("".str_repeat("s", count($_values)), ...$_values);
    }
    $stmt->execute();
    $result = $stmt->get_result();
    $rows = [];
    while($row = $result->fetch_assoc()){
      $rows[] = $row;
    }
    $stmt->close();
    return $rows;
  }

  public function sql($sql,$parameters=[]){
    $stmt = $this->db->prepare($sql);
    
    // If parameters is array
    if(is_array($parameters) && count($parameters) > 0){
      $stmt->bind_param("".str_repeat("s", count($parameters)), ...$parameters);
    }

    $stmt->execute();
    
    // If Select Statement
    if(strpos(strtolower($sql), "select") !== false){
      $result = $stmt->get_result();
      $rows = [];
      while($row = $result->fetch_assoc()){
        $rows[] = $row;
      }
      // TODO :: CHECK for PROBLEMS
      // Check if no result
      if(count($rows) == 0){
        $stmt->close();
        return false;
      }
      // Check if only one result and all values are empty
      $isAllEmpty = true;
      foreach($rows[0] as $key => $value){
        if($value != ""){
          $isAllEmpty = false;
        }
      }
      if($isAllEmpty){
        $stmt->close();
        return false;
      }
      $stmt->close();
      return $rows;  
    }

    // Update or Delete Statement
    if(strpos(strtolower($sql), "update") !== false || strpos(strtolower($sql), "delete") !== false){
      $row_counts = $stmt->affected_rows;
      $stmt->close();
      return $row_counts;
    }
    $stmt->close();
  }


  public function set($table,$parameters){
    $keys = [];
    $values = [];
    $equals = [];
    foreach($parameters as $key => $value){
      $keys[] = $key;
      $values[] = $value;
      $equals[] = " $key='". addslashes($value) ."' ";
    }
    $equalsSql = "".implode(",", $equals)."";
    $query = "INSERT INTO $table SET " . $equalsSql . " ON DUPLICATE KEY UPDATE " . $equalsSql;
    return $this->sql($query);
  }

  public function autocommit(){
    $this->db->autocommit(FALSE);
  }
  
  public function commit(){
    $this->db->commit();
  }

  public function rollback(){
    $this->db->rollback();
  }

}