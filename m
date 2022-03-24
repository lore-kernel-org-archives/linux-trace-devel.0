Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E32D8C433EF
	for <linux-trace-devel@archiver.kernel.org>; Thu, 24 Mar 2022 00:08:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346779AbiCXAKK (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 23 Mar 2022 20:10:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346775AbiCXAKD (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 23 Mar 2022 20:10:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1270E201B4
        for <linux-trace-devel@vger.kernel.org>; Wed, 23 Mar 2022 17:08:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4C0EFB821C3
        for <linux-trace-devel@vger.kernel.org>; Thu, 24 Mar 2022 00:08:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01BB7C36AE2;
        Thu, 24 Mar 2022 00:08:07 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1nXB1K-0071Sb-UH;
        Wed, 23 Mar 2022 20:08:06 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 2/2] trace-cmd library: Fix memory leak of page_maps
Date:   Wed, 23 Mar 2022 20:08:05 -0400
Message-Id: <20220324000805.1666464-3-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220324000805.1666464-1-rostedt@goodmis.org>
References: <20220324000805.1666464-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

tracecmd_close() does not free up the page_maps for when it reads v6
files. This was found via valgrind.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 lib/trace-cmd/trace-input.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 358b47935602..a902cfbdc567 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -4447,6 +4447,7 @@ void tracecmd_close(struct tracecmd_input *handle)
 	struct zchunk_cache *cache;
 	struct file_section *del_sec;
 	struct cpu_data *cpu_data;
+	struct page_map *page_map, *n;
 	int cpu;
 	int i;
 
@@ -4491,6 +4492,10 @@ void tracecmd_close(struct tracecmd_input *handle)
 				free(cache);
 			}
 			free(cpu_data->compress.chunks);
+			list_for_each_entry_safe(page_map, n, &cpu_data->page_maps, list) {
+				list_del(&page_map->list);
+				free(page_map);
+			}
 		}
 	}
 
-- 
2.35.1

