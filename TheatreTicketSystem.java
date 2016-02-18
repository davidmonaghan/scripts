import java.util.Scanner;
import java.text.DecimalFormat;

public class TheatreTicketSystem {
    public static void main(String[] args) {
     
    	Scanner keyboard = new Scanner(System.in);
    	DecimalFormat formatter = new DecimalFormat("00");
       
        int premiumSeatsSold = 0, regularSeatsSold = 0, economySeatsSold = 0, seatCount, userChoiceContinue;
        int premiumSeatsAvailable = 20, regularSeatsAvailable = 80, economySeatsAvailable = 20;
        int userTicketType = 0, userTicketAmount, userCancellationChoice;
        String ticketType;
        double totalTicketSales = 0, userTotalCost = 0;
        final int premiumSeatAmount = 10, economySeatAmount = 5;
        final double regularSeatAmount = 7.5;
       
 ////////**********This programme will allow the user to book seats within three categories if those seats are avaialable
 ////////***********The user can continue on if they wish or close the programme when they have finished
 ///////***********The programme will close automaticaly once all seats have been sold
 ///////***********Once the programme ends to final seating plan will be printed
       
 
        do{
  ///////**************************Start Of Stage Drawing**************************///////////////////

 
                System.out.println("\n|           Stage            |" +
                                   "\n|............................|");
            
             
                seatCount = premiumSeatsSold;
             
                for(int x=0; x < 2; x++){   // Loop will print out currently taken premium seats (P) and empty seats (#),
                   System.out.println();     // the seating plan will change with each loop and as the value of premiumSeatsSold is updated
                           
                    for(int y=0; y < 10; y++){
                        if(seatCount > 0){
                            System.out.print(" P ");
                        } 
                        else{
                            System.out.print(" # ");
                        }
                    
                        seatCount -=1;
                    }
                }
             
                seatCount = regularSeatsSold;
             
                for(int x=0; x < 8; x++){    // Loop will print out currently taken economy seats (R) and empty seats (#),
                    System.out.println();     // the seating plan will change with each loop and as the value of regularSeatsSold is updated
                 
                 
                    for(int y=0; y < 10; y++){
                        if(seatCount > 0){
                            System.out.print(" R ");
                            }
                        else{
                            System.out.print(" # ");
                        }
                    
                        seatCount -=1;
                    }
                }
             
                seatCount = economySeatsSold;
             
                for(int x=0; x < 2; x++){     // Loop will print out currently taken regular seats (e) and empty seats (#)
                    System.out.println();      // the seating plan will change with each loop and as the value of economySeatsSold is updated
                             
                    for(int y=0; y < 10; y++){
                        if(seatCount > 0){
                            System.out.print(" E ");
                        } 
                        else{
                            System.out.print(" # ");
                        }
                    
                        seatCount -= 1;
                    }
                }
             
             
        ///////**************************End Of Stage Drawing**************************///////////////////
             
             
        ///////**************************Beginning Of Ticket Choice********************///////////////////
              
            
                 System.out.println("\n\nWhat type of seats would you like to book?" +
                                      "\n" +
                                      "\nEnter a value between 1 and 3" +
                                      "\n1: Premium Seat (€10.00). There are " + premiumSeatsAvailable + " premium seats available" +
                                      "\n2: Regular Seats (€7.50). There are " + regularSeatsAvailable + " regular seats available" +
                                      "\n3: Economy Seats (€5.00). There are " + economySeatsAvailable + " economy seats available");
                 
                 do{
                    while(!keyboard.hasNextInt()){     /////Begin error check users ticket type choice
                         
                            keyboard.next();
                         
                            System.out.println("\nError!!! That is not a number" +
                                               "\nWhat type of seats would you like to book?" +
                                               "\n" +
                                               "\nEnter a value between 1 and 3" +
                                               "\n1: Premium Seat (€10.00). There are " + premiumSeatsAvailable + " premium seats available" +
                                                  "\n2: Regular Seats (€7.50). There are " + regularSeatsAvailable + " regular seats available" +
                                                  "\n3: Economy Seats (€5.00). There are " + economySeatsAvailable + " economy seats available");
                     }
                     
                     userTicketType = keyboard.nextInt();
                     
                     if(userTicketType >3 || userTicketType < 1){
                            System.out.println("\n\nError!!! That is not a number between 1 and 3." +
                                                 "\nWhat type of seats would you like to book?" +
                                                 "\n" +
                                                 "\nEnter a value between 1 and 3" +
                                                 "\n1: Premium Seat (€10.00). There are " + premiumSeatsAvailable + " premium seats available" +
                                                    "\n2: Regular Seats (€7.50). There are " + regularSeatsAvailable + " regular seats available" +
                                                    "\n3: Economy Seats (€5.00). There are " + economySeatsAvailable + " economy seats available");
                     }
                       
                     // Check if there are still tickets left for the users category choice
                     if(premiumSeatsAvailable == 0 && userTicketType == 1 || regularSeatsAvailable == 0 && userTicketType == 2|| economySeatsAvailable == 0 && userTicketType == 3){
                          switch(userTicketType){
                                  case 1:
                                      System.out.println("\nError!!! There are no premium tickets left." +
                                                      "\nPlease make another choice");
                                      userTicketType = 0;
                                      break;
                                  case 2:
                                      System.out.println("\nError!!! There are no regular tickets left." +
                                                    "\nPlease make another choice");
                                      userTicketType = 0;
                                      break;
                                  case 3:
                                      System.out.println("\nError!!! There are no economy tickets left." +
                                                     "\nPlease make another choice");
                                      userTicketType = 0;
                                      break;
                          }
                     }
                }while(userTicketType > 3 || userTicketType < 1);   /// End error check users ticket type choice
            
            
             
                switch(userTicketType){    /// Declares users ticket choice as a string for later error checking and receipts
                    case 1:
                        ticketType = "Premium";
                        break;
                    case 2:
                        ticketType = "Regular";
                        break;
                    case 3:
                        ticketType = "Economy";
                        break;
                    default:
                        System.out.println("System error 1");
                        ticketType = "System Error 1";
                        break;
                     
                }
            
               // Allows user to oder a number of tickets
             
                System.out.println("\nHow many tickets would you like to purchase?");
             
                while(!keyboard.hasNextInt()){     /////Begin error check users order
                    keyboard.next();
                 
                    System.out.println("\nError!!! That is not a number" +
                                       "\nPlease enter the number of tickts you require");
                }                                  /////End error check users order
             
                userTicketAmount = keyboard.nextInt();
             
            
                if(userTicketType == 1){   /// Confirms that there are enough ticket for the users choice of seats
                    while(userTicketAmount > premiumSeatsAvailable){

                        System.out.println("\nThere are not enough premium seats left to fill that order." +
                                           "\nThere are " + premiumSeatsAvailable + " seats left." +
                                           "\nPlease re-enter your order");
                     
                        while(!keyboard.hasNextInt()){  // Error checks users re-order
                            keyboard.next();
                           
                                System.out.println("Error!!! That is not a number" +
                                                 "\nThere are " + premiumSeatsAvailable + " seats left." +
                                             "\nPlease re-enter your order");
                            
                            userTicketAmount = 100;
                       }
                       
                        userTicketAmount = keyboard.nextInt();
                       
                      }
                }
             
                else if(userTicketType == 2){ /// Confirms that there are enough ticket for the users choice of seats
                    while(userTicketAmount > regularSeatsAvailable){
                        System.out.println("There are not enough regular seats left to fill that order." +
                                         "\nThere are " + regularSeatsAvailable + " seats left." +
                                         "\nPlease re-enter your order");
                     
                        while(!keyboard.hasNextInt()){ // Error checks users re-order
                            keyboard.next();
                           
                                System.out.println("Error!!! That is not a number" +
                                                 "\nThere are " + premiumSeatsAvailable + " seats left." +
                                             "\nPlease re-enter your order");
                            
                            userTicketAmount = 100;
                       }
                       
                        userTicketAmount = keyboard.nextInt();
                    }
                }
             
                else{ /// Confirms that there are enough ticket for the users choice of seats
                    while(userTicketAmount > economySeatsAvailable){
                        System.out.println("There are not enough economy seats left to fill that order." +
                                         "\nThere are " + regularSeatsAvailable + " seats left." +
                                         "\nPlease re-enter your order");
                       
                        while(!keyboard.hasNextInt()){  // Error checks users re-order
                            keyboard.next();
                           
                                System.out.println("Error!!! That is not a number" +
                                                 "\nThere are " + premiumSeatsAvailable + " seats left." +
                                             "\nPlease re-enter your order");
                            
                               userTicketAmount = 100;
                       }
                       
                        userTicketAmount = keyboard.nextInt();
                      
                      
                    }
                }
               
               
              
             
        ///////////***************End of Ticket Choice********************************////////////////////////////////
             
             
        //////////****************Beginning of Ticket cancellation********************////////////////////////////////
             
                System.out.println("\n\nYou have ordered " + userTicketAmount + " " + ticketType + " tickets" +
                                     "\nWould like to cancel, select 1 or 2" +
                                     "\n1: No, don't cancel tickets" +
                                     "\n2: Yes, DO cancel tickets");
               
                do{  /////Error check users cancellation choice
                     while(!keyboard.hasNextInt()){    
                         keyboard.next();
                      
                         System.out.println("\nError!!! That is not a number" +
                                            "\nYou have ordered " + userTicketAmount + " " + ticketType + " tickets" +
                                            "\nWould like to cancel, select 1 or 2" +
                                            "\n1: No, don't cancel tickets" +
                                            "\n2: Yes, DO cancel tickets");
                     }
                     
                     userCancellationChoice = keyboard.nextInt();
                     
                     if(userCancellationChoice < 1 || userCancellationChoice > 2){
                         System.out.println("\n\nError!!! That is not a number between 1 and 2." +
                                              "\nYou have ordered " + userTicketAmount + " " + ticketType + " tickets" +
                                              "\nWould like to cancel, select 1 or 2" +
                                              "\n1: No, don't cancel tickets" +
                                              "\n2: Yes, DO cancel tickets");
                     }
                   
                }while(userCancellationChoice < 1 || userCancellationChoice > 2);
             
                if(userCancellationChoice == 1){  // If user decides to keep tickets, variables are updated for the stage drawing algorithm and for later receipts
                    switch(userTicketType){
                        case 1:
                            premiumSeatsAvailable -= userTicketAmount;
                            premiumSeatsSold += userTicketAmount;
                            userTotalCost =  premiumSeatAmount * userTicketAmount;
                            totalTicketSales += (premiumSeatAmount * userTicketAmount);
                            break;
                        case 2:
                            regularSeatsAvailable -= userTicketAmount;
                            regularSeatsSold += userTicketAmount;
                            userTotalCost =  regularSeatAmount * userTicketAmount;
                            totalTicketSales += (regularSeatAmount * userTicketAmount);
                            break; 
                        case 3:
                            economySeatsAvailable -= userTicketAmount;
                            economySeatsSold += userTicketAmount;
                            userTotalCost =  economySeatAmount * userTicketAmount;
                            totalTicketSales += (economySeatAmount * userTicketAmount);
                            break;
                        default:
                            System.out.println("System error 2");
                            userTotalCost = 0;
                          
                    }
                }     
                else{
                    userTicketAmount = 0;
                    userTotalCost =  0;

                    ticketType = "Order Cancelled";
                }
             
             
        //////////****************End of Ticket cancellation***************************////////////////////////////////     
             
             
        //////////****************Beginning of Sales and ticket reports********************////////////////////////////////
                      
                ////***************1: This sessions order report**************///////////
              
              
                System.out.println("\n+++++Customers Order Summary++++++" +
                                   "\n" +
                                   "\nNumber of tickets sold: " + userTicketAmount +
                                   "\n           Ticket type: " + ticketType +
                                   "\n            Total Cost: €" + formatter.format(userTotalCost));
         
                ////*************2: Overall sales reports********//////////////////////
              
                System.out.println("\n+++++Total Sales Summary+++++++" +
                                   "\n" +
                                   "\nNumber of Premium Tickets sold: " + premiumSeatsSold +
                                   "\n  Number of Regular Seats Sold: " + regularSeatsSold +
                                   "\n  Number of Economy Seats sold: " + economySeatsSold +
                                   "\n          Total value of sales: €" + formatter.format(totalTicketSales));

         
                ////*************3: Sales Bar Chart***********/////////////////////////
               
                System.out.println("\n+++++Sales Bar Chart+++++\n");
               
                System.out.print("Premium Seats: ");
               
                for(int x=1; x <= premiumSeatsSold; x++){   ///Prints a bar chart based on the total number of ticket sales from previous orders and this sessions order
                    System.out.print("|");
                }
               
                System.out.println();
               
                System.out.print("Regular Seats: ");
               
                for(int x=1; x <= regularSeatsSold; x++){
                    System.out.print("|");
                }
               
                System.out.println();
         
                System.out.print("Economy Seats: ");
               
                for(int x=1; x <= economySeatsSold; x++){
                    System.out.print("|");
                }
                ////*********4: Seat availability chart***********/////////////////////
              
                System.out.println("\n" +
                                   "\n+++++Seat Availibity Summary+++++++" +
                                   "\n" +
                                   "\nPremium Seats Available: " + premiumSeatsAvailable +
                                   "\nRegular Seats Available: " + regularSeatsAvailable +
                                   "\nEconomy Seats Available: " + economySeatsAvailable);

             
        //////////****************End of Sales and ticket reports********************////////////////////////////////
               
        //////////****************User given a choice to continue or not if tickets are available*************////////////////////////////////     
             
                if(premiumSeatsAvailable == 0 && regularSeatsAvailable == 0 && economySeatsAvailable == 0){
                    System.out.println("\nAll seats have been sold, the programme will close." +
                                         "\nHere is the final seat allocation\n");
                   
                    userChoiceContinue = 0;
                }
                else{
                    //user has the choice to continue entering tickets orders
                    System.out.println("\nDo you want complete a new order?" +
                                           "\n1 for yes or 2 for no");
                  //Checks user input is a number and in the correct range, displays error if not and has user re-enter their choice
                    do{
                        while(!keyboard.hasNextInt()){
                              keyboard.next();
                               
                              System.out.println("Error!!! That is not a number" +
                                               "\nEnter 1 for Yes or 2 for No");
                        }
                           
                        userChoiceContinue = keyboard.nextInt();
                           
                        if(userChoiceContinue < 1 || userChoiceContinue > 2){
                             System.out.println("Error!!! That is not a valid number" +
                                              "\nEnter 1 for Yes or 2 for No");
                        }
                    }while(userChoiceContinue < 1 || userChoiceContinue > 2);
               }
              
              
               
        }while(userChoiceContinue == 1);
       
        //Once the programme has been completed the final seating plan will be printed
       
        if(userChoiceContinue == 2){
            System.out.println("\nYou have ended the programme" +
                               "\nHere is the final seat allocation\n");
        }
   
        System.out.println("|           Stage            |" +
                         "\n|............................|");


        seatCount = premiumSeatsSold;
       
        for(int x=0; x < 2; x++){   // Loop will print out currently taken premium seats (P) and empty seats (#),
          System.out.println();    
                  
           for(int y=0; y < 10; y++){
               if(seatCount > 0){
                   System.out.print(" P ");
               } 
               else{
                   System.out.print(" # ");
               }
           
               seatCount -=1;
           }
        }
       
        seatCount = regularSeatsSold;
       
        for(int x=0; x < 8; x++){    // Loop will print out currently taken economy seats (R) and empty seats (#),
           System.out.println();    
         
         
           for(int y=0; y < 10; y++){
               if(seatCount > 0){
                   System.out.print(" R ");
                   }
               else{
                   System.out.print(" # ");
               }
           
               seatCount -=1;
           }
        }
       
        seatCount = economySeatsSold;
       
        for(int x=0; x < 2; x++){     // Loop will print out currently taken regular seats (e) and empty seats (#)
           System.out.println();     
                    
           for(int y=0; y < 10; y++){
               if(seatCount > 0){
                   System.out.print(" E ");
               } 
               else{
                   System.out.print(" # ");
               }
           
               seatCount -= 1;
           }
        }

    }

}

