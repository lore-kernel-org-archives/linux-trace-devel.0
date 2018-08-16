Return-Path: <SRS0=QeEN=K7=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:50874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726011AbeHPVwc (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 16 Aug 2018 17:52:32 -0400
Date: Thu, 16 Aug 2018 14:52:19 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc: linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v3 2/3] kernel-shark-qt: Add I/O for configuration data.
Message-ID: <20180816145219.7e91e435@gandalf.local.home>
In-Reply-To: <20180816150729.4680-2-y.karadz@gmail.com>
References: <20180816150729.4680-1-y.karadz@gmail.com>
        <20180816150729.4680-2-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Thu, 16 Aug 2018 18:07:28 +0300
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> diff --git a/kernel-shark-qt/src/libkshark-configio.c b/kernel-shark-qt/src/libkshark-configio.c
> new file mode 100644
> index 0000000..b54dc5a
> --- /dev/null
> +++ b/kernel-shark-qt/src/libkshark-configio.c
> @@ -0,0 +1,1453 @@
> +// SPDX-License-Identifier: LGPL-2.1
> +
> +/*
> + * Copyright (C) 2018 VMware Inc, Yordan Karadzhov <y.karadz@gmail.com>
> + */
> +
> + /**
> +  *  @file    libkshark-configio.c
> +  *  @brief   Json Configuration I/O.
> +  */
> +
> +// C
> +/** Use GNU C Library. */
> +#define _GNU_SOURCE
> +#include <stdio.h>
> +#include <sys/stat.h>
> +
> +// KernelShark
> +#include "libkshark.h"
> +#include "libkshark-model.h"
> +
> +static struct json_object *kshark_json_config_alloc(const char *type)
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
> + * @brief Allocate kshark_config_doc and set its format.
> + *
> + * @param format: Input location for the Configuration format identifier.
> + *		  Currently only Json and String formats are supported.
> + *
> + * @returns kshark_config_doc instance on success. Else NULL. Use

 s/on success. Else NULL/on success, otherwise NULL/

> + *	    free() to free the object.
> + */
> +struct kshark_config_doc *
> +kshark_config_alloc(enum kshark_config_formats format)
> +{
> +	struct kshark_config_doc *doc;
> +
> +	switch (format) {
> +	case KS_CONFIG_AUTO:
> +	case KS_CONFIG_JSON:
> +	case KS_CONFIG_STRING:
> +		doc = malloc(sizeof(*doc));
> +		if (!doc)
> +			goto fail;
> +
> +		doc->format = format;
> +		doc->conf_doc = NULL;
> +		return doc;
> +	default:
> +		fprintf(stderr, "Document format %d not supported\n",
> +		format);

Just fall through, no need for "goto fail".

> +		goto fail;
> +	}
> +

Add here:

	return NULL;

Otherwise you print the error in the default and also print the wrong
message below.

> + fail:
> +	fprintf(stderr, "Failed to allocate memory for kshark_config_doc.\n");
> +	return NULL;
> +}
> +

[..]


