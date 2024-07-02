/*********************************************
 * OPL 22.1.1.0 Model
 * Author: jishnu
 * Creation Date: 27-Jun-2024 at 4:54:26 AM
 *********************************************/
using CP;

int n = ...;  						//	number of dealer's
int m = ...;						//  number of transportation vehicles
int cost[0..n+1][0..n+1] = ...;
int demand[0..n+1] = ...;
int time_window[0..n+1][1..2] = ...;
int trav_time[0..n+1][0..n+1] = ...;
int Vehicle_capacity = ...;

dvar int x[0..n+1][0..n+1][1..m];
dvar int u[0..n+1][1..m];//first time the vehicle i reaches the node j

dexpr int z = sum(k in 1..m, i in 0..n+1, j in 0..n+1) (cost[i][j]*x[i][j][k]);    
minimize z;			//The objective function minimizes the total cost of travel

subject to{
  	//This constraint ensures that each customer is visited exactly once
  constraint_1:   
    forall(i in 1..n){
      (sum(j in 1..n+1,k in 1..m: i!=j)(x[i][j][k]))==1;
    }

 	 //This initializes the time of each vehicle with zero at the depot (node 0)
  constraint_2:		
    forall(k in 1..m)
     	u[0][k] == 0;
     	
     	
   constraint_3:
  	forall(k in 1..m){ 		
  	  sum(i in 1..n+1)(x[0][i][k]) == 1;
  	  sum(j in 0..n)(x[j][n+1][k]) == 1;
  	  sum(j in 0..n+1)(x[j][0][k])==0;
  	  sum(j in 0..n+1)(x[n+1][j][k])==0;
  	}
  	
		// This ensures that each vehicle is loaded
  	constraint_4:
  		forall(k in 1..m){
  		  (sum(i in 0..n+1)(demand[i])*((sum(j in 0..n+1)(x[i][j][k])))) <= Vehicle_capacity;
  		}
  		
  		//establish the relationship between the vehicle departure time from a customer and its immediate successor
  	constraint_5:
  		forall(i in 0..n+1,j in 0..n+1, k in 1..m)
  		  x[i][j][k]*(u[i][k] + trav_time[i][j]-u[j][k]) <= 0;
  	
  		//after a vehicle arrives at a customer it has to leave for another destination
  	constraint_6:
  		forall(h in 1..n,k in 1..m){
  		  (sum(i in 0..n)(x[i][h][k])) == (sum(i in 1..n+1)(x[h][i][k]));
  		}
  		
  		//ensures that the delivery is made within the specified time interval
  	constraint_7:
  		forall(i in 0..n+1, k in 1..m){
  		 	time_window[i][1] <= u[i][k] <= time_window[i][2];
  		}
  		
  		//Ensures no self loop
  	constraint_8:
  		forall(i in 0..n+1,k in 1..m)
  		  	x[i][i][k]==0;
  		  	
  		  
  	constraint_9:
  		forall(i in 0..n+1,j in 0..n+1,k in 1..m){
  		  x[i][j][k]>=0;
  		  x[i][j][k]<=1;
  		}
  }
  
  execute{
    writeln(x);
    writeln(u);
  }