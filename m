Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84CA5C4320E
	for <linux-trace-devel@archiver.kernel.org>; Tue, 10 Aug 2021 20:48:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6B0526113B
	for <linux-trace-devel@archiver.kernel.org>; Tue, 10 Aug 2021 20:48:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233353AbhHJUsu (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 10 Aug 2021 16:48:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:44272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231705AbhHJUsr (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 10 Aug 2021 16:48:47 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 54BA16108F;
        Tue, 10 Aug 2021 20:48:25 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94.2)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1mDYfg-003hAK-7R; Tue, 10 Aug 2021 16:48:24 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Tom Zanussi <zanussi@kernel.org>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Clark Williams <williams@redhat.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 6/9] libtracefs: Add APIs tracefs_hist_data_keys/value_names()
Date:   Tue, 10 Aug 2021 16:48:15 -0400
Message-Id: <20210810204818.880714-7-rostedt@goodmis.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210810204818.880714-1-rostedt@goodmis.org>
References: <20210810204818.880714-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Add the APIs

  tracefs_hist_data_key_names()
  tracefs_hist_data_value_names()

To get the names of the keys and values respectively.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 include/tracefs.h       |  3 +++
 src/tracefs-hist-data.c | 30 ++++++++++++++++++++++++++++++
 2 files changed, 33 insertions(+)

diff --git a/include/tracefs.h b/include/tracefs.h
index 6fb66c44afc7..7aa6a3e5673a 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -428,6 +428,9 @@ struct tracefs_hist_data **tracefs_hist_data_read(struct tracefs_instance *insta
 void tracefs_hist_data_free(struct tracefs_hist_data *hdata);
 void tracefs_hist_data_free_list(struct tracefs_hist_data **hdata_list);
 
+char **tracefs_hist_data_key_names(struct tracefs_hist_data *hdata);
+char **tracefs_hist_data_value_names(struct tracefs_hist_data *hdata);
+
 struct tracefs_synth;
 
 /*
diff --git a/src/tracefs-hist-data.c b/src/tracefs-hist-data.c
index ab1ae824f59b..c93c27453255 100644
--- a/src/tracefs-hist-data.c
+++ b/src/tracefs-hist-data.c
@@ -1093,3 +1093,33 @@ tracefs_hist_data_read(struct tracefs_instance *instance,
 	return NULL;
 }
 
+/**
+ * tracefs_hist_data_key_names - return key names
+ * @hdata: The hist data descriptor to get the names from
+ *
+ * Returns a copy of the key names of the keys. The list of keys
+ * will be in the same order as the keys are listed.
+ * Returns NULL on error.
+ *
+ * Must be freed with tracefs_list_free();
+ */
+char **tracefs_hist_data_key_names(struct tracefs_hist_data *hdata)
+{
+	return tracefs_list_dup(hdata->key_names);
+}
+
+/**
+ * tracefs_hist_data_value_names - return value names
+ * @hdata: The hist data descriptor to get the names from
+ *
+ * Returns a copy of the value names of the keys. The list of keys
+ * will be in the same order as the values are listed.
+ * Returns NULL on error.
+ *
+ * Must be freed with tracefs_list_free();
+ */
+char **tracefs_hist_data_value_names(struct tracefs_hist_data *hdata)
+{
+	return tracefs_list_dup(hdata->value_names);
+}
+
-- 
2.30.2

