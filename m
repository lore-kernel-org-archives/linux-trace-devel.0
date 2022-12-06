Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C62D9C352A1
	for <linux-trace-devel@archiver.kernel.org>; Tue,  6 Dec 2022 21:20:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229744AbiLFVUM convert rfc822-to-8bit (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 6 Dec 2022 16:20:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229774AbiLFVUH (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 6 Dec 2022 16:20:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 859FD48432
        for <linux-trace-devel@vger.kernel.org>; Tue,  6 Dec 2022 13:20:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2457B618C9
        for <linux-trace-devel@vger.kernel.org>; Tue,  6 Dec 2022 21:20:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53873C433D6
        for <linux-trace-devel@vger.kernel.org>; Tue,  6 Dec 2022 21:20:02 +0000 (UTC)
Date:   Tue, 6 Dec 2022 16:20:00 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] kbuffer: Add struct reference for tep_handle
Message-ID: <20221206162000.289aca7a@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Hit this compile error:

include/traceevent/kbuffer.h:32:39: warning: ‘struct tep_handle’ declared inside parameter list will not be visible outside of this definition or declaration
   32 | struct kbuffer *kbuffer_create(struct tep_handle *tep);

kbuffer.h does not include event-parse.h, so it needs to declare
sturct tep_handle too.

Fixes: 21ba633645 ("libtraceevent: Add kbuffer_create()")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 include/traceevent/kbuffer.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/traceevent/kbuffer.h b/include/traceevent/kbuffer.h
index 66b095833b81..c8983a000585 100644
--- a/include/traceevent/kbuffer.h
+++ b/include/traceevent/kbuffer.h
@@ -27,6 +27,7 @@ enum {
 };
 
 struct kbuffer;
+struct tep_handle;
 
 struct kbuffer *kbuffer_alloc(enum kbuffer_long_size size, enum kbuffer_endian endian);
 struct kbuffer *kbuffer_create(struct tep_handle *tep);
-- 
2.35.1

