Return-Path: <SRS0=t+9I=SE=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4741C4360F
	for <linux-trace-devel@archiver.kernel.org>; Tue,  2 Apr 2019 13:42:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9D0642147C
	for <linux-trace-devel@archiver.kernel.org>; Tue,  2 Apr 2019 13:42:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731740AbfDBNm4 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 2 Apr 2019 09:42:56 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:40007 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731745AbfDBNm4 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 2 Apr 2019 09:42:56 -0400
Received: by mail-wr1-f67.google.com with SMTP id h4so16701202wre.7
        for <linux-trace-devel@vger.kernel.org>; Tue, 02 Apr 2019 06:42:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Lg02P6aEHrWfEHsIREncaJtq5C+qOqu3BVw/fV7EDAk=;
        b=Is7F2Np/hzXQO99NUrcAgA9/KHlXfgGy4ZVYGL+vEtRnZ4aglD6Pxzq6kur4UOsAvI
         HQIOowxEl2nzc3qMehuWIiI7kwXw/A4tWM84Vf4RSvhDweNip9AV9+H2EyZSxfw9QdSJ
         wpZQsz7VYwKAFCdxTrbkKh5kxuz4LK2cNy3gGjnWOrXvXaqQwvGYPs3weZCUkAIij4wj
         tf9siXnlfMfUzw4T8zLkuOjW5MEBsZugUyHveHWrLqFAAY2o/T4w6Oagt9oPaU+8FYBG
         oXd48BcPDMPIzjBjG72ZHf0Lk3b1X5T+fDXR4luD+R2aXjC45tRyWRBmwbozzuwCrpJE
         DJTg==
X-Gm-Message-State: APjAAAU0HxcPQSchfOxjj60lxqMjJSBu8NtNYgji+8WIgXlzUCDHDtki
        wU91G4Ez8585cIUyJsYlIQ==
X-Google-Smtp-Source: APXvYqzf55R2yzQK2c91CPFERWEWu1sxltn+UzFx4l2Dem+NuT5oeFB+rk9DPd+LqNSWZamtlecwdw==
X-Received: by 2002:adf:f80c:: with SMTP id s12mr47223067wrp.72.1554212574375;
        Tue, 02 Apr 2019 06:42:54 -0700 (PDT)
Received: from box.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id h84sm19207083wmf.15.2019.04.02.06.42.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 02 Apr 2019 06:42:53 -0700 (PDT)
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     rostedt@goodmis.org, linux-trace-devel@vger.kernel.org
Cc:     slavomir.kaslev@gmail.com
Subject: [RFC PATCH v8 08/13] trace-cmd: Use splice(2) for vsockets if available
Date:   Tue,  2 Apr 2019 16:42:22 +0300
Message-Id: <20190402134230.30988-17-kaslevs@vmware.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190402134230.30988-1-kaslevs@vmware.com>
References: <20190402134230.30988-1-kaslevs@vmware.com>
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
index 1b84bb5..d66f112 100644
--- a/lib/trace-cmd/trace-recorder.c
+++ b/lib/trace-cmd/trace-recorder.c
@@ -386,10 +386,8 @@ static long splice_data(struct tracecmd_recorder *recorder)
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
index 98cc4f3..6bfcab4 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -2660,12 +2660,61 @@ static int open_vsock(unsigned int cid, unsigned int port)
 
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
@@ -2870,13 +2919,16 @@ create_recorder_instance(struct buffer_instance *instance, const char *file, int
 
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

