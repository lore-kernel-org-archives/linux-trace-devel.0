Return-Path: <linux-trace-devel-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:37532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729042AbfAHWcT (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 8 Jan 2019 17:32:19 -0500
Date: Tue, 8 Jan 2019 17:32:16 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Slavomir Kaslev <kaslevs@vmware.com>
Cc: linux-trace-devel@vger.kernel.org, ykaradzhov@vmware.com,
        tstoyanov@vmware.com
Subject: Re: [PATCH v2 2/6] trace-cmd: Fix warnings reported by gcc 8.2
Message-ID: <20190108173216.0e89bdd9@gandalf.local.home>
In-Reply-To: <20190108150015.21327-3-kaslevs@vmware.com>
References: <20190108150015.21327-1-kaslevs@vmware.com>
        <20190108150015.21327-3-kaslevs@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Tue,  8 Jan 2019 17:00:11 +0200
Slavomir Kaslev <kaslevs@vmware.com> wrote:

> Compiling trace-cmd with gcc 8.2 reports:
> 
>     trace-read.c: In function ‘append_pid_filter’:
>     trace-read.c:414:3: warning: passing argument 1 to restrict-qualified parameter aliases with argument 3 [-Wrestrict]
>        sprintf(filter, "%s||" FILTER_FMT, filter, pid, pid, pid);
>        ^~~~~~~
> 
> since `snprintf` declares its first argument as __restrict but `buf` is also
> passed as argument #5.
> 
> Signed-off-by: Slavomir Kaslev <kaslevs@vmware.com>

FYI, I took this patch but changed the subject and description to this:

From: Slavomir Kaslev <kaslevs@vmware.com>
Subject: [PATCH] trace-cmd: Do not use target string pointer as parameter to
 sprintf()

Compiling trace-cmd with gcc 8.2 reports:

    trace-read.c: In function ‘append_pid_filter’:
    trace-read.c:414:3: warning: passing argument 1 to restrict-qualified parameter aliases with argument 3 [-Wrestrict]
       sprintf(filter, "%s||" FILTER_FMT, filter, pid, pid, pid);
       ^~~~~~~

since `snprintf` declares its first argument as __restrict but `buf` is also
passed as argument #5.

The code just concatenates to the filter string. Use the original string
length as the position to write to filter.

Signed-off-by: Slavomir Kaslev <kaslevs@vmware.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>

-- Steve
