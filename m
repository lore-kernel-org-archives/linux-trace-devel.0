Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 333E2C43460
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Apr 2021 12:28:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 042C76141E
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Apr 2021 12:28:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235833AbhD1M3b (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 28 Apr 2021 08:29:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236337AbhD1M3a (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Apr 2021 08:29:30 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BD93C061574
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Apr 2021 05:28:46 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id g14so14284307edy.6
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Apr 2021 05:28:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RoHJW8v1IN+0e0bayeOW7SbjCJ8zaHs6/DcIJkhnGXw=;
        b=lhNCthXlAhPcJ2n2UdBEGyqJhOeTuVOBT9uBc8zdUKI5wfDsbtsBgz6QpGh4d6KBXJ
         m2Tn9V294bihpH3XFbwp8z7pH42WDebZvZyfrDcyuYuQBuiG8n9UkZDEbP+ozLPyXtuf
         JxLD4ek9Pv1D7FhslT/SLpffI+zwi0uaPTW6sFNhmqCBW6yr8bFfSIgpvVTphVLzX1Du
         XajtjLwhPSRG8/sbxOCe4MN7hhL3iQKAP5njD51zwkUnLKQIXKl+xA+My5ohx5e1eFDj
         iddMNHcpFuu9ZF8WDQiYkVHzscnIXFhlYa1+8j5fonVCqogdhtlnZzNx7J01F0u9CD4G
         5Lxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RoHJW8v1IN+0e0bayeOW7SbjCJ8zaHs6/DcIJkhnGXw=;
        b=J84DM76gBlXTXNLwB58qpmOCk6Ab/HSa+/YfD7J28iVBctZBR440iiwNYCugbhgBJI
         AkWGBxOCLBnmgQZx9s7hpLhlpEP4kepnxsj4wHmLBk4qM46L14PZRf4N4hFhUH1OMtcv
         Y2xkJKYT7GdtPjq/zhDynsgioTFiKtfyqZbqHD7IxDWzqbrgOiK/JfpPp9SKlcc/J0aE
         DsizOK+LcR/nB4HBfGT42Rh0tlGcSBZlMlJjFhwNmdj+tWVkUVWANrWrXjCRmvoxlpzs
         Jvd5oEBDRpVfR3CH4renXu6SI+rc0MNS4neWfF4HxegDIKncvjlyy418XGPD/5ALOe/2
         ro2A==
X-Gm-Message-State: AOAM532Dts7JGkuPzedAEhFlQ2uXr7Qt3mb5DE7Oe9OL5a3gvrzRZ/GO
        76TiQUpTFzt8wMEzMtYD8ftlSJifJY9E3g==
X-Google-Smtp-Source: ABdhPJxyr6QVk95AdO5Z3OaG+T3mDpdALismX/R6yvkxem+nPufz+SrEQTb+sqVC/XnNKNdrv1nurQ==
X-Received: by 2002:aa7:d543:: with SMTP id u3mr10892043edr.26.1619612924860;
        Wed, 28 Apr 2021 05:28:44 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id n10sm1846546ejg.124.2021.04.28.05.28.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Apr 2021 05:28:44 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 3/5] trace-cmd library: Store the timestamp of the first event when reading a trace file
Date:   Wed, 28 Apr 2021 15:28:37 +0300
Message-Id: <20210428122839.805296-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210428122839.805296-1-tz.stoyanov@gmail.com>
References: <20210428122839.805296-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

When reading a trace file, detect and store the timestamp of the first
recorded event. A new API is introduced to get the first ts from an input
handler:
 tracecmd_get_first_ts()
The first ts can be used by the library users to align timestamps of the
events, when displaying them.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 include/trace-cmd/trace-cmd.h |  1 +
 lib/trace-cmd/trace-input.c   | 23 +++++++++++++++++++++++
 2 files changed, 24 insertions(+)

diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index 162cd318..022720b0 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -37,6 +37,7 @@ int tracecmd_get_guest_cpumap(struct tracecmd_input *handle,
 			      unsigned long long trace_id,
 			      const char **name,
 			      int *vcpu_count, const int **cpu_pid);
+unsigned long long tracecmd_get_first_ts(struct tracecmd_input *handle);
 int tracecmd_buffer_instances(struct tracecmd_input *handle);
 const char *tracecmd_buffer_instance_name(struct tracecmd_input *handle, int indx);
 struct tracecmd_input *tracecmd_buffer_instance_handle(struct tracecmd_input *handle, int indx);
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index bacf9ccf..284f25e8 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -61,6 +61,7 @@ struct cpu_data {
 	unsigned long long	offset;
 	unsigned long long	size;
 	unsigned long long	timestamp;
+	unsigned long long	first_ts;
 	struct list_head	page_maps;
 	struct page_map		*page_map;
 	struct page		**pages;
@@ -2273,6 +2274,7 @@ static int init_cpu(struct tracecmd_input *handle, int cpu)
 
 	if (update_page_info(handle, cpu))
 		goto fail;
+	cpu_data->first_ts = cpu_data->timestamp;
 
 	return 0;
  fail:
@@ -4072,6 +4074,27 @@ unsigned long long tracecmd_get_traceid(struct tracecmd_input *handle)
 	return handle->trace_id;
 }
 
+/**
+ * tracecmd_get_first_ts - get the timestamp of the first recorded event
+ * @handle: input handle for the trace.dat file
+ *
+ * Returns the timestamp of the first recorded event
+ */
+unsigned long long tracecmd_get_first_ts(struct tracecmd_input *handle)
+{
+	unsigned long long ts = 0;
+	bool first = true;
+	int i;
+
+	for (i = 0; i < handle->cpus; i++) {
+		if (first || ts > handle->cpu_data[i].first_ts)
+			ts = handle->cpu_data[i].first_ts;
+		first = false;
+	}
+
+	return ts;
+}
+
 /**
  * tracecmd_get_guest_cpumap - get the mapping of guest VCPU to host process
  * @handle: input handle for the trace.dat file
-- 
2.30.2

