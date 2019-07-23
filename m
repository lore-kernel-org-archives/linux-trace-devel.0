Return-Path: <SRS0=P3iB=VU=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E957C76186
	for <linux-trace-devel@archiver.kernel.org>; Tue, 23 Jul 2019 17:41:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EFA00223A0
	for <linux-trace-devel@archiver.kernel.org>; Tue, 23 Jul 2019 17:41:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391170AbfGWRlH (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 23 Jul 2019 13:41:07 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:47354 "EHLO smtp.gentoo.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388606AbfGWRlH (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 23 Jul 2019 13:41:07 -0400
Received: from patrickm (unknown [100.42.98.196])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: chutzpah)
        by smtp.gentoo.org (Postfix) with ESMTPSA id 10C9134848F;
        Tue, 23 Jul 2019 17:41:06 +0000 (UTC)
Date:   Tue, 23 Jul 2019 10:41:02 -0700
From:   Patrick McLean <chutzpah@gentoo.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 2/4] trace-cmd: No automagic dependency on udis86
Message-ID: <20190723104102.4f11cee4@patrickm>
In-Reply-To: <20190719231701.0e2c901e@oasis.local.home>
References: <20190720030344.1991393-1-chutzpah@gentoo.org>
 <20190720030344.1991393-3-chutzpah@gentoo.org>
 <20190719231701.0e2c901e@oasis.local.home>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 19 Jul 2019 23:17:01 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:
> Hi Patrick,
> 
> Thanks for sending these. Some questions below.
> 
> On Fri, 19 Jul 2019 20:03:42 -0700
> Patrick McLean <chutzpah@gentoo.org> wrote:
> 
> > From: Patrick McLean <patrick.mclean@sony.com>
> > 
> > Currently if udis86 is detected on the system, trace-cmd
> > automatically uses it. This is generally a problem for packagers
> > since if the build machine happens to have udis86, now there is a
> > dependency on it that may or may not be tracked.
> > 
> > This adds a NO_UDIS86 variable that can be set by the packager to
> > disable using udis86 completely.
> > 
> > Signed-off-by: Patrick McLean <patrick.mclean@sony.com>
> > ---
> >  Makefile | 8 +++++++-
> >  1 file changed, 7 insertions(+), 1 deletion(-)
> > 
> > diff --git a/Makefile b/Makefile
> > index 3579f27..6b85e21 100644
> > --- a/Makefile
> > +++ b/Makefile
> > @@ -136,8 +136,13 @@ export NO_PYTHON
> >  test-build = $(if $(shell sh -c 'echo "$(1)" | \
> >  	$(CC) -o /dev/null -c -x c - > /dev/null 2>&1 && echo y'),
> > $2) 
> > +ifndef NO_UDIS86
> >  # have udis86 disassembler library?
> > -udis86-flags := $(call test-build,\#include
> > <udis86.h>,-DHAVE_UDIS86 -ludis86) +udis86-flags := -DHAVE_UDIS86
> > +udis86-ldflags := -ludis86  
> 
> Can we keep the test here? If NO_UDIS86 is not defined. That is, if
> you compile without this define, this change assumes you have it.
> 
> It's fine to force not having it, but we shouldn't force having it if
> we don't.

That sounds good to me, preserve the current behaviour if nothing is
defined. I will attach an updated patch.

> > +else
> > +udis86-flags := -UHAVE_UDIS86  
> 
> I'm not sure this is needed, We shouldn't have anything defining
> HAVE_UDIS86.

Sure, I will drop it.


From: Patrick McLean <patrick.mclean@sony.com>

Currently if udis86 is detected on the system, trace-cmd automatically
uses it. This is generally a problem for packagers since if the build
machine happens to have udis86, now there is a dependency on it that may
or may not be tracked.

This adds a NO_UDIS86 variable that can be set by the packager to
disable using udis86 completely.

Signed-off-by: Patrick McLean <patrick.mclean@sony.com>
---
 Makefile | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Makefile b/Makefile
index 3579f27..ee3d8d9 100644
--- a/Makefile
+++ b/Makefile
@@ -136,8 +136,11 @@ export NO_PYTHON
 test-build = $(if $(shell sh -c 'echo "$(1)" | \
 	$(CC) -o /dev/null -c -x c - > /dev/null 2>&1 && echo y'), $2)
 
+ifndef NO_UDIS86
 # have udis86 disassembler library?
 udis86-flags := $(call test-build,\#include <udis86.h>,-DHAVE_UDIS86 -ludis86)
+udis86-ldflags := -ludis86
+endif # NO_UDIS86
 
 define BLK_TC_FLUSH_SOURCE
 #include <linux/blktrace_api.h>
@@ -237,6 +240,7 @@ endif
 # Append required CFLAGS
 override CFLAGS += $(INCLUDES) $(PLUGIN_DIR_SQ) $(VAR_DIR)
 override CFLAGS += $(udis86-flags) $(blk-flags)
+override LDFLAGS += $(udis86-ldflags)
 
 CMD_TARGETS = trace-cmd $(BUILD_PYTHON)
 
-- 
2.22.0

