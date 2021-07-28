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
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF692C432BE
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Jul 2021 13:34:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A98FD60FED
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Jul 2021 13:34:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236794AbhG1NeS (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 28 Jul 2021 09:34:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236776AbhG1NeS (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Jul 2021 09:34:18 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACE8CC061757
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 06:34:15 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id n2so3210832eda.10
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 06:34:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AUesTwcxeAi6DuKyk7+W9sZDBgdtg3G+7+VR4JwgM3I=;
        b=lEFpp3g9kFxDHiKxNEh3iFvN/vHTWVf+X1TlPczyysuZ4BPtqmsIS2PXBCoE1KCxcX
         K77CPin4uem7kQBxBPCNpuV4vXKkENaFtMJLyNjTw2ctXcOPUBmxK0Hk73zfnoWQ00OZ
         Uz5aBeQRkQzzpHOCfnd71m4EMNykSOHu+YPQlAtXC1U+PPycbvD7sy5YMOUMQCupuw8/
         +t9bkuqQFDBjI1cDeVK4rbzd/jkZchq9lQljY6Tts/WVqBBBkBdNi6ravJi0MW8+0AO4
         Km1+2uWKX44j57g/hwMD94whBfTltJjNdNu6HN8uimlpBYHfVksGLdsWlQvSSmskmsYY
         /JgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AUesTwcxeAi6DuKyk7+W9sZDBgdtg3G+7+VR4JwgM3I=;
        b=k/AP/VALky7llHfkh2H+Goh8EFvNiv1J0buoJEPTvwvM98WGzlI71mTu7qvXSwq+j0
         Q+BOwabuFNcCgLOttA6LJ2SChkt7d2dfhLzk3SnQY0xdLbcE27zdogV48pMsb1BREPAN
         l1paE4PiY9zKuBGicaP55gluqJUJOEarj9x7DfJFudpgEg6RDRuWTKJoWtGFkTmQpo2K
         mEpPmtjF58N4bzsQ1OZL65dZEyNUj6pZYYuiANVIp0a0LvHBN2Y10DNv12JHtxOxYvNr
         UvmWcL49Nu/QtvGUPl1t87l8L9S3ZY/eVdLaTiPeiHRH4Ve9HvS2h62964K6pd2a8RxH
         0WVg==
X-Gm-Message-State: AOAM5310mnkFwKEKM4JvFSkzlYP1kbyHGxe9bVnRc/wwUWFrUKO2BZWt
        SSODDYscrygw253rFNNHaSA=
X-Google-Smtp-Source: ABdhPJyWOFDXfp7ksRezk9lpONusBPznr8qpX5QhkoNF0aApoJ8Hs/6n84ue7Lsdv5K8unzj84NUIA==
X-Received: by 2002:a05:6402:550:: with SMTP id i16mr18504400edx.177.1627479254363;
        Wed, 28 Jul 2021 06:34:14 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id b25sm2700705edv.9.2021.07.28.06.34.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 06:34:13 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 76/87] tarce-cmd library: Copy CPU count between trace files
Date:   Wed, 28 Jul 2021 16:32:39 +0300
Message-Id: <20210728133250.234140-77-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210728133250.234140-1-tz.stoyanov@gmail.com>
References: <20210728133250.234140-1-tz.stoyanov@gmail.com>
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
index 2edb6b7e..ed91e8bc 100644
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

