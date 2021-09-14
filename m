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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CC32C433EF
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Sep 2021 13:17:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7642860C51
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Sep 2021 13:17:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233217AbhINNS1 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 14 Sep 2021 09:18:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232989AbhINNSW (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 14 Sep 2021 09:18:22 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94A52C061574
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Sep 2021 06:17:05 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id s24so9228416wmh.4
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Sep 2021 06:17:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KUu8wEBDFHkS++DKeU8RnSaGh748X1gceNhCKSNAVhw=;
        b=GFyTubmtZgIMrsjOEeG2amciVajMQcyVmPUUFtYmFW0CCGE+TIHQ0f3KXnSFtLTcsh
         yVTORaopzcAuUZvKy5EbJJlw63F0UNrACiTAihby7ywJiw3UaGrAQc5TDH8ihxJ+9A1t
         tNRkArCFUkA+Akf0tF7+P36vw2kT12CWuUoehPkjUgTLcOLB4XhmkJvf3GhvXML68prw
         oEMGvTRv/GET4X1cfeG1YJWq7jzHoqnJ4fhbcYYwugNfJsFMtKmn58LSvDui3OgS8Dgf
         Po6vMxQcomZbwJbaXZAn0t817hA5jKmmk+xGUdR0YDWng53ofhPiBGUByOj1DPUjAfpi
         48fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KUu8wEBDFHkS++DKeU8RnSaGh748X1gceNhCKSNAVhw=;
        b=bSsXdpqt6NyT6jlvPlxlHxV2U1eUmG/YByo2XlsuquWggirLvVftQyTSg/6tBUSW1E
         CHkfpI7NXeI3di0O21/bcm8GKSvcpdMt12gZlLFBTpYAkIanOeXYFstNHACRAJmONjzN
         qnA0VcfOu2qc0RP+oWLkEBwup6NIfWFanKXMUtQ3r1FMicSBiuLUcj+DA0fkq4Sp3GYW
         iIX6PAI4EdxvhWctUu5IA91j1RccOwdPiksN0r2EzbP7kN32ChPZtnzJjVATNkOyEVE6
         tED6v0rta/cCol6eM+NnVY3NXXbt++wcPdVB/HPRdgXLpla4IhbctYy57mtyxOkwAN7R
         yQ8A==
X-Gm-Message-State: AOAM5300LvenvQrnTQcFazvTi1/roP4LxOPvz/M5kx3/RCyi+H1oOcmW
        xRQ7X2y5TPujmwr055lkuT5wVRXGSSk=
X-Google-Smtp-Source: ABdhPJyMo05Qsjnd4q1F0CJzO18MdeFUD0gNZk/EIfpqJBg18/mRg5aUXKs3hA3T3E9sxHUec2XXWA==
X-Received: by 2002:a1c:20c5:: with SMTP id g188mr2128756wmg.182.1631625423825;
        Tue, 14 Sep 2021 06:17:03 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id q10sm1119624wmq.12.2021.09.14.06.17.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 06:17:03 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 16/20] trace-cmd library: Decompress file sections on reading
Date:   Tue, 14 Sep 2021 16:16:41 +0300
Message-Id: <20210914131645.3966308-17-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210914131645.3966308-1-tz.stoyanov@gmail.com>
References: <20210914131645.3966308-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

When reading sections from trace file v7 - check section flags to find
out if the section is compressed and decompress  it.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-input.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 80230ba5..290bcf5e 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -480,12 +480,15 @@ static struct file_section *section_open(struct tracecmd_input *handle, int id)
 
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
 
-- 
2.31.1