> +/**
> + * @brief Add a field to a KernelShark Configuration document.
> + *
> + * @param conf: Input location for the kshark_config_doc instance. Currently
> + *		only Json format is supported.
> + * @param key: The name of the field.
> + * @param val: Input location for the kshark_config_doc to be added. Currently
> + *	       only Json and String formats are supported. Pass KS_CONFIG_AUTO
> + *	       if you want "val" to have the same fornat as "conf". Upon
> + *	       calling this function, the ownership of "val" transfers to
> + *	       "conf".
> + */
> +void kshark_config_doc_add(struct kshark_config_doc *conf,
> +			   const char *key,
> +			   struct kshark_config_doc *val)
> +{
> +	struct json_object *jobj = NULL;
> +
> +	if (!conf || !val)
> +		return;
> +
> +	if (val->format == KS_CONFIG_AUTO)
> +		val->format = conf->format;
> +
> +	switch (conf->format) {
> +	case KS_CONFIG_JSON:
> +		switch (val->format) {
> +		case KS_CONFIG_JSON:
> +			json_object_object_add(conf->conf_doc, key,
> +					       val->conf_doc);
> +			break;
> +
> +		case KS_CONFIG_STRING:
> +			jobj = json_object_new_string(val->conf_doc);
> +			if (!jobj)
> +				goto fail;
> +
> +			json_object_object_add(conf->conf_doc, key, jobj);
> +			break;
> +
> +		default:
> +			fprintf(stderr, "Value format %d not supported\n",
> +			val->format);

Fix the indent of val->format);

> +			goto fail;
> +		}
> +
> +		free(val);
> +		break;
> +	default:
> +		fprintf(stderr, "Document format %d not supported\n",
> +		conf->format);

Here too.

> +		goto fail;
> +	}
> +
> +	return;
> +
> + fail:
> +	fprintf(stderr, "Failed to allocate memory for json_object.\n");
> +	json_object_put(jobj);
> +
> +	return;
> +}
> +
> +static bool get_jval(struct kshark_config_doc *conf,
> +		     const char *key, void **val)
> +{
> +	return json_object_object_get_ex(conf->conf_doc, key,
> +					 (json_object **) val);
> +}
> +
> +/**
> + * @brief Get the KernelShark Configuration document associate with a given
> + *	  field name.
> + *
> + * @param conf: Input location for the kshark_config_doc instance. Currently
> + *		only Json format is supported.
> + * @param key: The name of the field.
> + * @param val: Output location for the kshark_config_doc instance containing
> + *	       the field. Currently only Json and String formats are supported.
> + *
> + * @returns True, if the key exists. Else False.

	@returns True if the key exists, otherwise False.

> + */
> +bool kshark_config_doc_get(struct kshark_config_doc *conf,
> +			   const char *key,
> +			   struct kshark_config_doc *val)
> +{
> +	struct kshark_config_doc *tmp;
> +
> +	if (!conf || !val)
> +		return false;
> +
> +	if (val->format == KS_CONFIG_AUTO)
> +		val->format = conf->format;
> +
> +	switch (conf->format) {
> +	case KS_CONFIG_JSON:
> +		switch (val->format) {
> +		case KS_CONFIG_JSON:
> +			json_object_put(val->conf_doc);
> +			if (!get_jval(conf, key, &val->conf_doc))
> +				goto fail;
> +
> +			return true;
> +		case KS_CONFIG_STRING:
> +			tmp = kshark_config_alloc(KS_CONFIG_AUTO);
> +			if (!tmp)
> +				goto fail;
> +
> +			if (!get_jval(conf, key, &tmp->conf_doc))
> +				goto fail;
> +
> +			free(val->conf_doc);
> +			val->conf_doc =
> +				(char *) json_object_get_string(tmp->conf_doc);
> +			free(tmp);
> +
> +			return true;
> +		default:
> +			fprintf(stderr, "Value format %d not supported\n",
> +			val->format);

Indent issues here too.

> +			goto fail;
> +		}
> +
> +	default:
> +		fprintf(stderr, "Document format %d not supported\n",
> +		conf->format);

And here.

> +		goto fail;
> +	}
> +
> + fail:
> +	fprintf(stderr, "Failed to get config. document.\n");
> +	return false;
> +}
> +
> +/**
> + * @brief Create an empty Record Configuration document. The type description
> + *	  is set to "kshark.record.config".
> + *
> + * @returns kshark_config_doc instance. Use kshark_free_config_doc() to free
> + *	    the object.
> + */
> +struct kshark_config_doc *
> +kshark_record_config_new(enum kshark_config_formats format)
> +{
> +	return kshark_config_new("kshark.record.config", format);
> +}
> +
> +/**
> + * @brief Create an empty Filter Configuration document. The type description
> + *	  is set to "kshark.filter.config".
> + *
> + * @returns kshark_config_doc instance. Use kshark_free_config_doc() to free
> + *	    the object.
> + */
> +struct kshark_config_doc *
> +kshark_filter_config_new(enum kshark_config_formats format)
> +{
> +	return kshark_config_new("kshark.filter.config", format);
> +}
> +
> +/**
> + * @brief Create an empty Text Configuration document. The Text Configuration
> + *	  documents do not use type descriptions.
> + *
> + * @returns kshark_config_doc instance. Use free() to free the object.
> + */
> +struct kshark_config_doc *kshark_string_config_alloc()
> +{
> +	return kshark_config_alloc(KS_CONFIG_STRING);
> +}
> +
> +static void json_del_if_exist(struct json_object *jobj, const char *key)
> +{
> +	struct json_object *temp;
> +	if (json_object_object_get_ex(jobj, key, &temp))
> +	    json_object_object_del(jobj, key);
> +}
> +
> +
> +static bool kshark_json_type_check(struct json_object *jobj, const char *type)
> +{
> +	struct json_object *jtype;
> +	const char *type_str;
> +
> +	if (!json_object_object_get_ex(jobj, "type", &jtype))
> +		return false;
> +
> +	type_str = json_object_get_string(jtype);
> +	if (strcmp(type_str, type) != 0)
> +		return false;
> +
> +	return true;
> +}
> +
> +/**
> + * @brief Check the type of a Configuration document and compare with an
> + *	  expected value.
> + *
> + * @param conf: Input location for the kshark_config_doc instance.
> + * @param type: Input location for the expected value of the Configuration
> + *		document type, e.g. "kshark.record.config" or
> + *		"kshark.filter.config".

Oh, I forgot to ask...

Do you expect to have different "kshark.record" and kshark.filter"
options other than ".config"? If not, shouldn't it be:

	"kshark.config.record" and "kshark.config.filter" ?

That way we can do searches for all the configs in a json file by
searching for "kshark.config".


> + *
> + * @returns True, if the document has the expected type. Else false.

 @returns True if the document has the expected type, otherwise False.

> + */
> +bool kshark_type_check(struct kshark_config_doc *conf, const char *type)
> +{
> +	switch (conf->format) {
> +	case KS_CONFIG_JSON:
> +		return kshark_json_type_check(conf->conf_doc, type);
> +
> +	default:
> +		fprintf(stderr, "Document format %d not supported\n",
> +			conf->format);
> +		return false;
> +	}
> +}
> +
> +static bool kshark_trace_file_to_json(const char *file,
> +				      struct json_object *jobj)
> +{
> +	struct json_object *jfile_name, *jtime;
> +	struct stat st;
> +
> +	if (!file || !jobj)
> +		return false;
> +
> +	if (stat(file, &st) != 0) {
> +		fprintf(stderr, "Unable to find file %s\n", file);
> +		return false;
> +	}
> +
> +	jfile_name = json_object_new_string(file);
> +	jtime = json_object_new_int64(st.st_mtime);

BTW, are you saving the timestamp to make sure the trace.dat file is
the same? (assuming that the 'file' in question is trace.dat)

What if we want to use the same "session" for different trace.dat files?

> +
> +	if (!jfile_name || !jtime)
> +		goto fail;
> +
> +	json_object_object_add(jobj, "file", jfile_name);
> +	json_object_object_add(jobj, "time", jtime);
> +
> +	return true;
> +
> + fail:
> +	fprintf(stderr, "Failed to allocate memory for json_object.\n");
> +	json_object_put(jobj);
> +	json_object_put(jfile_name);
> +	json_object_put(jtime);
> +
> +	return false;
> +}
> +
> +/**
> + * @brief Record the name of a trace data file and its timestamp into a
> + *	  Configuration document.
> + *
> + * @param file: The name of the file.
> + * @param format: Input location for the Configuration format identifier.
> + *		  Currently only Json format is supported.
> + *
> + * @returns True, on success. Else False.

 returns True on success, otherwise False.

> + */
> +struct kshark_config_doc *
> +kshark_export_trace_file(const char *file,
> +			 enum kshark_config_formats format)
> +{
> +	/*  Create a new Configuration document. */
> +	struct kshark_config_doc *conf =
> +		kshark_config_new("kshark.data.config", format);
> +
> +	switch (format) {
> +	case KS_CONFIG_JSON:
> +		kshark_trace_file_to_json(file, conf->conf_doc);
> +		return conf;
> +
> +	default:
> +		fprintf(stderr, "Document format %d not supported\n",
> +			conf->format);
> +		return NULL;
> +	}
> +}
> +
> +static bool kshark_trace_file_from_json(const char **file,
> +					struct json_object *jobj)
> +{
> +	struct json_object *jfile_name, *jtime;
> +	const char *file_str;
> +	struct stat st;
> +	int64_t time;
> +
> +	if (!jobj)
> +		return false;
> +
> +	if (!kshark_json_type_check(jobj, "kshark.data.config") ||
> +	    !json_object_object_get_ex(jobj, "file", &jfile_name) ||
> +	    !json_object_object_get_ex(jobj, "time", &jtime)) {
> +		fprintf(stderr,
> +			"Failed to retrieve data file from json_object.\n");
> +		return false;
> +	}
> +
> +	file_str = json_object_get_string(jfile_name);
> +	time = json_object_get_int64(jtime);
> +
> +	if (stat(file_str, &st) != 0) {
> +		fprintf(stderr, "Unable to find file %s\n", file_str);
> +		return false;
> +	}
> +
> +	if (st.st_mtime != time) {
> +		fprintf(stderr,"Timestamp mismatch!\nFile %s", file_str);
> +		return false;
> +	}
> +
> +	*file = file_str;
> +
> +	return true;
> +}
> +
> +/**
> + * @brief Read the name of a trace data file and its timestamp from a
> + *	  Configuration document and check if such a file exists.
> + *	  If the file exists, open it.
> + *
> + * @param kshark_ctx: Input location for session context pointer.
> + * @param conf: Input location for the kshark_config_doc instance. Currently
> + *		only Json format is supported.
> + *
> + * @returns The name of the file on success. Else NULL.

	s/on success. Else/on success, otherwise/

There also needs to be a statement stating that "file" is an internal
element of @conf and should not be modified, and is undefined if @conf
is destroyed (freed).

> + */
> +const char* kshark_import_trace_file(struct kshark_context *kshark_ctx,
> +				     struct kshark_config_doc *conf)
> +{
> +	const char *file = NULL;
> +	switch (conf->format) {
> +	case KS_CONFIG_JSON:
> +		if (kshark_trace_file_from_json(&file, conf->conf_doc))
> +			kshark_open(kshark_ctx, file);
> +
> +		break;
> +
> +	default:
> +		fprintf(stderr, "Document format %d not supported\n",
> +			conf->format);
> +		return NULL;
> +	}
> +
> +	return file;
> +}
> +
> +static bool kshark_model_to_json(struct kshark_trace_histo *histo,
> +				 struct json_object *jobj)
> +{
> +	struct json_object *jrange, *jmin, *jmax, *jn_bins;
> +	if (!histo || !jobj)
> +		return false;
> +
> +	jrange = json_object_new_array();
> +
> +	jmin = json_object_new_int64(histo->min);
> +	jmax = json_object_new_int64(histo->max);
> +	jn_bins = json_object_new_int(histo->n_bins);
> +
> +	if (!jrange || !jmin || !jmax || !jn_bins)
> +		goto fail;
> +
> +	json_object_array_put_idx(jrange, 0, jmin);
> +	json_object_array_put_idx(jrange, 1, jmax);
> +
> +	json_object_object_add(jobj, "range", jrange);
> +	json_object_object_add(jobj, "bins", jn_bins);
> +
> +	return true;
> +
> + fail:
> +	fprintf(stderr, "Failed to allocate memory for json_object.\n");
> +	json_object_put(jobj);
> +	json_object_put(jrange);
> +	json_object_put(jmin);
> +	json_object_put(jmax);
> +	json_object_put(jn_bins);
> +
> +	return false;
> +}
> +
> +/**
> + * @brief Record the current configuration of the Vis. model into a
> + *	  Configuration document.
> + * Load the configuration of the Vis. model from a Configuration
> + *	  document.
> + *
> + * @param histo: Input location for the Vis. model descriptor.
> + * @param format: Input location for the kshark_config_doc instance. Currently
> + *		  only Json format is supported.
> + *
> + * @returns True, on success. Else False.

	@returns True on success, otherwise False.


> + */
> +struct kshark_config_doc *
> +kshark_export_model(struct kshark_trace_histo *histo,
> +		    enum kshark_config_formats format)
> +{
> +	/*  Create a new Configuration document. */
> +	struct kshark_config_doc *conf =
> +		kshark_config_new("kshark.model.config", format);
> +
> +	switch (format) {
> +	case KS_CONFIG_JSON:
> +		kshark_model_to_json(histo, conf->conf_doc);
> +		return conf;
> +
> +	default:
> +		fprintf(stderr, "Document format %d not supported\n",
> +			format);
> +		return NULL;
> +	}
> +}
> +
> +static bool kshark_model_from_json(struct kshark_trace_histo *histo,
> +				   struct json_object *jobj)
> +{
> +	struct json_object *jrange, *jmin, *jmax, *jn_bins;
> +	uint64_t min, max;
> +	int n_bins;
> +
> +	if (!histo || !jobj)
> +		return false;
> +
> +	if (!kshark_json_type_check(jobj, "kshark.model.config") ||
> +	    !json_object_object_get_ex(jobj, "range", &jrange) ||
> +	    !json_object_object_get_ex(jobj, "bins", &jn_bins) ||
> +	    json_object_get_type(jrange) != json_type_array ||
> +	    json_object_array_length(jrange) != 2)
> +		goto fail;
> +
> +	jmin = json_object_array_get_idx(jrange, 0);
> +	jmax = json_object_array_get_idx(jrange, 1);
> +	if (!jmin || !jmax)
> +		goto fail;
> +
> +	min = json_object_get_int64(jmin);
> +	max = json_object_get_int64(jmax);
> +	n_bins = json_object_get_int(jn_bins);
> +	ksmodel_set_bining(histo, n_bins, min, max);
> +
> +	if (histo->data && histo->data_size)
> +		ksmodel_fill(histo, histo->data, histo->data_size);
> +
> +	return true;
> +
> + fail:
> +	fprintf(stderr, "Failed to load event filter from json_object.\n");
> +	return false;
> +}
> +
> +/**
> + * @brief Load the configuration of the Vis. model from a Configuration
> + *	  document.
> + *
> + * @param histo: Input location for the Vis. model descriptor.
> + * @param conf: Input location for the kshark_config_doc instance. Currently
> + *		only Json format is supported.
> + *
> + * @returns True, if the model has been loaded. If the model configuration
> + *	    document contains no data or in a case of an error, the function
> + *	    returns False.
> + */
> +bool kshark_import_model(struct kshark_trace_histo *histo,
> +			 struct kshark_config_doc *conf)
> +{
> +	switch (conf->format) {
> +	case KS_CONFIG_JSON:
> +		return kshark_model_from_json(histo, conf->conf_doc);
> +
> +	default:
> +		fprintf(stderr, "Document format %d not supported\n",
> +			conf->format);
> +		return false;
> +	}
> +}
> +
> +static bool kshark_event_filter_to_json(struct pevent *pevent,
> +					struct tracecmd_filter_id *filter,
> +					const char *filter_name,
> +					struct json_object *jobj)
> +{
> +	json_object *jfilter_data, *jevent, *jsystem, *jname;
> +	int i, evt, *ids;
> +	char *temp;
> +
> +	/*
> +	 * If this Json document already contains a description of the filter,
> +	 * delete this description.
> +	 */
> +	json_del_if_exist(jobj, filter_name);
> +
> +	/* Get the array of Ids to be fitered. */
> +	ids = tracecmd_filter_ids(filter);
> +	if (!ids)
> +		return true;
> +
> +	/* Create a Json array and fill the Id values into it. */
> +	jfilter_data = json_object_new_array();
> +	if (!jfilter_data)
> +		goto fail;
> +
> +	for (i = 0; i < filter->count; ++i) {
> +		for (evt = 0; evt < pevent->nr_events; ++evt) {
> +			if (pevent->events[evt]->id == ids[i]) {
> +				jevent = json_object_new_object();
> +
> +				temp = pevent->events[evt]->system;
> +				jsystem = json_object_new_string(temp);
> +
> +				temp = pevent->events[evt]->name;
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
> +	free(ids);
> +
> +	/* Add the array of Ids to the filter config document. */
> +	json_object_object_add(jobj, filter_name, jfilter_data);
> +
> +	return true;
> +
> + fail:
> +	fprintf(stderr, "Failed to allocate memory for json_object.\n");
> +	json_object_put(jfilter_data);
> +	json_object_put(jevent);
> +	json_object_put(jsystem);
> +	json_object_put(jname);
> +	free(ids);
> +
> +	return false;
> +}
> +
> +/**
> + * @brief Record the current configuration of an Event Id filter into a
> + *	  Configuration document.
> + *
> + * @param pevent: Input location for the Page event.
> + * @param filter: Input location for an Id filter.
> + * @param filter_name: The name of the filter to show up in the Json document.
> + * @param conf: Input location for the kshark_config_doc instance. Currently
> + *		only Json format is supported.
> + *
> + * @returns True, on success or False in the case of an error.
> + */
> +bool kshark_export_event_filter(struct pevent *pevent,
> +				struct tracecmd_filter_id *filter,
> +				const char *filter_name,
> +				struct kshark_config_doc *conf)
> +{
> +	switch (conf->format) {
> +	case KS_CONFIG_JSON:
> +		return kshark_event_filter_to_json(pevent, filter,
> +						   filter_name,
> +						   conf->conf_doc);
> +
> +	default:
> +		fprintf(stderr, "Document format %d not supported\n",
> +			conf->format);
> +		return false;
> +	}
> +}
> +
> +static bool kshark_event_filter_from_json(struct pevent *pevent,
> +					  struct tracecmd_filter_id *filter,
> +					  const char *filter_name,
> +					  struct json_object *jobj)
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
> +	if (!json_object_object_get_ex(jobj, filter_name, &jfilter))
> +		return false;
> +
> +	if (!kshark_json_type_check(jobj, "kshark.filter.config") ||
> +	    json_object_get_type(jfilter) != json_type_array)
> +		goto fail;
> +
> +	/* Set the filter. */
> +	length = json_object_array_length(jfilter);
> +	for (i = 0; i < length; ++i) {
> +		jevent = json_object_array_get_idx(jfilter, i);
> +
> +		if (!json_object_object_get_ex(jevent, "system", &jsystem) ||
> +		    !json_object_object_get_ex(jevent, "name", &jname))
> +			goto fail;
> +
> +		system_str = json_object_get_string(jsystem);
> +		name_str = json_object_get_string(jname);
> +
> +		event = pevent_find_event_by_name(pevent, system_str, name_str);
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
> +/**
> + * @brief Load from Configuration document the configuration of an Event Id filter.
> + *
> + * @param pevent: Input location for the Page event.
> + * @param filter: Input location for an Id filter.
> + * @param filter_name: The name of the filter as showing up in the Config.
> + *	               document.
> + * @param conf: Input location for the kshark_config_doc instance. Currently
> + *		only Json format is supported.
> + *
> + * @returns True, if a filter has been loaded. If the filter configuration
> + *	    document contains no data for this particular filter or in a case
> + *	    of an error, the function returns False.
> + */
> +bool kshark_import_event_filter(struct pevent *pevent,
> +				struct tracecmd_filter_id *filter,
> +				const char *filter_name,
> +				struct kshark_config_doc *conf)
> +{
> +	switch (conf->format) {
> +	case KS_CONFIG_JSON:
> +		return kshark_event_filter_from_json(pevent, filter,
> +						     filter_name,
> +						     conf->conf_doc);
> +
> +	default:
> +		fprintf(stderr, "Document format %d not supported\n",
> +			conf->format);
> +		return false;
> +	}
> +}
> +
> +static bool kshark_task_filter_to_json(struct tracecmd_filter_id *filter,
> +				       const char *filter_name,
> +				       struct json_object *jobj)
> +{
> +	json_object *jfilter_data, *jpid;
> +	int i, *ids;
> +
> +	/*
> +	 * If this Json document already contains a description of the model,
> +	 * delete this description.
> +	 */
> +	json_del_if_exist(jobj, filter_name);
> +
> +	/* Get the array of Ids to be fitered. */
> +	ids = tracecmd_filter_ids(filter);
> +	if (!ids)
> +		return true;
> +
> +	/* Create a Json array and fill the Id values into it. */
> +	jfilter_data = json_object_new_array();
> +	if (!jfilter_data)
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
> +	free(ids);
> +
> +	/* Add the array of Ids to the filter config document. */
> +	json_object_object_add(jobj, filter_name, jfilter_data);
> +
> +	return true;
> +
> + fail:
> +	fprintf(stderr, "Failed to allocate memory for json_object.\n");
> +	json_object_put(jfilter_data);
> +	json_object_put(jpid);
> +	free(ids);
> +
> +	return false;
> +}
> +
> +/**
> + * @brief Record the current configuration of a Task Id filter into a
> + *	  Configuration document.
> + *
> + * @param filter: Input location for an Id filter.
> + * @param filter_name: The name of the filter to show up in the Json document.
> + * @param conf: Input location for the kshark_config_doc instance. Currently
> + *		only Json format is supported.
> + *
> + * @returns  True, on success or False in the case of an error.
> + */
> +bool kshark_export_task_filter(struct tracecmd_filter_id *filter,
> +			       const char *filter_name,
> +			       struct kshark_config_doc *conf)
> +{
> +	switch (conf->format) {
> +	case KS_CONFIG_JSON:
> +		return kshark_task_filter_to_json(filter, filter_name,
> +						  conf->conf_doc);
> +
> +	default:
> +		fprintf(stderr, "Document format %d not supported\n",
> +			conf->format);
> +		return false;
> +	}
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
> +	if (!json_object_object_get_ex(jobj, filter_name, &jfilter))
> +		return false;
> +
> +	if (!kshark_json_type_check(jobj, "kshark.filter.config") ||
> +	    json_object_get_type(jfilter) != json_type_array)
> +		goto fail;
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
> + * @brief Load from Configuration document the configuration of a Task Id filter.
> + *
> + * @param filter: Input location for an Id filter.
> + * @param filter_name: The name of the filter as showing up in the Config.
> + *	               document.
> + * @param conf: Input location for the kshark_config_doc instance. Currently
> + *		only Json format is supported.
> + *
> + * @returns True, if a filter has been loaded. If the filter configuration
> + *	    document contains no data for this particular filter or in a case
> + *	    of an error, the function returns False.
> + */
> +bool kshark_import_task_filter(struct tracecmd_filter_id *filter,
> +			       const char *filter_name,
> +			       struct kshark_config_doc *conf)
> +{
> +	switch (conf->format) {
> +	case KS_CONFIG_JSON:
> +		return kshark_task_filter_from_json(filter, filter_name,
> +						    conf->conf_doc);
> +
> +	default:
> +		fprintf(stderr, "Document format %d not supported\n",
> +			conf->format);
> +		return false;
> +	}
> +}
> +
> +static bool kshark_adv_filters_to_json(struct kshark_context *kshark_ctx,
> +				       struct json_object *jobj)
> +{
> +	struct event_filter *adv_filter = kshark_ctx->advanced_event_filter;
> +	json_object *jfilter_data, *jevent, *jsystem, *jname, *jfilter;
> +	struct event_format **events;
> +	char *str;
> +	int i;
> +
> +	/*
> +	 * If this Json document already contains a description of the model,
> +	 * delete this description.
> +	 */
> +	json_del_if_exist(jobj, KS_ADV_EVENT_FILTER_NAME);
> +
> +	if (!kshark_ctx->advanced_event_filter ||
> +	    !kshark_ctx->advanced_event_filter->filters)
> +		return true;
> +
> +	/* Create a Json array and fill the Id values into it. */
> +	jfilter_data = json_object_new_array();
> +	if (!jfilter_data)
> +		goto fail;
> +
> +	events = pevent_list_events(kshark_ctx->pevent, EVENT_SORT_SYSTEM);
> +	if (!events)
> +		return false;
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
> +	json_object_object_add(jobj, KS_ADV_EVENT_FILTER_NAME, jfilter_data);
> +
> +	return true;
> +
> + fail:
> +	fprintf(stderr, "Failed to allocate memory for json_object.\n");
> +	json_object_put(jfilter_data);
> +	json_object_put(jevent);
> +	json_object_put(jsystem);
> +	json_object_put(jname);
> +	json_object_put(jfilter);
> +
> +	return false;
> +}
> +
> +/**
> + * @brief Record the current configuration of the advanced filter into a
> + *	  Configuration document.
> + *
> + * @param kshark_ctx: Input location for session context pointer.
> + * @param conf: Input location for the kshark_config_doc instance. Currently
> + *		only Json format is supported. If NULL, a new Adv. Filter
> + *		Configuration document will be created.
> + *
> + * @returns  True, on success or False in the case of an error.
> + */
> +bool kshark_export_adv_filters(struct kshark_context *kshark_ctx,
> +			       struct kshark_config_doc **conf)
> +{
> +	if (!*conf)
> +		*conf = kshark_filter_config_new(KS_CONFIG_JSON);
> +
> +	switch ((*conf)->format) {
> +	case KS_CONFIG_JSON:
> +		return kshark_adv_filters_to_json(kshark_ctx,
> +						  (*conf)->conf_doc);
> +
> +	default:
> +		fprintf(stderr, "Document format %d not supported\n",
> +			(*conf)->format);
> +		return false;
> +	}
> +}
> +
> +static bool kshark_adv_filters_from_json(struct kshark_context *kshark_ctx,
> +					 struct json_object *jobj)
> +{
> +	struct event_filter *adv_filter = kshark_ctx->advanced_event_filter;
> +	json_object *jfilter, *jsystem, *jname, *jcond;
> +	int i, length, ret;
> +	char *filter_str;
> +
> +	/*
> +	 * Use the name of the filter to find the array of events associated
> +	 * with this filter. Notice that the filter config document may
> +	 * contain no data for this particular filter.
> +	 */
> +	if (!json_object_object_get_ex(jobj, KS_ADV_EVENT_FILTER_NAME,
> +				       &jfilter))
> +		return false;
> +
> +	if (!kshark_json_type_check(jobj, "kshark.filter.config") ||
> +	    json_object_get_type(jfilter) != json_type_array)
> +		goto fail;
> +
> +	/* Set the filter. */
> +	length = json_object_array_length(jfilter);
> +	for (i = 0; i < length; ++i) {
> +		jfilter = json_object_array_get_idx(jfilter, i);
> +
> +		if (!json_object_object_get_ex(jfilter, "system", &jsystem) ||
> +		    !json_object_object_get_ex(jfilter, "name", &jname) ||
> +		    !json_object_object_get_ex(jfilter, "condition", &jcond))
> +			goto fail;
> +
> +		asprintf(&filter_str, "%s/%s:%s",
> +			 json_object_get_string(jsystem),
> +			 json_object_get_string(jname),
> +			 json_object_get_string(jcond));
> +
> +		ret = pevent_filter_add_filter_str(adv_filter,
> +						   filter_str);
> +		if (ret < 0)
> +			goto fail;
> +	}
> +
> +	return true;
> +
> + fail:
> +	fprintf(stderr, "Failed to laod Advanced filters.\n");
> +	char error_str[200];
> +	int error_status =
> +		pevent_strerror(kshark_ctx->pevent, ret, error_str,
> +							 sizeof(error_str));
> +
> +	if (error_status == 0)
> +		fprintf(stderr, "filter failed due to: %s\n", error_str);
> +
> +	free(filter_str);
> +	return false;
> +}
> +
> +/**
> + * @brief Load from Configuration document the configuration of the advanced
> + *	  filter.
> + *
> + * @param kshark_ctx: Input location for session context pointer.
> + * @param conf: Input location for the kshark_config_doc instance. Currently
> + *		only Json format is supported.
> + *
> + * @returns True, if a filter has been loaded. If the filter configuration
> + *	    document contains no data for the Adv. filter or in a case of
> + *	    an error, the function returns False.
> + */
> +bool kshark_import_adv_filters(struct kshark_context *kshark_ctx,
> +			       struct kshark_config_doc *conf)
> +{
> +	switch (conf->format) {
> +	case KS_CONFIG_JSON:
> +		return kshark_adv_filters_from_json(kshark_ctx,
> +						    conf->conf_doc);
> +
> +	default:
> +		fprintf(stderr, "Document format %d not supported\n",
> +			conf->format);
> +		return false;
> +	}
> +}
> +
> +static bool filter_is_set(struct tracecmd_filter_id *filter)
> +{
> +	return filter && filter->count;
> +}
> +
> +/**
> + * @brief Record the current configuration of "show task" and "hide task"
> + *	  filters into a Json document.
> + *
> + * @param kshark_ctx: Input location for session context pointer.
> + * @param conf: Input location for the kshark_config_doc instance. Currently
> + *		only Json format is supported. If NULL, a new Filter
> + *		Configuration document will be created.
> + *
> + * @returns True, if a filter has been recorded. If both filters contain
> + *	    no Id values or in a case of an error, the function returns False.
> + */
> +bool kshark_export_all_event_filters(struct kshark_context *kshark_ctx,
> +				     struct kshark_config_doc **conf)
> +{
> +	bool ret = true;
> +
> +	if (!*conf)
> +		*conf = kshark_filter_config_new(KS_CONFIG_JSON);
> +
> +	/* Save a filter only if it contains Id values. */
> +	if (filter_is_set(kshark_ctx->show_event_filter))
> +		ret &= kshark_export_event_filter(kshark_ctx->pevent,
> +						  kshark_ctx->show_event_filter,
> +						  KS_SHOW_EVENT_FILTER_NAME,
> +						  *conf);
> +
> +	if (filter_is_set(kshark_ctx->hide_event_filter))
> +		ret &= kshark_export_event_filter(kshark_ctx->pevent,
> +						  kshark_ctx->hide_event_filter,
> +						  KS_HIDE_EVENT_FILTER_NAME,
> +						  *conf);
> +
> +	return ret;
> +}
> +
> +/**
> + * @brief Record the current configuration of "show task" and "hide task"
> + *	  filters into a Configuration document.
> + *
> + * @param kshark_ctx: Input location for session context pointer.
> + * @param conf: Input location for the kshark_config_doc instance. Currently
> + *		only Json format is supported. If NULL, a new Filter
> + *		Configuration document will be created.
> + *
> + * @returns True, if a filter has been recorded. If both filters contain
> + *	    no Id values or in a case of an error, the function returns False.
> + */
> +bool kshark_export_all_task_filters(struct kshark_context *kshark_ctx,
> +				    struct kshark_config_doc **conf)
> +{
> +	bool ret = true;
> +
> +	if (!*conf)
> +		*conf = kshark_filter_config_new(KS_CONFIG_JSON);

Need to check here if *conf is not NULL otherwise, the functions below
will dereference *conf.

> +
> +	/* Save a filter only if it contains Id values. */
> +	if (filter_is_set(kshark_ctx->show_task_filter))
> +		ret &= kshark_export_task_filter(kshark_ctx->show_task_filter,
> +						 KS_SHOW_TASK_FILTER_NAME,
> +						 *conf);
> +
> +	if (filter_is_set(kshark_ctx->hide_task_filter))
> +		ret &= kshark_export_task_filter(kshark_ctx->hide_task_filter,
> +						 KS_HIDE_TASK_FILTER_NAME,
> +						 *conf);
> +
> +	return ret;
> +}
> +
> +/**
> + * @brief Load from a Configuration document the configuration of "show event"
> + *	  and "hide event" filters.
> + *
> + * @param kshark_ctx: Input location for session context pointer.
> + * @param conf: Input location for the kshark_config_doc instance. Currently
> + *		only Json format is supported.
> + *
> + * @returns True, if a filter has been loaded. If the filter configuration
> + *	    document contains no data for any event filter or in a case
> + *	    of an error, the function returns False.
> + */
> +bool kshark_import_all_event_filters(struct kshark_context *kshark_ctx,
> +				     struct kshark_config_doc *conf)
> +{
> +	bool ret = false;
> +
> +	ret |= kshark_import_event_filter(kshark_ctx->pevent,
> +					  kshark_ctx->hide_event_filter,
> +					  KS_HIDE_EVENT_FILTER_NAME,
> +					  conf);
> +
> +	ret |= kshark_import_event_filter(kshark_ctx->pevent,
> +					  kshark_ctx->show_event_filter,
> +					  KS_SHOW_EVENT_FILTER_NAME,
> +					  conf);
> +
> +	return ret;
> +}
> +
> +/**
> + * @brief Load from Configuration document the configuration of "show task"
> + *	  and "hide task" filters.
> + *
> + * @param kshark_ctx: Input location for session context pointer.
> + * @param conf: Input location for the kshark_config_doc instance. Currently
> + *		only Json format is supported.
> + *
> + * @returns True, if a filter has been loaded. If the filter configuration
> + *	    document contains no data for any task filter or in a case of an
> + *	    error, the function returns False.
> + */
> +bool kshark_import_all_task_filters(struct kshark_context *kshark_ctx,
> +				    struct kshark_config_doc *conf)
> +{
> +	bool ret = false;
> +
> +	ret |= kshark_import_task_filter(kshark_ctx->hide_task_filter,
> +					 KS_HIDE_TASK_FILTER_NAME,
> +					 conf);
> +
> +	ret |= kshark_import_task_filter(kshark_ctx->show_task_filter,
> +					 KS_SHOW_TASK_FILTER_NAME,
> +					 conf);
> +
> +	return ret;
> +}
> +
> +/**
> + * @brief Create a Filter Configuration document containing the current
> + *	  configuration of all filters.
> + *
> + * @param kshark_ctx: Input location for session context pointer.
> + * @param format: Input location for the kshark_config_doc instance. Currently
> + *		  only Json format is supported.
> + *
> + * @returns kshark_config_doc instance. Use kshark_free_config_doc() to free
> + *	    the object.
> + */
> +struct kshark_config_doc *
> +kshark_export_all_filters(struct kshark_context *kshark_ctx,
> +			  enum kshark_config_formats format)
> +{
> +	/*  Create a new Configuration document. */
> +	struct kshark_config_doc *conf =
> +		kshark_filter_config_new(format);

If *conf ends up being NULL here, it will cause a dereference.

> +
> +	/* Save a filter only if it contains Id values. */
> +	if (!kshark_export_all_event_filters(kshark_ctx, &conf) ||

You could just add:

	if (!*conf ||

> +	    !kshark_export_all_task_filters(kshark_ctx, &conf) ||
> +	    !kshark_export_adv_filters(kshark_ctx, &conf)) {
> +		kshark_free_config_doc(conf);
> +		return NULL;
> +	}
> +
> +	return conf;
> +}
> +
> +/**
> + * @brief Load from a Configuration document the configuration of all filters.
> + *
> + * @param kshark_ctx: Input location for session context pointer.
> + * @param conf: Input location for the kshark_config_doc instance. Currently
> + *		only Json format is supported.
> + *
> + * @returns True, if a filter has been loaded. If the filter configuration
> + *	    document contains no data for any filter or in a case of an error,
> + *	    the function returns False.
> + */
> +bool kshark_import_all_filters(struct kshark_context *kshark_ctx,
> +			       struct kshark_config_doc *conf)
> +{
> +	bool ret;
> +	ret = kshark_import_all_task_filters(kshark_ctx, conf);
> +	ret |= kshark_import_all_event_filters(kshark_ctx, conf);
> +	ret |= kshark_import_adv_filters(kshark_ctx, conf);
> +
> +	return ret;
> +}
> +
> +static bool kshark_save_json_file(const char *file_name,
> +				  struct json_object *jobj)
> +{
> +	int flags;
> +
> +	/* Save the file in a human-readable form. */
> +	flags = JSON_C_TO_STRING_SPACED | JSON_C_TO_STRING_PRETTY;
> +	if (json_object_to_file_ext(file_name, jobj, flags) == 0)
> +		return true;
> +
> +	return false;
> +}
> +
> +/**
> + * @brief Save a Configuration document into a file.
> + *
> + * @param file_name: The name of the file.
> + * @param conf: Input location for the kshark_config_doc instance. Currently
> + *		only Json format is supported.
> + *
> + * @returns True, on success. Else False.

	@returns True on success, otherwise False.

The rest looks good!

-- Steve


> + */
> +bool kshark_save_config_file(const char *file_name,
> +			     struct kshark_config_doc *conf)
> +{
> +	switch (conf->format) {
> +	case KS_CONFIG_JSON:
> +		return kshark_save_json_file(file_name, conf->conf_doc);
> +
> +	default:
> +		fprintf(stderr, "Document format %d not supported\n",
> +			conf->format);
> +		return false;
> +	}
> +}
> +
> +static struct json_object *kshark_open_json_file(const char *file_name,
> +						 const char *type)
> +{
> +	struct json_object *jobj, *var;
> +	const char *type_var;
> +
> +	jobj = json_object_from_file(file_name);
> +
> +	if (!jobj)
> +		return NULL;
> +
> +	/* Get the type of the document. */
> +	if (!json_object_object_get_ex(jobj, "type", &var))
> +		goto fail;
> +
> +	type_var = json_object_get_string(var);
> +
> +	if (strcmp(type, type_var) != 0)
> +		goto fail;
> +
> +	return jobj;
> +
> + fail:
> +	/* The document has a wrong type. */
> +	fprintf(stderr, "Failed to open Json file %s\n.", file_name);
> +	fprintf(stderr, "The document has a wrong type.\n");
> +
> +	json_object_put(jobj);
> +	return NULL;
> +}
> +
> +static const char *get_ext(const char *filename)
> +{
> +	const char *dot = strrchr(filename, '.');
> +
> +	if(!dot)
> +		return "unknown";
> +
> +	return dot + 1;
> +}
> +
> +/**
> + * @brief Open for read a Configuration file and check if it has the
> + *	  expected type.
> + *
> + * @param file_name: The name of the file. Currently only Json files are
> + *		     supported.
> + * @param type: String describing the expected type of the document,
> + *		e.g. "kshark.record.config" or "kshark.filter.config".
> + *
> + * @returns kshark_config_doc instance on success, or NULL on failure. Use
> + *	    kshark_free_config_doc() to free the object.
> + */
> +struct kshark_config_doc *kshark_open_config_file(const char *file_name,
> +						  const char *type)
> +{
> +	struct kshark_config_doc *conf = NULL;
> +
> +	if (strcmp(get_ext(file_name), "json") == 0) {
> +		struct json_object *jobj =
> +			kshark_open_json_file(file_name, type);
> +
> +		if (jobj) {
> +			conf = malloc(sizeof(*conf));
> +			conf->conf_doc = jobj;
> +			conf->format = KS_CONFIG_JSON;
> +		}
> +	}
> +
> +	return conf;
> +}
> diff --git a/kernel-shark-qt/src/libkshark.h b/kernel-shark-qt/src/libkshark.h
> index ff09da3..69f77af 100644
> --- a/kernel-shark-qt/src/libkshark.h
> +++ b/kernel-shark-qt/src/libkshark.h
> @@ -16,6 +16,9 @@
>  #include <stdint.h>
>  #include <pthread.h>
>  
> +// Json-C
> +#include <json.h>
> +
>  #ifdef __cplusplus
>  extern "C" {
>  #endif
> @@ -367,6 +370,163 @@ kshark_get_collection_entry_back(struct kshark_entry_request **req,
>  				 const struct kshark_entry_collection *col,
>  				 ssize_t *index);
>  
> +/** Structure representing a KernelShark Configuration document. */
> +struct kshark_config_doc {
> +	/** Document format identifier. */
> +	int	format;
> +
> +	/** Configuration document instance. */
> +	void	*conf_doc;
> +};
> +
> +/** Configuration format identifiers. */
> +enum kshark_config_formats {
> +	/** Unformatted Configuration document identifier. */
> +	KS_CONFIG_AUTO = 0,
> +
> +	/**
> +	 * String Configuration document identifier. The String format is
> +	 * meant to be used only by kshark_config_doc_add() and
> +	 * kshark_config_doc_get(), when adding/getting simple string fields.
> +	 */
> +	KS_CONFIG_STRING,
> +
> +	/** Json Configuration document identifier. */
> +	KS_CONFIG_JSON,
> +};
> +
> +/**
> + * Field name for the Configuration document describing the Hide Event filter.
> + */
> +#define KS_HIDE_EVENT_FILTER_NAME	"hide event filter"
> +
> +/**
> + * Field name for the Configuration document describing the Show Event filter.
> + */
> +#define KS_SHOW_EVENT_FILTER_NAME	"show event filter"
> +
> +/**
> + * Field name for the Configuration document describing the Hide Task filter.
> + */
> +#define KS_HIDE_TASK_FILTER_NAME	"hide task filter"
> +
> +/**
> + * Field name for the Configuration document describing the Show Task filter.
> + */
> +#define KS_SHOW_TASK_FILTER_NAME	"show task filter"
> +
> +/**
> + * Field name for the Configuration document describing the Advanced event
> + * filter.
> + */
> +#define KS_ADV_EVENT_FILTER_NAME	"adv event filter"
> +
> +/**
> + * Field name for the Configuration document describing the state of the Vis.
> + * model.
> + */
> +#define KS_HISTO_NAME			"vis. model"
> +
> +/**
> + * Field name for the Configuration document describing the currently loaded
> + * trace data file.
> + */
> +#define KS_DATA_SOURCE_NAME		"trace data"
> +
> +struct kshark_config_doc *
> +kshark_config_alloc(enum kshark_config_formats);
> +
> +struct kshark_config_doc *
> +kshark_config_new(const char *type, enum kshark_config_formats);
> +
> +void kshark_free_config_doc(struct kshark_config_doc *conf);
> +
> +struct kshark_config_doc *
> +kshark_record_config_new(enum kshark_config_formats);
> +
> +struct kshark_config_doc *
> +kshark_filter_config_new(enum kshark_config_formats);
> +
> +struct kshark_config_doc *kshark_string_config_alloc();
> +
> +bool kshark_type_check(struct kshark_config_doc *conf, const char *type);
> +
> +void kshark_config_doc_add(struct kshark_config_doc *conf,
> +			   const char *key,
> +			   struct kshark_config_doc *val);
> +
> +bool kshark_config_doc_get(struct kshark_config_doc *conf,
> +			   const char *key,
> +			   struct kshark_config_doc *val);
> +
> +struct kshark_trace_histo;
> +
> +struct kshark_config_doc *
> +kshark_export_trace_file(const char *file,
> +			 enum kshark_config_formats format);
> +
> +const char *kshark_import_trace_file(struct kshark_context *kshark_ctx,
> +				     struct kshark_config_doc *conf);
> +
> +struct kshark_config_doc *
> +kshark_export_model(struct kshark_trace_histo *histo,
> +		     enum kshark_config_formats format);
> +
> +
> +bool kshark_import_model(struct kshark_trace_histo *histo,
> +			 struct kshark_config_doc *conf);
> +
> +bool kshark_export_adv_filters(struct kshark_context *kshark_ctx,
> +			       struct kshark_config_doc **conf);
> +
> +bool kshark_import_adv_filters(struct kshark_context *kshark_ctx,
> +			       struct kshark_config_doc *conf);
> +
> +bool kshark_export_event_filter(struct pevent *pevent,
> +				struct tracecmd_filter_id *filter,
> +				const char *filter_name,
> +				struct kshark_config_doc *conf);
> +
> +bool kshark_import_event_filter(struct pevent *pevent,
> +				struct tracecmd_filter_id *filter,
> +				const char *filter_name,
> +				struct kshark_config_doc *conf);
> +
> +bool kshark_export_task_filter(struct tracecmd_filter_id *filter,
> +			       const char *filter_name,
> +			       struct kshark_config_doc *conf);
> +
> +bool kshark_import_task_filter(struct tracecmd_filter_id *filter,
> +			       const char *filter_name,
> +			       struct kshark_config_doc *conf);
> +
> +bool kshark_export_all_event_filters(struct kshark_context *kshark_ctx,
> +				     struct kshark_config_doc **conf);
> +
> +bool kshark_export_all_task_filters(struct kshark_context *kshark_ctx,
> +				    struct kshark_config_doc **conf);
> +
> +struct kshark_config_doc *
> +kshark_export_all_filters(struct kshark_context *kshark_ctx,
> +			  enum kshark_config_formats format);
> +
> +bool kshark_import_all_event_filters(struct kshark_context *kshark_ctx,
> +				     struct kshark_config_doc *conf);
> +
> +bool kshark_import_all_task_filters(struct kshark_context *kshark_ctx,
> +				    struct kshark_config_doc *conf);
> +
> +bool kshark_import_all_filters(struct kshark_context *kshark_ctx,
> +			       struct kshark_config_doc *conf);
> +
> +bool kshark_save_config_file(const char *file_name,
> +			     struct kshark_config_doc *conf);
> +
> +struct kshark_config_doc *kshark_open_config_file(const char *file_name,
> +						  const char *type);
> +
> +struct kshark_config_doc *kshark_json_to_conf(struct json_object *jobj);
> +
>  #ifdef __cplusplus
>  }
>  #endif
