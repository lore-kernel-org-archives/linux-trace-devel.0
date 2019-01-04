Return-Path: <linux-trace-devel-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:46054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726189AbfADDnD (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 3 Jan 2019 22:43:03 -0500
Date: Thu, 3 Jan 2019 22:43:00 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Johannes Berg <johannes@sipsolutions.net>,
        "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Cc: Tzvetomir Stoyanov <tstoyanov@vmware.com>
Subject: Re: trace-cmd python
Message-ID: <20190103224300.418e002b@vmware.local.home>
In-Reply-To: <1524143246.3024.21.camel@sipsolutions.net>
References: <1524143246.3024.21.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Thu, 19 Apr 2018 15:07:26 +0200
Johannes Berg <johannes@sipsolutions.net> wrote:

Hi Johannes,

This was buried in my TODO list, and lost. I just noticed it. 

> So, starting again from git clean -fdxq, I observe the following:
> 
> 1) make -j8 install
>    -> errors out with  
> "make[1]: *** No rule to make target '/home/jberg1/sys/trace-cmd/lib/trace-cmd/libtracecmd.a', needed by 'ctracecmd.so'.  Stop."
> 
> 2) make install
>    -> python plugin not installed
>    -> copy it manually  
> 
> 3) running trace-cmd report with plugin_mac80211.py in
> ~/.trace-cmd/plugins/ I see
> 
> failed loading /home/jberg1/.trace-cmd/plugins/mac80211.py
> Traceback (most recent call last):
>   File "<string>", line 1, in <module>
>   File "/tmp/tcmd//lib/trace-cmd/python/tracecmd.py", line 22, in <module>
>     from ctracecmd import *
> ImportError: /tmp/tcmd//lib/trace-cmd/python/ctracecmd.so: undefined symbol: traceevent_plugin_free_options_list
> 
> If I remove that from the header file I eventually get down to not
> having __vpr_stat() or something, which seems to indicate that
> ctracecmd.so isn't linked with libtraceevent, only with libtracecmd? But
> adding that to the Makefile didn't change anything, and then I gave up
> and checked out v2.7 instead.
>

I just checked, and this is still an issue today. I'll make sure that
this gets fixed soon.

Thanks for reporting! (even though it got lost in my INBOX :-( )

-- Steve
