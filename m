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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A93FC43461
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Apr 2021 12:28:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E804661158
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Apr 2021 12:28:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236337AbhD1M3c (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 28 Apr 2021 08:29:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236440AbhD1M3b (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Apr 2021 08:29:31 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ADF3C061574
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Apr 2021 05:28:47 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id ja3so18460211ejc.9
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Apr 2021 05:28:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gv5y3rqgeuatvJpCMSkmKG3E0fvmuYQPIfLH2BNYFg4=;
        b=VeHLgxL+eY08mOU+khxlo1dNgXX98KxFbo61NibHztmklfRmK0jE59ZaQvsTBo8YmN
         O4kXHvCTyecVbm9tNDqcbuUqFEjxHWwzQ6wtYkJlNsZryBoyMg3ObaN9X8yMMA6PQH4P
         gdX3DgcrhxbCBo4tAf8BRLwyYOMQhm/cXa3AqDq/Jcz4Dfp40InnmeswQ3GlIQUMxvQ+
         sw2nXH6jN4qixb7RWoxkgzDBA7JforYqkutwSpMM2HmGASJJEDyOYXVvLz69ukzBMN2H
         CSDfVcU+mdPi3KsCahSDF7p2sxOdQFIl5980cURL7ps2t2eyR4W10vzz/L06TN5EeQui
         piAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gv5y3rqgeuatvJpCMSkmKG3E0fvmuYQPIfLH2BNYFg4=;
        b=VVnFX88VZG4sTCTVBS1I4O5Mdn4N8eNbnZJehAR4yMmzpXOEgs7+Oz1+EsER+QxwG1
         6a3FsvOzEUAQTraKivNIF6lYmFKqxTwOtM4uLqYojXI6QmYY9U2RWbawKuKKdLgrE9KA
         ifOrrKeNVQ2iDSLFuyUdi/lJjo+SBwgUArzBAFXcm4EuxYRPxLd/H/HapZtSyb8uYUAt
         A7fF43bq8F1xkZs01MPX0CoDOQ/k3Beh7DbhhfsngbKrGLEN7YRk0aPaTV1m88eSJl0s
         fxZDbVUx+aOcvTnB6LIwvpLnBJ9QfuWaA65VA8C7NGE7JeHH6QHdEbd9azafIecJZOgF
         64AQ==
X-Gm-Message-State: AOAM532SYRf2C/DxjVZMBo1w6mKISqtIezTskRUAeafVhG/fBnEzg0m4
        nW9/QZEfoxIQ55CLBu+Vue4=
X-Google-Smtp-Source: ABdhPJwX6RQbQuE7hGUNMktGnspMeLv5Yi65EvDfDR2u4nPVQMPNQ5qtBIASoVpGM3o4wt+KCJXCwA==
X-Received: by 2002:a17:906:f41:: with SMTP id h1mr29126062ejj.399.1619612925911;
        Wed, 28 Apr 2021 05:28:45 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id n10sm1846546ejg.124.2021.04.28.05.28.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Apr 2021 05:28:45 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 4/5] trace-cmd library: New API for modifyning the timestamp offset
Date:   Wed, 28 Apr 2021 15:28:38 +0300
Message-Id: <20210428122839.805296-5-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210428122839.805296-1-tz.stoyanov@gmail.com>
References: <20210428122839.805296-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

New API is introduced, it can be used to add value to the offset
which will be applied to the timestamps of all events from given
trace file:
 tracecmd_add_ts_offset()

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 include/trace-cmd/trace-cmd.h |  1 +
 lib/trace-cmd/trace-input.c   | 12 ++++++++++++
 2 files changed, 13 insertions(+)

diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index 022720b0..7305487c 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -38,6 +38,7 @@ int tracecmd_get_guest_cpumap(struct tracecmd_input *handle,
 			      const char **name,
 			      int *vcpu_count, const int **cpu_pid);
 unsigned long long tracecmd_get_first_ts(struct tracecmd_input *handle);
+void tracecmd_add_ts_offset(struct tracecmd_input *handle, long long offset);
 int tracecmd_buffer_instances(struct tracecmd_input *handle);
 const char *tracecmd_buffer_instance_name(struct tracecmd_input *handle, int indx);
 struct tracecmd_input *tracecmd_buffer_instance_handle(struct tracecmd_input *handle, int indx);
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 284f25e8..6adc8bfa 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -2291,6 +2291,18 @@ void tracecmd_set_ts_offset(struct tracecmd_input *handle,
 	handle->ts_offset = offset;
 }
 
+/**
+ * tracecmd_add_ts_offset - Add value to the offset which will be applied to the timestamps of all
+ *			    events from given trace file
+ * @handle: input handle to the trace.dat file
+ * @offset: value, that will be added to the offset
+ */
+void tracecmd_add_ts_offset(struct tracecmd_input *handle,
+			    long long offset)
+{
+	handle->ts_offset += offset;
+}
+
 void tracecmd_set_ts2secs(struct tracecmd_input *handle,
 			 unsigned long long hz)
 {
-- 
2.30.2

