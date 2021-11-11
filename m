Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6594EC433EF
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:12:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 436BC61268
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:12:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234016AbhKKPPZ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Nov 2021 10:15:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234020AbhKKPPX (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Nov 2021 10:15:23 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7404FC0613F5
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 07:12:34 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id f8so25651453edy.4
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 07:12:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Tl90gK52auO2k4I4/yIpDyn9pEDGGbSPlxcauaoOYJ4=;
        b=BLfq+Nef7BLS/xgJtFC5OSDl/bW2nhPwY4ZPl/NndBgIlDSdnQIbTi4hgCj9DM3XaK
         sys0ChOhdR2LJ876/OL+EGFz9cOZysFfwsZRKYZE/IdCdx81b1y2P/eZpXVvTC5pBJOW
         3SC6jJR4VG0v1LYu/4vZAtutErUoP6eswbCj4YVwhN2NCMeOh5y/P3nQnlyhB9UFhP/p
         Iz36r55XVyxWEQo46CN8Y/l5Hrz0GWUkeyIzT2lLOw5b1RNqv9F+mQqd7MWJtNq8MFbI
         Jt6GY3Oc7YK37PenOEC3IiVl79xTxEL1CzUnmVwQrZfqlX/ZTHsnsMJ35FPpHyLz68NG
         bHyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Tl90gK52auO2k4I4/yIpDyn9pEDGGbSPlxcauaoOYJ4=;
        b=I94ZK3L+NldAgPx8npKOMTEcT7WbhGrNxezRajOJtvbR/n2Jd07YUqa07X0qnDSdpS
         bEEcCxtPgAvIDI4NM7pGnzRDB/NmSaXRqZMmG2ccyWeiL9/4rqXumjmwK0ymz/nvRs8D
         GG0k8+GVEFQVeIzf0zQfmSCQUUI+ff06XCKRPJjCFSw/zjZ7OSHtqjHR39eXozO7ldp6
         QDOMw3Ch2yMla5t3c9xQs+fG6Ev6nolsWsBxoEl5qxYmFQmgQZOmY6RIqc5xLYWC5ZHx
         XpU/eieFm2DGzVPhBgwouYdLRwKw6ELHzBr7cN1QbMa6O3I+A+fPTOTnlj+HFVvAYmaI
         QaZw==
X-Gm-Message-State: AOAM532w7/z+tBVidX+Tv7unGh/FUtIizIy5QJ/NJRtZmT0IyDtXKkI0
        FjrRx51NOPF6lhzuus9A6M4S1dZD0+DNRQ==
X-Google-Smtp-Source: ABdhPJyOJhgfeSlzPaxd29mfF3Ow6sSt3DnhkRbxDhO3oZhgu4Jv7+s1Kks8lgV6sCB/3gUg/dkMwg==
X-Received: by 2002:a17:907:8a24:: with SMTP id sc36mr9894562ejc.530.1636643553045;
        Thu, 11 Nov 2021 07:12:33 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id dk5sm1686835edb.20.2021.11.11.07.12.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Nov 2021 07:12:32 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 3/8] trace-cmd library: Copy CPU count between trace files
Date:   Thu, 11 Nov 2021 17:12:23 +0200
Message-Id: <20211111151228.86922-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211111151228.86922-1-tz.stoyanov@gmail.com>
References: <20211111151228.86922-1-tz.stoyanov@gmail.com>
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
index e168c1e0..03dddcbd 100644
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

