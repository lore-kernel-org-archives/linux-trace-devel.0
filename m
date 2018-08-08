Return-Path: <SRS0=PkBc=KX=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:36319 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726733AbeHHOHd (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 8 Aug 2018 10:07:33 -0400
Received: by mail-wm0-f67.google.com with SMTP id w24-v6so2457808wmc.1
        for <linux-trace-devel@vger.kernel.org>; Wed, 08 Aug 2018 04:48:12 -0700 (PDT)
Subject: Re: [PATCH 2/2] kernel-shark-qt: Add Json I/O for filter
 configurations.
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-trace-devel@vger.kernel.org,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
References: <20180807160013.11537-1-y.karadz@gmail.com>
 <20180807160013.11537-2-y.karadz@gmail.com>
 <20180807212126.0fe0fbe7@gandalf.local.home>
From: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <f176f271-74c1-ecb0-1592-beb77e25e8e8@gmail.com>
Date: Wed, 8 Aug 2018 14:48:10 +0300
MIME-Version: 1.0
In-Reply-To: <20180807212126.0fe0fbe7@gandalf.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

Hi Steven,

On  8.08.2018 04:21, Steven Rostedt wrote:
>> /**
>> + * @brief Create an empty Json document and set its type description.
>> + *
>> + * @param type: String describing the type of the document,
>> + *		e.g. "kshark.record.config" or "kshark.filter.config".
>> + *
>> + * @returns json_object instance. Use json_object_put() to free the object.
> I wonder if we should add handlers like:
> 
> 	kshark_config_free(struct json_object *jobj);
> 
> and call that instead? Perhaps even create our own object that may
> contain extra state that the json object does not, and return that?
> 
> 

What do we gain by doing it this way?

Thanks!
Yordan
