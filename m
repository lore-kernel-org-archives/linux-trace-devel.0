Return-Path: <SRS0=xGmm=LA=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:37894 "EHLO
        mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727333AbeHQSNd (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 17 Aug 2018 14:13:33 -0400
Received: by mail-wm0-f51.google.com with SMTP id t25-v6so7649773wmi.3
        for <linux-trace-devel@vger.kernel.org>; Fri, 17 Aug 2018 08:09:48 -0700 (PDT)
Subject: Re: [PATCH v3 2/3] kernel-shark-qt: Add I/O for configuration data.
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-trace-devel@vger.kernel.org
References: <20180816150729.4680-1-y.karadz@gmail.com>
 <20180816150729.4680-2-y.karadz@gmail.com>
 <20180816145219.7e91e435@gandalf.local.home>
 <0a535d0f-333c-f002-970c-33c5a8937b05@gmail.com>
 <20180817084958.11361418@gandalf.local.home>
 <38b58799-95e7-53c0-8398-2b590dfb1192@gmail.com>
 <20180817105842.7f14e6e7@gandalf.local.home>
From: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <f364f502-c14f-b5ee-c4d7-1dc7634ade6d@gmail.com>
Date: Fri, 17 Aug 2018 18:09:44 +0300
MIME-Version: 1.0
In-Reply-To: <20180817105842.7f14e6e7@gandalf.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>


On 17.08.2018 17:58, Steven Rostedt wrote:
> And we can have more than one file saved in the session. Hmm, I wonder
> if we should add code to see if files still exist, and remove the
> information if they do not.

Actually if you use this a lot you may have a big number of *.json files 
in your work directory. And some of these files can represent sessions, 
some other only filters. But when you click on the Session Import, for 
example, the Open File dialog will show you all *.json files. In this 
case you may get confused and try to open a wrong file. This is the 
reason why we need the "type" field.

Thanks!
Yordan
