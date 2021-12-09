Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81D1DC433FE
	for <linux-trace-devel@archiver.kernel.org>; Thu,  9 Dec 2021 10:45:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235286AbhLIKtM (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 9 Dec 2021 05:49:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235093AbhLIKtL (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 9 Dec 2021 05:49:11 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 342EAC0617A2
        for <linux-trace-devel@vger.kernel.org>; Thu,  9 Dec 2021 02:45:38 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id o20so18065315eds.10
        for <linux-trace-devel@vger.kernel.org>; Thu, 09 Dec 2021 02:45:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ioiXdU2heiWv0iNx67hiNBxvivPA+Wg4RUNhZG2Bb6c=;
        b=YhrGUMoJ3xE/VqDQ4zZa/rzrLj7y4C0ovlnKxg7XmQi+rstuMOp3zKe4gKT7+ipUmO
         AhLkvZ9xOvWqoJH0iMA+QI6+PEJzyGV3YqEEkPpLuF4TO90lW780Tearc8dLGT0eDNpR
         HRtAmKlyhsQ4hB/ysIPX13jMT4aao1PPRKkx86eRE2c/qa1ITEX3yfL4pmfkHonaAFbI
         EB0M3SSyvnzUTIidQGlAoMuOWh810/rnQVC3dQH7bSETRwrYiHm3KF61z4wUeWI0b6Ia
         3cFSdO4yNtG2hNaL/HutS4FYiSpmkzn9pUQnV27U4QtSOsTx2CU9UCEajPAgnpNh/LD0
         YCQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ioiXdU2heiWv0iNx67hiNBxvivPA+Wg4RUNhZG2Bb6c=;
        b=YRo1Eqed5R3LE+mpcbPnXkoB76wrPYAf5u7/3uhyaWiXQuzYsnK7TqkAdo3Z0grH3U
         gawSoYRupf0DQ5gWbnQ5VV3Uban1nxckn3qpyoicQTaDQJBVIrAYCwX8rXGKLdEAg1Dv
         XtewyWpNYqTOsTdAZDmtLDP+TcGdea8j7RtvVfZqPmC+wLNZ2sLgYKSIYmb7kFcl6vfv
         vYYVc4vSMYfwLvggYBNrBx6LSApC+6Igl9psMSbhAYHY5FR7UYiExxuApea6Br9IHIPj
         Qv2KHt7e2fp3hlGbn9gxOx0P2sHEGqKR2VDX9xjQlhzos+EAI7QDAUngBjGcrKr7f5jX
         TsnQ==
X-Gm-Message-State: AOAM531S5FHTOX49JgnQs/0jeTy2N/TREm6gQZIzS9HOUOBpLtldppN3
        URPN10JAuYA2X2CbOYYzKnE=
X-Google-Smtp-Source: ABdhPJx/5ZZmPal5GZXOflRTTVmuVT7MnmYQjDKwapKV8V0xA6J9rmqF6XgppGtlStSjbukA9AcBbA==
X-Received: by 2002:a17:906:7ccf:: with SMTP id h15mr14759901ejp.386.1639046736779;
        Thu, 09 Dec 2021 02:45:36 -0800 (PST)
Received: from crow.. ([95.87.219.163])
        by smtp.gmail.com with ESMTPSA id b7sm3778545edd.26.2021.12.09.02.45.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Dec 2021 02:45:36 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org, linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2 1/3] libtracefs: Rename the 'tracefs_get_hist_*()' APIs
Date:   Thu,  9 Dec 2021 12:45:22 +0200
Message-Id: <20211209104524.5354-2-y.karadz@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211209104524.5354-1-y.karadz@gmail.com>
References: <20211209104524.5354-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The following APIs are renamed:
tracefs_get_hist_name()   -> tracefs_hist_get_name()
tracefs_get_hist_event()  -> tracefs_hist_get_event()
tracefs_get_hist_system() -> tracefs_hist_get_system()

This is done in order to match the naming convention used in
the library. The patch adds documentation as well.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 Documentation/libtracefs-hist.txt | 24 +++++++++++++++++++++++-
 include/tracefs.h                 |  6 +++---
 src/tracefs-hist.c                | 24 +++++++++++++++++++++---
 3 files changed, 47 insertions(+), 7 deletions(-)

diff --git a/Documentation/libtracefs-hist.txt b/Documentation/libtracefs-hist.txt
index 2eef718..3a167e8 100644
--- a/Documentation/libtracefs-hist.txt
+++ b/Documentation/libtracefs-hist.txt
@@ -4,7 +4,8 @@ libtracefs(3)
 NAME
 ----
 tracefs_hist_alloc, tracefs_hist_free, tracefs_hist_add_key, tracefs_hist_add_value, tracefs_hist_add_name, tracefs_hist_start,
-tracefs_hist_destory, tracefs_hist_add_sort_key, tracefs_hist_set_sort_key,tracefs_hist_sort_key_direction - Create and update event histograms
+tracefs_hist_destory, tracefs_hist_add_sort_key, tracefs_hist_set_sort_key, tracefs_hist_sort_key_direction
+tracefs_hist_echo_cmd, tracefs_hist_get_name, tracefs_hist_get_event, tracefs_hist_get_system - Create, update and describe event histograms
 
 SYNOPSIS
 --------
@@ -69,6 +70,12 @@ int tracefs_hist_command(struct tracefs_instance pass:[*]instance,
 			 struct tracefs_hist pass:[*]hist,
 			 enum tracefs_hist_command command);
 
+const char *tracefs_hist_get_name(struct tracefs_hist pass:[*]hist);
+
+const char *tracefs_hist_get_event(struct tracefs_hist pass:[*]hist);
+
+const char *tracefs_hist_get_system(struct tracefs_hist pass:[*]hist);
+
 --
 
 DESCRIPTION
@@ -229,12 +236,27 @@ instead of showing the number, show the name of the running task.
 *TRACEFS_HIST_KEY_USECS* for use with "common_timestamp" or TRACEFS_HIST_TIMESTAMP,
 in which case it will show the timestamp in microseconds instead of nanoseconds.
 
+*tracefs_hist_get_name*() returns the name of the histogram or NULL on error.
+The returned string belongs to the histogram object and is freed with the histogram
+by *tracefs_hist_free*().
+
+*tracefs_hist_get_event*() returns the event name of the histogram or NULL on error.
+The returned string belongs to the histogram object and is freed with the histogram
+by *tracefs_hist_free*().
+
+*tracefs_hist_get_system*() returns the system name of the histogram or NULL on error.
+The returned string belongs to the histogram object and is freed with the histogram
+by *tracefs_hist_free*().
+
 
 RETURN VALUE
 ------------
 *tracefs_hist_alloc_nd*() returns an allocated histogram descriptor which must
 be freed by *tracefs_hist_free*() or NULL on error.
 
+*tracefs_hist_get_name*(), *tracefs_hist_get_event*() and *tracefs_hist_get_system*()
+return strings owned by the histogram object.
+
 All the other functions return zero on success or -1 on error.
 
 If *tracefs_hist_start*() returns an error, a message may be displayed
diff --git a/include/tracefs.h b/include/tracefs.h
index 3ac3d9c..b874d3f 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -354,9 +354,9 @@ struct tracefs_hist *
 tracefs_hist_alloc_nd(struct tep_handle *tep,
 		      const char *system, const char *event_name,
 		      struct tracefs_hist_axis *axes);
-const char *tracefs_get_hist_name(struct tracefs_hist *hist);
-const char *tracefs_get_hist_event(struct tracefs_hist *hist);
-const char *tracefs_get_hist_system(struct tracefs_hist *hist);
+const char *tracefs_hist_get_name(struct tracefs_hist *hist);
+const char *tracefs_hist_get_event(struct tracefs_hist *hist);
+const char *tracefs_hist_get_system(struct tracefs_hist *hist);
 int tracefs_hist_add_key(struct tracefs_hist *hist, const char *key,
 			 enum tracefs_hist_key_type type);
 int tracefs_hist_add_value(struct tracefs_hist *hist, const char *value);
diff --git a/src/tracefs-hist.c b/src/tracefs-hist.c
index ea9e127..59ac5e4 100644
--- a/src/tracefs-hist.c
+++ b/src/tracefs-hist.c
@@ -41,17 +41,35 @@ struct tracefs_hist {
 	unsigned int		filter_state;
 };
 
-const char *tracefs_get_hist_name(struct tracefs_hist *hist)
+/*
+ * tracefs_hist_get_name - get the name of the histogram
+ * @hist: The histogram to get the name for
+ *
+ * Returns name string owned by @hist on success, or NULL on error.
+ */
+const char *tracefs_hist_get_name(struct tracefs_hist *hist)
 {
 	return hist ? hist->name : NULL;
 }
 
-const char *tracefs_get_hist_event(struct tracefs_hist *hist)
+/*
+ * tracefs_hist_get_event - get the event name of the histogram
+ * @hist: The histogram to get the event name for
+ *
+ * Returns event name string owned by @hist on success, or NULL on error.
+ */
+const char *tracefs_hist_get_event(struct tracefs_hist *hist)
 {
 	return hist ? hist->event_name : NULL;
 }
 
-const char *tracefs_get_hist_system(struct tracefs_hist *hist)
+/*
+ * tracefs_hist_get_system - get the system name of the histogram
+ * @hist: The histogram to get the system name for
+ *
+ * Returns system name string owned by @hist on success, or NULL on error.
+ */
+const char *tracefs_hist_get_system(struct tracefs_hist *hist)
 {
 	return hist ? hist->system : NULL;
 }
-- 
2.32.0

