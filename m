Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F91BC433EF
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Dec 2021 10:59:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240121AbhLJLDa (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 10 Dec 2021 06:03:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237285AbhLJLDa (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 10 Dec 2021 06:03:30 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C695C061746
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Dec 2021 02:59:55 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id w1so28501279edc.6
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Dec 2021 02:59:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TSnm0a26M58DHTqXW7gtU3LVcAdETyef38QT6KMLRlA=;
        b=WUUeqDexX9NB/QfNFuTOPDg5daooBO0Bz+1bKRYV/qPab0npQ9WcYD2sSoKfhO6uEB
         2l/oY+6QcuNXom98xwzwwRuIXXJfwPw2gD1wq+/RXmZRVXyoy1jeobg7SyLZnpQewaa5
         DFsYK0ME2rc31p9D/tyRT70LOCO7Y2N/E4iU7etLHCJdhZ4tD4o66io6XsGd+gmlaCWF
         p+flbUUahf4o3J3U1Sgo1OCzbAlpqgunfKGgxPPF9diP4AiyCNe8K6NQ3U7/tGWwoNnG
         BkvIlxQXQBKfElgecKcUZaD6fNyRuMs55lokPTnA331/WEpLCXPqUF+/5QkdTuAeCJxB
         W6sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TSnm0a26M58DHTqXW7gtU3LVcAdETyef38QT6KMLRlA=;
        b=M+HZaGRQoUdbAmX8qhkAKmkgC87QrrnKhbKKN42edK+Gy20Hohv/QERODjVSBs7g8U
         ethcknBnt5hLrbjRQIOj2UGEVkwArvT0GiQuaHLCZgmZetKn/sH1wVDOV9mU/pKAYN4e
         G39wqoQJtiR4z3OYR5nHMeoPiR9k6KidVyKBfytZo7+1qoTKECE2vbtxEbxrhI/7F+bG
         lglKN3NXoZlhkhVygjvuBnH2Y9W7LDmxprhAckbXltYMNoTcCzAVzi5VTV2thkhokiJE
         klrWDVN638FWWSosN54rgLUPK2Z6ra1QIsRrqAy/PCXCEB0Ea23BdRlbjRq61e4Hoc/q
         jxXw==
X-Gm-Message-State: AOAM532yzcytnwRedmfNel8Lk3d9L39+qFJhz2Zd4pElKkQwKGAWF9vs
        Yi6c5PjM3A8/9YaDfjNwgrnS+OU1YjU=
X-Google-Smtp-Source: ABdhPJyy3BF5LXFbNNln4uL8N0pbSWyhbEwUca2WHo34n7zfsGNyZ8PRe3vINGBMf8QW8ROIFxvNww==
X-Received: by 2002:a17:906:4fc5:: with SMTP id i5mr23501859ejw.475.1639133993579;
        Fri, 10 Dec 2021 02:59:53 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id j17sm1320379edj.0.2021.12.10.02.59.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 02:59:53 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v6 16/20] trace-cmd library: Decompress file sections on reading
Date:   Fri, 10 Dec 2021 12:59:34 +0200
Message-Id: <20211210105938.98250-17-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211210105938.98250-1-tz.stoyanov@gmail.com>
References: <20211210105938.98250-1-tz.stoyanov@gmail.com>
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
index a631692a..97ad47cc 100644
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
@@ -1114,6 +1117,8 @@ static int handle_section(struct tracecmd_input *handle, struct file_section *se
 		return -1;
 
 	section->data_offset = lseek64(handle->fd, 0, SEEK_CUR);
+	if ((section->flags & TRACECMD_SEC_FL_COMPRESS) && in_uncompress_block(handle))
+		return -1;
 
 	switch (section->id) {
 	case TRACECMD_OPTION_HEADER_INFO:
@@ -1139,6 +1144,9 @@ static int handle_section(struct tracecmd_input *handle, struct file_section *se
 		break;
 	}
 
+	if (section->flags & TRACECMD_SEC_FL_COMPRESS)
+		in_uncompress_reset(handle);
+
 	return ret;
 }
 
@@ -4044,6 +4052,7 @@ static int read_metadata_strings(struct tracecmd_input *handle)
 	unsigned short flags;
 	int found = 0;
 	unsigned short id;
+	unsigned int csize, rsize;
 	unsigned long long size;
 	off64_t offset;
 
@@ -4053,7 +4062,18 @@ static int read_metadata_strings(struct tracecmd_input *handle)
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
2.33.1

