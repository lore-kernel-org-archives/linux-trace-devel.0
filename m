Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3AAFC4332F
	for <linux-trace-devel@archiver.kernel.org>; Fri, 23 Dec 2022 16:24:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231329AbiLWQYe (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 23 Dec 2022 11:24:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230423AbiLWQYd (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 23 Dec 2022 11:24:33 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 916262BDB
        for <linux-trace-devel@vger.kernel.org>; Fri, 23 Dec 2022 08:24:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id DA400CE1CF3
        for <linux-trace-devel@vger.kernel.org>; Fri, 23 Dec 2022 16:24:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB99BC433EF;
        Fri, 23 Dec 2022 16:24:27 +0000 (UTC)
Date:   Fri, 23 Dec 2022 11:24:25 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Daniel Wagner <dwagner@suse.de>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] trace-cmd: Add initial support for meson
Message-ID: <20221223112425.55aab646@gandalf.local.home>
In-Reply-To: <20221223111820.07213749@gandalf.local.home>
References: <20221223101502.12269-1-dwagner@suse.de>
        <20221223101502.12269-3-dwagner@suse.de>
        <20221223111820.07213749@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 23 Dec 2022 11:18:20 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:

> As a work around. But now I get this:
> 
> ../tracecmd/trace-profile.c:13:10: fatal error: libaudit.h: No such file or directory
>    13 | #include <libaudit.h>
>       |          ^~~~~~~~~~~~
> 
> 
> We're missing the -DNO_AUDIT added when not there, as that file has:

I guess something like this is needed?

diff --git a/meson.build b/meson.build
index 31f8a101190e..d2cfe15b4a60 100644
--- a/meson.build
+++ b/meson.build
@@ -78,6 +79,12 @@ audit_dep = dependency('audit', required: false)
 if not audit_dep.found()
     conf10.set('NO_AUDIT', true, description: 'Is audit missing?')
     conf.set('WARN_NO_AUDIT', true, description: 'Issue no audit warning?')
+    add_project_arguments(
+       [
+         '-DNO_AUDIT'
+       ],
+       language : 'c',
+    )
 endif
 
 config_h = configure_file(

-- Steve
