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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 183B0C47094
	for <linux-trace-devel@archiver.kernel.org>; Thu, 10 Jun 2021 11:36:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ED7DA613FE
	for <linux-trace-devel@archiver.kernel.org>; Thu, 10 Jun 2021 11:36:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230188AbhFJLiO (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 10 Jun 2021 07:38:14 -0400
Received: from mail-wm1-f48.google.com ([209.85.128.48]:34761 "EHLO
        mail-wm1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230245AbhFJLiO (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 10 Jun 2021 07:38:14 -0400
Received: by mail-wm1-f48.google.com with SMTP id u5-20020a7bc0450000b02901480e40338bso4597515wmc.1
        for <linux-trace-devel@vger.kernel.org>; Thu, 10 Jun 2021 04:36:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=laA4gGGumfq0sJQFfiL10durfgyLHHcEFJonCoS0JyE=;
        b=hOLOw8o2Z/un6Pl9tTd65a50CD8cKU649RBQi9NFV6jAzPPKu8lpOjw2ZVFbkJk0F0
         +875qUTlVI/Bw2qlQieb/hPWkI+42U1clnnGAkNSG4QWqcoIqz+A1Oqt4XFF3gD3N2Ot
         YjWZB2B/9eLcoth4B0uemBE95wN691QvLdkvqUmLNi/rsRpNxsoMZN14u7ir/P2QU7ZR
         bNNJezT7iyxCJw/CKqj1sIeQ3ru7iE6G5GM9EVdPIcODHN2yw8P9IKBCtoEZBd+x8EM0
         6WhXqKGPIIR/IKOniKYSDVdlUsv5NG0OVhIQMak7j/sHD4LIj5bNGVebWt2Nb1c/N2Iu
         8Vfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=laA4gGGumfq0sJQFfiL10durfgyLHHcEFJonCoS0JyE=;
        b=o0SpmtGjHP3ZYcFQDnIdnl7HnNRwIIF4Xj32k0lTSNpJS6ve4xxFPWcmtgfTi7nPw9
         AXMrZAvlmMJj3zzdNcs0NLpgXpK3NGdpLdurFAOpcpxAFck/pHtZENbIZfgHZQb/LpH3
         rt1h4gZfayndC7rwsHTBqQEhBXuYMJoI1lHAminGNQYShPDQ+akqDbsw2t3ROGE4IehH
         wOkn7shXW+66E9YAIzC1AWdaUuJt+oPNEmB9g/UesVlLVPDzfMB+zDHZnAKh7atbka5b
         gbe1mCnqpZKAVwBknOwPuexgLhlfa69cGADk2cUD9Qxfq7E0iquOXSbUDzjMIps+zx5E
         5rhQ==
X-Gm-Message-State: AOAM533ErCxfZcstcOACmjUvhfi8sfKWzec9we5vmysDeJWXCujWAdLE
        KR7brbos4wmuWSIL5bbmJlQ=
X-Google-Smtp-Source: ABdhPJxOME9x8oRMsaP2KZCxLDRLueHLrTCSCbRIitXmLLceysn379p+4B/mJbfCFS1QsfpGDat6QA==
X-Received: by 2002:a7b:c394:: with SMTP id s20mr4574229wmj.33.1623324902836;
        Thu, 10 Jun 2021 04:35:02 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id n42sm8898391wms.29.2021.06.10.04.35.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 04:35:02 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v5 37/40] trace-cmd library: Refactor the logic for writing CPU instance trace data
Date:   Thu, 10 Jun 2021 14:34:23 +0300
Message-Id: <20210610113426.257931-38-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210610113426.257931-1-tz.stoyanov@gmail.com>
References: <20210610113426.257931-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Added a helper function, internal to the library, for updating CPU
instance offset in the trace file. This allows to reuse the logic inside
the library, will be used in the tracecmd_copy API.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/include/trace-cmd-local.h |  2 ++
 lib/trace-cmd/trace-output.c            | 11 +++++++++--
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/lib/trace-cmd/include/trace-cmd-local.h b/lib/trace-cmd/include/trace-cmd-local.h
index e8c7968f..14908f3c 100644
--- a/lib/trace-cmd/include/trace-cmd-local.h
+++ b/lib/trace-cmd/include/trace-cmd-local.h
@@ -72,4 +72,6 @@ struct cpu_data_source {
 int out_write_cpu_data(struct tracecmd_output *handle, int cpus,
 		       struct cpu_data_source *data);
 
+int out_update_buffer_cpu_offset(struct tracecmd_output *handle, const char *name);
+
 #endif /* _TRACE_CMD_LOCAL_H */
diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index a3ccfba5..9933224c 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -1853,8 +1853,7 @@ int tracecmd_append_cpu_data(struct tracecmd_output *handle,
 	return tracecmd_write_cpu_data(handle, cpus, cpu_data_files);
 }
 
-int tracecmd_append_buffer_cpu_data(struct tracecmd_output *handle,
-				    const char *name, int cpus, char * const *cpu_data_files)
+__hidden int out_update_buffer_cpu_offset(struct tracecmd_output *handle, const char *name)
 {
 	tsize_t b_offset;
 	tsize_t offset;
@@ -1883,6 +1882,14 @@ int tracecmd_append_buffer_cpu_data(struct tracecmd_output *handle,
 		tracecmd_warning("could not seek to %lld\n", offset);
 		return -1;
 	}
+	return 0;
+}
+
+int tracecmd_append_buffer_cpu_data(struct tracecmd_output *handle,
+				    const char *name, int cpus, char * const *cpu_data_files)
+{
+	if (out_update_buffer_cpu_offset(handle, name))
+		return -1;
 
 	return tracecmd_write_cpu_data(handle, cpus, cpu_data_files);
 }
-- 
2.31.1

