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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BD46C48BE8
	for <linux-trace-devel@archiver.kernel.org>; Mon, 14 Jun 2021 07:51:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 74FAE61246
	for <linux-trace-devel@archiver.kernel.org>; Mon, 14 Jun 2021 07:51:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232590AbhFNHxV (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 14 Jun 2021 03:53:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232583AbhFNHxT (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 14 Jun 2021 03:53:19 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4031C061574
        for <linux-trace-devel@vger.kernel.org>; Mon, 14 Jun 2021 00:51:02 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id r7so30789974edv.12
        for <linux-trace-devel@vger.kernel.org>; Mon, 14 Jun 2021 00:51:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=p6IobRJ6Evi4eZu0SI8LMyVIQ413IC7AqsSEq/FbWVo=;
        b=JOAwPraUdoUGD3pNe4hqIByv+3Mf9wSK7aj4GH9VCxipcQrhJhFGwEKP/JLVlLe5Wz
         8xibUHaGqnqZVSkzrLgXPcutYJRvXifKPwg2/lnAQlxde1oJMm3SyqR4kGI+INktdZVl
         XQOOWANgtJk39OvR4XojKM1b+SOdxixyh7YE4w7lyxIVpYD4rWm1xQt1OnvIxqHkTBap
         xX5En9Z4PEgYlW1UXyIifpQYJiWhj9R6hR7m605zHlY/Vwq+Etg0qbHqBt+YzeOD/UR8
         heTGAToI9YSrdr8EYtdEvt5kucdA8lCmba6Nty4eORXz3NWJ+rmamjT9ZmpOya5gTe1i
         p/dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=p6IobRJ6Evi4eZu0SI8LMyVIQ413IC7AqsSEq/FbWVo=;
        b=hNe8D6Bl6txaj9/+YHdohJ15pzK6VEBVSfBr4Vzqr0nO5TC9+U9WWSNWQNCLRR2i5J
         ooqGmcnSrSzVaCF4M7INQXEUpJ5oBfL63KTe4is0pMuqfJ0Y4CVZDyVe5I6/SvxUovOH
         8yJdAcA9HRDdmde8mryCgVvS4oGGJR4CeizUBw4b5kwsbYH/yJlHCfIv/qbdHX5fPez3
         0haQqsrZhEqrc6eevSDAuC1BQrFPNn/cecHYOftXfWLWYB/gFmoR17z56ZXmBY7TTtxH
         FbO5QYOXx0qwRlvKS/npsvxEGBKmEl/A+0bFTZwIetCUfyyjT8Ei4kdT3PgvZeBlCrUO
         lkdA==
X-Gm-Message-State: AOAM530s0Tgespb/o5ZzcRwZgA50Qo3p9PBe93knjFrg2XXI42EoSEef
        aavsgVk98Wa61tTmaRQENwvZK5Y3PYlaEQ==
X-Google-Smtp-Source: ABdhPJzgLIlho7OCOeJ0m3BGH7o5LkaiUx1pvXcRYaC2Ul1u2A1eTzew3A6vudr/hCjxhKt+WCvbHA==
X-Received: by 2002:a05:6402:b5a:: with SMTP id bx26mr15162561edb.81.1623657061407;
        Mon, 14 Jun 2021 00:51:01 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id f6sm6536444eja.108.2021.06.14.00.51.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jun 2021 00:51:01 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v6 31/45] trace-cmd library: Add new API to get file version of output handler
Date:   Mon, 14 Jun 2021 10:50:15 +0300
Message-Id: <20210614075029.598048-32-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210614075029.598048-1-tz.stoyanov@gmail.com>
References: <20210614075029.598048-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Added an API to get the version of the trace file, associated with given
output file handler.
  tracecmd_get_out_file_version()

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/include/private/trace-cmd-private.h | 1 +
 lib/trace-cmd/trace-output.c                      | 9 +++++++++
 2 files changed, 10 insertions(+)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index 65e80cec..9a08a960 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -319,6 +319,7 @@ int tracecmd_append_cpu_data(struct tracecmd_output *handle,
 int tracecmd_append_buffer_cpu_data(struct tracecmd_output *handle,
 				    const char *name, int cpus, char * const *cpu_data_files);
 struct tracecmd_output *tracecmd_get_output_handle_fd(int fd);
+unsigned long tracecmd_get_out_file_version(struct tracecmd_output *handle);
 
 /* --- Reading the Fly Recorder Trace --- */
 
diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index 06d0738e..9b83eb76 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -1966,3 +1966,12 @@ __hidden bool check_out_state(struct tracecmd_output *handle, int new_state)
 {
 	return check_file_state(handle->file_version, handle->file_state, new_state);
 }
+
+/**
+ * tracecmd_get_out_file_version - return the trace.dat file version
+ * @handle: output handle for the trace.dat file
+ */
+unsigned long tracecmd_get_out_file_version(struct tracecmd_output *handle)
+{
+	return handle->file_version;
+}
-- 
2.31.1

