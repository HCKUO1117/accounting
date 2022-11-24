package com.hc.accounting.accounting

import android.app.Activity
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ArrayAdapter
import android.widget.TextView

class RecordAdapter (activity: Activity, private val resourceId:Int, data:List<MyRecord>) : ArrayAdapter<MyRecord>(activity,resourceId,data){

    override fun getView(position: Int, convertView: View?, parent: ViewGroup): View {
        val view = LayoutInflater.from(context).inflate(resourceId,parent,false)
        val category: TextView =view.findViewById(R.id.name)//绑定布局得图片
        val amount:TextView=view.findViewById(R.id.amount)//绑定布局中得名字
        val record=getItem(position)//获取当前项得Fruit实例
        if (record!=null){
            category.text = record.category
            amount.text= record.amount.toString()
        }
        return  view
    }
}