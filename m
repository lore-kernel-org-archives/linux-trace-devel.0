Return-Path: <SRS0=gflo=KP=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:53411 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732194AbeGaPbR (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 31 Jul 2018 11:31:17 -0400
Received: by mail-wm0-f68.google.com with SMTP id s9-v6so3170771wmh.3
        for <linux-trace-devel@vger.kernel.org>; Tue, 31 Jul 2018 06:50:51 -0700 (PDT)
Subject: Re: [PATCH 4/6] kernel-shark-qt: Define Data collections
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-trace-devel@vger.kernel.org
References: <20180711133814.26854-1-y.karadz@gmail.com>
 <20180711133814.26854-5-y.karadz@gmail.com>
 <20180712193316.537feb32@gandalf.local.home>
From: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <d626ba01-430b-7be7-d8aa-2582ebdcf906@gmail.com>
Date: Tue, 31 Jul 2018 16:50:47 +0300
MIME-Version: 1.0
In-Reply-To: <20180712193316.537feb32@gandalf.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

Hi Steven,

On 13.07.2018 02:33, Steven Rostedt wrote:
> On a styling point. I realized that reading the doxygen output I find
> more difficult than kerneldoc. But then I realized it can be better if
> we add spacing. By putting in a blank comment line after @brief, and
> after the last @param, I think it is easier to read. For example:
> 
> 
>> + * @brief Allocate and process data collection, defined with a given Matching
>> + *	  condition function and value. Add this collection to the list of
>> + *	  collections used by the session.
>    + *
>> + * @param kshark_ctx: Input location for the session context pointer.
>> + * @param data: Input location for the trace data.
>> + * @param n_rows: The size of the inputted data.
>> + * @param cond: Matching condition function for the collection to be
>> + *	        registered.
>> + * @param val: Matching condition value of for collection to be registered.
>> + * @param margin: The size of the additional (margin) data which do not
>> + *		  satisfying the data condition, but is added at the beginning
>> + *		  and at the end of each interval of the collection. If "0",
>> + *		  no margin data is added.
>> + *
>> + * @returns Pointer to the registered Data collections on success, or NULL
>> + *	    on failure.
>> + */
> What do you think?


Do you mean that it makes it easy to read in the source file?
I can make this change in a separate patch.

Thanks!
Yordan
