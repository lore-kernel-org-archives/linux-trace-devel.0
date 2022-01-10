Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 152BCC433F5
	for <linux-trace-devel@archiver.kernel.org>; Mon, 10 Jan 2022 13:10:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229662AbiAJNKH (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 10 Jan 2022 08:10:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbiAJNKH (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 10 Jan 2022 08:10:07 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1605C06173F
        for <linux-trace-devel@vger.kernel.org>; Mon, 10 Jan 2022 05:10:06 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id c71so41789435edf.6
        for <linux-trace-devel@vger.kernel.org>; Mon, 10 Jan 2022 05:10:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=Udn9ppRplrPS9Bt8CUe7fBC2grkASKP1qlIkN0TEsAM=;
        b=M1jBUVPt+34N+K7NjxYp257McMmvIZW0w2MXNoBlGf+aXCTTKjb5lVH4DCNhq1XN9p
         LgA3S4pM8OFxyJAa/bD4UGCi/i3FN4fCcBVke7bvTQmeoT6lrH3k5mEsuSb009TxD0KR
         yv1NEuTlRyF8BpdXF3rEDPsbvvWUFR3af02nm84TdaNm82Ku0JN4Zpz68iwP227I18kw
         Qcz8O/bs8HQwXrO2ch4auUqGtxq7yPtOqEPj+LRMqJUxL0vFkxHoKXwWbwYbsPG0ixbH
         81WOwvy8J7/dGYwHIgFcTzUEvcS6mh1tl0lvEohWScP7gdhTWmqepFY49LeGOWeRzO6v
         sZrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Udn9ppRplrPS9Bt8CUe7fBC2grkASKP1qlIkN0TEsAM=;
        b=Gl0pbJevuLAwXX1SZH/yqY5jaoZgDbyDMm1B+oSC6B/XPwTHaa+6fm9ymHH4U2GeUF
         1qEBPizZw+O/OidENaKLcio+z91dB1yhuLh51mxFKO6JzNLMOjGbV7WuXEINKmcrYGTq
         jFM26dKt7QHZorjPmDyKi/LtXN8++NTPwkHx4J3BFzEbsZvo0P6YTWHTVNt+h7RhGHtW
         x8VStdECmhhjQy0VD/34RJ8/2vYskS9YzZJMBdJV5hd97xDWfMD1Y14t+kjxefpka3/9
         gV22O9WwIG5yAO7LakInmsb+DyTHo8BtIxeu7/0BDbhMsZaLfMBdEaG9XZrWcMSOMOA7
         VCrQ==
X-Gm-Message-State: AOAM532RUTlcIJYTQq05KteMuIqhDb2ueYPFym5YoVkc1qxTexPt3Sfc
        lbF/s3a6yG050qsIMtNHUPzXG1CbQC0=
X-Google-Smtp-Source: ABdhPJwwMoEfj2jsNv5yr6FqCAt2OYdo7jeBeSfTqAGJwrV7aUF4E8FM6Ql7JmXcsPXp/TpmhLQH5g==
X-Received: by 2002:a05:6402:348b:: with SMTP id v11mr70666091edc.309.1641820205198;
        Mon, 10 Jan 2022 05:10:05 -0800 (PST)
Received: from [192.168.1.9] ([95.87.219.163])
        by smtp.gmail.com with ESMTPSA id x20sm3520487edd.28.2022.01.10.05.10.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Jan 2022 05:10:04 -0800 (PST)
Message-ID: <93580097-5496-5373-484b-322fc407c61a@gmail.com>
Date:   Mon, 10 Jan 2022 15:10:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [PATCH V4 2/3] kernel-shark: Move common APIs and definitions out
 to avoid duplication
Content-Language: en-US
To:     Hongzhan Chen <hongzhan.chen@intel.com>,
        linux-trace-devel@vger.kernel.org
References: <20220110042518.9376-1-hongzhan.chen@intel.com>
 <20220110042518.9376-2-hongzhan.chen@intel.com>
From:   Yordan Karadzhov <y.karadz@gmail.com>
In-Reply-To: <20220110042518.9376-2-hongzhan.chen@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi Hongzhan,

This patch breaks the build on my machine.
More comments below.

On 10.01.22 г. 6:25 ч., Hongzhan Chen wrote:
> To avoid code duplication, move some common APIs and definitions
> out from plugin SchedEvent to share with other plugins.
> 
> Signed-off-by: Hongzhan Chen <hongzhan.chen@intel.com>
> 
> diff --git a/src/KsPlugins.cpp b/src/KsPlugins.cpp
> index ad9f478..a288018 100644
> --- a/src/KsPlugins.cpp
> +++ b/src/KsPlugins.cpp

In this file we have a missing include. We need
#include <limits>

> @@ -414,3 +414,24 @@ void eventFieldIntervalPlot(KsCppArgV *argvCpp,
>   			  << exc.what() << std::endl;
>   	}
>   }
> +
> +/**
> + * @brief Distance between the click and the shape. Used to decide if
> + *	  the double click action must be executed.
> + *
> + * @param x: X coordinate of the click.
> + * @param y: Y coordinate of the click.
> + *
> + * @returns If the click is inside the box, the distance is zero.
> + *	    Otherwise infinity.
> + */
> +double LatencyBox::distance(int x, int y) const
> +{
> +	if (x < pointX(0) || x > pointX(2))
> +		return std::numeric_limits<double>::max();
> +
> +	if (y < pointY(0) || y > pointY(1))
> +		return std::numeric_limits<double>::max();
> +
> +	return 0;
> +}
> diff --git a/src/KsPlugins.hpp b/src/KsPlugins.hpp
> index d41d094..5288f57 100644
> --- a/src/KsPlugins.hpp
> +++ b/src/KsPlugins.hpp
> @@ -13,6 +13,7 @@
>   #define _KS_PLUGINS_H
>   
>   // C++
> +#include <vector>
>   #include <functional>
>   
>   // KernelShark
> @@ -101,4 +102,57 @@ void eventFieldIntervalPlot(KsCppArgV *argvCpp,
>   			    KsPlot::Color col,
>   			    float size);
>   
> +/**
> + * This class represents the graphical element visualizing the latency between
> + * two events such as sched_waking and sched_switch events for common Linux
> + * kernel or cobalt_switch_contexts for Xenomai.
> + */
> +class LatencyBox : public KsPlot::Rectangle
> +{
> +	/** On double click do. */
> +	void _doubleClick() const override {}
> +
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
	The documentation of the function must be provided above the implementation (in KsPlugins.cpp).
	No need to have a second copy here.

> +	double distance(int x, int y) const override;
> +};
> +
> +template<class T> KsPlot::PlotObject *
> +makeLatencyBox(std::vector<const KsPlot::Graph *> graph,
> +			     std::vector<int> bins,
> +			     std::vector<kshark_data_field_int64 *> data,
> +			     KsPlot::Color col, float size)
This function needs documentation. Also please align the indentation of the parameters.
> +{
> +	LatencyBox *rec = new T;
> +	rec->_data = data;
> +
> +	KsPlot::Point p0 = graph[0]->bin(bins[0])._base;
> +	KsPlot::Point p1 = graph[0]->bin(bins[1])._base;
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
> +
>   #endif
> diff --git a/src/plugins/SchedEvents.cpp b/src/plugins/SchedEvents.cpp
> index b73e45f..9119998 100644
> --- a/src/plugins/SchedEvents.cpp
> +++ b/src/plugins/SchedEvents.cpp
> @@ -11,9 +11,6 @@
>    *	     preempted by another task.
>    */
>   
> -// C++
> -#include <vector>
> -
>   // KernelShark
>   #include "libkshark.h"
>   #include "libkshark-plugin.h"
> @@ -24,7 +21,7 @@
>   
>   using namespace KsPlot;
>   
> -static KsMainWindow *ks_ptr;
> +static KsMainWindow *ks4sched_ptr;
>   
>   /**
>    * @brief Provide the plugin with a pointer to the KsMainWindow object (the GUI
> @@ -32,72 +29,24 @@ static KsMainWindow *ks_ptr;
>    */
>   __hidden void *plugin_set_gui_ptr(void *gui_ptr)
>   {
> -	ks_ptr = static_cast<KsMainWindow *>(gui_ptr);
> +	ks4sched_ptr = static_cast<KsMainWindow *>(gui_ptr);
>   	return nullptr;
>   }
>   
>   /**
> - * This class represents the graphical element visualizing the latency between
> - *  sched_waking and sched_switch events.
> + * This child class represents the graphical element visualizing the latency
> + * between sched_waking and sched_switch events. It is defined to re-implement
> + * the handler for double-click.
>    */
> -class LatencyBox : public Rectangle
> +class SchedLatencyBox : public LatencyBox
>   {
>   	/** On double click do. */
>   	void _doubleClick() const override
>   	{
> -		ks_ptr->markEntry(_data[1]->entry, DualMarkerState::B);
> -		ks_ptr->markEntry(_data[0]->entry, DualMarkerState::A);
> +		ks4sched_ptr->markEntry(_data[1]->entry, DualMarkerState::B);
> +		ks4sched_ptr->markEntry(_data[0]->entry, DualMarkerState::A);
>   	}
>   
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
>   };
>   
>   /*
> @@ -191,14 +140,14 @@ __hidden void plugin_draw(kshark_cpp_argv *argv_c,
>   	eventFieldIntervalPlot(argvCpp,
>   			       plugin_ctx->sw_data, checkFieldSW,
>   			       plugin_ctx->ss_data, checkEntryPid,
> -			       makeShape,
> +			       makeLatencyBox<SchedLatencyBox>,
>   			       {0, 255, 0}, // Green
>   			       -1);         // Default size
>   
>   	eventFieldIntervalPlot(argvCpp,
>   			       plugin_ctx->ss_data, checkFieldSS,
>   			       plugin_ctx->ss_data, checkEntryPid,
> -			       makeShape,
> +			       makeLatencyBox<SchedLatencyBox>,
>   			       {255, 0, 0}, // Red
>   			       -1);         // Default size
>   }
> diff --git a/src/plugins/common_sched.h b/src/plugins/common_sched.h
> new file mode 100644
> index 0000000..40f6532
> --- /dev/null
> +++ b/src/plugins/common_sched.h
> @@ -0,0 +1,53 @@
> +/* SPDX-License-Identifier: LGPL-2.1 */
> +
> +/*
> + * Copyright (C) 2018 VMware Inc, Yordan Karadzhov (VMware) <y.karadz@gmail.com>
> + *               2021 Intel Inc, Hongzhan Chen <hongzhan.chen@intel.com>
> + */
> +
> +/**
> + *  @file    common_sched.h
> + *  @brief   Common definitions for sched plugins.
> + */
> +
> +#ifndef _KS_PLUGIN_COMMON_SCHED_H
> +#define _KS_PLUGIN_COMMON_SCHED_H
> +
> +#ifdef __cplusplus
> +extern "C" {
> +#endif
> +

We need this new type (below) to be documented, because it is being used by the parameters of the functions. Add 
something like this:
/** The type of the numerical data field used by the 'tep' APIs. */
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
We need documentation for those 3 definitions as well as for the function below.

> +static inline void plugin_sched_set_pid(ks_num_field_t *field,
> +				 tep_num_field_t pid)
> +{
> +	*field &= ~PID_MASK;
> +	*field |= pid & PID_MASK;
> +}
> +
> +/**
> + * @brief Retrieve the PID value from the data field stored in the
> + *	  kshark_data_container object.
> + *
> + * @param field: Input location for the data field.
> + */
> +static inline int plugin_sched_get_pid(ks_num_field_t field)
> +{
> +	return field & PID_MASK;
> +}
> +
> +#ifdef __cplusplus
> +}
> +#endif
> +
> +#endif
> diff --git a/src/plugins/sched_events.c b/src/plugins/sched_events.c
> index 198ed49..3bb9bc2 100644
> --- a/src/plugins/sched_events.c
> +++ b/src/plugins/sched_events.c
> @@ -22,36 +22,6 @@
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
> diff --git a/src/plugins/sched_events.h b/src/plugins/sched_events.h
> index a2ba4b4..1032075 100644
> --- a/src/plugins/sched_events.h
> +++ b/src/plugins/sched_events.h
> @@ -15,6 +15,7 @@
>   // KernelShark
>   #include "libkshark.h"
>   #include "libkshark-plugin.h"
> +#include "plugins/common_sched.h"
>   
>   #ifdef __cplusplus
>   extern "C" {
> @@ -55,10 +56,6 @@ struct plugin_sched_context {
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
> 

Before sending the next version, please make sure that the code builds without any errors or warnings, including the 
building of the Doxygen documentation. If you don't know how to build the documentation, checkout the instructions in 
README.

Looking forward to see the final version of the patch.

Thanks!
Yordan
