Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A371DC00140
	for <linux-trace-devel@archiver.kernel.org>; Tue, 16 Aug 2022 01:29:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240023AbiHPB3v (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 15 Aug 2022 21:29:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232723AbiHPB3e (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 15 Aug 2022 21:29:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A9B01D510E
        for <linux-trace-devel@vger.kernel.org>; Mon, 15 Aug 2022 14:20:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3432C60F25
        for <linux-trace-devel@vger.kernel.org>; Mon, 15 Aug 2022 21:20:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66FB9C433C1
        for <linux-trace-devel@vger.kernel.org>; Mon, 15 Aug 2022 21:20:49 +0000 (UTC)
Date:   Mon, 15 Aug 2022 17:20:56 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] trace-cmd: Do not return zero length name for guest by name
Message-ID: <20220815172056.37ec14c8@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

The function trace_get_guest() will first look for a guest by name, and
if it finds one, it will return it. But if the guest added did not have
a name (but had an empty string), it would return any guest that also
did not have a name (but just an empty string). If two guests did not
have a name, and the CID was used, then the first guest would be
returned for the second guest, breaking the creating of two guests where
both were without names.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 tracecmd/trace-vm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tracecmd/trace-vm.c b/tracecmd/trace-vm.c
index 09bd60259258..f78f1d83386b 100644
--- a/tracecmd/trace-vm.c
+++ b/tracecmd/trace-vm.c
@@ -35,7 +35,7 @@ static struct trace_guest *get_guest_by_name(const char *name)
 {
 	int i;
 
-	if (!guests)
+	if (!guests || !strlen(name))
 		return NULL;
 
 	for (i = 0; i < guests_len; i++)
-- 
2.35.1

