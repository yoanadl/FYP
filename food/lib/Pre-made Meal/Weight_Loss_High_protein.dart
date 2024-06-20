import 'dart:ffi';

import 'package:flutter/material.dart';

class WeightLossHighProtein {
    String name = "";
    String breakfast = "";
    String morningSnack = '';
    String lunch = '';
    String afternoonSnack = '';
    String dinner = '';

    List<WeightLossHighProtein> MealPlans = [
            new WeightLossHighProtein("", "", "", "", "", ""),
            new WeightLossHighProtein("", "", "", "", "", ""),
            new WeightLossHighProtein("", "", "", "", "", "")
    ];

    WeightLossHighProtein (String name, String breakfast, String morningSnack, String lunch, String afternoonSnack, String dinner){
        this.name = name;
        this.breakfast = breakfast;
        this.morningSnack = morningSnack;
        this.lunch = lunch;
        this.afternoonSnack = afternoonSnack;
        this.dinner = dinner;
    }

    String getName(){
        return name;
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
