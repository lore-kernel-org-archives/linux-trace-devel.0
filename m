Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0ED4C28CF5
	for <linux-trace-devel@archiver.kernel.org>; Wed, 26 Jan 2022 09:49:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232786AbiAZJtg (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 26 Jan 2022 04:49:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239402AbiAZJtd (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 26 Jan 2022 04:49:33 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB203C06161C
        for <linux-trace-devel@vger.kernel.org>; Wed, 26 Jan 2022 01:49:31 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id jx6so37800171ejb.0
        for <linux-trace-devel@vger.kernel.org>; Wed, 26 Jan 2022 01:49:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VmSDOZEmnC1Q4tZ1Rluqfwgaw/xNXvnUCl6K8fiymH0=;
        b=i8KOi504XVzYtIsNnAxCohVLB41vNSQqpLm98sWIMjIqj1xzwVeltrLlN9J6nJ5Dkh
         ZGmVxLNqr0qVuKykQhH1FP+2nyfh69VmDdFG9QGfnpKVtS/ghEmCKmJKQKw6B0GLSNEs
         c4WgswzRw3lKzetRhIfHvzaA09BtG30c3F8y+GpqtE4BLGQ1GjEkIj/BI/P9pXS/c6LU
         zxNBs13I0s/Qm+RUONpGe+pn91misJJG69nEIh+ALmEBgEiKt0t1VmwXQKhkDWZxhIp/
         d1vjkRPrClvR0blO1H7yOp5ilhTH7UCOdc/oi1RVwPr60kES6jqtVo/Mpg+QOJ0aB+Ty
         mEVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VmSDOZEmnC1Q4tZ1Rluqfwgaw/xNXvnUCl6K8fiymH0=;
        b=oX+siKSr5F4TRH/uom2bt6p7ANpFrqVEfiNFWGANPJaMiQPCADHhdxt2vHo2TAPMtx
         lCejDaAuiVikeWdgJhBu4LpiogKHrxr4jyW+nzd+vniTxSlXhKQyF+IjCNSw2k9YXR+F
         Jcv7Bxmrf6yjyrmQGv5t44ArsguvLSKUCmxaMaFsktiyVxU9mMYLtgeFz1dnCkdltLuI
         QyFzl4U26y3L6rLJC8sE/4gqFxns80DuWo5QUagv/h64wS24WH28rJhvhIAKQPfZz5XU
         gw6mVo0C59/znbJ5h8pRqXjgXAzA9Y2Wy2vyyJFdaJlaKJSR+5Yh4j0OmqqUKYEHFdfY
         /AhA==
X-Gm-Message-State: AOAM532qNdB3mikdq7NIbeIvwFwL4BLs6GRfg4YOlYRVRiei3JmBVmrk
        epVIshvdIPKXaxL46aspf7M3Hj7vCyI=
X-Google-Smtp-Source: ABdhPJzpDuAaIwghTlEnB483TBAZ1ZFsw2SuYbk+P7vtCTIMNX5bybB+ro9nW/f8FSnEzJoLsfQ1nw==
X-Received: by 2002:a17:907:1c12:: with SMTP id nc18mr11828138ejc.47.1643190570593;
        Wed, 26 Jan 2022 01:49:30 -0800 (PST)
Received: from oberon.zico.biz ([151.251.254.11])
        by smtp.gmail.com with ESMTPSA id e17sm7119155eje.218.2022.01.26.01.49.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 01:49:30 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v8 16/20] trace-cmd library: Decompress file sections on reading
Date:   Wed, 26 Jan 2022 11:49:02 +0200
Message-Id: <20220126094906.570451-17-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220126094906.570451-1-tz.stoyanov@gmail.com>
References: <20220126094906.570451-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

When reading sections from trace file v7 - check section flags to find
out if the section is compressed and decompress  it.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-input.c | 26 ++++++++++++++++++++++++--
 1 file changed, 24 insertions(+), 2 deletions(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 7d8f0fe4..3f7971c4 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -484,12 +484,17 @@ static struct file_section *section_open(struct tracecmd_input *handle, int id)
 
 	if (lseek64(handle->fd, sec->data_offset, SEEK_SET) == (off64_t)-1)
 		return NULL;
+
+	if ((sec->flags & TRACECMD_SEC_FL_COMPRESS) && in_uncompress_block(handle))
+		return NULL;
+
 	return sec;
 }
 
 static void section_close(struct tracecmd_input *handle, struct file_section *sec)
 {
-	/* To Do */
+	if (sec->flags & TRACECMD_SEC_FL_COMPRESS)
+		in_uncompress_reset(handle);
 }
 
 static int section_add_or_update(struct tracecmd_input *handle, int id, int flags,
@@ -1116,6 +1121,8 @@ static int handle_section(struct tracecmd_input *handle, struct file_section *se
 		return -1;
 
 	section->data_offset = lseek64(handle->fd, 0, SEEK_CUR);
+	if ((section->flags & TRACECMD_SEC_FL_COMPRESS) && in_uncompress_block(handle))
+		return -1;
 
 	switch (section->id) {
 	case TRACECMD_OPTION_HEADER_INFO:
@@ -1141,6 +1148,9 @@ static int handle_section(struct tracecmd_input *handle, struct file_section *se
 		break;
 	}
 
+	if (section->flags & TRACECMD_SEC_FL_COMPRESS)
+		in_uncompress_reset(handle);
+
 	return ret;
 }
 
@@ -4080,6 +4090,7 @@ static int read_metadata_strings(struct tracecmd_input *handle)
 	unsigned short flags;
 	int found = 0;
 	unsigned short id;
+	unsigned int csize, rsize;
 	unsigned long long size;
 	off64_t offset;
 
@@ -4089,7 +4100,18 @@ static int read_metadata_strings(struct tracecmd_input *handle)
 			break;
 		if (id == TRACECMD_OPTION_STRINGS) {
 			found++;
-			init_metadata_strings(handle, size);
+			if ((flags & TRACECMD_SEC_FL_COMPRESS)) {
+				read4(handle, &csize);
+				read4(handle, &rsize);
+				do_lseek(handle, -8, SEEK_CUR);
+				if (in_uncompress_block(handle))
+					break;
+			} else {
+				rsize = size;
+			}
+			init_metadata_strings(handle, rsize);
+			if (flags & TRACECMD_SEC_FL_COMPRESS)
+				in_uncompress_reset(handle);
 		} else {
 			if (lseek64(handle->fd, size, SEEK_CUR) == (off_t)-1)
 				break;
-- 
2.34.1

