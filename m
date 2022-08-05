Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16BE2C25B07
	for <linux-trace-devel@archiver.kernel.org>; Fri,  5 Aug 2022 15:40:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240760AbiHEPky (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 5 Aug 2022 11:40:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236776AbiHEPkr (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 5 Aug 2022 11:40:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6111E18E38
        for <linux-trace-devel@vger.kernel.org>; Fri,  5 Aug 2022 08:40:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F3131615EA
        for <linux-trace-devel@vger.kernel.org>; Fri,  5 Aug 2022 15:40:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 077C0C43142;
        Fri,  5 Aug 2022 15:40:42 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.96)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1oJzRJ-008S4Y-3D;
        Fri, 05 Aug 2022 11:40:42 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 5/9] trace-cmd library: Allow callers to save private data in tracecmd_input handlers
Date:   Fri,  5 Aug 2022 11:40:36 -0400
Message-Id: <20220805154040.2014381-6-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220805154040.2014381-1-rostedt@goodmis.org>
References: <20220805154040.2014381-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Add a private field for tracecmd_input handle where callers can set it via
tracecmd_set_private() and retrieve it with tracecmd_get_private(). This
will allow a way to find specific information about a handle for users of
tracecmd_iterate_events_multi().

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 include/trace-cmd/trace-cmd.h |  3 +++
 lib/trace-cmd/trace-input.c   | 12 ++++++++++++
 2 files changed, 15 insertions(+)

diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index 86a3486972cc..e8d72c76c02a 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -48,6 +48,9 @@ int tracecmd_buffer_instances(struct tracecmd_input *handle);
 const char *tracecmd_buffer_instance_name(struct tracecmd_input *handle, int indx);
 struct tracecmd_input *tracecmd_buffer_instance_handle(struct tracecmd_input *handle, int indx);
 
+void tracecmd_set_private(struct tracecmd_input *handle, void *data);
+void *tracecmd_get_private(struct tracecmd_input *handle);
+
 int tracecmd_iterate_events(struct tracecmd_input *handle,
 			    cpu_set_t *cpus, int cpu_size,
 			    int (*callback)(struct tracecmd_input *handle,
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 5df10716013d..a3f17070c269 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -215,6 +215,8 @@ struct tracecmd_input {
 
 	/* For custom profilers. */
 	tracecmd_show_data_func	show_data_func;
+
+	void			*private;
 };
 
 __thread struct tracecmd_input *tracecmd_curr_thread_handle;
@@ -245,6 +247,16 @@ enum tracecmd_file_states tracecmd_get_file_state(struct tracecmd_input *handle)
 	return handle->file_state;
 }
 
+void tracecmd_set_private(struct tracecmd_input *handle, void *data)
+{
+	handle->private = data;
+}
+
+void *tracecmd_get_private(struct tracecmd_input *handle)
+{
+	return handle->private;
+}
+
 #if DEBUG_RECORD
 static void remove_record(struct page *page, struct tep_record *record)
 {
-- 
2.35.1

