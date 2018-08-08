Return-Path: <SRS0=PkBc=KX=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:34924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726111AbeHHDif (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 7 Aug 2018 23:38:35 -0400
Date: Tue, 7 Aug 2018 21:21:26 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc: linux-trace-devel@vger.kernel.org,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Subject: Re: [PATCH 2/2] kernel-shark-qt: Add Json I/O for filter
 configurations.
Message-ID: <20180807212126.0fe0fbe7@gandalf.local.home>
In-Reply-To: <20180807160013.11537-2-y.karadz@gmail.com>
References: <20180807160013.11537-1-y.karadz@gmail.com>
        <20180807160013.11537-2-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Tue,  7 Aug 2018 19:00:13 +0300
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> Add to the C API of KernelShark instruments for saving/loading of
> filter configuration to/from Json files.
> 
> Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
> ---
>  kernel-shark-qt/src/CMakeLists.txt   |   1 +
>  kernel-shark-qt/src/libkshark-json.c | 601 +++++++++++++++++++++++++++
>  kernel-shark-qt/src/libkshark.h      |  49 +++
>  3 files changed, 651 insertions(+)
>  create mode 100644 kernel-shark-qt/src/libkshark-json.c
> 
> diff --git a/kernel-shark-qt/src/CMakeLists.txt b/kernel-shark-qt/src/CMakeLists.txt
> index ea5dbda..b3de765 100644
> --- a/kernel-shark-qt/src/CMakeLists.txt
> +++ b/kernel-shark-qt/src/CMakeLists.txt
> @@ -2,6 +2,7 @@ message("\n src ...")
>  
>  message(STATUS "libkshark")
>  add_library(kshark SHARED libkshark.c
> +                          libkshark-json.c
>                            libkshark-model.c
>                            libkshark-collection.c)
>  
> diff --git a/kernel-shark-qt/src/libkshark-json.c b/kernel-shark-qt/src/libkshark-json.c
> new file mode 100644
> index 0000000..d06488e
> --- /dev/null
> +++ b/kernel-shark-qt/src/libkshark-json.c
> @@ -0,0 +1,601 @@
> +// SPDX-License-Identifier: LGPL-2.1
> +
> +/*
> + * Copyright (C) 2018 VMware Inc, Yordan Karadzhov <y.karadz@gmail.com>
> + */
> +
> + /**
> +  *  @file    libkshark-json.c
> +  *  @brief   Json Confoguration I/O.
> +  */
> +
> +// C
> +/** Use GNU C Library. */
> +#define _GNU_SOURCE
> +#include <stdio.h>
> +
> +// KernelShark
> +#include "libkshark.h"
> +
> +/**
> + * @brief Create an empty Json document and set its type description.
> + *
> + * @param type: String describing the type of the document,
> + *		e.g. "kshark.record.config" or "kshark.filter.config".
> + *
> + * @returns json_object instance. Use json_object_put() to free the object.

I wonder if we should add handlers like:

	kshark_config_free(struct json_object *jobj);

and call that instead? Perhaps even create our own object that may
contain extra state that the json object does not, and return that?


> + */
> +struct json_object *kshark_config_alloc(const char *type)
> +{
> +	json_object *jobj, *jtype;
> +
> +	jobj = json_object_new_object();
> +	jtype = json_object_new_string(type);
> +
> +	if (!jobj || !jtype)
> +		goto fail;
> +
> +	/* Set the type of this Json document. */
> +	json_object_object_add(jobj, "type", jtype);
> +
> +	return jobj;
> +
> + fail:
> +	fprintf(stderr, "Failed to allocate memory for json_object.\n");
> +	json_object_put(jobj);
> +	json_object_put(jtype);
> +
> +	return NULL;
> +}
> +
> +/**
> + * @brief Create an empty Record Configuration document. The type description
> + *	  is set to "kshark.record.config".
> + *
> + * @returns json_object instance. Use json_object_put() to free the object.
> + */
> +struct json_object *kshark_record_config_alloc()
> +{
> +	return kshark_config_alloc("kshark.record.config");
> +}
> +
> +/**
> + * @brief Create an empty Filter Configuration document. The type description
> + *	  is set to "kshark.filter.config".
> + *
> + * @returns json_object instance. Use json_object_put() to free the object.
> + */
> +struct json_object *kshark_filter_config_alloc()
> +{
> +	return kshark_config_alloc("kshark.filter.config");;
> +}
> +
> +/**
> + * @brief Record the current configuration of an Event Id filter into a Json
> + *	  document.
> + *
> + * @param pevt: Input location for the Page event.
> + * @param filter: Input location for an Id filter.
> + * @param filter_name: The name of the filter to show up in the Json document.
> + * @param jobj: Input location for the json_object instance.
> + */
> +void kshark_event_filter_to_json(struct pevent *pevt,

Please call "struct pevent" variables "pevent". Need to stay
consistent. Ideally, we should pick a single name for types of data
structures. This will be useful when we rename pevent to something else
as well.


> +				 struct tracecmd_filter_id *filter,
> +				 const char *filter_name,
> +				 struct json_object *jobj)
> +{
> +	json_object *jfilter_data, *jevent, *jsystem, *jname;
> +	int i, evt, *ids;
> +	char *temp;
> +
> +	/* Get the array of Ids to be fitered. */
> +	ids = tracecmd_filter_ids(filter);

ids needs to be freed. And tracecmd_filter_ids() needs documentation
describing it :-/  (that's my fault, hmm Tzvetomir could fix this ;-).

It also needs to be checked for NULL.

> +
> +	/* Create a Json array and fill the Id values into it. */
> +	jfilter_data = json_object_new_array();
> +	if (!jfilter_data)
> +		goto fail;
> +
> +	for (i = 0; i < filter->count; ++i) {
> +		for (evt = 0; evt < pevt->nr_events; ++evt) {
> +			if (pevt->events[evt]->id == ids[i]) {
> +				jevent = json_object_new_object();
> +
> +				temp = pevt->events[evt]->system;
> +				jsystem = json_object_new_string(temp);
> +
> +				temp = pevt->events[evt]->name;
> +				jname = json_object_new_string(temp);
> +
> +				if (!jevent || !jsystem || !jname)
> +					goto fail;
> +
> +				json_object_object_add(jevent, "system",
> +							       jsystem);
> +
> +				json_object_object_add(jevent, "name",
> +							       jname);
> +
> +				json_object_array_add(jfilter_data, jevent);
> +
> +				break;
> +			}
> +		}
> +	}
> +
> +	/* Add the array of Ids to the filter config document. */
> +	json_object_object_add(jobj, filter_name, jfilter_data);
> +
> +	return;
> +
> + fail:
> +	fprintf(stderr, "Failed to allocate memory for json_object.\n");
> +	json_object_put(jfilter_data);
> +	json_object_put(jevent);
> +	json_object_put(jsystem);
> +	json_object_put(jname);
> +}
> +
> +/**
> + * @brief Load from Json document the configuration of an Event Id filter.
> + *
> + * @param pevt: Input location for the Page event.
> + * @param filter: Input location for an Id filter.
> + * @param filter_name: The name of the filter as showing up in the Json
> + *	               document.
> + * @param jobj: Input location for the json_object instance.
> + *
> + * @returns True, if a filter has been loaded. If the filter configuration
> + *	    document contains no data for this particular filter or in a case
> + *	    of an error, the function returns False.
> + */
> +bool kshark_event_filter_from_json(struct pevent *pevt,
> +				   struct tracecmd_filter_id *filter,
> +				   const char *filter_name,
> +				   struct json_object *jobj)
> +{
> +	json_object *jfilter, *jevent, *jsystem, *jname;
> +	const char *system_str, *name_str;
> +	struct event_format *event;
> +	int i, length;
> +
> +	/*
> +	 * Use the name of the filter to find the array of events associated
> +	 * with this filter. Notice that the filter config document may
> +	 * contain no data for this particular filter.
> +	 */
> +	json_object_object_get_ex(jobj, filter_name, &jfilter);

Shouldn't you add a check of the return value of the above. Looking at
the documentation:

  http://json-c.github.io/json-c/json-c-0.12/doc/html/json__object_8h.html#af3f38b3395b1af8e9d3ac73818c3a936

You could have:

	ret = json_object_object_get_ex(jobj, filter_name, &jfilter);

	if (!ret || json_object_get_type(jfilter) != ...


> +	if (!jfilter || json_object_get_type(jfilter) != json_type_array)
> +		return false;
> +
> +	/* Set the filter. */
> +	length = json_object_array_length(jfilter);
> +	for (i = 0; i < length; ++i) {
> +		jevent = json_object_array_get_idx(jfilter, i);
> +
> +		json_object_object_get_ex(jevent, "system", &jsystem);
> +		json_object_object_get_ex(jevent, "name", &jname);

Same here.

> +		if (!jsystem || !jname)
> +			goto fail;
> +
> +		system_str = json_object_get_string(jsystem);
> +		name_str = json_object_get_string(jname);
> +
> +		event = pevent_find_event_by_name(pevt, system_str, name_str);
> +		if (!event)
> +			goto fail;
> +
> +		tracecmd_filter_id_add(filter, event->id);
> +	}
> +
> +	return true;
> +
> + fail:
> +	fprintf(stderr, "Failed to load event filter from json_object.\n");
> +	return false;
> +}
> +
> +static void kshark_task_filter_to_json(struct tracecmd_filter_id *filter,
> +				       const char *filter_name,
> +				       struct json_object *jobj)
> +{
> +	json_object *jfilter_data, *jpid;
> +	int i, *ids;
> +
> +	/* Get the array of Ids to be fitered. */
> +	ids = tracecmd_filter_ids(filter);

Again, ids need to be freed.

> +
> +	/* Create a Json array and fill the Id values into it. */
> +	jfilter_data = json_object_new_array();
> +	if (!jfilter_data)

Hmm, can json_object_put() take a NULL pointer?

> +		goto fail;
> +
> +	for (i = 0; i < filter->count; ++i) {
> +		jpid = json_object_new_int(ids[i]);
> +		if (!jpid)
> +			goto fail;
> +
> +		json_object_array_add(jfilter_data, jpid);
> +	}
> +
> +	/* Add the array of Ids to the filter config document. */
> +	json_object_object_add(jobj, filter_name, jfilter_data);
> +
> +	return;
> +
> + fail:
> +	fprintf(stderr, "Failed to allocate memory for json_object.\n");
> +	json_object_put(jfilter_data);
> +	json_object_put(jpid);
> +}
> +
> +static bool kshark_task_filter_from_json(struct tracecmd_filter_id *filter,
> +					 const char *filter_name,
> +					 struct json_object *jobj)
> +{
> +	json_object *jfilter, *jpid;
> +	int i, length;
> +
> +	/*
> +	 * Use the name of the filter to find the array of events associated
> +	 * with this filter. Notice that the filter config document may
> +	 * contain no data for this particular filter.
> +	 */
> +	json_object_object_get_ex(jobj, filter_name, &jfilter);
> +	if (!jfilter || json_object_get_type(jfilter) != json_type_array)
> +		return false;
> +
> +	/* Set the filter. */
> +	length = json_object_array_length(jfilter);
> +	for (i = 0; i < length; ++i) {
> +		jpid = json_object_array_get_idx(jfilter, i);
> +		if (!jpid)
> +			goto fail;
> +
> +		tracecmd_filter_id_add(filter, json_object_get_int(jpid));
> +	}
> +
> +	return true;
> +
> + fail:
> +	fprintf(stderr, "Failed to load task filter from json_object.\n");
> +	return false;
> +}
> +
> +/**
> + * @brief Record the current configuration of the advanced filter into a Json
> + *	  document.
> + *
> + * @param kshark_ctx: Input location for session context pointer.
> + * @param jobj: Input location for the json_object instance.
> + */
> +void kshark_adv_filters_to_json(struct kshark_context *kshark_ctx,
> +				struct json_object *jobj)
> +{
> +	struct event_filter *adv_filter = kshark_ctx->advanced_event_filter;
> +	json_object *jfilter_data, *jevent, *jsystem, *jname, *jfilter;
> +	struct event_format **events;
> +	char *str;
> +	int i;
> +
> +	if (!kshark_ctx->advanced_event_filter->filters)

Should we also check if advanced_event_filter is NULL?

> +		return;
> +
> +	/* Create a Json array and fill the Id values into it. */
> +	jfilter_data = json_object_new_array();
> +	if (!jfilter_data)
> +		goto fail;
> +
> +	events = pevent_list_events(kshark_ctx->pevent, EVENT_SORT_SYSTEM);

events returned could be NULL. Need to check that.

(will review the rest tomorrow)

-- Steve

> +
> +	for (i = 0; events[i]; i++) {
> +		str = pevent_filter_make_string(adv_filter,
> +						events[i]->id);
> +		if (!str)
> +			continue;
> +
> +		jevent = json_object_new_object();
> +		jsystem = json_object_new_string(events[i]->system);
> +		jname = json_object_new_string(events[i]->name);
> +		jfilter = json_object_new_string(str);
> +		if (!jevent || !jsystem || !jname || !jfilter)
> +			goto fail;
> +
> +		json_object_object_add(jevent, "system", jsystem);
> +		json_object_object_add(jevent, "name", jname);
> +		json_object_object_add(jevent, "condition", jfilter);
> +
> +		json_object_array_add(jfilter_data, jevent);
> +	}
> +
> +	/* Add the array of advanced filters to the filter config document. */
> +	json_object_object_add(jobj, "adv event filter", jfilter_data);
> +
> +	return;
> +
