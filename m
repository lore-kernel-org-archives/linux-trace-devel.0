Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6840C43334
	for <linux-trace-devel@archiver.kernel.org>; Tue, 28 Jun 2022 15:21:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347823AbiF1PVi (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 28 Jun 2022 11:21:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344555AbiF1PVi (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 28 Jun 2022 11:21:38 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C26832EF9
        for <linux-trace-devel@vger.kernel.org>; Tue, 28 Jun 2022 08:21:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 2CF39CE2114
        for <linux-trace-devel@vger.kernel.org>; Tue, 28 Jun 2022 15:21:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24CFAC3411D;
        Tue, 28 Jun 2022 15:21:33 +0000 (UTC)
Date:   Tue, 28 Jun 2022 11:21:31 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc:     Chuck Lever III <chuck.lever@oracle.com>
Subject: [PATCH] libtraceevent: Warn when kallsyms exits due to parsing
 error
Message-ID: <20220628112131.3f306e97@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

If the kallsyms has a corrupted line, it will exit the parsing. This can
be confusing to users that expect to see function address converted into
names.

Add a tep_warning() when this happens. At least the library will warn
about it (although trace-cmd requires --verbose to see it).

Link: https://lore.kernel.org/all/355D2478-33D3-4046-8422-E512F42C51BC@oracle.com/

Reported-by: Chuck Lever III <chuck.lever@oracle.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 src/event-parse.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/src/event-parse.c b/src/event-parse.c
index 4bbf29727e9f..823333a3bde4 100644
--- a/src/event-parse.c
+++ b/src/event-parse.c
@@ -739,8 +739,11 @@ int tep_parse_kallsyms(struct tep_handle *tep, const char *kallsyms)
 		if (errno)
 			goto out;
 
-		if (n != 2 || !func_end)
+		if (n != 2 || !func_end) {
+			tep_warning("Failed to parse kallsyms n=%d func_end=%d",
+				    n, func_end);
 			goto out;
+		}
 
 		func = line + func_start;
 		/*
-- 
2.35.1

