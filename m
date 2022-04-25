Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5AA0C433EF
	for <linux-trace-devel@archiver.kernel.org>; Mon, 25 Apr 2022 18:46:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244588AbiDYStx (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 25 Apr 2022 14:49:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244567AbiDYStt (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 25 Apr 2022 14:49:49 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B87AF6F4AA;
        Mon, 25 Apr 2022 11:46:44 -0700 (PDT)
Received: from localhost.localdomain (c-73-140-2-214.hsd1.wa.comcast.net [73.140.2.214])
        by linux.microsoft.com (Postfix) with ESMTPSA id F22DA20E8CAC;
        Mon, 25 Apr 2022 11:46:43 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com F22DA20E8CAC
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1650912404;
        bh=ZmUiorrcv4hSBgHHc4SmHe16T+eq+bKCUHOlyXmVWb8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b+k0xqPXHFbAtfHWKHC34qI5dYzSEAkeqEGKU9kn83ypInT59deJfM81m5Z8ic58J
         SulDKl9SrMCc8ZGzQ2kL1/+CIJVv17zSaoQfqE6arA9WpFP3JH/WHaZkqSgBY0zxvd
         mSolsimvFe+KFG0BcJ60XpNvlPY5ASqe6xlC8H6o=
From:   Beau Belgrave <beaub@linux.microsoft.com>
To:     rostedt@goodmis.org, mhiramat@kernel.org,
        mathieu.desnoyers@efficios.com
Cc:     linux-trace-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, beaub@linux.microsoft.com
Subject: [PATCH v2 3/7] tracing/user_events: Use WRITE instead of READ for io vector import
Date:   Mon, 25 Apr 2022 11:46:27 -0700
Message-Id: <20220425184631.2068-4-beaub@linux.microsoft.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220425184631.2068-1-beaub@linux.microsoft.com>
References: <20220425184631.2068-1-beaub@linux.microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

import_single_range expects the direction/rw to be where it came from,
not the protection/limit. Since the import is in a write path use WRITE.

Link: https://lore.kernel.org/all/2059213643.196683.1648499088753.JavaMail.zimbra@efficios.com/

Reported-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Signed-off-by: Beau Belgrave <beaub@linux.microsoft.com>
---
 kernel/trace/trace_events_user.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/trace/trace_events_user.c b/kernel/trace/trace_events_user.c
index 075d694d20e3..15edbf6b1e2e 100644
--- a/kernel/trace/trace_events_user.c
+++ b/kernel/trace/trace_events_user.c
@@ -1245,7 +1245,8 @@ static ssize_t user_events_write(struct file *file, const char __user *ubuf,
 	if (unlikely(*ppos != 0))
 		return -EFAULT;
 
-	if (unlikely(import_single_range(READ, (char *)ubuf, count, &iov, &i)))
+	if (unlikely(import_single_range(WRITE, (char __user *)ubuf,
+					 count, &iov, &i)))
 		return -EFAULT;
 
 	return user_events_write_core(file, &i);
-- 
2.25.1

