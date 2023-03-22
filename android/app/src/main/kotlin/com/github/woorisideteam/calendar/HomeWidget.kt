package com.github.woorisideteam.calendar

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.net.Uri
import android.os.Build
import android.widget.RemoteViews
import android.widget.Toast
import com.github.woorisideteam.calendar.home_widget.*
import com.github.woorisideteam.calendar.home_widget.CalendarGridWidgetProvider.Companion.EXTRA_ITEM
import com.github.woorisideteam.calendar.home_widget.CalendarGridWidgetProvider.Companion.TOAST_ACTION

class HomeWidget : HomeWidgetProvider() {

    override fun onEnabled(context: Context?) {
        super.onEnabled(context)
    }

    // Called when the BroadcastReceiver receives an Intent broadcast.
    // Checks whether the intent's action is TOAST_ACTION. If it is, the
    // widget displays a Toast message for the current item.
    override fun onReceive(context: Context, intent: Intent) {
        val mgr: AppWidgetManager = AppWidgetManager.getInstance(context)
        if (intent.action == TOAST_ACTION) {
            val appWidgetId: Int = intent.getIntExtra(
                AppWidgetManager.EXTRA_APPWIDGET_ID,
                AppWidgetManager.INVALID_APPWIDGET_ID
            )
            // EXTRA_ITEM represents a custom value provided by the Intent
            // passed to the setOnClickFillInIntent() method to indicate the
            // position of the clicked item. See StackRemoteViewsFactory in
            // Set the fill-in Intent for details.
            val viewIndex: Int = intent.getIntExtra(EXTRA_ITEM, 0)
            Toast.makeText(context, "Touched view $viewIndex", Toast.LENGTH_SHORT).show()
        }
        super.onReceive(context, intent)
    }

    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray, widgetData: SharedPreferences) {
        appWidgetIds.forEach { widgetId ->
            val intent = Intent(context, CalendarGridWidgetService::class.java).apply {
                // Add the widget ID to the intent extras.
                putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, widgetId)
                data = Uri.parse(toUri(Intent.URI_INTENT_SCHEME))
            }
            val views = RemoteViews(context.packageName, R.layout.home_widget).apply {

                // Open App on Widget Click
                val pendingIntent = HomeWidgetLaunchIntent.getActivity(context,
                    MainActivity::class.java)
                setOnClickPendingIntent(R.id.textYearMonth, pendingIntent)

                setRemoteAdapter(R.id.gridCell, intent)
            }
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                views.setRemoteAdapter(R.id.gridCell,
                RemoteViews.RemoteCollectionItems.Builder()
                    .addItem(0, RemoteViews(context.packageName, R.layout.calendar_cell))
                    .setViewTypeCount(1)
                    .build()
                )
            }
            // This section makes it possible for items to have individualized
            // behavior. It does this by setting up a pending intent template.
            // Individuals items of a collection can't set up their own pending
            // intents. Instead, the collection as a whole sets up a pending
            // intent template, and the individual items set a fillInIntent
            // to create unique behavior on an item-by-item basis.
            val toastPendingIntent: PendingIntent = Intent(
                context,
                CalendarGridWidgetProvider::class.java
            ).run {
                // Set the action for the intent.
                // When the user touches a particular view, it has the effect of
                // broadcasting TOAST_ACTION.
                action = TOAST_ACTION
                putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, widgetId)
                data = Uri.parse(toUri(Intent.URI_INTENT_SCHEME))

                PendingIntent.getBroadcast(context, 0, this, PendingIntent.FLAG_UPDATE_CURRENT)
            }
            views.setPendingIntentTemplate(R.id.gridCell, toastPendingIntent)
            views.setInt(R.id.background, "setImageAlpha", 255)
            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}