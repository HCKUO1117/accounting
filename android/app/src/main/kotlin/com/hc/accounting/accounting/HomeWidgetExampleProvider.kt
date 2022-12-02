package com.hc.accounting.accounting

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.graphics.Color
import android.net.Uri
import android.widget.RemoteViews
import com.google.gson.annotations.SerializedName
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetProvider

class HomeWidgetExampleProvider : HomeWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences
    ) {
        appWidgetIds.forEach { widgetId ->

            val views = RemoteViews(context.packageName, R.layout.example_layout).apply {

                // Open App on Widget Click
                val pendingIntent = HomeWidgetLaunchIntent.getActivity(
                    context,
                    MainActivity::class.java
                )
                setOnClickPendingIntent(R.id.widget_container, pendingIntent)

                // Swap Title Text by calling Dart Code in the Background
                setTextViewText(
                    R.id.widget_title, widgetData.getString("title", null)
                        ?: "No Title Set"
                )
//                val backgroundIntent = HomeWidgetBackgroundIntent.getBroadcast(
//                    context,
//                    Uri.parse("homeWidgetExample://titleClicked")
//                )
//                setOnClickPendingIntent(R.id.widget_title, backgroundIntent)

                val data = widgetData.getString("message", null)

                ///傳值給list view
                val intent = Intent(context, ListWidgetService::class.java).apply {
                    // Add the widget ID to the intent extras.
                    putExtra("data", data)
                }
                intent.putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, widgetId);
                intent.data = Uri.parse(intent.toUri(Intent.URI_INTENT_SCHEME));
                setRemoteAdapter(R.id.list_view, intent)


                val income = widgetData.getString("income", "0")

                setTextViewText(
                    R.id.income_amount, income
                )

                val expenditure = widgetData.getString("expenditure", "0")

                setTextViewText(
                    R.id.expenditure_amount, expenditure
                )

                val balance = widgetData.getString("balance", "0")

                setTextViewText(
                    R.id.balance, balance
                )

//                if(balanceNum <0){
//                    setTextColor(R.id.balance, Color.parseColor("#FF5252"))
//                }

                val share = context.getSharedPreferences(
                    "FlutterSharedPreferences",
                    Context.MODE_PRIVATE
                )


                val budget = share.getString("flutter.goalNum", "-1.0")


                val budgetNum = budget!!.toDouble()
                if (budget == "-1.0") {
                    setTextViewText(R.id.budget_amount, context.getString(R.string.unSet))
                    setTextColor(R.id.budget_amount, Color.parseColor("#9E9E9E"))
                } else {
                    val monthExpenditure = widgetData.getString("monthExpenditure", "0")
                    val monthExpenditureNum = monthExpenditure!!.toDouble()
                    val budgetLeft = budgetNum + monthExpenditureNum

                    setTextViewText(
                        R.id.budget_amount, budgetLeft.toString()
                    )
                    if (budgetLeft < 0) {
                        setTextColor(R.id.budget_amount, Color.parseColor("#FF5252"))
                    } else {
                        setTextColor(R.id.budget_amount, Color.parseColor("#448AFF"))
                    }
                }


                // Detect App opened via Click inside Flutter
//                val pendingIntentWithData = HomeWidgetLaunchIntent.getActivity(
//                    context,
//                    MainActivity::class.java,
//                    Uri.parse("homeWidgetExample://message?message=$message")
//                )
//                setOnClickPendingIntent(R.id.widget_message, pendingIntentWithData)
            }


            appWidgetManager.updateAppWidget(widgetId, views)
            appWidgetManager.notifyAppWidgetViewDataChanged(widgetId, R.id.list_view)
        }
    }
}

class MyRecord {
    @SerializedName("date")
    var date: String = ""

    @SerializedName("category")
    var category: String = ""

    @SerializedName("amount")
    var amount: Double = 0.0
}
