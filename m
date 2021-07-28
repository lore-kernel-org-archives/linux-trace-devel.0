Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3FF0C4338F
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Jul 2021 13:34:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D99EE60FED
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Jul 2021 13:34:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236793AbhG1NeT (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 28 Jul 2021 09:34:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236776AbhG1NeT (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Jul 2021 09:34:19 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7D17C061764
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 06:34:16 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id qk33so4580049ejc.12
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 06:34:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZUYlyUIutzJIFnHWgj6nTftYfHMsZXdFkBAf1R7fpvw=;
        b=hDh3zmTK7P9T/hHIJD/rav7SzgRpGatbbvOxqSbhO196n6Y/yX4pKln8psoWid6ab7
         BpgE0YReMA8Id1wK7YWwtIuGn8gxcICnnqshpC1csdyA2nVBOMphr2pI6HFEr7KNda5+
         ansuHwIuC3xCTm4PNEP+xKdxF/nFvJhhxe+o6MGVrnl83vYhUb1o3y/vKbt25gJMvAjE
         107wePgomcFMv/V3eIeHTfi3b9Q9hYSA2cO0E3jLfFmQ2ntmrbuhYAGXnmC9JGdkZutz
         7SCgg1WuOeYtGHpCzw/S5BBghIBbrAcjuInJdDX+rjCttkArRJovUNeJmD+FyWs4fakH
         6b/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZUYlyUIutzJIFnHWgj6nTftYfHMsZXdFkBAf1R7fpvw=;
        b=SnG7oj/xYHxyOLkbW/Wk4WhXmJClP+8gr+mX0kbM/pYYrYezxS2DWpRGdJRl2vcwOQ
         A+qXK1ClfORkqITLnLIUWvSSK2kpVo+A4tRgAAtFDiCCnbo1FUDnjAr81IiwGjyvtcl3
         EhWxgjvsdDBrTqe4ZfcrHKNNGY5tQT9gxN2YPX2wyZfi5U1IQzcWfTIedw+FlM4I8MzU
         luirdgoHjmC5HAJCJ5MzydmyeefE9qJsonqPdwNJQhjHHGJXFZb1GPQqKoECovLPtKh8
         lIGVKJbsE3uGd7nlMOrf89cvcZ4D6HmK0IVV81HeBdshUQxze0l3SQeVKSYZ/QcEsIQF
         S2Lg==
X-Gm-Message-State: AOAM531SDchGpDwaLoIqMc+x7CPVXtR+HMm/qub10lnhDfdzoXqPJ2ab
        5a6h9yITDQW+ZvPA0/eqR7Y=
X-Google-Smtp-Source: ABdhPJxGP43dxcuyWajvOi8F7/v2TXDj8lG9pEdSFHW1TaqgIX2k1nX675cOqjFnn4JOEsi7CFJPFQ==
X-Received: by 2002:a17:906:2bd4:: with SMTP id n20mr27400113ejg.390.1627479255438;
        Wed, 28 Jul 2021 06:34:15 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id b25sm2700705edv.9.2021.07.28.06.34.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 06:34:14 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 77/87] tarce-cmd library: New API to copy buffer description between trace files
Date:   Wed, 28 Jul 2021 16:32:40 +0300
Message-Id: <20210728133250.234140-78-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210728133250.234140-1-tz.stoyanov@gmail.com>
References: <20210728133250.234140-1-tz.stoyanov@gmail.com>
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
index ed91e8bc..5345e327 100644
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

