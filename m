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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E53EC4338F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 05:11:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 042BE60C3F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 05:11:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234137AbhG2FLU (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 29 Jul 2021 01:11:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233798AbhG2FLU (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 29 Jul 2021 01:11:20 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E474C061757
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 22:11:16 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id gs8so8390493ejc.13
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 22:11:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4NTNKjtb81y+MvZ+Ru9YbE9e0/w1hBWYDLtZxkoh4fM=;
        b=XoDL7c5+Xd5JpnqKwPtEBVPbm8LN6B8w0+vGBP1XDKn1jQSkLEi1Q7MzRYhiPVaavU
         1hiAJ4uskilQoWy0pKYXLBi4hD0wqo/4qEA/7P3d9Y+Q0JZQt+sb3r0if7+GLxuFHi2z
         iRhKJ31qyjDKuTFaxKkKkD9tjJffiJnWJGiw18nNsYR4hbk4Fo63j/G0ObiwZZ9hEOPS
         RSGmBDuUnh2SZq/uVMbTXULJTDB0V0KqhvIBrYpesMNYEpfvhu5sQ+L7HM5TWfPg504e
         Sgob4PiOq1DcayfTJZjuGAliz6oIDEAraWbZjwrNGzjSjoKQE4R94e6PAjePiX7ZEAU6
         iB8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4NTNKjtb81y+MvZ+Ru9YbE9e0/w1hBWYDLtZxkoh4fM=;
        b=ocvSQZI6JctvU8yjGsBdAmtRJDqVjtEKKepfItqtG4FHj7VINTohJtyd0Gk6AcnrKH
         VqIDPJvIa+fF6qs7XuLK3YMk1I0cuPJ/aQ9URT5aY97rJiSAppEb5WdxyC7RF3yhXoVk
         f8C6/vy25NSZjqJ9fkg9+5XPWKB8SvePI7CJNgNergV0TbAsdFY0UkkxnwPPoYiE91Ql
         cZADxQQqFfpr7JSdRsu0SWu/PmlzTaAGARAd031zeRrRqFsjsS1mZ2YGb6omlrg/EJwd
         OqZS48UWxmtAyHBAyY0E50Gd6oUJr+Osr+fir6LA8Rx+kv6TC598VXyZUSupM3S6VZtN
         bduA==
X-Gm-Message-State: AOAM532PkHbtIKR2KQcMXQ+pE8hKF+ac/zDCj3sagORUTTdQGFKj+mus
        29iG3deLS2JbdKFRVT/1hgMl1DG5Xo/jxw==
X-Google-Smtp-Source: ABdhPJxp4mckGsIJQ4EDMaMQM55bBlt4odQaRYT3ylhuZQG9Q2OMMnvwrNpWM90VKALE+Rb5CUptlg==
X-Received: by 2002:a17:906:9742:: with SMTP id o2mr2883450ejy.532.1627535474724;
        Wed, 28 Jul 2021 22:11:14 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id s20sm530615eji.116.2021.07.28.22.11.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 22:11:14 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 76/87] tarce-cmd library: Copy CPU count between trace files
Date:   Thu, 29 Jul 2021 08:09:48 +0300
Message-Id: <20210729050959.12263-77-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210729050959.12263-1-tz.stoyanov@gmail.com>
References: <20210729050959.12263-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The tracecmd_copy_headers() API should be able to copy CPU count also,
as it is part of the headers.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-input.c | 40 +++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 5ceb9756..f4533f7e 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -4700,6 +4700,33 @@ error:
 	return -1;
 }
 
+static int copy_cpu_count(struct tracecmd_input *in_handle, struct tracecmd_output *out_handle)
+{
+	unsigned int cpus;
+
+	if (!check_in_state(in_handle, TRACECMD_FILE_CPU_COUNT) ||
+	    !check_out_state(out_handle, TRACECMD_FILE_CPU_COUNT))
+		return -1;
+
+	if (in_handle->file_version < 7) {
+		if (read4(in_handle, &cpus))
+			return -1;
+	} else {
+		cpus = in_handle->max_cpu;
+	}
+
+	if (tracecmd_get_out_file_version(out_handle) < 7) {
+		cpus = tep_read_number(in_handle->pevent, &cpus, 4);
+		if (do_write_check(out_handle, &cpus, 4))
+			return -1;
+	}
+
+	in_handle->file_state = TRACECMD_FILE_CPU_COUNT;
+	out_set_file_state(out_handle, in_handle->file_state);
+
+	return 0;
+}
+
 /**
  * tracecmd_copy_headers - Copy headers from a tracecmd_input handle to a file descriptor
  * @in_handle: input handle for the trace.dat file to copy from.
@@ -4798,6 +4825,19 @@ int tracecmd_copy_headers(struct tracecmd_input *in_handle,
 			return 0;
 
 		ret = copy_command_lines(in_handle, out_handle);
+		if (ret < 0)
+			goto out;
+
+		/* fallthrough */
+	case TRACECMD_FILE_CPU_COUNT:
+		if (end_state <= in_handle->file_state)
+			return 0;
+
+		ret = copy_cpu_count(in_handle, out_handle);
+		if (ret < 0)
+			goto out;
+
+		/* fallthrough */
 	default:
 		break;
 	}
-- 
2.31.1

