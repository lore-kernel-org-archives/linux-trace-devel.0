Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B7A2C433F5
	for <linux-trace-devel@archiver.kernel.org>; Mon, 11 Apr 2022 04:10:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234291AbiDKEMz (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 11 Apr 2022 00:12:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233151AbiDKEMy (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 11 Apr 2022 00:12:54 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45C282DC8
        for <linux-trace-devel@vger.kernel.org>; Sun, 10 Apr 2022 21:10:41 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id m30so21147548wrb.1
        for <linux-trace-devel@vger.kernel.org>; Sun, 10 Apr 2022 21:10:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZDNEpWC9t/tJaB/T0fk5diJJOG8fEIPQq5HRuBB2qAs=;
        b=K3nixAMI3S8WN8kAnL5J7KFJYgT77MuANv2vPnUmkkpDaypVOV12pXwhhXbqJyiWJi
         bWaBKIFptr32BGIQSDdEPP528riRjvLzTMVffkdJdgidI4FFfswGIa9HRAVty1gZMCSn
         BAfg8sUoe1w/pVSMUolkh0dwXIEnNni0itYkwYfouMTY8+uaUvm8JGbQKjPpDoLp13u5
         b8DOWzLv8EjZyf1nJ1MO4dSfZtpyhDGOzGTKpLG5rVXC3hOr3IQknaxdzlbB//375ozo
         2XmRfOCeiIn0NGI0vY9AXn4botaw7VD93VQnFTVim4SvKSYELaSviIGlPyf0mJVUSf5L
         pycQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZDNEpWC9t/tJaB/T0fk5diJJOG8fEIPQq5HRuBB2qAs=;
        b=zXu6/jo5Na48a7AhGzPjFll0G9ljAcLMI8Kt6lehpVFBxbrdAZH+vz2efddqX4hBff
         mmyFw0ouDCuFrpsNsBZO6d3c0ZB0gTy1P+7og4P1QoRbPJ+B5ZCp+n1T/9AYXGxymvNV
         voKk1kruzYLbhKM6c5ZPKFVKPdp4fmE+PbNP0z40OZtzT+QRefn2CL3wSHgJuIxlbN5E
         PnZm5ip5DGC8igQ009kTMMaNUq6jLodXLNrOvyEsSSM2bo2HuGMlu+34Csm2Fhhl/MdR
         4r9S1wKw4/JfaGNHCHns4BCf2wMNI4MNB8C7Ghj6KWk6csFeBxhc520mIBfjztBakVs4
         J5HA==
X-Gm-Message-State: AOAM531OB1pfVG2DHIJr5HkEPgKyk3u3ST2HStzGrql5sPzk/oxMbJ0J
        pHgl96jcIqE0XhzQ8EARYVhDwNGHGzQ=
X-Google-Smtp-Source: ABdhPJzMKhat2bNshTCI7gv3KFUnMp2S8wzyXfilZV/j9HMQ4rRPlMsZXfZPpG29tWSvnkQD5gbVvQ==
X-Received: by 2002:a5d:4d02:0:b0:207:a6e8:ef4a with SMTP id z2-20020a5d4d02000000b00207a6e8ef4amr2141154wrt.245.1649650239531;
        Sun, 10 Apr 2022 21:10:39 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id i7-20020a5d5587000000b00207a8cde900sm728479wrv.19.2022.04.10.21.10.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Apr 2022 21:10:39 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH] trace-cmd: Write the actual size of compressed block in the trace file
Date:   Mon, 11 Apr 2022 07:10:38 +0300
Message-Id: <20220411041038.132453-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Before a data block is compressed using the chosen compression
algorithm, a hook function is called to calculate the size of the
required buffer to compress the data. In most cases that size is bigger
than the actual size of the compressed data. The current logic writes
into the trace file that buffer with its calculated size, even though
part of it is not used. In the trace file should be written only the
compressed data block, with its real size.

fixes: 3f8447b1 ("trace-cmd library: Add support for compression algorithms")
Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-compress.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/lib/trace-cmd/trace-compress.c b/lib/trace-cmd/trace-compress.c
index aa03d17c..a63295e6 100644
--- a/lib/trace-cmd/trace-compress.c
+++ b/lib/trace-cmd/trace-compress.c
@@ -303,7 +303,7 @@ error:
  */
 int tracecmd_compress_block(struct tracecmd_compression *handle)
 {
-	unsigned int size;
+	unsigned int size, real_size;
 	char *buf;
 	int endian4;
 	int ret;
@@ -318,12 +318,14 @@ int tracecmd_compress_block(struct tracecmd_compression *handle)
 	if (!buf)
 		return -1;
 
-	ret = handle->proto->compress_block(handle->context, handle->buffer, handle->pointer, buf, size);
-	if (ret < 0)
+	real_size = handle->proto->compress_block(handle->context, handle->buffer, handle->pointer, buf, size);
+	if (real_size < 0) {
+		ret = real_size;
 		goto out;
+	}
 
 	/* Write compressed data size */
-	endian4 = tep_read_number(handle->tep, &ret, 4);
+	endian4 = tep_read_number(handle->tep, &real_size, 4);
 	ret = do_write(handle, &endian4, 4);
 	if (ret != 4)
 		goto out;
@@ -337,8 +339,8 @@ int tracecmd_compress_block(struct tracecmd_compression *handle)
 	}
 
 	/* Write compressed data */
-	ret = do_write(handle, buf, size);
-	if (ret != size) {
+	ret = do_write(handle, buf, real_size);
+	if (ret != real_size) {
 		ret = -1;
 		goto out;
 	}
-- 
2.35.1

