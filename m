Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FF52C433FE
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 Dec 2021 12:27:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233967AbhLBMa5 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 2 Dec 2021 07:30:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240265AbhLBMaz (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 2 Dec 2021 07:30:55 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CA6DC061757
        for <linux-trace-devel@vger.kernel.org>; Thu,  2 Dec 2021 04:27:33 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id r25so49185402edq.7
        for <linux-trace-devel@vger.kernel.org>; Thu, 02 Dec 2021 04:27:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lbuXHNZqAeL/Zo3Awo3tYVuoLh3AWEQpHm7l237xiXQ=;
        b=jlEXGpeUoPUEqlSZh1gJ/qmyDkmNOri9BKb3GPL1X6WSaokJuX2VFb9QLr4aeI5Qjs
         iBzma2BIy8Lx5aANjMaP8PZRwXf6VX2Bk1DxjXwdaVWNaeG2N+aeZLv6DVwpF0MKw2Er
         ARrvhsu3n+b01MsP7ulNlyr0yjLsN8zkT2KCxrU5uwxc/VEnAE6qrYEV5eI1t6J1qIit
         59QWJMDDb5UF+fOjzMwuKP1SIUH3e8251KrFgrgOmfkAegI+8HUFnb6JeqmpvS+pN/75
         inanWNVhwBKgW6Ea4+IkZFD+WZCY3RtP96Sjm+o9SJx9j2tqwB62h1/nSe/RNubGB2Iw
         cCMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lbuXHNZqAeL/Zo3Awo3tYVuoLh3AWEQpHm7l237xiXQ=;
        b=CWju+DWQkQ4p6jdOGpxbj8qlJUaNVFptd+JUeAP7jbjhj5qVgAGPLDHNGE7Q5h59Js
         twGumfONLf97F1+00EUey35gtTSvDy3znOuhmrUBVBfNgkSLEM5rzQCXAqnWu8LdKGz6
         W7QVz3tqQanmpol0f9quBpjrTQrKStdqTO436bvVki5UzuQUxEFC3kAT/zGa5GTvT/W7
         cYwOE9jzZwk0ovX1wqjgtu/Yiy+zr+U3zrrvNAXeoA/zc7u1mCRLHu/JY85wXt6hsYYd
         YU8PlUiwO46Nttt67aGEgMP4VRzGkceiqu1fUW1fT+Hhx48RL6un2JeZVv8BcEr6EwPI
         w0mg==
X-Gm-Message-State: AOAM533c26ukGqgVy1XLVTPGphJhnBVXqAgl+8htI+jvnXIQwfTXfWnb
        Auq5MCvH2pCmD5WGSlK/YWGuRyiq2+YP+g==
X-Google-Smtp-Source: ABdhPJwMwlZHWUNVDrF2YrUHtvTzT2XbBIN3CkSGnFq9dIoQ/BrOoh5JtXuAqjOcFgWXkPsvqaFehA==
X-Received: by 2002:a17:906:6a0a:: with SMTP id qw10mr14747084ejc.547.1638448050684;
        Thu, 02 Dec 2021 04:27:30 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id u16sm2073403edr.43.2021.12.02.04.27.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Dec 2021 04:27:30 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v5 3/8] trace-cmd library: Copy CPU count between trace files
Date:   Thu,  2 Dec 2021 14:27:21 +0200
Message-Id: <20211202122726.43775-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211202122726.43775-1-tz.stoyanov@gmail.com>
References: <20211202122726.43775-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The tracecmd_copy_headers() API should be able to copy CPU count also,
as it is part of the headers.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-input.c | 42 +++++++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 8cd03de0..4cfe26bc 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -4741,6 +4741,35 @@ error:
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
+	if (!HAS_SECTIONS(in_handle)) {
+		if (read4(in_handle, &cpus))
+			return -1;
+	} else {
+		cpus = in_handle->max_cpu;
+	}
+
+	if (tracecmd_get_out_file_version(out_handle) < FILE_VERSION_SECTIONS) {
+		cpus = tep_read_number(in_handle->pevent, &cpus, 4);
+		if (do_write_check(out_handle, &cpus, 4))
+			return -1;
+	} else {
+		tracecmd_add_option(out_handle, TRACECMD_OPTION_CPUCOUNT, sizeof(int), &cpus);
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
@@ -4839,6 +4868,19 @@ int tracecmd_copy_headers(struct tracecmd_input *in_handle,
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
2.33.1

