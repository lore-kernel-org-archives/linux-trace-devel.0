Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6DAFC352A1
	for <linux-trace-devel@archiver.kernel.org>; Tue,  6 Dec 2022 21:13:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229507AbiLFVNV (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 6 Dec 2022 16:13:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbiLFVNU (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 6 Dec 2022 16:13:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 993AF2AED
        for <linux-trace-devel@vger.kernel.org>; Tue,  6 Dec 2022 13:13:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 567CEB81A21
        for <linux-trace-devel@vger.kernel.org>; Tue,  6 Dec 2022 21:13:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85DC6C433D6;
        Tue,  6 Dec 2022 21:13:16 +0000 (UTC)
Date:   Tue, 6 Dec 2022 16:13:14 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Bean Huo <beanhuo@iokpp.de>
Cc:     linux-trace-devel@vger.kernel.org, tz.stoyanov@gmail.com,
        Bean Huo <beanhuo@micron.com>
Subject: Re: [PATCH] libtracefs: Fix wrong return value in
 tracefs_tracing_dir_is_mounted()
Message-ID: <20221206161314.73ecbfd2@gandalf.local.home>
In-Reply-To: <20221128133715.288fb265@gandalf.local.home>
References: <20221128132106.291101-1-beanhuo@iokpp.de>
        <20221128102410.5ccf784d@gandalf.local.home>
        <e6c020fc59cd3a2333806fbaf2a90092866fb7b7.camel@iokpp.de>
        <20221128133715.288fb265@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 28 Nov 2022 13:37:15 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:

> Ah, I think I see the issue here. If it returns NULL, then we need to do
> more. I'll take a look into this later today.

Can you test this patch?

Thanks,

-- Steve

diff --git a/src/tracefs-utils.c b/src/tracefs-utils.c
index 777912e46821..d91ff40eee87 100644
--- a/src/tracefs-utils.c
+++ b/src/tracefs-utils.c
@@ -245,7 +245,7 @@ const char *tracefs_tracing_dir(void)
 	if (tracing_dir)
 		return tracing_dir;
 
-	tracing_dir = trace_find_tracing_dir(false);
+	tracing_dir = find_tracing_dir(false, true);
 	return tracing_dir;
 }
 
@@ -263,7 +263,7 @@ const char *tracefs_debug_dir(void)
 	if (debug_dir)
 		return debug_dir;
 
-	debug_dir = trace_find_tracing_dir(true);
+	debug_dir = find_tracing_dir(true, true);
 	return debug_dir;
 }
 
