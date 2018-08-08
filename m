Return-Path: <SRS0=PkBc=KX=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wr1-f66.google.com ([209.85.221.66]:40245 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726733AbeHHOIQ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 8 Aug 2018 10:08:16 -0400
Received: by mail-wr1-f66.google.com with SMTP id h15-v6so1747121wrs.7
        for <linux-trace-devel@vger.kernel.org>; Wed, 08 Aug 2018 04:48:55 -0700 (PDT)
Subject: Re: [PATCH 2/2] kernel-shark-qt: Add Json I/O for filter
 configurations.
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-trace-devel@vger.kernel.org,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
References: <20180807160013.11537-1-y.karadz@gmail.com>
 <20180807160013.11537-2-y.karadz@gmail.com>
 <20180807212126.0fe0fbe7@gandalf.local.home>
From: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <ced0da66-0b65-b45b-037a-370fd07a16db@gmail.com>
Date: Wed, 8 Aug 2018 14:48:53 +0300
MIME-Version: 1.0
In-Reply-To: <20180807212126.0fe0fbe7@gandalf.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>


On  8.08.2018 04:21, Steven Rostedt wrote:
>> +
>> +	/* Create a Json array and fill the Id values into it. */
>> +	jfilter_data = json_object_new_array();
>> +	if (!jfilter_data)
> Hmm, can json_object_put() take a NULL pointer?
> 

Yes, see here:

https://github.com/json-c/json-c/blob/master/json_object.c#L185

Thanks!
Yordan
