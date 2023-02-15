package com.github.woorisideteam.calendar

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.net.Uri
import android.widget.RemoteViews
import com.github.woorisideteam.calendar.home_widget.HomeWidgetBackgroundIntent
import com.github.woorisideteam.calendar.home_widget.HomeWidgetLaunchIntent
import com.github.woorisideteam.calendar.home_widget.HomeWidgetProvider

class HomeWidget : HomeWidgetProvider() {
    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray, widgetData: SharedPreferences) {
        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.home_widget).apply {

                // Open App on Widget Click
                val pendingIntent = HomeWidgetLaunchIntent.getActivity(context,
                    MainActivity::class.java)
                setOnClickPendingIntent(R.id.qwe, pendingIntent)

//                val counter = widgetData.getInt("_counter", 0)
//
//                var counterText = "Your counter value is: $counter"
//
//                if (counter == 0) {
//                    counterText = "You have not pressed the counter button"
//                }
//
//                setTextViewText(R.id.tv_counter, counterText)
//
//                // Pending intent to update counter on button click
//                val backgroundIntent = HomeWidgetBackgroundIntent.getBroadcast(context,
//                    Uri.parse("myAppWidget://updatecounter"))
//                setOnClickPendingIntent(R.id.bt_update, backgroundIntent)
            }
            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}