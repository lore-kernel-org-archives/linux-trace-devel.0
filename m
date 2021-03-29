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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E21AC433E1
	for <linux-trace-devel@archiver.kernel.org>; Mon, 29 Mar 2021 12:59:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2A3D361934
	for <linux-trace-devel@archiver.kernel.org>; Mon, 29 Mar 2021 12:59:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230388AbhC2M62 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 29 Mar 2021 08:58:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230516AbhC2M60 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 29 Mar 2021 08:58:26 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF39EC061574
        for <linux-trace-devel@vger.kernel.org>; Mon, 29 Mar 2021 05:58:25 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id z1so14112971edb.8
        for <linux-trace-devel@vger.kernel.org>; Mon, 29 Mar 2021 05:58:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6oDcldO8a5L3WVns4mVarPPy/ZK33nxnZ8qbXfnLcAo=;
        b=gmu/YzY8uDXgHx1SjVYmoME+AcoYiBrWHV9tRgCTIxLZ/P4Omv6PW1MFEL0gZodIIR
         uv13cmGu6T7x0SqyKlQMjlRPA+h0YGnsOl+bjjeixG5LlE6p+gb+QCexllEhMP9fyReK
         iDXfEyBwviOMKgLkETe5CAVac8YBgb5Yv2Y3XKWfH8e8WdWVHsvLVwHid8YS/a04u59G
         aZ+ejxkExcivfgD833e2arJLyELeU93Pwhjn7PKDKgSv8p8n7qLPh22VAEPH3ogC0igM
         axltx0RPoz854gVhY0j01QMnlXbuw8BqNvSNFq51VSaLVw9NbVDCj3r4wXtU52B+8kr9
         gL8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6oDcldO8a5L3WVns4mVarPPy/ZK33nxnZ8qbXfnLcAo=;
        b=cuaTSQckUvxZ/tzQ2yjYUdO1A3DpKzPSFP5g5wNQztCOmshtUDtAc1/RbKjc+8RbM+
         uahuhutZ5N8kjxZXSWPFRZl81ZYg5qKtlKNOQFYWgQpwwk7ryvfPr22U6DBhJ7lBgkLa
         2np6OOcuf2+UIAorE3o3RTf1OLOrQl0KL8I78+mkDNsugQWhqWYhNkljOhdXVLA7jFCA
         xRDjmJ8Q+BBmnWzcmo9uyKcvPkLQZHB5nSe/rVYtbAbnQuVnPHPxQiog1Ad2DGLq+8qe
         kQwZi0MRXxDgYN5dFPjOHK86FrFsLWuJUbTIeQwWxTw6Cr4orHKMLK1NILNblXF4K03O
         qxhw==
X-Gm-Message-State: AOAM532sKmA9ZpgF3B8ttGhb3Ymleafp1LEvgBv7XmAjJRM618+/T85D
        QvqKX0UuJhK9DjXWFCbpS/AigHg2UeK7nw==
X-Google-Smtp-Source: ABdhPJy1Uh7d+w+A4uiqEkP7vYkHYQSg77QeoZhu3+NfEiYBJR+KyvosmovRxEPfscvOIjnARK2liw==
X-Received: by 2002:aa7:c654:: with SMTP id z20mr28246612edr.377.1617022704560;
        Mon, 29 Mar 2021 05:58:24 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id d19sm8909075edr.45.2021.03.29.05.58.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Mar 2021 05:58:24 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 1/4] trace-cmd: Add internal API to check if tsc2nsec is supported
Date:   Mon, 29 Mar 2021 15:58:18 +0300
Message-Id: <20210329125821.97496-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210329125821.97496-1-tz.stoyanov@gmail.com>
References: <20210329125821.97496-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

A new internal API is added to check is tsc to nanoseconds conversion is
supported:
 bool trace_tsc2nsec_is_supported(void);

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/include/trace-local.h | 2 ++
 tracecmd/trace-record.c        | 5 +++++
 2 files changed, 7 insertions(+)

diff --git a/tracecmd/include/trace-local.h b/tracecmd/include/trace-local.h
index 7773e9fc..6a4c5f51 100644
--- a/tracecmd/include/trace-local.h
+++ b/tracecmd/include/trace-local.h
@@ -341,4 +341,6 @@ static inline bool is_digits(const char *s)
 	return true;
 }
 
+bool trace_tsc2nsec_is_supported(void);
+
 #endif /* __TRACE_LOCAL_H */
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 5e69cf48..5c9d800f 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -5827,6 +5827,11 @@ static int get_tsc_nsec(int *shift, int *mult)
 }
 #endif
 
+bool trace_tsc2nsec_is_supported(void)
+{
+	return (get_tsc_nsec(NULL, NULL) == 0);
+}
+
 static void parse_record_options(int argc,
 				 char **argv,
 				 enum trace_cmd curr_cmd,
-- 
2.30.2

