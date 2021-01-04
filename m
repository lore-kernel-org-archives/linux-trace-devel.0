Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77FACC433E0
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 Jan 2021 17:48:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 53928206CB
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 Jan 2021 17:48:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726019AbhADRsT (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 4 Jan 2021 12:48:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725889AbhADRsS (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 4 Jan 2021 12:48:18 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B640C061793
        for <linux-trace-devel@vger.kernel.org>; Mon,  4 Jan 2021 09:47:38 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id r5so28191902eda.12
        for <linux-trace-devel@vger.kernel.org>; Mon, 04 Jan 2021 09:47:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ctl/1hc1CjgpqETA+YlX+MS6l+shLWrhVEkHHBmBygY=;
        b=dTrLrVAuOEe1Y3zT+63siD5MWNgksQ++tBgn2buEuWMxMqKKVzFVrjKe38iT4PVfqf
         RkuFvQD0XeUeTa1vKc701bs9//gdR5qRcPDif8UjcrSLDhUEpOpod9uBtyfbJhjA9fqa
         UvJ+sOHaNOrA0Bz4vML2Tyfqaj6US9gN5eP4U1O/3tCe4VvpZd8jJLjfRL1/bhPJ67Kr
         aEztcGDCvpeqI7DH4OIwA1qshX5faHmcHPfGuIsLdN8N83rl6CsrbPQPyKQTvgxfGXHv
         jQM/Ry1juI/i/etetCqkuE7MsjP672/FZtAbWnshQW9eficKk68SNknEBMRD5itl0mIS
         N1ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ctl/1hc1CjgpqETA+YlX+MS6l+shLWrhVEkHHBmBygY=;
        b=NWLhhxIcP4sUQT4pv/u4MxGmbzzTZr+KqiItQhD0r26RxhLUNA86VFkhl3qUawZ73p
         GjKyS77PkGro+3fZGv5AM/eto+FQIM0Q8sT9efSDRvdUFf5OqVQe3GpD3oUjaGRQ9psz
         Pb5MmOfonAW+11pGmaxVEWkj0mf7a7f0yphrjL4Imk93cU80IXXFeoFZugc3W/4jIrSb
         E7rMEnGB98jX/0GPzFaaCGb4l5k0B4LCLvfUDUxmTnZ14qHzCyzkbkOrf/mu1cDg0Lya
         xSGNS4bh9Swy4ddUxenSSQVgxkPcMuB1GP670eOxlPVb2af0ZziqCj2Hc/RWicbbw7z5
         bOYA==
X-Gm-Message-State: AOAM531GWb8yeSkojtjfprx7QSDwL5tYtFORR/ymBIb6FBGyw1CLewGx
        qEtVsscoZxD5bCUpaxYMqYfnE0QDRpWADQ==
X-Google-Smtp-Source: ABdhPJyIoBlDV/4siZj6gKtCGSkihg09BvyjRtGmtmoNVqheRNMXqQatwDiIMxEDL292lvXqM8+u2Q==
X-Received: by 2002:aa7:cb49:: with SMTP id w9mr74215709edt.357.1609782457226;
        Mon, 04 Jan 2021 09:47:37 -0800 (PST)
Received: from localhost.localdomain ([95.87.199.238])
        by smtp.gmail.com with ESMTPSA id l14sm44107750edq.35.2021.01.04.09.47.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Jan 2021 09:47:36 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v8 01/44] kernel-shark: Adopt trace-cmd API changes
Date:   Mon,  4 Jan 2021 19:46:41 +0200
Message-Id: <20210104174724.70404-2-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210104174724.70404-1-y.karadz@gmail.com>
References: <20210104174724.70404-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Use the new names of the methods

free_record() -> tracecmd_free_record()
tracecmd_get_pevent() -> tracecmd_get_tep()

follow the tracecmd library naming convention.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/libkshark.c            | 20 ++++++++++----------
 src/plugins/sched_events.c |  4 ++--
 2 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/src/libkshark.c b/src/libkshark.c
index 52aacd3..42dc08c 100644
--- a/src/libkshark.c
+++ b/src/libkshark.c
@@ -151,7 +151,7 @@ bool kshark_open(struct kshark_context *kshark_ctx, const char *file)
 	}
 
 	kshark_ctx->handle = handle;
-	kshark_ctx->pevent = tracecmd_get_pevent(handle);
+	kshark_ctx->pevent =  tracecmd_get_tep(handle);
 
 	kshark_ctx->advanced_event_filter =
 		tep_filter_alloc(kshark_ctx->pevent);
