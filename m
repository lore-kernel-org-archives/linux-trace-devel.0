Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F1FCC4332F
	for <linux-trace-devel@archiver.kernel.org>; Fri, 23 Dec 2022 16:18:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229625AbiLWQS1 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 23 Dec 2022 11:18:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230211AbiLWQSZ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 23 Dec 2022 11:18:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12F501A214
        for <linux-trace-devel@vger.kernel.org>; Fri, 23 Dec 2022 08:18:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C69FDB820E4
        for <linux-trace-devel@vger.kernel.org>; Fri, 23 Dec 2022 16:18:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D46AC433D2;
        Fri, 23 Dec 2022 16:18:22 +0000 (UTC)
Date:   Fri, 23 Dec 2022 11:18:20 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Daniel Wagner <dwagner@suse.de>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] trace-cmd: Add initial support for meson
Message-ID: <20221223111820.07213749@gandalf.local.home>
In-Reply-To: <20221223101502.12269-3-dwagner@suse.de>
References: <20221223101502.12269-1-dwagner@suse.de>
        <20221223101502.12269-3-dwagner@suse.de>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 23 Dec 2022 11:15:02 +0100
Daniel Wagner <dwagner@suse.de> wrote:

> Add support for building the project with meson.
> 
> trace-cmd depends on a statically linked libtracecmd
> (e.g. trace_perf_open, trace_perf_close, trace_perf_init).
> 
> Instead depending libtracecmd to be compiled and installed
> separately add libtracecmd directly to trace-cmd build. This
> avoids an additional step.
> 
> We still are able to build libtracecmd as stand alone project.
> The top meson.build file just lives in the lib directory.
> 
> Signed-off-by: Daniel Wagner <dwagner@suse.de>
> ---

I forgot to mention last time, I hit this:

  meson.build:79:11: ERROR: Unknown variable "conf10".

But I added this:

diff --git a/meson.build b/meson.build
index 31f8a101190e..9c800b80d341 100644
--- a/meson.build
+++ b/meson.build
@@ -23,6 +23,7 @@ mandir    = join_paths(prefixdir, get_option('mandir'))
 htmldir   = join_paths(prefixdir, get_option('htmldir'))
 
 conf = configuration_data()
+conf10 = configuration_data()
 
 libtraceevent_dep = dependency('libtraceevent', version: '>= 1.5.0', required: true)
 libtracefs_dep = dependency('libtracefs', version: '>= 1.6.0', required: true)

As a work around. But now I get this:

../tracecmd/trace-profile.c:13:10: fatal error: libaudit.h: No such file or directory
   13 | #include <libaudit.h>
      |          ^~~~~~~~~~~~


We're missing the -DNO_AUDIT added when not there, as that file has:

#ifndef NO_AUDIT
#include <libaudit.h>
#endif


-- Steve
