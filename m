Return-Path: <SRS0=+9rX=K6=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:40606 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729125AbeHOREN (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 15 Aug 2018 13:04:13 -0400
Received: by mail-wm0-f68.google.com with SMTP id y9-v6so1477414wma.5
        for <linux-trace-devel@vger.kernel.org>; Wed, 15 Aug 2018 07:11:52 -0700 (PDT)
Subject: Re: [PATCH v2 2/3] kernel-shark-qt: Add I/O for configuration data.
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-trace-devel@vger.kernel.org
References: <20180814180348.17236-1-y.karadz@gmail.com>
 <20180814180348.17236-2-y.karadz@gmail.com>
 <20180814224655.0d50667d@vmware.local.home>
From: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <770ffe04-3a04-a276-0411-997f0015a158@gmail.com>
Date: Wed, 15 Aug 2018 17:11:49 +0300
MIME-Version: 1.0
In-Reply-To: <20180814224655.0d50667d@vmware.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

Hi Steven,

On 15.08.2018 05:46, Steven Rostedt wrote:
>> +
>> +/**
>> + * @brief Add a field to a KernelShark Configuration document.
>> + *
>> + * @param conf: Input location for the kshark_config_doc instance. Currently
>> + *		only Json format is supported.
>> + * @param key: The name of the field.
>> + * @param val: Input location for the kshark_config_doc to be added.
>> + *	       Currently only Json and String formats are supported.
>> + */
>> +void kshark_config_doc_add(struct kshark_config_doc *conf,
>> +			   const char *key,
>> +			   struct kshark_config_doc *val)
> Hmm, this seems a bit low level on the abstract area. I guess in need
> to see the code that uses this (do you have a branch that converted to
> this already?).
> 
> Ideally, we would want our kshark_config_doc to take something
> directly, and not have it add another kshark_config_doc. That is, where
> the creation of the val is, should probably be able to add to the conf
> directly. Know what I mean?
> 

I would prefer to keep the *doc_add and *doc_get functions. I need ADD 
and GET because of the way the information gets structured in the 
configuration document. See an example of a Session description file below:

{
    "type": "kshark.session.config",
    "MainWindow": [
      898,
      538
    ],
    "Markers": {
      "type": "kshark.markers.config",
      "markA": {
        "isSet": false
      },
      "markB": {
        "isSet": false
      },
      "Active": "A"
    },
    "Filters": {
      "type": "kshark.filter.config",
      "show task filter": [
        314,
        42
      ]
    },
    "ViewTop": 16988720,
    "ColorScheme": 0.75,
    "trace data": {
      "type": "kshark.data.config",
      "file": 
"\/home\/yordan\/Workspace\/trace-cmd_qtdev\/kernel-shark-qt\/bin\/trace_very_big.dat",
      "time": 1520425749
    },
    "vis. model": {
      "type": "kshark.model.config",
      "range": [
        119984624152884,
        119984638388301
      ],
      "bins": 777
    },
    "CpuPlots": [
      0,
      1,
      2,
      3,
      4,
      5,
      6,
      7
    ],
    "TaskPlots": [
    ]
  }

In this example we have the top level document having
  "type": "kshark.session.config"

This top level document contains some simple field like:
"MainWindow", "ViewTop", "ColorScheme" etc.

but it also contains other documents, having there own types.
Like "Markers", "Filters", "vis. model" etc.

If the user only wants to export the filtering settings the 
"kshark.filter.config" documents is enough.
However when we want to save the entire session, we first create
"kshark.filter.config" and then we ADD this document to 
kshark.session.config

I've tried to demonstrate the way all this works in the example added in 
the following patch.

What do you think?

Thanks!
Yordan


>> +{
>> +	struct json_object *jobj;
>> +
>> +	if (!conf || !val)
>> +		return;
>> +
>> +	if (val->format == KS_NOFORMAT_CONFIG)
>> +		val->format = conf->format;
>> +
>> +	if (conf->format == KS_JSON_CONFIG) {
>> +		if (val->format == KS_JSON_CONFIG) {
>> +			json_object_object_add(conf->conf_doc, key,
>> +					       val->conf_doc);
>> +		}
>> +
>> +		if (val->format == KS_STRING_CONFIG) {
>> +			jobj = json_object_new_string(val->conf_doc);
>> +			json_object_object_add(conf->conf_doc, key, jobj);
>> +		}
>> +
>> +		free(val);
>> +	}
>> +}
>> +
>> +static bool get_jval(struct kshark_config_doc *conf,
>> +		     const char *key, void **val)
>> +{
>> +	return json_object_object_get_ex(conf->conf_doc, key,
>> +					 (json_object **) val);
>> +}
>> +
>> +/**
>> + * @brief Get the KernelShark Configuration document associate with a given
>> + *	  field name.
>> + *
>> + * @param conf: Input location for the kshark_config_doc instance. Currently
>> + *		only Json format is supported.
>> + * @param key: The name of the field.
>> + * @param val: Output location for the kshark_config_doc instance containing
>> + *	       the field. Currently only Json and String formats are supported.
>> + *
>> + * @returns True, if the key exists. Else False.
>> + */
>> +bool kshark_config_doc_get(struct kshark_config_doc *conf,
>> +			   const char *key,
>> +			   struct kshark_config_doc *val)
> I feel this is the same as add. Too low level. Again, I'll have to take
> a look at how these are used in the finished product.
> 
