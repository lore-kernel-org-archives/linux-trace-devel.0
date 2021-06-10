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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A22AC47094
	for <linux-trace-devel@archiver.kernel.org>; Thu, 10 Jun 2021 11:35:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4578A61406
	for <linux-trace-devel@archiver.kernel.org>; Thu, 10 Jun 2021 11:35:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230416AbhFJLho (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 10 Jun 2021 07:37:44 -0400
Received: from mail-wr1-f50.google.com ([209.85.221.50]:40923 "EHLO
        mail-wr1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230410AbhFJLhh (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 10 Jun 2021 07:37:37 -0400
Received: by mail-wr1-f50.google.com with SMTP id y7so1900133wrh.7
        for <linux-trace-devel@vger.kernel.org>; Thu, 10 Jun 2021 04:35:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jNmgwtkM7E5IR4z79tTsl2FEDjRbmtrhOhWVpEAWIrY=;
        b=WHAcUlEZkJNb6az1QFZONW6qg3fOu3WK9nb8PPGQCwyPj366Rk55yiilTH7kQIbOQA
         3KdeATDV2m52tUD/9ShigZLd0YqgAtVTu71kyBXWCdyDADiU+aP2Csxy90pBGbzEPPu1
         8NP/ZNxIgD7HPr4M54p4Gt7JCAlTcoTyfPdSifeh/VEYOemtcXn+MlGlgPArYLBftKjj
         hBLbX952cmIadu0R4wP5oEoGXwrrgMUHsbE3jfMvt8deEFaYQRvaUgXZlo3g9k5MAoBY
         IR1dOAtAzz0Wbk/N2VVcoO9OcFGLY4UwVg8Kg21h98vm+ZQIq6i9bdpERfY9IzsHkpRu
         5tQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jNmgwtkM7E5IR4z79tTsl2FEDjRbmtrhOhWVpEAWIrY=;
        b=m7P7/eA3vh6QrvcRaALFu4RK0+b67KPXm10dvjXR6gbBhYCO/DgdBi3u5SCwZj/fzo
         rbY/0KoSNVjjbHlTwSb792vgAhj7oKzLEB38cNA7yBN/26vd4pjozr1XevbSptP2TbrX
         CRRo3eM3wqlul7iGEleBzbyJKIuPncTpW8WSwO+6Sp6GirsCBkUXNpuzOgkIcgjQ1CQc
         O2XGSw2RH/Dtuz60PIDxzJN8VfMV6Vw860xGLoRa2wN9gfyxlIic/Zly2yg2ATZ8cpsM
         FSpR4j/S2WI/2ab9ix0UBPm35ScqtkU5+4ftGwbBkdLRH0sPqcAwtUUYe8Tq/9bnA4EO
         HNLQ==
X-Gm-Message-State: AOAM5330o/Nj3OE9FGF4ZMRbNHD9Muy61tontVTl4iokVPkcX58LYwIs
        +KqY55ukl+PTnT2ldXCoJB8=
X-Google-Smtp-Source: ABdhPJy6uXnsIwsUAGIMQXYYGutdUK1+UzXUkfgfA11EumqB3PBRp9R/NNtg13MWXwm3jzJvZ4h5nQ==
X-Received: by 2002:adf:a45a:: with SMTP id e26mr5001065wra.222.1623324880153;
        Thu, 10 Jun 2021 04:34:40 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id n42sm8898391wms.29.2021.06.10.04.34.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 04:34:39 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v5 12/40] trace-cmd library: Add new API to get compression of input handler
Date:   Thu, 10 Jun 2021 14:33:58 +0300
Message-Id: <20210610113426.257931-13-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210610113426.257931-1-tz.stoyanov@gmail.com>
References: <20210610113426.257931-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The new API returns name and version of the compression algorithm,
used to compress the trace file associated with given input file handler:
 tracecmd_get_file_compress_proto()

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 .../include/private/trace-cmd-private.h          |  2 ++
 lib/trace-cmd/trace-input.c                      | 16 ++++++++++++++++
 2 files changed, 18 insertions(+)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index ec534d51..624d0afb 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -236,6 +236,8 @@ unsigned long long
 tracecmd_get_cursor(struct tracecmd_input *handle, int cpu);
 
 unsigned long tracecmd_get_in_file_version(struct tracecmd_input *handle);
+int tracecmd_get_file_compress_proto(struct tracecmd_input *handle,
+				     const char **name, const char **version);
 
 int tracecmd_ftrace_overrides(struct tracecmd_input *handle, struct tracecmd_ftrace *finfo);
 bool tracecmd_get_use_trace_clock(struct tracecmd_input *handle);
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 43d731e0..0b17b58d 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -4148,6 +4148,22 @@ unsigned long tracecmd_get_in_file_version(struct tracecmd_input *handle)
 	return handle->file_version;
 }
 
+/**
+ * tracecmd_get_file_compress_proto - get name and version of compression algorithm,
+ *				      used to compress the trace file
+ * @handle: input handle for the trace.dat file
+ * @name: return, name of the compression algorithm.
+ * @version: return, version of the compression algorithm.
+ *
+ * Returns 0 on success, or -1 in case of an error. If 0 is returned, the name and version of the
+ * algorithm are stored in @name and @version. The returned strings must *not* be freed.
+ */
+int tracecmd_get_file_compress_proto(struct tracecmd_input *handle,
+				     const char **name, const char **version)
+{
+	return tracecmd_compress_proto_get_name(handle->compress, name, version);
+}
+
 /**
  * tracecmd_get_use_trace_clock - return use_trace_clock
  * @handle: input handle for the trace.dat file
-- 
2.31.1

