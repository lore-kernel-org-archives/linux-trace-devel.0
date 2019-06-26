Return-Path: <SRS0=TDtF=UZ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26995C48BD6
	for <linux-trace-devel@archiver.kernel.org>; Wed, 26 Jun 2019 10:52:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 026D020656
	for <linux-trace-devel@archiver.kernel.org>; Wed, 26 Jun 2019 10:52:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oZFkrozt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726948AbfFZKw0 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 26 Jun 2019 06:52:26 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:35247 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726992AbfFZKw0 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 26 Jun 2019 06:52:26 -0400
Received: by mail-wr1-f65.google.com with SMTP id f15so2207277wrp.2
        for <linux-trace-devel@vger.kernel.org>; Wed, 26 Jun 2019 03:52:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0ZoJEAyBgB4UNUmEIVNa+o5MCXZSNvQUkLr7LJOPY8s=;
        b=oZFkroztP2sfIJfzdSF5v1YHZbEbwUwmapKamAEiUBYTxp4Cxgb1jnAq7rHY3oA6Zi
         rOwE6JHfwxBQQ5UlZiquYrMUMKVK7sHm4C21lMNqwoV1ibAq0FLvwNO8gHH0DtNZWX3W
         ZfM8ekkkesLaZogiSDCL/y53p97ViksURE55dX0MHI1hxiTF7vIcijqHUi+1G2BI8DHx
         DcBdXkpiDfRAS7U5pQ0ktbMW/QnSFnQbIhhnVgxU/CxGnhfRxMH3vhmrdrF8bbpPG4a+
         dVR8ZgvY82CeqSpgfVWa05+bu0aTtjOI/af6CtoQlGxfNm57eYb+Vxka9QUCUBxPil4w
         SoDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0ZoJEAyBgB4UNUmEIVNa+o5MCXZSNvQUkLr7LJOPY8s=;
        b=Gv4IczHlJHkUnCO0VkGf8vMgnVKU8gZiVN4iIfYXFcVw13J7C4OY1ljJYDo55xljsb
         EcB+/8p1WV/U6o4KoyJtSEAaz9EttEzd14Qlc5regGrMvI7YiRgTXtVoMo+pFr6Aomso
         hDfPN/c+dom80V9SY096YazFjfBA4sdYxFqgiCWHhwackse4fqjsqahbYcNDOjjL2bqO
         R5hLJK1SVSYNTTjy1QDGds27YuM0InnjRFCC/WXAgAe/uVq3s04XnpdpMfIAnxdt1F3u
         dVGMDxzG2xwRnq40HtDZ1bxjBnM+359+pvWgrPsZQGVACtPkAz4R94uOAJvsuvxtVlQa
         sHsA==
X-Gm-Message-State: APjAAAVw7U7l2Sslee6BbribtPkOQ77bMCsrL3m3l+6WyH+zPNDJ8os+
        tilQh+bZuK1bSlsrztsMVA==
X-Google-Smtp-Source: APXvYqwBBe4Bh0IlbksAwtb2qvHsSBuapARIh8ziE+gr2/E99SeIUE+XPB1S/3f5BgLUUROf0OpQAQ==
X-Received: by 2002:adf:dfc5:: with SMTP id q5mr3374909wrn.142.1561546344256;
        Wed, 26 Jun 2019 03:52:24 -0700 (PDT)
Received: from box.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id s10sm15456929wrt.49.2019.06.26.03.52.23
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 26 Jun 2019 03:52:23 -0700 (PDT)
From:   "Slavomir Kaslev (VMware)" <slavomir.kaslev@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v13 07/13] trace-cmd: Use splice(2) for vsockets if available
Date:   Wed, 26 Jun 2019 13:52:03 +0300
Message-Id: <20190626105209.13200-8-slavomir.kaslev@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190626105209.13200-1-slavomir.kaslev@gmail.com>
References: <20190626105209.13200-1-slavomir.kaslev@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Slavomir Kaslev <kaslevs@vmware.com>

Detect if splice(2) reading is supported for vsockets (Linux 4.20 and
later) and use it, or fallback to read/write-ing otherwise.

Signed-off-by: Slavomir Kaslev <kaslevs@vmware.com>
---
 tracecmd/trace-record.c | 56 +++++++++++++++++++++++++++++++++++++++--
 1 file changed, 54 insertions(+), 2 deletions(-)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index a99aa63..130eab7 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -2718,12 +2718,61 @@ static int open_vsock(unsigned int cid, unsigned int port)
 
 	return sd;
 }
+
+static int try_splice_read_vsock(void)
+{
+	int ret, sd, brass[2];
+
+	sd = socket(AF_VSOCK, SOCK_STREAM, 0);
+	if (sd < 0)
+		return -errno;
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
@@ -2927,13 +2976,16 @@ create_recorder_instance(struct buffer_instance *instance, const char *file, int
 
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
2.20.1

