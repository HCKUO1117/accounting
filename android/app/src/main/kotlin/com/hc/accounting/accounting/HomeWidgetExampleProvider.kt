package com.hc.accounting.accounting

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.net.Uri
import android.widget.RemoteViews
import com.google.gson.Gson
import com.google.gson.annotations.SerializedName
import com.google.gson.reflect.TypeToken
import es.antonborri.home_widget.HomeWidgetBackgroundIntent
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

            print("123456789")

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
                val backgroundIntent = HomeWidgetBackgroundIntent.getBroadcast(
                    context,
                    Uri.parse("homeWidgetExample://titleClicked")
                )
                setOnClickPendingIntent(R.id.widget_title, backgroundIntent)

                val message = widgetData.getString("message", null)

                ///傳值給list view
                val intent = Intent(context, ListWidgetService::class.java).apply {
                    // Add the widget ID to the intent extras.
                    putExtra("data", message)
                }
                setRemoteAdapter(R.id.list_view, intent)


                val gson = Gson()
                val type = object: TypeToken<List<MyRecord>>() {
                }.type
                val record = gson.fromJson<List<MyRecord>>(message ?: "[]",type)

                setTextViewText(
                    R.id.widget_message, record[0].category
                )
                // Detect App opened via Click inside Flutter
                val pendingIntentWithData = HomeWidgetLaunchIntent.getActivity(
                    context,
                    MainActivity::class.java,
                    Uri.parse("homeWidgetExample://message?message=$message")
                )
                setOnClickPendingIntent(R.id.widget_message, pendingIntentWithData)
            }


            appWidgetManager.updateAppWidget(widgetId, views)
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
