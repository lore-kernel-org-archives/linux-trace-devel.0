Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50AEFC43334
	for <linux-trace-devel@archiver.kernel.org>; Wed, 15 Jun 2022 02:54:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243570AbiFOCyk (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 14 Jun 2022 22:54:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231631AbiFOCyk (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 14 Jun 2022 22:54:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70B7C33374
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Jun 2022 19:54:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C6ADD60DC8
        for <linux-trace-devel@vger.kernel.org>; Wed, 15 Jun 2022 02:54:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 308C8C341C0;
        Wed, 15 Jun 2022 02:54:38 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1o1JAz-002Nx5-0K;
        Tue, 14 Jun 2022 22:54:37 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>,
        Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH 2/2] trace-cmd library: Fix reading of temp file used to decompress
Date:   Tue, 14 Jun 2022 22:54:36 -0400
Message-Id: <20220615025436.568682-3-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220615025436.568682-1-rostedt@goodmis.org>
References: <20220615025436.568682-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

When not using read_zpage, and reading from a temporary file, the offsets
are not accounted for properly. That is, it uses the offset of the
location of the trace.dat file to map the temporary file (that starts at
offset zero).

Account for mapping of the temporary file when appropriate.

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Fixes: add83e0c8b51 ("trace-cmd library: Fix tracecmd_read_at()")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 lib/trace-cmd/trace-input.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index c181c7d93be4..0fef2ca7bb70 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -1401,8 +1401,11 @@ static void *allocate_page_map(struct tracecmd_input *handle,
 	int ret;
 	int fd;
 
-	if (handle->cpu_compressed && handle->read_zpage)
-		return read_zpage(handle, cpu, offset);
+	if (handle->cpu_compressed) {
+		if (handle->read_zpage)
+			return read_zpage(handle, cpu, offset);
+		offset -= cpu_data->file_offset;
+	}
 
 	if (handle->read_page) {
 		map = malloc(handle->page_size);
@@ -1419,7 +1422,7 @@ static void *allocate_page_map(struct tracecmd_input *handle,
 	map_size = handle->page_map_size;
 	map_offset = offset & ~(map_size - 1);
 
-	if (map_offset < cpu_data->file_offset) {
+	if (!handle->cpu_compressed && map_offset < cpu_data->file_offset) {
 		map_size -= cpu_data->file_offset - map_offset;
 		map_offset = cpu_data->file_offset;
 	}
@@ -1442,10 +1445,9 @@ static void *allocate_page_map(struct tracecmd_input *handle,
 		map_size -= map_offset + map_size -
 			(cpu_data->file_offset + cpu_data->file_size);
 
-	if (cpu_data->compress.fd >= 0) {
-		map_offset -= cpu_data->file_offset;
+	if (cpu_data->compress.fd >= 0)
 		fd = cpu_data->compress.fd;
-	} else
+	else
 		fd = handle->fd;
  again:
 	page_map->size = map_size;
-- 
2.35.1

