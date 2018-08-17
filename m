Return-Path: <SRS0=xGmm=LA=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wr1-f67.google.com ([209.85.221.67]:45240 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725879AbeHQRSh (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 17 Aug 2018 13:18:37 -0400
Received: by mail-wr1-f67.google.com with SMTP id 20-v6so1264046wrb.12
        for <linux-trace-devel@vger.kernel.org>; Fri, 17 Aug 2018 07:15:05 -0700 (PDT)
Subject: Re: [PATCH v3 2/3] kernel-shark-qt: Add I/O for configuration data.
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-trace-devel@vger.kernel.org
References: <20180816150729.4680-1-y.karadz@gmail.com>
 <20180816150729.4680-2-y.karadz@gmail.com>
 <20180816145219.7e91e435@gandalf.local.home>
 <102a7b39-3eeb-0e00-9e1a-39578d178ece@gmail.com>
 <20180817085235.0de3493a@gandalf.local.home>
From: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <8156e00f-6416-c770-a533-e54a0ee02f6f@gmail.com>
Date: Fri, 17 Aug 2018 17:15:00 +0300
MIME-Version: 1.0
In-Reply-To: <20180817085235.0de3493a@gandalf.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>



On 17.08.2018 15:52, Steven Rostedt wrote:
> Yes please. Naming like this is usually done in "reverse" language.
> Similar to DNS names. Although we may type "www.vmware.com", it is
> really processed in the order of "com:vmware:www". And with config
> names, the more detailed the data, the farther out it goes:
>   <domain>.<subdomain>.<topic>.<detailed_topic>
> 

OK, I will do the modification and send the patch again.

Thanks!
Yordan



> Thanks!
> 
> -- Steve
