import 'dart:ffi';

import 'package:flutter/material.dart';

class BuildMuscleLowCarb {
    String name = '';
    String details = '';    
    String breakfast = '';
    String morningSnack = '';
    String lunch = '';
    String afternoonSnack = '';
    String dinner = '';

    List<BuildMuscleLowCarb> MealPlans = [
            new BuildMuscleLowCarb("Meal Plan 1", "", "", "", "", "", ""),
            new BuildMuscleLowCarb("Meal Plan 2", "", "", "", "", "", ""),
            new BuildMuscleLowCarb("Meal Plan 3", "", "", "", "", "", "")
    ];

    BuildMuscleLowCarb (String name, String details, String breakfast, String morningSnack, String lunch, String afternoonSnack, String dinner){
        this.name = name;
        this.details = details;
        this.breakfast = breakfast;
        this.morningSnack = morningSnack;
        this.lunch = lunch;
        this.afternoonSnack = afternoonSnack;
        this.dinner = dinner;
    }

    String getName(){
        return name;
    }

    String getdetails(){
      return details;
    }
    String getbreakfast(){
        return breakfast;
    }

        String getmorningSnack(){
        return morningSnack;
    }

        String getlunch(){
        return lunch;
    }

        String getafternoonSnack(){
        return afternoonSnack;
    }

        String getdinner(){
        return dinner;
    }
}
