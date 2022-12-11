package com.hc.accounting.accounting

import android.appwidget.AppWidgetManager
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.widget.RemoteViews
import android.widget.RemoteViewsService
import com.google.gson.Gson
import com.google.gson.reflect.TypeToken

class ListWidgetService : RemoteViewsService() {

    override fun onGetViewFactory(intent: Intent): RemoteViewsFactory {
        return ListRemoteViewsFactory(this.applicationContext, intent)
    }
}

class ListRemoteViewsFactory(

) : RemoteViewsService.RemoteViewsFactory {
    private var message: String? = null
    var record: List<MyRecord> = listOf()

    val UPDATE_WIDGET_ACTION = "WidgetRemoteViewsFactory#update"

    private lateinit var context: Context
    private var appWidgetId = 0

    private var receiver: BroadcastReceiver? = null


    constructor(context: Context, intent: Intent) : this() {
        message = intent.getStringExtra("data")
        this.context = context

        appWidgetId = intent.getIntExtra(
            AppWidgetManager.EXTRA_APPWIDGET_ID,
            AppWidgetManager.INVALID_APPWIDGET_ID
        )

        context.registerReceiver(object : BroadcastReceiver() {
            override fun onReceive(context: Context?, intent: Intent) {

                val appWidgetManager = AppWidgetManager.getInstance(context)
                appWidgetManager.notifyAppWidgetViewDataChanged(appWidgetId, R.id.list_view)
            }
        }.also { receiver = it }, IntentFilter(UPDATE_WIDGET_ACTION))
    }

    override fun onCreate() {
//        val gson = Gson()
//        val type = object: TypeToken<List<MyRecord>>() {
//        }.type
//        record = gson.fromJson( message ?: "[]",type)
    }

    override fun getViewAt(position: Int): RemoteViews {
        // Construct a remote views item based on the widget item XML file,
        // and set the text based on the position.
        return RemoteViews(context.packageName, R.layout.record_card).apply {
            if (record[position].category.isNotEmpty()) {
                setTextViewText(R.id.name, record[position].category)
            } else {
                setTextViewText(R.id.name, context.getString(R.string.unCategory))
            }

            setTextViewText(R.id.amount, record[position].amount.toString())
        }
    }

    override fun onDataSetChanged() {
        val gson = Gson()
        val type = object : TypeToken<List<MyRecord>>() {
        }.type
        record = gson.fromJson(message ?: "[]", type)
    }

    override fun onDestroy() {
    }

    override fun getCount(): Int {
        return record.size
    }

    override fun getLoadingView(): RemoteViews {
        return RemoteViews(context.packageName, R.layout.loading_layout)
    }

    override fun getViewTypeCount(): Int {
        return 1
    }

    override fun getItemId(p0: Int): Long {
        return p0.toLong()
    }

    override fun hasStableIds(): Boolean {
        return true
    }
}