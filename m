Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F169C433F5
	for <linux-trace-devel@archiver.kernel.org>; Wed,  5 Jan 2022 11:34:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235656AbiAELe0 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 5 Jan 2022 06:34:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235556AbiAELe0 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 5 Jan 2022 06:34:26 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A549C061761
        for <linux-trace-devel@vger.kernel.org>; Wed,  5 Jan 2022 03:34:26 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id l10so981427wrh.7
        for <linux-trace-devel@vger.kernel.org>; Wed, 05 Jan 2022 03:34:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=67Fp7jURSSQWmmmi9atSt83tFHUKa11VhKEGAlqZA54=;
        b=pDGjeDtlrRKP6A+b6bLfJKN9/n/HnbVZCDRJoVV5ogW1joGCGag2lW/iAtcSEmlM5O
         LuH332Q4Svo25zb4B01ncC15NGNx4EMHoj08DG0kSW2X9fyyxKysKoNAplfq4wrWvDTW
         BrVqqrdYnPCuM+OyrW5uFHZbL2AXH12tbGhg+bPbdpjJmWpQK9A3Z4W1CZaBnynxQAWG
         HGPE53f1MTsr/jkWDy4dP2T5XZkB1mIBUuYXJNB7t4tQdGEzwB7tudJUp6tGNqRzTMRl
         n01aEeaZsC1zdcW7UMzJBqbbkkqbHvFSOzIANgXzFdBbj77aETtqU5lFrzIUu6nqH5gs
         RC6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=67Fp7jURSSQWmmmi9atSt83tFHUKa11VhKEGAlqZA54=;
        b=byNcRmy3XFbAxP/6/dsmD8PtpmUfNbFgpoc/WIsWfuC9rh4H55eT6yITxOSj2t+fsD
         7K/tJO7Jw7dKNTStF+0wSzrUDFQrXeTEKo9+/l9k+sNPlWCnXwfeiwIaZfxvjrOjjAOA
         wMU44DsthtuF5ZaP52d/fOwFp54fsSKT20isu8+G+TUbI4WpA1twkvxLZlyXcfSWAjEG
         Ann+qUNwbeb1wX2KAXYxiicjh9WAFsf8c0c2AgZKYFR3V6Z9o7JlHIpkqNbrLPUN29Xo
         EHj97wF3fwwn70HmPgi+OiSCkiEKJampbVa9xORTlf8gosgI5bJQuGIt+idCaKlIfJux
         IgKA==
X-Gm-Message-State: AOAM531e+CXCs1ujSlYgS3dvGX3PpVMzQR2UBySYvhWugELqIOJ04Dyf
        68bbeKWQFKtQz75aNwqQDr0=
X-Google-Smtp-Source: ABdhPJxkxbI4tZaD9cOActQ5DvGWBiUTiV8paUqzWJIhRXPfMsR75YydrC0wuXNUo19Vga/N6+gvNg==
X-Received: by 2002:a5d:58c5:: with SMTP id o5mr45034773wrf.15.1641382464560;
        Wed, 05 Jan 2022 03:34:24 -0800 (PST)
Received: from [192.168.1.9] ([95.87.219.163])
        by smtp.gmail.com with ESMTPSA id f8sm43236922wry.16.2022.01.05.03.34.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Jan 2022 03:34:24 -0800 (PST)
Message-ID: <bb1741d5-600a-82a9-d8bc-91222400e129@gmail.com>
Date:   Wed, 5 Jan 2022 13:34:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [PATCH v2 1/2] kernel-shark: Move common APIs and definitions out
 to avoid duplication
Content-Language: en-US
To:     Hongzhan Chen <hongzhan.chen@intel.com>,
        linux-trace-devel@vger.kernel.org
References: <20211222064014.4471-1-hongzhan.chen@intel.com>
 <20211222064014.4471-2-hongzhan.chen@intel.com>
