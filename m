Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81D00C433EF
	for <linux-trace-devel@archiver.kernel.org>; Wed, 19 Jan 2022 08:27:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352470AbiASI1i (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 19 Jan 2022 03:27:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352458AbiASI1e (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 19 Jan 2022 03:27:34 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FD98C06161C
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jan 2022 00:27:34 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id j23so2454106edp.5
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jan 2022 00:27:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vpewCo1rrp1XIy486ODOklGV+ZGpCBJZq5i/DlMZglU=;
        b=JM184s1+NH/p+6uZJ9dgUkSQxT0zKLbadaB4UjP4d05r5v1NGm/I2qP/4AaN831f4B
         iTZM4stqaFVjhgebBeEEhXF0Y0FjuLiWmhlyQ6gcNLG+MieGVuQEHu5RkfFM6Pt+kuPG
         r49cN1zTL/LQnrnFl/9JHgePCuHJhM2jNwiyNTuAUPaAY9lWTK/ys3zAgErHpkzl+MxT
         iDeSyQsQ2+I/zXVGKQisd8+8EeERsPog0e/kabpFg4FSOKwKXq7rySPUkSNg9kil2NNM
         iFsKN75has8rtRG9Df23Td5mLkskEnNfa7ZtT9iCJlTAAzmIpjdJ3KyP66JNtMxyDMmT
         TNBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vpewCo1rrp1XIy486ODOklGV+ZGpCBJZq5i/DlMZglU=;
        b=sMhZNd08AiLdANFsLZeasLC4qgrWSTBp3IsGA/lf8n89eZaKbq5oFMRfSFAKCDJ99B
         97kbpwP6BcD35Welt4wkvT3MS6YWPyzXZYZXiYgtDGBkl9GB0ig64YutyocNNhp+KhCF
         yvVDXMOkL1OONBP8w/HpkQvI81G/Pvsj+Hu5DEelRl8g2Go6+feQhB2dc04U57Vrr1kY
         V/6BuFUFmLJ2OVaKwhCWiCva53Qug7KbVdhodh1q8YESq3h9Oq89NcDbcZPYNOyryVtH
         Kh08l7ZYuw0vIV0vhkDUn70fMXHcphghpQWSbKwLct/VS+xEP0+RGDc5TRMAcZY6Z9Ht
         fFjw==
X-Gm-Message-State: AOAM530AbLPN5geKAyY4cEp6yQvoY/kTLB+eWxro5hVOXSJ3taMN8x7k
        Puo2MR5o2dPp07ZqSGymadD+jy8ue3c=
X-Google-Smtp-Source: ABdhPJwWsegwfoOOQMZnpBYoZh3Awp7PgCsciZdRYm6ZadT+jodiyB5X2PCi2o6X4AOqOLXqLF8+1Q==
X-Received: by 2002:a17:907:92e:: with SMTP id au14mr21457914ejc.547.1642580852682;
        Wed, 19 Jan 2022 00:27:32 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id d14sm848703edu.57.2022.01.19.00.27.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jan 2022 00:27:32 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v7 16/20] trace-cmd library: Decompress file sections on reading
Date:   Wed, 19 Jan 2022 10:27:11 +0200
Message-Id: <20220119082715.245846-17-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220119082715.245846-1-tz.stoyanov@gmail.com>
References: <20220119082715.245846-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

When reading sections from trace file v7 - check section flags to find
out if the section is compressed and decompress  it.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-input.c | 24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index e772b463..cac1d554 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -484,12 +484,15 @@ static struct file_section *section_open(struct tracecmd_input *handle, int id)
 
 	if (lseek64(handle->fd, sec->data_offset, SEEK_SET) == (off64_t)-1)
 		return NULL;
+	if ((sec->flags & TRACECMD_SEC_FL_COMPRESS) && in_uncompress_block(handle))
+		return NULL;
 	return sec;
 }
 
 static void section_close(struct tracecmd_input *handle, struct file_section *sec)
 {
-	/* To Do */
+	if (sec->flags & TRACECMD_SEC_FL_COMPRESS)
+		in_uncompress_reset(handle);
 }
 
 static int section_add_or_update(struct tracecmd_input *handle, int id, int flags,
@@ -1116,6 +1119,8 @@ static int handle_section(struct tracecmd_input *handle, struct file_section *se
 		return -1;
 
 	section->data_offset = lseek64(handle->fd, 0, SEEK_CUR);
+	if ((section->flags & TRACECMD_SEC_FL_COMPRESS) && in_uncompress_block(handle))
+		return -1;
 
 	switch (section->id) {
 	case TRACECMD_OPTION_HEADER_INFO:
@@ -1141,6 +1146,9 @@ static int handle_section(struct tracecmd_input *handle, struct file_section *se
 		break;
 	}
 
+	if (section->flags & TRACECMD_SEC_FL_COMPRESS)
+		in_uncompress_reset(handle);
+
 	return ret;
 }
 
@@ -4055,6 +4063,7 @@ static int read_metadata_strings(struct tracecmd_input *handle)
 	unsigned short flags;
 	int found = 0;
 	unsigned short id;
+	unsigned int csize, rsize;
 	unsigned long long size;
 	off64_t offset;
 
@@ -4064,7 +4073,18 @@ static int read_metadata_strings(struct tracecmd_input *handle)
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

