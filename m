Return-Path: <SRS0=LhtG=MV=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:52992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726481AbeJIXwJ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 9 Oct 2018 19:52:09 -0400
Date: Tue, 9 Oct 2018 12:34:19 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Yordan Karadzhov <y.karadz@gmail.com>
Cc: linux-trace-devel@vger.kernel.org,
        Yordan Karadzhov <ykaradzhov@vmware.com>
Subject: Re: [PATCH 2/4] kernel-shark-qt: Add KernalShark Utils
Message-ID: <20181009123419.22fe49f2@gandalf.local.home>
In-Reply-To: <20181008151629.13973-3-ykaradzhov@vmware.com>
References: <20181008151629.13973-1-ykaradzhov@vmware.com>
        <20181008151629.13973-3-ykaradzhov@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Mon,  8 Oct 2018 18:16:27 +0300
Yordan Karadzhov <y.karadz@gmail.com> wrote:


> index 0000000..2c4cecc
> --- /dev/null
> +++ b/kernel-shark-qt/src/KsUtils.cpp
> @@ -0,0 +1,584 @@
> +// SPDX-License-Identifier: LGPL-2.1
> +
> +/*
> + * Copyright (C) 2017 VMware Inc, Yordan Karadzhov <y.karadz@gmail.com>
> + */
> +
> +/**
> + *  @file    KsUtils.cpp
> + *  @brief   KernelShark Utils.
> + */
> +
> +// KernelShark
> +#include "KsUtils.hpp"
> +
> +namespace KsUtils {
> +
> +/** @brief Geat a sorteg vector of Task's Pids.  */

 "sorteg"?

> +QVector<int> getPidList()
> +{
> +	kshark_context *kshark_ctx(nullptr);
> +	int nTasks, *tempPids;
> +	QVector<int> pids;
> +
> +	if (!kshark_instance(&kshark_ctx))
> +		return pids;
> +
> +	nTasks = kshark_get_task_pids(kshark_ctx, &tempPids);
> +	for (int r = 0; r < nTasks; ++r) {
> +		pids.append(tempPids[r]);
> +	}
> +
> +	free(tempPids);
> +
> +	qSort(pids);
> +
> +	return pids;
> +}
> +
> +/**
> + * Set the bit of the filter mask of the kshark session context responsible
> + * for the visibility of the events in the Table View.
> + */
> +void listFilterSync(bool state)
> +{
> +	kshark_context *kshark_ctx(nullptr);

Add space here.

> +	if (!kshark_instance(&kshark_ctx))
> +		return;
> +
> +	if (state) {
> +		kshark_ctx->filter_mask |= KS_TEXT_VIEW_FILTER_MASK;
> +	} else {
> +		kshark_ctx->filter_mask &= ~KS_TEXT_VIEW_FILTER_MASK;
> +	}
> +}
> +
> +/**
> + * Set the bit of the filter mask of the kshark session context responsible
> + * for the visibility of the events in the Graph View.
> + */
> +void graphFilterSync(bool state)
> +{
> +	kshark_context *kshark_ctx(nullptr);

Add space here.

> +	if (!kshark_instance(&kshark_ctx))
> +		return;
> +
> +	if (state) {
> +		kshark_ctx->filter_mask |= KS_GRAPH_VIEW_FILTER_MASK;
> +	} else {
> +		kshark_ctx->filter_mask &= ~KS_GRAPH_VIEW_FILTER_MASK;
> +	}
> +}
> +
> +/**
> + * @brief Simple CPU matching function to be user for data collections.
> + *
> + * @param kshark_ctx: Input location for the session context pointer.
> + * @param e: kshark_entry to be checked.
> + * @param cpu: Matching condition value.
> + *
> + * @returns True if the CPU of the entry matches the value of "cpu" and
> + * 	    the entry is visibility in Graph. Otherwise false.
> + */
> +bool matchCPUVisible(struct kshark_context *kshark_ctx,
> +		     struct kshark_entry *e, int cpu)
> +{
> +	if (e->cpu == cpu && (e->visible & KS_GRAPH_VIEW_FILTER_MASK))
> +		return true;
> +
> +	return false;

BTW, you can make the above:

	return (e->cpu == cpu) &&
		(e->visible & KS_GRAPH_VIEW_FILTER_MASK);

> +}
> +
> +}; // KsUtils
> +
> +/** A stream operator for converting QColor into KsPlot::Color. */
> +KsPlot::Color& operator <<(KsPlot::Color &thisColor, const QColor &c)
> +{
> +	thisColor.set(c.red(), c.green(), c.blue());
> +
> +	return thisColor;
> +}
> +
> +/** Create a default (empty) KsDataStore. */
> +KsDataStore::KsDataStore(QWidget *parent)
> +: QObject(parent),
> +  _pevent(nullptr),
> +  _rows(nullptr),
> +  _dataSize(0)
> +{}
> +
> +/** Destroy the KsDataStore object. */
> +KsDataStore::~KsDataStore()
> +{}
> +
> +/** Load trace data for file. */
> +void KsDataStore::loadDataFile(const QString &file)
> +{
> +	kshark_context *kshark_ctx(nullptr);

Add space here.

> +	if (!kshark_instance(&kshark_ctx))
> +		return;
> +
> +	clear();
> +
> +	if (!kshark_open(kshark_ctx, file.toStdString().c_str()) ||
> +	    !kshark_ctx->handle ||
> +	    !kshark_ctx->pevent) {

Hmm, if the kshark_open() succeeds but for some reason there's not a
pevent (can that happen?) should we do a kshark_close?

> +		qCritical() << "ERROR Loading file " << file;
> +		return;
> +	}
> +
> +	_pevent = kshark_ctx->pevent;

BTW, we need to rename "pevent" to "tep", as that name is now obsolete.

> +
> +	if (kshark_ctx->event_handlers == nullptr)
> +		kshark_handle_plugins(kshark_ctx, KSHARK_PLUGIN_INIT);
> +	else
> +		kshark_handle_plugins(kshark_ctx, KSHARK_PLUGIN_UPDATE);
> +
> +	_dataSize = kshark_load_data_entries(kshark_ctx, &_rows);
> +}
> +
> +void KsDataStore::_freeData()
> +{
> +	if (_dataSize) {
> +		for (size_t r = 0; r < _dataSize; ++r)
> +			free(_rows[r]);
> +
> +		free(_rows);
> +		_rows = nullptr;
> +	}
> +}
> +
> +/** Reload the trace data. */
> +void KsDataStore::reload()
> +{
> +	kshark_context *kshark_ctx(nullptr);

Add space here.

> +	if (!kshark_instance(&kshark_ctx))
> +		return;
> +
> +	_freeData();
> +
> +	_dataSize = kshark_load_data_entries(kshark_ctx, &_rows);
> +	_pevent = kshark_ctx->pevent;
> +
> +	emit updateWidgets(this);
> +}
> +
> +/** Free the loaded trace data and close the file. */
> +void KsDataStore::clear()
> +{
> +	kshark_context *kshark_ctx(nullptr);
> +
> +	_freeData();
> +
> +	_pevent = nullptr;
> +
> +	if (kshark_instance(&kshark_ctx) &&
> +	    kshark_ctx->handle)

You can keep the two on the same line, even if it breaks the 80
character limit.

> +		kshark_close(kshark_ctx);
> +}
> +
> +/** Update the visibility of the entries (filter). */
> +void KsDataStore::update()
> +{
> +	kshark_context *kshark_ctx(nullptr);

Add space here.

> +	if (!kshark_instance(&kshark_ctx))
> +		return;
> +
> +	if (kshark_filter_is_set(kshark_ctx)) {
> +		kshark_filter_entries(kshark_ctx, _rows, _dataSize);
> +		emit updateWidgets(this);
> +	}
> +}
> +
> +/** Register a collection of visible entries for each CPU. */
> +void KsDataStore::registerCPUCollections()
> +{
> +	kshark_context *kshark_ctx(nullptr);

Add space here.

> +	if (!kshark_instance(&kshark_ctx) ||
> +	    !kshark_filter_is_set(kshark_ctx))
> +		return;
> +
> +	int nCPUs = _pevent->cpus;
> +	for (int cpu = 0; cpu < nCPUs; ++cpu) {
> +		kshark_register_data_collection(kshark_ctx,
> +						_rows, _dataSize,
> +						KsUtils::matchCPUVisible,
> +						cpu,
> +						0);
> +	}
> +}
> +
> +void KsDataStore::_unregisterCPUCollections()
> +{
> +	kshark_context *kshark_ctx(nullptr);

Add space here.

> +	if (!kshark_instance(&kshark_ctx))
> +		return;
> +
> +	int nCPUs = _pevent->cpus;
> +	for (int cpu = 0; cpu < nCPUs; ++cpu) {
> +		kshark_unregister_data_collection(&kshark_ctx->collections,
> +						  KsUtils::matchCPUVisible,
> +						  cpu);
> +	}
> +}
> +
> +void KsDataStore::_applyIdFilter(int filterId, QVector<int> vec)
> +{
> +	kshark_context *kshark_ctx(nullptr);

Add space here.

> +	if (!kshark_instance(&kshark_ctx))
> +		return;
> +
> +	switch (filterId) {
> +		case KS_SHOW_EVENT_FILTER:
> +		case KS_HIDE_EVENT_FILTER:
> +			kshark_filter_clear(kshark_ctx, KS_SHOW_EVENT_FILTER);
> +			kshark_filter_clear(kshark_ctx, KS_HIDE_EVENT_FILTER);

Hmm, I'm curious to why you clear both SHOW/HIDE filters if the
filterId is one of SHOW or HIDE?

Perhaps a comment should be here explaining it too.


> +			break;
> +		case KS_SHOW_TASK_FILTER:
> +		case KS_HIDE_TASK_FILTER:
> +			kshark_filter_clear(kshark_ctx, KS_SHOW_TASK_FILTER);
> +			kshark_filter_clear(kshark_ctx, KS_HIDE_TASK_FILTER);
> +			break;
> +		default:
> +			return;
> +	}
> +
> +	for (auto &&pid: vec)
> +		kshark_filter_add_id(kshark_ctx, filterId, pid);
> +
> +	if (!_pevent)
> +		return;
> +
> +	_unregisterCPUCollections();
> +
> +	/*
> +	 * If the advanced event filter is set the data has to be reloaded,

I think you need a comma between "set" and "the".

> +	 * because the advanced filter uses tep_records.
> +	 */
> +	if (kshark_ctx->advanced_event_filter->filters)
> +		reload();
> +	else
> +		kshark_filter_entries(kshark_ctx, _rows, _dataSize);
> +
> +	registerCPUCollections();
> +
> +	emit updateWidgets(this);
> +}
> +
> +/** Apply Show Task filter. */
> +void KsDataStore::applyPosTaskFilter(QVector<int> vec)
> +{
> +	_applyIdFilter(KS_SHOW_TASK_FILTER, vec);
> +}
> +
> +/** Apply Hide Task filter. */
> +void KsDataStore::applyNegTaskFilter(QVector<int> vec)
> +{
> +	_applyIdFilter(KS_HIDE_TASK_FILTER, vec);
> +}
> +
> +/** Apply Show Event filter. */
> +void KsDataStore::applyPosEventFilter(QVector<int> vec)
> +{
> +	_applyIdFilter(KS_SHOW_EVENT_FILTER, vec);
> +}
> +
> +/** Apply Hide Event filter. */
> +void KsDataStore::applyNegEventFilter(QVector<int> vec)
> +{
> +	_applyIdFilter(KS_HIDE_EVENT_FILTER, vec);
> +}
> +
> +/** Disable all filters. */
> +void KsDataStore::clearAllFilters()
> +{
> +	kshark_context *kshark_ctx(nullptr);
> +	kshark_instance(&kshark_ctx);
> +
> +	if (!_pevent)
> +		return;
> +
> +	_unregisterCPUCollections();
> +
> +	kshark_filter_clear(kshark_ctx, KS_SHOW_TASK_FILTER);
> +	kshark_filter_clear(kshark_ctx, KS_HIDE_TASK_FILTER);
> +	kshark_filter_clear(kshark_ctx, KS_SHOW_EVENT_FILTER);
> +	kshark_filter_clear(kshark_ctx, KS_HIDE_EVENT_FILTER);
> +
> +	tep_filter_reset(kshark_ctx->advanced_event_filter);
> +	kshark_clear_all_filters(kshark_ctx, _rows, _dataSize);
> +
> +	emit updateWidgets(this);
> +}
> +
> +/**
> + * @brief Create Plugin Manager. Use list of plugins declared in the
> + *	  CMake-generated header file.
> + */
> +KsPluginManager::KsPluginManager(QWidget *parent)
> +: QObject(parent)
> +{
> +	kshark_context *kshark_ctx(nullptr);
> +	_parsePluginList();
> +
> +	if (!kshark_instance(&kshark_ctx))
> +		return;
> +
> +	registerFromList(kshark_ctx);
> +}
> +
> +/** Parse the plugin list declared in the CMake-generated header file. */
> +void KsPluginManager::_parsePluginList()
> +{
> +	_ksPluginList = KsUtils::getPluginList();
> +	int nPlugins = _ksPluginList.count();
> +
> +	_registeredKsPlugins.resize(nPlugins);
> +	for (int i = 0; i < nPlugins; ++i) {
> +		if (_ksPluginList[i].contains(" default", Qt::CaseInsensitive)) {
> +			_ksPluginList[i].remove(" default", Qt::CaseInsensitive);
> +			_registeredKsPlugins[i] = true;
> +		} else {
> +			_registeredKsPlugins[i] = false;
> +		}
> +	}
> +}
> +
> +/**
> + * Register the plugins by using the information in "_ksPluginList" and
> + * "_registeredKsPlugins".
> + */
> +void KsPluginManager::registerFromList(kshark_context *kshark_ctx)
> +{
> +	auto lamRegBuiltIn = [&kshark_ctx](const QString &plugin)
> +	{
> +		char *lib;
> +		int n;
> +		n = asprintf(&lib, "%s/lib/plugin-%s.so",
> +			     KS_DIR, plugin.toStdString().c_str());
> +		if (n > 0) {

Usually the if statement after a call should be the error path, unless
we need to ignore the error. That is:

		if (n <= 0)
			return;

Then the below is not indented.

> +			kshark_register_plugin(kshark_ctx, lib);
> +			free(lib);
> +		}
> +	};
> +
> +	auto lamRegUser = [&kshark_ctx](const QString &plugin)
> +	{
> +		const char *lib = plugin.toStdString().c_str();
> +		kshark_register_plugin(kshark_ctx, lib);
> +	};
> +
> +	_forEachInList(_ksPluginList,
> +		       _registeredKsPlugins,
> +		       lamRegBuiltIn);
> +
> +	_forEachInList(_userPluginList,
> +		       _registeredUserPlugins,
> +		       lamRegUser);
> +}
> +
> +/**
> + * Unegister the plugins by using the information in "_ksPluginList" and
> + * "_registeredKsPlugins".
> + */
> +void KsPluginManager::unregisterFromList(kshark_context *kshark_ctx)
> +{
> +	auto lamUregBuiltIn = [&kshark_ctx] (const QString &plugin)
> +	{
> +		char *lib;
> +		int n;
> +		n = asprintf(&lib, "%s/lib/plugin-%s.so",
> +			     KS_DIR, plugin.toStdString().c_str());
> +		if (n > 0) {

same here.

> +			kshark_unregister_plugin(kshark_ctx, lib);
> +			free(lib);
> +		}
> +	};
> +
> +	auto lamUregUser = [&kshark_ctx] (const QString &plugin)
> +	{
> +		const char *lib = plugin.toStdString().c_str();
> +		kshark_unregister_plugin(kshark_ctx, lib);
> +	};
> +
> +	_forEachInList(_ksPluginList,
> +		       _registeredKsPlugins,
> +			lamUregBuiltIn);
> +
> +	_forEachInList(_userPluginList,
> +		       _registeredUserPlugins,
> +			lamUregUser);
> +}
> +
> +/**
> + * @brief Register a Plugin.
> + *
> + * @param plugin: provide here the name of the plugin (as in the CMake-generated
> + *		  header file) of a name of the plugin's library file (.so).
> + */
> +void KsPluginManager::registerPlugin(const QString &plugin)
> +{
> +	kshark_context *kshark_ctx(nullptr);
> +	char *lib;
> +	int n;
> +
> +	if (!kshark_instance(&kshark_ctx))
> +		return;
> +
> +	for (int i = 0; i < _ksPluginList.count(); ++i) {
> +		if (_ksPluginList[i] == plugin) {
> +			/*
> +			 * The argument is the name of the plugin. From the
> +			 * name get the library .so file.
> +			 */
> +			n = asprintf(&lib, "%s/lib/plugin-%s.so",
> +					KS_DIR, plugin.toStdString().c_str());
> +			if (n > 0) {

This is fine to keep it this way, as we return either way.

> +				kshark_register_plugin(kshark_ctx, lib);
> +				_registeredKsPlugins[i] = true;
> +				free(lib);
> +			}
> +
> +			return;

Add space here.

> +		} else if (plugin.contains("/lib/plugin-" + _ksPluginList[i],
> +					   Qt::CaseInsensitive)) {
> +			/*
> +			 * The argument is the name of the library .so file.
> +			 */
> +			n = asprintf(&lib, "%s", plugin.toStdString().c_str());
> +			if (n > 0) {
> +				kshark_register_plugin(kshark_ctx, lib);
> +				_registeredKsPlugins[i] = true;
> +				free(lib);
> +			}
> +
> +			return;
> +		}
> +	}
> +
> +	/* No plugin with this name in the list. Try to add it anyway. */
> +	if (plugin.endsWith(".so") && QFileInfo::exists(plugin)) {
> +		kshark_register_plugin(kshark_ctx,
> +				       plugin.toStdString().c_str());
> +
> +		_userPluginList.append(plugin);
> +		_registeredUserPlugins.append(true);
> +	} else {
> +		qCritical() << "ERROR: " << plugin << "cannot be registered!";
> +	}
> +}
> +
> +/** @brief Unregister a Plugin.
> + *<br> WARNING: Do not use this function to unregister User plugins.

Hmm, do we need the <br> above? (if this is required by DocGen I find
it rather ugly :-( )

Also, if this is not to be used to unregister User Plugins, can you add
what should be used to unregister them?


> + * @param plugin: provide here the name of the plugin (as in the CMake-generated
> + *		  header file) of a name of the plugin's library file (.so).
> + *
> + */
> +void KsPluginManager::unregisterPlugin(const QString &plugin)
> +{
> +	kshark_context *kshark_ctx(nullptr);
> +	char *lib;
> +	int n;
> +
> +	if (!kshark_instance(&kshark_ctx))
> +		return;
> +
> +	for (int i = 0; i < _ksPluginList.count(); ++i) {
> +		if (_ksPluginList[i] == plugin) {
> +			/*
> +			 * The argument is the name of the plugin. From the
> +			 * name get the library .so file.
> +			 */
> +			n = asprintf(&lib, "%s/lib/plugin-%s.so", KS_DIR,
> +				     plugin.toStdString().c_str());
> +			if (n > 0) {
> +				kshark_unregister_plugin(kshark_ctx, lib);
> +				_registeredKsPlugins[i] = false;
> +				free(lib);
> +			}
> +
> +			return;
> +		} else if  (plugin.contains("/lib/plugin-" +
> +			                   _ksPluginList[i], Qt::CaseInsensitive)) {
> +			/*
> +			 * The argument is the name of the library .so file.
> +			 */
> +			n = asprintf(&lib, "%s", plugin.toStdString().c_str());
> +			if (n > 0) {
> +				kshark_unregister_plugin(kshark_ctx, lib);
> +				_registeredKsPlugins[i] = false;
> +				free(lib);
> +			}
> +
> +			return;
> +		}
> +	}
> +}
> +
> +/** Unload all plugins. */
> +void KsPluginManager::unloadAll()
> +{
> +	kshark_context *kshark_ctx(nullptr);
> +	if (!kshark_instance(&kshark_ctx))
> +		return;
> +
> +	kshark_handle_plugins(kshark_ctx, KSHARK_PLUGIN_CLOSE);
> +	kshark_free_plugin_list(kshark_ctx->plugins);
> +	kshark_ctx->plugins = nullptr;
> +	kshark_free_event_handler_list(kshark_ctx->event_handlers);
> +
> +	unregisterFromList(kshark_ctx);
> +}
> +
> +/** @brief Update (change) the Plugins.
> + *
> + * @param pluginIds: The indexes of the plugins to be loaded.
> + */
> +void KsPluginManager::updatePlugins(QVector<int> pluginIds)
> +{
> +	kshark_context *kshark_ctx(nullptr);

Add space here.

> +	if (!kshark_instance(&kshark_ctx))
> +		return;
> +
> +	auto register_plugins = [&] (QVector<int> ids)
> +	{
> +		int nKsPlugins = _registeredKsPlugins.count();
> +
> +		/* First clear all registered plugins. */
> +		for (auto &p: _registeredKsPlugins)
> +			p = false;
> +		for (auto &p: _registeredUserPlugins)
> +			p = false;
> +
> +		/* The vector contains the indexes of those to register. */
> +		for (auto const &p: ids) {
> +			if (p < nKsPlugins)
> +				_registeredKsPlugins[p] = true;
> +			else
> +				_registeredUserPlugins[p - nKsPlugins] = true;
> +		}
> +		registerFromList(kshark_ctx);
> +	};
> +
> +	if (!kshark_ctx->pevent) {
> +		kshark_free_plugin_list(kshark_ctx->plugins);
> +		kshark_ctx->plugins = nullptr;
> +
> +		/*
> +		 * No data is loaded. For the moment, just register the
> +		 * plugins. Handling of the plugins will be done after
> +		 * we load a data file.
> +		 */
> +		register_plugins(pluginIds);
> +		return;
> +	}
> +
> +	/* Clean up all old plugins first. */
> +	unloadAll();
> +
> +	/* Now load. */
> +	register_plugins(pluginIds);
> +	kshark_handle_plugins(kshark_ctx, KSHARK_PLUGIN_INIT);
> +
> +	emit dataReload();
> +}
> diff --git a/kernel-shark-qt/src/KsUtils.hpp b/kernel-shark-qt/src/KsUtils.hpp
> new file mode 100644
> index 0000000..40142ca
> --- /dev/null
> +++ b/kernel-shark-qt/src/KsUtils.hpp

