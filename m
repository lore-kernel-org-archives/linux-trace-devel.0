Return-Path: <SRS0=DGv/=O2=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wm1-f66.google.com ([209.85.128.66]:50824 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726607AbeLQRoH (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 17 Dec 2018 12:44:07 -0500
Received: by mail-wm1-f66.google.com with SMTP id n190so99403wmd.0
        for <linux-trace-devel@vger.kernel.org>; Mon, 17 Dec 2018 09:44:05 -0800 (PST)
Subject: Re: [PATCH v2 5/8] kernel-shark-qt: Create "Apply filter XX"
 checkboxes in KsUtils
To: Steven Rostedt <rostedt@goodmis.org>,
        Yordan Karadzhov <ykaradzhov@vmware.com>
Cc: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
References: <20181214125212.9637-1-ykaradzhov@vmware.com>
 <20181214125212.9637-6-ykaradzhov@vmware.com>
 <20181214120155.706a68aa@gandalf.local.home>
From: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <19a2b689-b316-a759-b626-3a5aed4d1a87@gmail.com>
Date: Mon, 17 Dec 2018 19:44:03 +0200
MIME-Version: 1.0
In-Reply-To: <20181214120155.706a68aa@gandalf.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>



On 14.12.18 г. 19:01 ч., Steven Rostedt wrote:
> On Fri, 14 Dec 2018 12:52:39 +0000
> Yordan Karadzhov <ykaradzhov@vmware.com> wrote:
> 
>> The code responsible for the creation of the "Apply filters to Graph"
>> and "Apply filters to List" checkboxes (showing in the "Filtering" menu),
>> has been moved outside of the KsMainWindow class and is now available
>> in KsUtils. This is done because we want to have the same checkboxes
>> available in the KsQuickContextMenu.
>>
> 
> I applied this patch and it shows the "Hide CPU [x]". But it's a bit
> flaky. The first time I tried it, it didn't do anything. Then after
> starting kernelshark again, I was able to have it hide the CPU, but
> when I clicked on the "Filter" menu on the top toolbar, the filter went
> away.

Interesting, I have an idea why this may happen, but I am not sure.


> 
> Another thing, the "Apply filters to Graph" checkbox is a bit
> confusing. What does it actually mean? The filters are applied by
> default to the graph, correct? But the checkbox isn't set.
> 
> Also, does it make sense to have that "Apply filters to graph" checkbox
> in the Graph menu. It would make more sense if it said "Apply filters
> to table".

You are right. There is a typo in the name of the checkbox. But it does 
the correct thing.

I will fix the two problems and will resend the patch.

Thanks a lot!
Yordan


> 
> I think I'll apply this series except for this patch and the last one
> (5 and 8).
> 
> -- Steve
> 
