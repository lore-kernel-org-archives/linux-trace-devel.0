Return-Path: <SRS0=qNMP=SY=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9327DC10F11
	for <linux-trace-devel@archiver.kernel.org>; Mon, 22 Apr 2019 14:55:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 69F4120656
	for <linux-trace-devel@archiver.kernel.org>; Mon, 22 Apr 2019 14:55:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727804AbfDVOze (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 22 Apr 2019 10:55:34 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:39966 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726132AbfDVOze (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 22 Apr 2019 10:55:34 -0400
Received: by mail-wr1-f67.google.com with SMTP id h4so16088364wre.7
        for <linux-trace-devel@vger.kernel.org>; Mon, 22 Apr 2019 07:55:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QLdWRZm/W9su2Jf1gcxBiO8slcy7S1fb9p8fnu/O4u8=;
        b=eONz8vL+zlcxphs8yFjT1CBdqguJAlZUdQHUrICrGukeFsdSa2GO0R/VgWhN2UeqLQ
         psAVYByU987o24MfcHmSax4zRgTaYEwX3HAM8TExSQ8QtrxyRoVYSexDywi56NdYWuM2
         TgK7d+34kqIexvUVdlqaf00v0h7ESUshGkKuQG7r2i58oab15i12u8WaWbV2u2Au9eUF
         kNuDHF6iXLhqDtLuNqOrtn20r3Wz4IxAdA10dmJ9rPP79lCz7Pk4EffivSejgO2gpUy5
         DLhrWb8J2Zd6irCfKIKdvVuJhjIVf6CofHeFcc8ox6pRn0gDdN+MVp9h9Itq1aYoi7cO
         SU4w==
X-Gm-Message-State: APjAAAVSI0G7cooGl+fAvCVZpjEYrWGc2vYY/KywVU0JcESmGi0WPLGu
        Qphv2tIY+3wvxSUiELewwP/E5WtQXw==
X-Google-Smtp-Source: APXvYqySNHOCXA2UYTLXzqW378OCStZVcF8rY0G0pYztiHeq9AQUsGTlw4kmlqXF4xMsJNB16y2MWg==
X-Received: by 2002:adf:fc47:: with SMTP id e7mr14179671wrs.100.1555944932203;
        Mon, 22 Apr 2019 07:55:32 -0700 (PDT)
Received: from box.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id f128sm17321087wme.28.2019.04.22.07.55.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 22 Apr 2019 07:55:31 -0700 (PDT)
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v10 07/12] trace-cmd: Use splice(2) for vsockets if available
Date:   Mon, 22 Apr 2019 17:55:14 +0300
Message-Id: <20190422145519.16146-8-kaslevs@vmware.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190422145519.16146-1-kaslevs@vmware.com>
References: <20190422145519.16146-1-kaslevs@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Detect if splice(2) reading is supported for vsockets (Linux 4.20 and
later) and use it, or fallback to read/write-ing otherwise.

Signed-off-by: Slavomir Kaslev <kaslevs@vmware.com>
---
 lib/trace-cmd/trace-recorder.c |  6 ++--
 tracecmd/trace-record.c        | 56 ++++++++++++++++++++++++++++++++--
 2 files changed, 56 insertions(+), 6 deletions(-)

diff --git a/lib/trace-cmd/trace-recorder.c b/lib/trace-cmd/trace-recorder.c
index 0ea7a87..6b168a7 100644
--- a/lib/trace-cmd/trace-recorder.c
+++ b/lib/trace-cmd/trace-recorder.c
@@ -394,10 +394,8 @@ static long splice_data(struct tracecmd_recorder *recorder)
 	ret = splice(recorder->brass[0], NULL, recorder->fd, NULL,
 		     read, recorder->fd_flags);
 	if (ret < 0) {
-		if (errno != EAGAIN && errno != EINTR) {
-			warning("recorder error in splice output");
-			return -1;
-		}
+		if (errno != EAGAIN && errno != EINTR)
+			return ret;
 		return total_read;
 	} else
 		update_fd(recorder, ret);
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 1c6e115..eacb7e9 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -2703,12 +2703,61 @@ static int open_vsock(unsigned int cid, unsigned int port)
 
 	return sd;
 }
+
+static int try_splice_read_vsock(void)
+{
+	int ret, sd, brass[2];
+
+	sd = socket(AF_VSOCK, SOCK_STREAM, 0);
+	if (sd < 0)
+		return sd;
+
+	ret = pipe(brass);
+	if (ret < 0)
+		goto out_close_sd;
+
+	/*
+	 * On kernels that don't support splice reading from vsockets
+	 * this will fail with EINVAL, or ENOTCONN otherwise.
+	 * Technically, it should never succeed but if it does, claim splice
+	 * reading is supported.
+	 */
+	ret = splice(sd, NULL, brass[1], NULL, 10, 0);
+	if (ret < 0)
+		ret = errno != EINVAL;
+	else
+		ret = 1;
+
+	close(brass[0]);
+	close(brass[1]);
+out_close_sd:
+	close(sd);
+	return ret;
+}
+
+static bool can_splice_read_vsock(void)
+{
+	static bool initialized, res;
+
+	if (initialized)
+		return res;
+
+	res = try_splice_read_vsock() > 0;
+	initialized = true;
+	return res;
+}
+
 #else
 static inline int open_vsock(unsigned int cid, unsigned int port)
 {
 	die("vsock is not supported");
 	return -1;
 }
+
+static bool can_splice_read_vsock(void)
+{
+	return false;
+}
 #endif
 
 static int do_accept(int sd)
@@ -2913,13 +2962,16 @@ create_recorder_instance(struct buffer_instance *instance, const char *file, int
 
 	if (is_guest(instance)) {
 		int fd;
+		unsigned int flags;
 
 		fd = open_vsock(instance->cid, instance->client_ports[cpu]);
 		if (fd < 0)
 			die("Failed to connect to agent");
 
-		return tracecmd_create_recorder_virt(
-			file, cpu, recorder_flags | TRACECMD_RECORD_NOSPLICE, fd);
+		flags = recorder_flags;
+		if (!can_splice_read_vsock())
+			flags |= TRACECMD_RECORD_NOSPLICE;
+		return tracecmd_create_recorder_virt(file, cpu, flags, fd);
 	}
 
 	if (brass)
-- 
2.19.1

