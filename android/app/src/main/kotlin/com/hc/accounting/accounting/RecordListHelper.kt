package com.hc.accounting.accounting

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ArrayAdapter
import android.widget.RemoteViews
import android.widget.RemoteViewsService
import android.widget.TextView
import com.google.gson.Gson
import com.google.gson.reflect.TypeToken

class ListWidgetService : RemoteViewsService() {

    override fun onGetViewFactory(intent: Intent): RemoteViewsFactory {
        return ListRemoteViewsFactory(this.applicationContext, intent)
    }
}

class ListRemoteViewsFactory(
    private val context: Context,
    intent: Intent
) : RemoteViewsService.RemoteViewsFactory {
    var message = intent.getStringExtra("data")
    var record:List<MyRecord> = listOf()

    override fun onCreate() {
        val gson = Gson()
        val type = object: TypeToken<List<MyRecord>>() {
        }.type
        record = gson.fromJson( message ?: "[]",type)
    }

    override fun getViewAt(position: Int): RemoteViews {
        // Construct a remote views item based on the widget item XML file,
        // and set the text based on the position.
        return RemoteViews(context.packageName, R.layout.record_card).apply {
            setTextViewText(R.id.name, record[position].category)
            setTextViewText(R.id.amount,record[position].amount.toString())
        }
    }

    override fun onDataSetChanged() {
        TODO("Not yet implemented")
    }

    override fun onDestroy() {
        TODO("Not yet implemented")
    }

    override fun getCount(): Int {
        TODO("Not yet implemented")
    }

    override fun getLoadingView(): RemoteViews {
        TODO("Not yet implemented")
    }

    override fun getViewTypeCount(): Int {
        TODO("Not yet implemented")
    }

    override fun getItemId(p0: Int): Long {
        TODO("Not yet implemented")
    }

    override fun hasStableIds(): Boolean {
        TODO("Not yet implemented")
    }
}