@@ -674,7 +674,7 @@ static void free_rec_list(struct rec_list **rec_list, int n_cpus,
 			temp_rec = rec_list[cpu];
 			rec_list[cpu] = temp_rec->next;
 			if (type == REC_RECORD)
-				free_record(temp_rec->rec);
+				tracecmd_free_record(temp_rec->rec);
 			free(temp_rec);
 		}
 	}
@@ -774,14 +774,14 @@ static ssize_t get_records(struct kshark_context *kshark_ctx,
 				if (!kshark_show_task(kshark_ctx, entry->pid)) {
 					entry->visible &= ~kshark_ctx->filter_mask;
 				}
-				free_record(rec);
+				tracecmd_free_record(rec);
 				break;
 			} /* REC_ENTRY */
 			}
 
 			task = kshark_add_task(kshark_ctx, pid);
 			if (!task) {
-				free_record(rec);
+				tracecmd_free_record(rec);
 				goto fail;
 			}
 
@@ -902,7 +902,7 @@ ssize_t kshark_load_data_entries(struct kshark_context *kshark_ctx,
  *	  to all fields of the record.
  *
  * @param kshark_ctx: Input location for the session context pointer.
- * @param data_rows: Output location for the trace data. Use free_record()
+ * @param data_rows: Output location for the trace data. Use tracecmd_free_record()
  *	 	     to free the elements of the outputted array.
  *
  * @returns The size of the outputted data in the case of success, or a
@@ -1167,7 +1167,7 @@ int kshark_get_pid_easy(struct kshark_entry *entry)
 		data = tracecmd_read_at(kshark_ctx->handle, entry->offset,
 					NULL);
 		pid = tep_data_pid(kshark_ctx->pevent, data);
-		free_record(data);
+		tracecmd_free_record(data);
 
 		pthread_mutex_unlock(&kshark_ctx->input_mutex);
 	}
@@ -1234,7 +1234,7 @@ const char *kshark_get_latency_easy(struct kshark_entry *entry)
 
 	data = tracecmd_read_at(kshark_ctx->handle, entry->offset, NULL);
 	lat = kshark_get_latency(kshark_ctx->pevent, data);
-	free_record(data);
+	tracecmd_free_record(data);
 
 	pthread_mutex_unlock(&kshark_ctx->input_mutex);
 
@@ -1279,7 +1279,7 @@ int kshark_get_event_id_easy(struct kshark_entry *entry)
 		data = tracecmd_read_at(kshark_ctx->handle, entry->offset,
 					NULL);
 		event_id = tep_data_type(kshark_ctx->pevent, data);
-		free_record(data);
+		tracecmd_free_record(data);
 
 		pthread_mutex_unlock(&kshark_ctx->input_mutex);
 	}
@@ -1378,7 +1378,7 @@ const char *kshark_get_info_easy(struct kshark_entry *entry)
 	if (event)
 		info = kshark_get_info(kshark_ctx->pevent, data, event);
 
-	free_record(data);
+	tracecmd_free_record(data);
 
 	pthread_mutex_unlock(&kshark_ctx->input_mutex);
 
@@ -1492,7 +1492,7 @@ char* kshark_dump_entry(const struct kshark_entry *entry)
 			free(temp_str);
 		}
 
-		free_record(data);
+		tracecmd_free_record(data);
 		if (size < 1)
 			entry_str = NULL;
 	} else {
diff --git a/src/plugins/sched_events.c b/src/plugins/sched_events.c
index d0fd15e..4b671f1 100644
--- a/src/plugins/sched_events.c
+++ b/src/plugins/sched_events.c
@@ -160,7 +160,7 @@ static int find_wakeup_pid(struct kshark_context *kshark_ctx, struct kshark_entr
 
 	record = tracecmd_read_at(kshark_ctx->handle, e->offset, NULL);
 	ret = tep_read_number_field(pid_field, record->data, &val);
-	free_record(record);
+	tracecmd_free_record(record);
 
 	if (ret)
 		return -1;
@@ -252,7 +252,7 @@ bool plugin_switch_match_rec_pid(struct kshark_context *kshark_ctx,
 		if (ret == 0 && !(val & 0x7f))
 			switch_pid = tep_data_pid(plugin_ctx->pevent, record);
 
-		free_record(record);
+		tracecmd_free_record(record);
 	}
 
 	if (switch_pid >= 0 && switch_pid == pid)
-- 
2.25.1

