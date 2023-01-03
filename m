Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C341C3DA7D
	for <linux-trace-devel@archiver.kernel.org>; Tue,  3 Jan 2023 23:38:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234208AbjACXiz (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 3 Jan 2023 18:38:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229685AbjACXiu (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 3 Jan 2023 18:38:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0247F9
        for <linux-trace-devel@vger.kernel.org>; Tue,  3 Jan 2023 15:38:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 802EA614C8
        for <linux-trace-devel@vger.kernel.org>; Tue,  3 Jan 2023 23:38:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 962B6C433F2;
        Tue,  3 Jan 2023 23:38:48 +0000 (UTC)
Date:   Tue, 3 Jan 2023 18:38:46 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc:     Ching-lin Yu <chinglinyu@google.com>
Subject: [PATCH] libtracefs: Fix tracefs_instance_set_buffer_size() for
 individual CPUs
Message-ID: <20230103183846.5ffdef36@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

The tracefs_instance_set_buffer_size() function, when passed an update for
an individual CPU, writes in "val" and not val (the string that holds the
value to set). This is obviously wrong. Fix it.

Fixes: 48c026fbb430e ("libtracefs: Add tracefs_instance_set_buffer_size() API")
Reported-by: Ching-lin Yu <chinglinyu@google.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 src/tracefs-instance.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/tracefs-instance.c b/src/tracefs-instance.c
index 6905f61ff929..57f5c7f9a000 100644
--- a/src/tracefs-instance.c
+++ b/src/tracefs-instance.c
@@ -419,7 +419,7 @@ int tracefs_instance_set_buffer_size(struct tracefs_instance *instance, size_t s
 			return ret;
 		}
 
-		ret = tracefs_instance_file_write(instance, path, "val");
+		ret = tracefs_instance_file_write(instance, path, val);
 		free(path);
 	}
 	free(val);
-- 
2.35.1

