Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BFEDC4361B
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Dec 2020 22:20:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B1EA8235FD
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Dec 2020 22:20:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727777AbgLPWU1 convert rfc822-to-8bit (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 16 Dec 2020 17:20:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:48154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727626AbgLPWU1 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 16 Dec 2020 17:20:27 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B8A0F20721;
        Wed, 16 Dec 2020 22:19:46 +0000 (UTC)
Date:   Wed, 16 Dec 2020 17:19:44 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2] trace-cmd: Re-enable the build of KernelShark v1
Message-ID: <20201216171944.230cc08a@gandalf.local.home>
In-Reply-To: <20201216152850.7cf69fc8@gandalf.local.home>
References: <20201216130715.181002-1-y.karadz@gmail.com>
        <20201216152850.7cf69fc8@gandalf.local.home>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 16 Dec 2020 15:28:50 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:

> On Wed, 16 Dec 2020 15:07:15 +0200
> "Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:
> 
> > --- a/lib/traceevent/parse-utils.c
> > +++ b/lib/traceevent/parse-utils.c
> > @@ -9,8 +9,6 @@
> >  #include <stdarg.h>
> >  #include <errno.h>
> >  
> > -#include "event-utils.h"
> > -
> >  #define __weak __attribute__((weak))
> >  
> >  void __vwarning(const char *fmt, va_list ap)
> > --   
> 
> Is this needed?
> 
> I removed this hunk, and it still builds fine for me. After I did the
> dependency change mentioned in the other email.

I was building without libtraceevent installed, and it worked for me. But I
see why you did this. After installing libtraceevent on my host, I get:

( cc -c  -g -Wall -DVSOCK -D_GNU_SOURCE -DWARN_NO_AUDIT -DNO_AUDIT -I/work/git/trace-cmd.git/include -I/work/git/trace-cmd.git/../../include -I/work/git/trace-cmd.git/include/trace-cmd -I/work/git/trace-cmd.git/lib/trace-cmd/include -I/work/git/trace-cmd.git/lib/trace-cmd/include/private -I/work/git/trace-cmd.git/tracecmd/include -I/usr/local/include/traceevent  -I/usr/local/include/tracefs  -DVAR_DIR="/var" '-DPLUGIN_TRACEEVENT_DIR="/usr/local/lib64/traceevent/plugins"' '-DPLUGIN_TRACECMD_DIR=""'   -DHAVE_BLK_TC_FLUSH -I/work/git/trace-cmd.git/lib/traceevent/include -std=gnu99 -fPIC parse-utils.c -o /work/git/trace-cmd.git/lib/traceevent/parse-utils.o)
parse-utils.c:16:6: error: conflicting types for ‘__vwarning’
   16 | void __vwarning(const char *fmt, va_list ap)
      |      ^~~~~~~~~~
In file included from parse-utils.c:12:
/usr/local/include/traceevent/event-utils.h:20:6: note: previous declaration of ‘__vwarning’ was here
   20 | void __vwarning(const char *fmt, ...);
      |      ^~~~~~~~~~
parse-utils.c:41:6: error: conflicting types for ‘__vpr_stat’
   41 | void __vpr_stat(const char *fmt, va_list ap)
      |      ^~~~~~~~~~
In file included from parse-utils.c:12:
/usr/local/include/traceevent/event-utils.h:21:6: note: previous declaration of ‘__vpr_stat’ was here
   21 | void __vpr_stat(const char *fmt, ...);
      |      ^~~~~~~~~~
make[1]: *** [Makefile:50: /work/git/trace-cmd.git/lib/traceevent/parse-utils.o] Error 1
make: *** [Makefile:363: /work/git/trace-cmd.git/lib/traceevent/libtraceevent.a] Error 2


Ideally, we don't want to include the libtraceevent or libtracefs system
includes when building locally. Let me see if I can fix the make file here.

-- Steve