From:   Yordan Karadzhov <y.karadz@gmail.com>
In-Reply-To: <20211222064014.4471-2-hongzhan.chen@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 22.12.21 г. 8:40 ч., Hongzhan Chen wrote:
> To avoid code duplication, move some common APIs and definitions
> out to create new files and share with other plugins.
> 
> Signed-off-by: Hongzhan Chen <hongzhan.chen@intel.com>
> ---
>   src/plugins/CMakeLists.txt  |  2 +-
>   src/plugins/CommonSched.hpp | 99 +++++++++++++++++++++++++++++++++++++
>   src/plugins/SchedEvents.cpp | 87 +-------------------------------
>   src/plugins/common_sched.c  | 37 ++++++++++++++
>   src/plugins/common_sched.h  | 50 +++++++++++++++++++
>   src/plugins/sched_events.c  | 37 +-------------
>   src/plugins/sched_events.h  | 12 ++---
>   7 files changed, 192 insertions(+), 132 deletions(-)
>   create mode 100644 src/plugins/CommonSched.hpp
>   create mode 100644 src/plugins/common_sched.c
>   create mode 100644 src/plugins/common_sched.h
> 
> diff --git a/src/plugins/CMakeLists.txt b/src/plugins/CMakeLists.txt
> index 3e170fa..15d71d3 100644
> --- a/src/plugins/CMakeLists.txt
> +++ b/src/plugins/CMakeLists.txt
> @@ -41,7 +41,7 @@ set(PLUGIN_LIST "")
>   if (Qt5Widgets_FOUND AND TT_FONT_FILE)
>   
>       BUILD_GUI_PLUGIN(NAME sched_events
> -                     SOURCE sched_events.c SchedEvents.cpp)
> +                     SOURCE common_sched.c sched_events.c SchedEvents.cpp)
>       list(APPEND PLUGIN_LIST "sched_events")
>   
>       BUILD_GUI_PLUGIN(NAME event_field_plot
> diff --git a/src/plugins/CommonSched.hpp b/src/plugins/CommonSched.hpp
> new file mode 100644
> index 0000000..e1b88e4
> --- /dev/null
> +++ b/src/plugins/CommonSched.hpp
> @@ -0,0 +1,99 @@
> +/* SPDX-License-Identifier: LGPL-2.1 */
> +
> +/*
> + * Copyright (C) 2021 Intel Inc, Hongzhan Chen <hongzhan.chen@intel.com>
> + */
> +
> +/**
> + *  @file    CommonSched.hpp
> + *  @brief   Tools for plot common sched.
> + */
> +
> +// C++
> +#include <vector>
> +
> +// KernelShark
> +#include "libkshark.h"
> +#include "libkshark-plugin.h"
> +#include "KsPlotTools.hpp"
> +#include "KsPlugins.hpp"
> +#include "KsMainWindow.hpp"
> +
> +using namespace KsPlot;
> +
> +static KsMainWindow *ks_ptr;
> +
> +/**
> + * @brief Provide the plugin with a pointer to the KsMainWindow object (the GUI
> + * itself) such that the plugin can manipulate the GUI.
> + */
> +__hidden void *plugin_set_gui_ptr(void *gui_ptr)
> +{
> +	ks_ptr = static_cast<KsMainWindow *>(gui_ptr);
> +	return nullptr;
> +}
> +

I would prefer the global variable above and the function to set this global variable to stay within the plugin.
Also make sure that these global variable have different names in the two plugins.


> +/**
> + * This class represents the graphical element visualizing the latency between
> + * two events such as sched_waking and sched_switch events for common Linux
> + * kernel or cobalt_switch_contexts for Xenomai.
> + */
> +class LatencyBox : public Rectangle
> +{
> +	/** On double click do. */
> +	void _doubleClick() const override
> +	{
> +		ks_ptr->markEntry(_data[1]->entry, DualMarkerState::B);
> +		ks_ptr->markEntry(_data[0]->entry, DualMarkerState::A);
> +	}
> +
So, here comes the problem of depending on some KS GUI definitions that are not available in KsPlugins.cpp/hpp.
This is a C++ code so let's do it the C++(OOP) way. In KsPlugins you will provide a generic (dummy) version of the 
double-click function

void _doubleClick() const override {}

all the rest is the same.

> +public:
> +	/** The trace record data that corresponds to this LatencyBox. */
> +	std::vector<kshark_data_field_int64 *>	_data;
> +
> +	/**
> +	 * @brief Distance between the click and the shape. Used to decide if
> +	 *	  the double click action must be executed.
> +	 *
> +	 * @param x: X coordinate of the click.
> +	 * @param y: Y coordinate of the click.
> +	 *
> +	 * @returns If the click is inside the box, the distance is zero.
> +	 *	    Otherwise infinity.
> +	 */
> +	double distance(int x, int y) const override
> +	{
> +		if (x < pointX(0) || x > pointX(2))
> +			return std::numeric_limits<double>::max();
> +
> +		if (y < pointY(0) || y > pointY(1))
> +			return std::numeric_limits<double>::max();
> +
> +		return 0;
> +	}
> +};
> +
> +static PlotObject *makeShape(std::vector<const Graph *> graph,
> +			     std::vector<int> bins,
> +			     std::vector<kshark_data_field_int64 *> data,
> +			     Color col, float size)
> +{
> +	LatencyBox *rec = new LatencyBox;

This function can also be in KsPlugins.hpp, if you change the definition to something like this

template<class T> KsPlot::PlotObject *
makeLatencyBox(std::vector<const KsPlot::Graph *> graph,
	       std::vector<int> bins,
	       std::vector<kshark_data_field_int64 *> data,
	       KsPlot::Color col, float size)
{
	LatencyBox *rec = new T;

> +	rec->_data = data;
> +
> +	Point p0 = graph[0]->bin(bins[0])._base;
> +	Point p1 = graph[0]->bin(bins[1])._base;
> +	int height = graph[0]->height() * .3;
> +
> +	rec->setFill(false);
> +	rec->setPoint(0, p0.x() - 1, p0.y() - height);
> +	rec->setPoint(1, p0.x() - 1, p0.y() - 1);
> +
> +	rec->setPoint(3, p1.x() - 1, p1.y() - height);
> +	rec->setPoint(2, p1.x() - 1, p1.y() - 1);
> +
> +	rec->_size = size;
> +	rec->_color = col;
> +
> +	return rec;
> +}
> diff --git a/src/plugins/SchedEvents.cpp b/src/plugins/SchedEvents.cpp
> index b73e45f..b0fb29c 100644
> --- a/src/plugins/SchedEvents.cpp
> +++ b/src/plugins/SchedEvents.cpp
> @@ -11,94 +11,9 @@
>    *	     preempted by another task.
>    */
>   
> -// C++
> -#include <vector>
> -
>   // KernelShark
> -#include "libkshark.h"
> -#include "libkshark-plugin.h"
>   #include "plugins/sched_events.h"
> -#include "KsPlotTools.hpp"
> -#include "KsPlugins.hpp"
> -#include "KsMainWindow.hpp"
> -
> -using namespace KsPlot;
> -
> -static KsMainWindow *ks_ptr;
> -
> -/**
> - * @brief Provide the plugin with a pointer to the KsMainWindow object (the GUI
> - * itself) such that the plugin can manipulate the GUI.
> - */
> -__hidden void *plugin_set_gui_ptr(void *gui_ptr)
> -{
> -	ks_ptr = static_cast<KsMainWindow *>(gui_ptr);
> -	return nullptr;
> -}
> -
> -/**
> - * This class represents the graphical element visualizing the latency between
> - *  sched_waking and sched_switch events.
> - */
> -class LatencyBox : public Rectangle
> -{
> -	/** On double click do. */
> -	void _doubleClick() const override
> -	{
> -		ks_ptr->markEntry(_data[1]->entry, DualMarkerState::B);
> -		ks_ptr->markEntry(_data[0]->entry, DualMarkerState::A);
> -	}
> -
> -public:
> -	/** The trace record data that corresponds to this LatencyBox. */
> -	std::vector<kshark_data_field_int64 *>	_data;
> -
> -	/**
> -	 * @brief Distance between the click and the shape. Used to decide if
> -	 *	  the double click action must be executed.
> -	 *
> -	 * @param x: X coordinate of the click.
> -	 * @param y: Y coordinate of the click.
> -	 *
> -	 * @returns If the click is inside the box, the distance is zero.
> -	 *	    Otherwise infinity.
> -	 */
> -	double distance(int x, int y) const override
> -	{
> -		if (x < pointX(0) || x > pointX(2))
> -			return std::numeric_limits<double>::max();
> -
> -		if (y < pointY(0) || y > pointY(1))
> -			return std::numeric_limits<double>::max();
> -
> -		return 0;
> -	}
> -};
> -

Here you will have a child class that implements only the double-click function

class SchedLatencyBox : public LatencyBox
{
	/** On double click do. */
	void _doubleClick() const override
	{
		ks_ptr->markEntry(_data[1]->entry, DualMarkerState::B);
		ks_ptr->markEntry(_data[0]->entry, DualMarkerState::A);
	}
};

Again, make sure that the child classes have different names in the two plugins. This will prevent any funny things that 
can potentially happen during linking.

> -static PlotObject *makeShape(std::vector<const Graph *> graph,
> -			     std::vector<int> bins,
> -			     std::vector<kshark_data_field_int64 *> data,
> -			     Color col, float size)
> -{
> -	LatencyBox *rec = new LatencyBox;
> -	rec->_data = data;
> -
> -	Point p0 = graph[0]->bin(bins[0])._base;
> -	Point p1 = graph[0]->bin(bins[1])._base;
> -	int height = graph[0]->height() * .3;
> -
> -	rec->setFill(false);
> -	rec->setPoint(0, p0.x() - 1, p0.y() - height);
> -	rec->setPoint(1, p0.x() - 1, p0.y() - 1);
> -
> -	rec->setPoint(3, p1.x() - 1, p1.y() - height);
> -	rec->setPoint(2, p1.x() - 1, p1.y() - 1);
> -
> -	rec->_size = size;
> -	rec->_color = col;
> -
> -	return rec;
> -};

and you don't need a local definition of makeShape. You can use makeLatencyBox<SchedLatencyBox>

Note that I haven't tested this at all, so do not copy-paste my code blindly.


> +#include "plugins/CommonSched.hpp"
>   
>   /*
>    * Ideally, the sched_switch has to be the last trace event recorded before the
> diff --git a/src/plugins/common_sched.c b/src/plugins/common_sched.c
> new file mode 100644
> index 0000000..446adc8
> --- /dev/null
> +++ b/src/plugins/common_sched.c
> @@ -0,0 +1,37 @@
> +// SPDX-License-Identifier: LGPL-2.1
> +
> +/*
> + * Copyright (C) 2021 Intel Inc, Hongzhan Chen <hongzhan.chen@intel.com>
> + */
> +
> +/**
> + *  @file    common_sched.c
> + *  @brief
> + */
> +
> +// KernelShark
> +#include "plugins/common_sched.h"
> +
> +void plugin_sched_set_pid(ks_num_field_t *field,
> +				 tep_num_field_t pid)
> +{
> +	*field &= ~PID_MASK;
> +	*field = pid & PID_MASK;
> +}
> +
> +/**
> + * @brief Retrieve the PID value from the data field stored in the
> + *	  kshark_data_container object.
> + *
> + * @param field: Input location for the data field.
> + */
> +__hidden int plugin_sched_get_pid(ks_num_field_t field)
> +{
> +	return field & PID_MASK;
> +}
> +

No need to have this file. All functions above can stay in the header as 'static inline'
the one below must stay within the plugin.

cheers,
Yordan

> +/** Initialize the control interface of the plugin. */
> +void *KSHARK_MENU_PLUGIN_INITIALIZER(void *gui_ptr)
> +{
> +	return plugin_set_gui_ptr(gui_ptr);
> +}
> diff --git a/src/plugins/common_sched.h b/src/plugins/common_sched.h
> new file mode 100644
> index 0000000..c504f3e
> --- /dev/null
> +++ b/src/plugins/common_sched.h
> @@ -0,0 +1,50 @@
> +/* SPDX-License-Identifier: LGPL-2.1 */
> +
> +/*
> + * Copyright (C) 2021 Intel Inc, Hongzhan Chen<hongzhan.chen@intel.com>
> + */
> +
> +/**
> + *  @file    common_sched.h
> + *  @brief   Plugin for common sched.
> + */
> +
> +#ifndef _KS_PLUGIN_COMMON_SCHED_H
> +#define _KS_PLUGIN_COMMON_SCHED_H
> +
> +// KernelShark
> +#include "libkshark-plugin.h"
> +
> +#ifdef __cplusplus
> +extern "C" {
> +#endif
> +
> +typedef unsigned long long tep_num_field_t;
> +
> +/** The type of the data field stored in the kshark_data_container object. */
> +typedef int64_t ks_num_field_t;
> +
> +#define PREV_STATE_SHIFT	((int) ((sizeof(ks_num_field_t) - 1) * 8))
> +
> +#define PREV_STATE_MASK		(((ks_num_field_t) 1 << 8) - 1)
> +
> +#define PID_MASK		(((ks_num_field_t) 1 << PREV_STATE_SHIFT) - 1)
> +
> +void plugin_sched_set_pid(ks_num_field_t *field,
> +				 tep_num_field_t pid);
> +
> +/**
> + * @brief Retrieve the PID value from the data field stored in the
> + *	  kshark_data_container object.
> + *
> + * @param field: Input location for the data field.
> + */
> +int plugin_sched_get_pid(ks_num_field_t field);
> +
> +void *plugin_set_gui_ptr(void *gui_ptr);
> +
> +#ifdef __cplusplus
> +}
> +#endif
> +
> +#endif
> diff --git a/src/plugins/sched_events.c b/src/plugins/sched_events.c
> index 198ed49..6add092 100644
> --- a/src/plugins/sched_events.c
> +++ b/src/plugins/sched_events.c
> @@ -17,41 +17,12 @@
>   #include <trace-cmd.h>
>   
>   // KernelShark
> +#include "plugins/common_sched.h"
>   #include "plugins/sched_events.h"
>   #include "libkshark-tepdata.h"
>   
>   /** Plugin context instance. */
>   
> -//! @cond Doxygen_Suppress
> -
> -typedef unsigned long long tep_num_field_t;
> -
> -#define PREV_STATE_SHIFT	((int) ((sizeof(ks_num_field_t) - 1) * 8))
> -
> -#define PREV_STATE_MASK		(((ks_num_field_t) 1 << 8) - 1)
> -
> -#define PID_MASK		(((ks_num_field_t) 1 << PREV_STATE_SHIFT) - 1)
> -
> -//! @endcond
> -
> -static void plugin_sched_set_pid(ks_num_field_t *field,
> -				 tep_num_field_t pid)
> -{
> -	*field &= ~PID_MASK;
> -	*field = pid & PID_MASK;
> -}
> -
> -/**
> - * @brief Retrieve the PID value from the data field stored in the
> - *	  kshark_data_container object.
> - *
> - * @param field: Input location for the data field.
> - */
> -__hidden int plugin_sched_get_pid(ks_num_field_t field)
> -{
> -	return field & PID_MASK;
> -}
> -
>   /* Use the most significant byte to store the value of "prev_state". */
>   static void plugin_sched_set_prev_state(ks_num_field_t *field,
>   					tep_num_field_t prev_state)
> @@ -230,9 +201,3 @@ int KSHARK_PLOT_PLUGIN_DEINITIALIZER(struct kshark_data_stream *stream)
>   
>   	return ret;
>   }
> -
> -/** Initialize the control interface of the plugin. */
> -void *KSHARK_MENU_PLUGIN_INITIALIZER(void *gui_ptr)
> -{
> -	return plugin_set_gui_ptr(gui_ptr);
> -}
> diff --git a/src/plugins/sched_events.h b/src/plugins/sched_events.h
> index 2c540fd..c2b0ff7 100644
> --- a/src/plugins/sched_events.h
> +++ b/src/plugins/sched_events.h
> @@ -9,12 +9,12 @@
>    *  @brief   Plugin for Sched events.
>    */
>   
> -#ifndef _KS_PLUGIN_SHED_H
> -#define _KS_PLUGIN_SHED_H
> +#ifndef _KS_PLUGIN_SCHED_H
> +#define _KS_PLUGIN_SCHED_H
>   
>   // KernelShark
>   #include "libkshark.h"
> -#include "libkshark-plugin.h"
> +#include "plugins/common_sched.h"
>   
>   #ifdef __cplusplus
>   extern "C" {
> @@ -55,18 +55,12 @@ struct plugin_sched_context {
>   
>   KS_DECLARE_PLUGIN_CONTEXT_METHODS(struct plugin_sched_context)
>   
> -/** The type of the data field stored in the kshark_data_container object. */
> -typedef int64_t ks_num_field_t;
> -
> -int plugin_sched_get_pid(ks_num_field_t field);
>   
>   int plugin_sched_get_prev_state(ks_num_field_t field);
>   
>   void plugin_draw(struct kshark_cpp_argv *argv, int sd, int pid,
>   		 int draw_action);
>   
> -void *plugin_set_gui_ptr(void *gui_ptr);
> -
>   #ifdef __cplusplus
>   }
>   #endif
> 
