Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BBCAC4320A
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 05:11:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 362806023E
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 05:11:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233798AbhG2FLV (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 29 Jul 2021 01:11:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233899AbhG2FLU (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 29 Jul 2021 01:11:20 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E7E0C061765
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 22:11:17 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id o5so8485528ejy.2
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 22:11:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xq+3L4+TFICrMplTofG0MACMJbsB95F3lY2de2dQMBY=;
        b=s8fRTaNVB4+0DYvj9E0tCiNTlPTW3GzmD6Bz0ghAcXGb2oIHSPnlY8m/SsB89fm4+f
         eyj0bOUB+4GJp2h/g8UONxebEioKjbJkWfKco+Z8+TFkWxhCy/SiessAylxOYrShq2JV
         ikE1QDoa5GaLWf1udK6KdXKgHRymLyHcXALfXbcUlhCUFbwKagdLzx5EmjTjkH+wbOHW
         Gf4i94PKsGkaQRD/TtBzQ+ullcARmeMrsfWbQ0Y3ocQ8YybayiWWFfBvsy1+9nuHF8OU
         nXPey4tEeIb7/7hMJkxDM7lkdQ8ILR+SKayYVn2ujzKIbqjhWfihrf4uQOZhOJimr/mF
         t8pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xq+3L4+TFICrMplTofG0MACMJbsB95F3lY2de2dQMBY=;
        b=Tx3RZ5G/skEiIOmPzMm0IZ08N1zVKjCGlhRQf7sTZqX+z80xvLj6scVPJBxMVbkq1o
         5CnSPtXL1rOQrLT6OdhJ6h4MVV7/OnH++ih4MLwoFocxrVOKczpgHXAlsPcYzse+hmnk
         nIfVw7LqDho4m34ZIXDMq4KuV3a2wrXXrC6xRE+kTI/IcN1klX6A6ab994UhEmoGGlku
         WFyrCaQpa/bPwPFPzkP8QL88g8JGlLsMLEPAe/6L0E20t0QPHPd6ZdmbJsBP0ugtkFG6
         ZwRN4RQiO5rm4sn6Nq/ULel/Y0q4W6M1hNjjmg3TtiEWo7FnBi0RCEwQES2ckDXCMKWX
         kg9w==
X-Gm-Message-State: AOAM531wAvDsiWYBi/HdArZa6/j8V84idRKtdJoUQ5eQbabndCwSJfnp
        0wkTzNB659neKg2EPlPoshI=
X-Google-Smtp-Source: ABdhPJzAl56f4+nelniGeYXGgHqk0l+M+3OQ/7U3zSmd/y5/lRfmcm6HO3lWl5yeROJO+UyjS8yjpQ==
X-Received: by 2002:a17:906:ed1:: with SMTP id u17mr2843501eji.304.1627535475781;
        Wed, 28 Jul 2021 22:11:15 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id s20sm530615eji.116.2021.07.28.22.11.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 22:11:15 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 77/87] tarce-cmd library: New API to copy buffer description between trace files
Date:   Thu, 29 Jul 2021 08:09:49 +0300
Message-Id: <20210729050959.12263-78-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210729050959.12263-1-tz.stoyanov@gmail.com>
References: <20210729050959.12263-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

A new library API is introduced, to copy buffers description between
trace files:
	tracecmd_copy_buffer_descr()

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/include/private/trace-cmd-private.h |  2 ++
 lib/trace-cmd/trace-input.c                       | 13 +++++++++++++
 2 files changed, 15 insertions(+)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index 05a2ea01..58c17fe5 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -183,6 +183,8 @@ int tracecmd_copy_headers(struct tracecmd_input *in_handle,
 			  struct tracecmd_output *out_handle,
 			  enum tracecmd_file_states start_state,
 			  enum tracecmd_file_states end_state);
+int tracecmd_copy_buffer_descr(struct tracecmd_input *in_handle,
+			       struct tracecmd_output *out_handle);
 void tracecmd_set_flag(struct tracecmd_input *handle, int flag);
 void tracecmd_clear_flag(struct tracecmd_input *handle, int flag);
 unsigned long tracecmd_get_flags(struct tracecmd_input *handle);
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index f4533f7e..76be1a02 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -4846,6 +4846,19 @@ int tracecmd_copy_headers(struct tracecmd_input *in_handle,
 	return ret < 0 ? -1 : 0;
 }
 
+int tracecmd_copy_buffer_descr(struct tracecmd_input *in_handle,
+			       struct tracecmd_output *out_handle)
+{
+	int i;
+
+	if (tracecmd_get_out_file_version(out_handle) >= 7)
+		return 0;
+
+	for (i = 0; i < in_handle->nr_buffers; i++)
+		tracecmd_add_buffer_info(out_handle, in_handle->buffers[i].name, 0);
+	return tracecmd_write_buffer_info(out_handle);
+}
+
 /**
  * tracecmd_record_at_buffer_start - return true if record is first on subbuffer
  * @handle: input handle for the trace.dat file
-- 
2.31.1

