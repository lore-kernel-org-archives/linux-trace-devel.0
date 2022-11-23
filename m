Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 247E8C433FE
	for <linux-trace-devel@archiver.kernel.org>; Wed, 23 Nov 2022 18:33:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239712AbiKWSdt (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 23 Nov 2022 13:33:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239732AbiKWSdL (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 23 Nov 2022 13:33:11 -0500
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CD294D7;
        Wed, 23 Nov 2022 10:32:54 -0800 (PST)
Received: from W11-BEAU-MD.localdomain (unknown [76.135.50.127])
        by linux.microsoft.com (Postfix) with ESMTPSA id D537420B83C2;
        Wed, 23 Nov 2022 10:32:53 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com D537420B83C2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1669228373;
        bh=HFS/TFV5Fr1gZcBh1KwYegY7XKpVS5/yp/VV3VDAkFs=;
        h=From:To:Cc:Subject:Date:From;
        b=SsN5BCR/KIuwbC887JFaiXfq0yDwvoxWluS1/Rn/4ffQbgyz9ZbLG6A8DuvqLD3zh
         6gb5y2g0m6X065EBT1xP/3Dir320ma4niyB7jw+FnVmWJUE26yNYe3F0VIBVMR8bk2
         iC6nfm/f0ZA8CGWPFNUobQxzIkbtRvCZ2ts+Yhls=
From:   Beau Belgrave <beaub@linux.microsoft.com>
To:     rostedt@goodmis.org, mhiramat@kernel.org
Cc:     linux-trace-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] tracing/user_events: Fix call print_fmt leak
Date:   Wed, 23 Nov 2022 10:32:48 -0800
Message-Id: <20221123183248.554-1-beaub@linux.microsoft.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

If user_event_trace_register() fails within user_event_parse() the
call's print_fmt member is not freed. Add kfree call to fix this.

Fixes: aa3b2b4c6692 ("user_events: Add print_fmt generation support for basic types")
Signed-off-by: Beau Belgrave <beaub@linux.microsoft.com>
---
 kernel/trace/trace_events_user.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/trace/trace_events_user.c b/kernel/trace/trace_events_user.c
index ae78c2d53c8a..b46844736015 100644
--- a/kernel/trace/trace_events_user.c
+++ b/kernel/trace/trace_events_user.c
@@ -1357,6 +1357,7 @@ static int user_event_parse(struct user_event_group *group, char *name,
 put_user:
 	user_event_destroy_fields(user);
 	user_event_destroy_validators(user);
+	kfree(user->call.print_fmt);
 	kfree(user);
 	return ret;
 }
-- 
2.25.1