Is this private to libkshark and not going to be exported?

In other words, do we need to worry about namespace?

-- Steve

> @@ -0,0 +1,231 @@
> +/* SPDX-License-Identifier: LGPL-2.1 */
> +
> +/*
> + * Copyright (C) 2017 VMware Inc, Yordan Karadzhov <y.karadz@gmail.com>
> + */
> +
> +/**
> + *  @file    KsUtils.hpp
> + *  @brief   KernelShark Utils.
> + */
> +
> +#ifndef _KS_UTILS_H
> +#define _KS_UTILS_H
> +
> +// C++ 11
> +#include <chrono>
> +
> +// Qt
> +#include <QtWidgets>
> +
> +// KernelShark
> +#include "libkshark.h"
> +#include "libkshark-model.h"
> +#include "KsCmakeDef.hpp"
> +#include "KsPlotTools.hpp"
> +
> +/** Macro providing the height of the screen in pixels. */
> +#define SCREEN_HEIGHT  QApplication::desktop()->screenGeometry().height()
> +
> +/** Macro providing the width of the screen in pixels. */
> +#define SCREEN_WIDTH   QApplication::desktop()->screenGeometry().width()
> +
> +//! @cond Doxygen_Suppress
> +
> +auto fontHeight = [] ()
> +{
> +	QFont font;
> +	QFontMetrics fm(font);
> +	return fm.height();
> +};
> +
> +auto stringWidth = [](QString s)
> +{
> +	QFont font;
> +	QFontMetrics fm(font);
> +	return fm.width(s);
> +};
> +
> +//! @endcond
> +
> +/** Macro providing the height of the font in pixels. */
> +#define FONT_HEIGHT		fontHeight()
> +
> +/** Macro providing the width of the font in pixels. */
> +#define FONT_WIDTH 		stringWidth("4")
> +
> +/** Macro providing the width of a string in pixels. */
> +#define STRING_WIDTH(s)		stringWidth(s)
> +
> +/** Macro providing the height of the KernelShark graphs in pixels. */
> +#define KS_GRAPH_HEIGHT	(FONT_HEIGHT*2)
> +
> +//! @cond Doxygen_Suppress
> +
> +#define KS_JSON_CAST(doc) \
> +reinterpret_cast<json_object *>(doc)
> +
> +#define KS_C_STR_CAST(doc) \
> +reinterpret_cast<const char *>(doc)
> +
> +typedef std::chrono::high_resolution_clock::time_point  hd_time;
> +
> +#define GET_TIME std::chrono::high_resolution_clock::now()
> +
> +#define GET_DURATION(t0) \
> +std::chrono::duration_cast<std::chrono::duration<double>>( \
> +std::chrono::high_resolution_clock::now() - t0).count()
> +
> +//! @endcond
> +
> +namespace KsUtils {
> +
> +QVector<int> getPidList();
> +
> +/** @brief Geat the list of plugins. */
> +inline QStringList getPluginList() {return plugins.split(";");}
> +
> +void listFilterSync(bool state);
> +
> +void graphFilterSync(bool state);
> +
> +/** @brief Convert the timestamp of the trace record into a string showing
> + *	   the time in seconds.
> + *
> + * @param ts: Input location for the timestamp.
> + * @param prec: the number of digits after the decimal point in the return
> + *		string.
> + *
> + * @returns String showing the time in seconds.
> + */
> +inline QString Ts2String(int64_t ts, int prec)
> +{
> +	return QString::number(ts * 1e-9, 'f', prec);
> +}
> +
> +bool matchCPUVisible(struct kshark_context *kshark_ctx,
> +			      struct kshark_entry *e, int cpu);
> +}; // KsUtils
> +
> +/** Identifier of the Dual Marker active state. */
> +enum class DualMarkerState {
> +	A,
> +	B
> +};
> +
> +/**
> + * The KsDataStore class provides the access to trace data for all KernelShark
> + * widgets.
> + */
> +class KsDataStore : public QObject
> +{
> +	Q_OBJECT
> +public:
> +	explicit KsDataStore(QWidget *parent = nullptr);
> +
> +	~KsDataStore();
> +
> +	void loadDataFile(const QString &file);
> +
> +	void clear();
> +
> +	/** Get the page event used to parse the page.. */
> +	tep_handle *pevent() const {return _pevent;}
> +
> +	/** Get the trace data array.. */
> +	struct kshark_entry **rows() const {return _rows;}
> +
> +	/** Get the size of the data array. */
> +	size_t size() const {return _dataSize;}
> +
> +	void reload();
> +
> +	void update();
> +
> +	void registerCPUCollections();
> +
> +	void applyPosTaskFilter(QVector<int>);
> +
> +	void applyNegTaskFilter(QVector<int>);
> +
> +	void applyPosEventFilter(QVector<int>);
> +
> +	void applyNegEventFilter(QVector<int>);
> +
> +	void clearAllFilters();
> +
> +signals:
> +	/**
> +	 * This signal is emitted when the data has changed and the View
> +	 * widgets have to update.
> +	 */
> +	void updateWidgets(KsDataStore *);
> +
> +private:
> +	/** Page event used to parse the page. */
> +	tep_handle		*_pevent;
> +
> +	/** Trace data array. */
> +	struct kshark_entry	**_rows;
> +
> +	/** The size of the data array. */
> +	size_t			_dataSize;
> +
> +	void _freeData();
> +	void _unregisterCPUCollections();
> +	void _applyIdFilter(int filterId, QVector<int> vec);
> +};
> +
> +/** A Plugin Manage class. */
> +class KsPluginManager : public QObject
> +{
> +	Q_OBJECT
> +public:
> +	explicit KsPluginManager(QWidget *parent = nullptr);
> +
> +	/** A list of available built-in plugins. */
> +	QStringList	_ksPluginList;
> +
> +	/** A list of registered built-in plugins. */
> +	QVector<bool>	_registeredKsPlugins;
> +
> +	/** A list of available user plugins. */
> +	QStringList	_userPluginList;
> +
> +	/** A list of registered user plugins. */
> +	QVector<bool>	_registeredUserPlugins;
> +
> +	void registerFromList(kshark_context *kshark_ctx);
> +	void unregisterFromList(kshark_context *kshark_ctx);
> +
> +	void registerPlugin(const QString &plugin);
> +	void unregisterPlugin(const QString &plugin);
> +	void unloadAll();
> +
> +	void updatePlugins(QVector<int> pluginId);
> +
> +signals:
> +	/** This signal is emitted when a plugin is loaded or unloaded. */
> +	void dataReload();
> +
> +private:
> +	void _parsePluginList();
> +
> +	template <class T>
> +	void _forEachInList(const QStringList &pl,
> +			    const QVector<bool> &reg,
> +			    T action)
> +	{
> +		int nPlugins;
> +		nPlugins = pl.count();
> +		for (int i = 0; i < nPlugins; ++i) {
> +			if (reg[i]) {
> +				action(pl[i]);
> +			}
> +		}
> +	}
> +};
> +
> +KsPlot::Color& operator <<(KsPlot::Color &thisColor, const QColor &c);
> +
> +#endif
