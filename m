Return-Path: <SRS0=+9rX=K6=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:35547 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728957AbeHORI2 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 15 Aug 2018 13:08:28 -0400
Received: by mail-wm0-f65.google.com with SMTP id o18-v6so1501214wmc.0
        for <linux-trace-devel@vger.kernel.org>; Wed, 15 Aug 2018 07:16:07 -0700 (PDT)
Subject: Re: [PATCH v2 2/3] kernel-shark-qt: Add I/O for configuration data.
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-trace-devel@vger.kernel.org
References: <20180814180348.17236-1-y.karadz@gmail.com>
 <20180814180348.17236-2-y.karadz@gmail.com>
 <20180814224655.0d50667d@vmware.local.home>
From: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <82ea4075-415e-ed99-56e2-c281c6c5d2c2@gmail.com>
Date: Wed, 15 Aug 2018 17:16:04 +0300
MIME-Version: 1.0
In-Reply-To: <20180814224655.0d50667d@vmware.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

Hi Steven,

On 15.08.2018 05:46, Steven Rostedt wrote:
>> +/**
>> + * @brief Record the current configuration of the advanced filter into a
>> + *	  Configuration document.
>> + *
>> + * @param kshark_ctx: Input location for session context pointer.
>> + * @param conf: Input location for the kshark_config_doc instance. Currently
>> + *		only Json format is supported. If NULL, a new Adv. Filter
>> + *		Configuration document will be created.
> We should have a format parameter here, where they can specify what
> type to create (currently only KS_JSON_CONFIG is supported). Otherwise,
> how would one pass something else in when if we support something else?
> 

The idea here is that the user is expected to provide an instance of 
kshark_config_doc and this instance already has a format.

A new instance will be created only in the case of passing conf = NULL.
In this case the new instance will have the default format (Json).

I agree that it looks peculiar, because we support only one format for 
the moment. ;-)

Thanks!
Yordan


>> + */
>> +void kshark_export_adv_filters(struct kshark_context *kshark_ctx,
>> +			       struct kshark_config_doc **conf)
>> +{
>> +	if (!*conf)
>> +		*conf = kshark_filter_config_new(KS_JSON_CONFIG);
>> +
>> +	if ((*conf)->format == KS_JSON_CONFIG)
>> +		kshark_adv_filters_to_json(kshark_ctx, (*conf)->conf_doc);
>> +}
