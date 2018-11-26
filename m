Return-Path: <SRS0=Jn1h=OF=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:39146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725199AbeK0FAZ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 27 Nov 2018 00:00:25 -0500
Date: Mon, 26 Nov 2018 13:05:30 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: kaslevs@vmware.com
Cc: linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] trace-cmd: Fix record --date flag when sending tracing
 data to a listener
Message-ID: <20181126130530.63e8df2f@gandalf.local.home>
In-Reply-To: <20181114154328.14731-1-kaslevs@vmware.com>
References: <20181114154328.14731-1-kaslevs@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Wed, 14 Nov 2018 17:43:28 +0200
kaslevs@vmware.com wrote:

> From: Slavomir Kaslev <kaslevs@vmware.com>
> 
> Currently the `trace-cmd record` --date is not taken into account when tracing
> data is sent to a remote host with the -N flag.
> 
> This patch fixes this by the writing output buffer options from the recording
> side instead of on the listener side.
> 
> Signed-off-by: Slavomir Kaslev <kaslevs@vmware.com>
> ---
>

I don't see anything too wrong with it, accept the following test broke:

 $ git checkout trace-cmd-v2.6
 $ make
 $ sudo cp trace-cmd /usr/local/bin/trace-cmd-v2.6
 $ git checkout origin/master
 $ patch -p1 < this.patch
 $ make
 $ trace-cmd-v2.6 listen -p 12345

In another terminal:

 $ sudo trace-cmd record -N 127.0.0.1:12345 -e sched sleep 1
trace-cmd: No such file or directory
  Cannot handle the protocol


Remember, we need to remain backward compatible. We also need to test
this code running as a listener, and the trace-cmd-v2.6 (and earlier)
as the recorder.

-- Steve
