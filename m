Return-Path: linux-trace-devel-owner@vger.kernel.org
Received: from mail-wr0-f196.google.com ([209.85.128.196]:35175 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750749AbeBHH3W (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 8 Feb 2018 02:29:22 -0500
Received: by mail-wr0-f196.google.com with SMTP id w50so3631193wrc.2
        for <linux-trace-devel@vger.kernel.org>; Wed, 07 Feb 2018 23:29:21 -0800 (PST)
Message-ID: <1518074969.2041.9.camel@gmail.com>
Subject: Re: [PATCH v2 13/24] trace-cmd: Move python-related files in python/
From: "Vladislav K. Valtchev" <vladislav.valtchev@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-trace-devel@vger.kernel.org, y.karadz@gmail.com
Date: Thu, 08 Feb 2018 09:29:29 +0200
In-Reply-To: <20180207151114.29e76c2e@gandalf.local.home>
References: <20180206084906.9854-1-vladislav.valtchev@gmail.com>
         <20180206084906.9854-14-vladislav.valtchev@gmail.com>
         <20180207142238.74d12ec3@gandalf.local.home>
         <20180207151114.29e76c2e@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Wed, 2018-02-07 at 15:11 -0500, Steven Rostedt wrote:
> On Wed, 7 Feb 2018 14:22:38 -0500
> Steven Rostedt <rostedt@goodmis.org> wrote:
>  
> > > -TRACE_VIEW_OBJS =
> > > -TRACE_VIEW_OBJS += $(obj)/kernel-shark/trace-view.o
> > > -TRACE_VIEW_OBJS += $(obj)/kernel-shark/trace-view-store.o  
> > 
> > Why is this being moved into python code?
> 
> I now understand why you did it this way.




> 
> > > +ctracecmdgui.so: ctracecmdgui.i $(LIBTRACECMD_STATIC) $(TRACE_VIEW_OBJS)
> 
> For this above.
> 
> I'd rather have that depend on a single file in kernel-shark directory,
> or something that makes it a little cleaner.
> 
> -- Steve


Yep, you're totally right.
That was mostly a hack, part of a mechanical step. Probably we should make
a mini static lib for those two files and make both trace-view and the python targets
depend on it.


-- 
Vladislav Valtchev
VMware Open Source Technology Center
