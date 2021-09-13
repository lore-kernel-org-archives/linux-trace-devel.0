Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 870A6C433F5
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Sep 2021 12:49:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 63C1B61051
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Sep 2021 12:49:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235044AbhIMMuN (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 13 Sep 2021 08:50:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235736AbhIMMtQ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 13 Sep 2021 08:49:16 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48B9FC061574
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Sep 2021 05:48:00 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id d21so6807737wra.12
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Sep 2021 05:48:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nnct16Eyu0jAjQS8nc7YZ5zULEAJIbnBL0K7rY7k9m8=;
        b=Lz6YF01MT8MDwgMMXYwfGVCVz/3QH8YDXXSiY1GjoYauV41FJgANya4eFirpPNemZA
         CPGNyUhVRwnBQoYH9prnltumrTBquw/YeO5VxwVDGSl8z7cvbWXBjB6VUm4qr3dMd3jY
         3pU+Dam/EGa2A6uSxXb1sxmuJsUf9ZO1QKYgfjDbcVTSxsxHEGSCS6PdBrxq6mczgDNO
         /I25t54CsJAiR+OS1XCF02eDeSvZ8xg/CLO/WdMGvf9Ain0apydWDtqCX3TLGxsPBMLx
         F46DNjKraBLRSgmTOk+4mhrmX2p3XGYMzhbfhP9Seb2nXi5+6RQB6R2e7RWSnGL9+20F
         5BPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nnct16Eyu0jAjQS8nc7YZ5zULEAJIbnBL0K7rY7k9m8=;
        b=FIsS12WVKANVO0zuSKTMJQ8GjjxwA6xm05QiYQoQ6YePrmoE0xtgG4vxVcZFoqzZ8x
         GLmulAi6gAyzAFr0uso5yKYyRI413uWqU0TEhGIMOc6wCUUqUD0mSVN8yPnFDZ9tMyPt
         H1QUeAeLjNiA+4GJ2nDK/l6HpKRgjegzK6OiWZSB6YyGevt1ujH8WpoQeorOZ+hFqO0n
         VxJMnVxOo0bJ4zO2H6+lXj7tMcHU2QL3EOeephY8hBn70fDTvUxDDfvdO9rmEmkIKxTH
         gZ3AsAKro8piphUNnhnq2MzD9fy5uJxp133RbQXYmChvZOHIKRJbUvmYlc2nbajpdMFN
         vKqw==
X-Gm-Message-State: AOAM531tOxoJ5T3tCRQRKbMy7GcRE0GnBEGl2P/vgqxqDDjpu3ctd7aA
        na6O5787vAWtzjXbqp5cqXsvuF2Bzgs=
X-Google-Smtp-Source: ABdhPJzSDHwSAlmaI//L9QqUJi5A24VbnhO0vYwy+5ogwV06nNj0IDMMnpQWpUN9RM8AV8cQ0Xqskw==
X-Received: by 2002:adf:f6c7:: with SMTP id y7mr596257wrp.44.1631537278949;
        Mon, 13 Sep 2021 05:47:58 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id k17sm7718077wmj.0.2021.09.13.05.47.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 05:47:58 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 3/8] trace-cmd library: Copy CPU count between trace files
Date:   Mon, 13 Sep 2021 15:47:49 +0300
Message-Id: <20210913124754.3679916-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210913124754.3679916-1-tz.stoyanov@gmail.com>
References: <20210913124754.3679916-1-tz.stoyanov@gmail.com>
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
index e4fdc534..c3d7075f 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -4752,6 +4752,33 @@ error:
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
@@ -4850,6 +4877,19 @@ int tracecmd_copy_headers(struct tracecmd_input *in_handle,
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

