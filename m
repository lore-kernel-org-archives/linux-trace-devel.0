Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FAA0C433EF
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:25:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4041C61073
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:25:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229696AbhJHE1N (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Oct 2021 00:27:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbhJHE1M (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Oct 2021 00:27:12 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FA24C061570
        for <linux-trace-devel@vger.kernel.org>; Thu,  7 Oct 2021 21:25:17 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id b8so31247502edk.2
        for <linux-trace-devel@vger.kernel.org>; Thu, 07 Oct 2021 21:25:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EsMRUrF6pI1Pk4c9Rq7ALKGE/g069hK9bjKyuW+YxM8=;
        b=c4mVkqmoO7oR4akYDg4UqI+LA2Jo1cuApJWPHPFyuNsoJVoBqO0XRhlRoCMBzR88m+
         TVVSXbAwx4vJd9TTEOyNzBcHRRDKdwPCtdyC3/H1AMYHiFlM2WqMp3KvppCuLQX90xVX
         mLUdRE+8lWiyD+EEeYaTQD6ijzmP3mM+LNbFzrnqhZd+bl3gzTk6Zc2woD1Rt9HriBJ9
         mUcvOhM0/KESm9bTQow1stq/zQLTuBSvNE1Srs26jUVX3F01WpWGMTDDJufTy+GorAEP
         16423QTC0zRUKHLyzVDiaMh841qTDLFjZz3FannNM0S3+gexmtT2cu0wwrsklivAF6Q/
         vuZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EsMRUrF6pI1Pk4c9Rq7ALKGE/g069hK9bjKyuW+YxM8=;
        b=fNY+rfA2F55uiAveghZvd/b9ve0rA6VtXKTH9TqAtf9IisLq8Gl0KIIDKLq6m4bgQV
         WaW7oj+X+RIvEO7j8OUDOfxNSEbIukwUwXnZxhFyfUPHLLqZxS2Sp0PVYaQH3r3Qj7dX
         fO2Vh0kwrkFGqulXX/MKhH9aNu1JDG1TDvbSl1kT68gEixw8gdr/sd52p6w9EI4xlZ1Y
         VBAJsLfJ8ZyHqfeQf4q5aHC5FN+6KjXiYGdSStu4qsvyEPTFW7garMvyLPMjDqo/H0Fn
         Kg+r/Quam1oQYmKblM3GSwimDKYWiTSLdTQBwYfSxt3ruVl3c8rxfIji78gWu1YGLm8B
         WNow==
X-Gm-Message-State: AOAM531zZfgVqNh7nmxDS+poE648zDKzCAaBja4HfpUcwLteg70Er+XD
        Ib2v8VuLa1pBXMXMr9THZoSH2AWjike9Mw==
X-Google-Smtp-Source: ABdhPJwsXFEl3FoaTIP2rjwXO3Pomy7g4ikReRe+n2tKWtI5IIPLJDSe3mDAnZBsO1vHvqSDpFmuwg==
X-Received: by 2002:a17:906:7632:: with SMTP id c18mr1332963ejn.317.1633667115704;
        Thu, 07 Oct 2021 21:25:15 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id e7sm506320edz.95.2021.10.07.21.25.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 21:25:14 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 3/8] trace-cmd library: Copy CPU count between trace files
Date:   Fri,  8 Oct 2021 07:25:05 +0300
Message-Id: <20211008042510.978362-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211008042510.978362-1-tz.stoyanov@gmail.com>
References: <20211008042510.978362-1-tz.stoyanov@gmail.com>
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
index 8960ff75..cde613f3 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -4742,6 +4742,35 @@ error:
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
@@ -4840,6 +4869,19 @@ int tracecmd_copy_headers(struct tracecmd_input *in_handle,
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

