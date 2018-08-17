Return-Path: <SRS0=xGmm=LA=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wr1-f68.google.com ([209.85.221.68]:34819 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726376AbeHQMhN (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 17 Aug 2018 08:37:13 -0400
Received: by mail-wr1-f68.google.com with SMTP id g1-v6so6534826wru.2
        for <linux-trace-devel@vger.kernel.org>; Fri, 17 Aug 2018 02:34:31 -0700 (PDT)
Subject: Re: [PATCH v3 2/3] kernel-shark-qt: Add I/O for configuration data.
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-trace-devel@vger.kernel.org
References: <20180816150729.4680-1-y.karadz@gmail.com>
 <20180816150729.4680-2-y.karadz@gmail.com>
 <20180816145219.7e91e435@gandalf.local.home>
From: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <102a7b39-3eeb-0e00-9e1a-39578d178ece@gmail.com>
Date: Fri, 17 Aug 2018 12:34:27 +0300
MIME-Version: 1.0
In-Reply-To: <20180816145219.7e91e435@gandalf.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

Hi Steven,

On 16.08.2018 21:52, Steven Rostedt wrote:
>> +/**
>> + * @brief Check the type of a Configuration document and compare with an
>> + *	  expected value.
>> + *
>> + * @param conf: Input location for the kshark_config_doc instance.
>> + * @param type: Input location for the expected value of the Configuration
>> + *		document type, e.g. "kshark.record.config" or
>> + *		"kshark.filter.config".
> Oh, I forgot to ask...
> 
> Do you expect to have different "kshark.record" and kshark.filter"
> options other than ".config"? If not, shouldn't it be:
> 
> 	"kshark.config.record" and "kshark.config.filter" ?
> 
> That way we can do searches for all the configs in a json file by
> searching for "kshark.config".
> 
> 

My logic was that in the future we may have KernelShark doing some 
automated analyses over the trace data. In this case the result can be 
outputted to a Json file and have a type "kshark.*.output". So I 
intuitively added the ".config" at the end, like a file extension.

However your logic makes sense and I am OK with switching the order.
Thanks!
Yordan
