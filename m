Return-Path: <SRS0=ayt5=VI=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5208EC74A35
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Jul 2019 13:03:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 26F8E21019
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Jul 2019 13:03:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="j3ao1Qnm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728180AbfGKNDP (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Jul 2019 09:03:15 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:44926 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725971AbfGKNDO (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Jul 2019 09:03:14 -0400
Received: by mail-wr1-f65.google.com with SMTP id p17so6193322wrf.11
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Jul 2019 06:03:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=o1v5rDCF84XbeQVuw2S+05ZHRphrkE0pHuSTo2O2QWo=;
        b=j3ao1QnmP8VHKLUB/YXJ+atdTaGqsqcd/FG3Q+Ua+nbTocTwbrH/GvfpNmK/trAK14
         axeR5ezGOuwXv8I41q20K/Ofmn/yH6hL5BOyQIzfO17l3+zGEIPTLPgj0QuupH9L3tsm
         TL/A2tzvlscaXruAih3uQDegWyfVXJpZWn02BG+bfu1LiEUZ6fCYRNX+tX+URXHaR89m
         WY7Z5FsVy/1cmwvU/gu6MsCiwaWpAY9XxFSHGHzwNY+8fyfr9wRGtMZxGfa81LXetgKD
         ykRiOD702QS+jje1aSUdhaH4RX/zJAZwVa664uyNCOPQIUnNdyuBTWR9w/pwuFpy79BE
         hVIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=o1v5rDCF84XbeQVuw2S+05ZHRphrkE0pHuSTo2O2QWo=;
        b=Gttd/zYuzwMpXyryKhsBuaLIiJb/H3z8Rec/fSbhMwIeJmxZTb0DNKYnMn6mAcokLl
         VagSLCNRWops0hZrzwMjFbweDx97P/1JUt4/zgE24kv9onTQeXz21oJPliF1qY3ZiM/3
         VZjY+EN4WGenwMSolkvOs37b2LBdBu2zAoDGjmBB+ERPLrjQq/FJ23XdWQOWWmF3LyQi
         bfceVaZDzrFwLWF8AhneMLJ9FKmitcNdfg96qkQcrLFYJTg3AHjAREQVISEVJcoXTdxe
         kSI+0w+oFPZTX6L2QlBsB0u6wZPejjAzyvJjMJRMRTR23efjJNsIQ5s14BsZb23pnybL
         aoTA==
X-Gm-Message-State: APjAAAWBtzOrK51Ib/gcK3fld7iBX8vj/E16tp84hMC5mHYScqBpaD2o
        vyN9en3dNik8hghs4UKJJK1tuqpX
X-Google-Smtp-Source: APXvYqyjkcTMChV0dfLUQt5zQA4yq6IA5Y5NJs2tMYdawTPmn2juiSw7qoAMUDcj+S7I+sOerBtb+w==
X-Received: by 2002:adf:f3cc:: with SMTP id g12mr5037830wrp.149.1562850192661;
        Thu, 11 Jul 2019 06:03:12 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id h6sm4642590wre.82.2019.07.11.06.03.11
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 11 Jul 2019 06:03:12 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 2/7] trace-cmd: Move trace-msg.c into the library.
Date:   Thu, 11 Jul 2019 16:03:02 +0300
Message-Id: <20190711130307.25041-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190711130307.25041-1-tz.stoyanov@gmail.com>
References: <20190711130307.25041-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Functions, implemented in trace-msg.c file, do not depend on
trace-cmd application context and can be used standalone.
The file is moved from trace-cmd to libtracecmd.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 {tracecmd/include => include/trace-cmd}/trace-msg.h | 0
 lib/trace-cmd/Makefile                              | 1 +
 {tracecmd => lib/trace-cmd}/trace-msg.c             | 0
 tracecmd/Makefile                                   | 1 -
 4 files changed, 1 insertion(+), 1 deletion(-)
 rename {tracecmd/include => include/trace-cmd}/trace-msg.h (100%)
 rename {tracecmd => lib/trace-cmd}/trace-msg.c (100%)

diff --git a/tracecmd/include/trace-msg.h b/include/trace-cmd/trace-msg.h
similarity index 100%
rename from tracecmd/include/trace-msg.h
rename to include/trace-cmd/trace-msg.h
diff --git a/lib/trace-cmd/Makefile b/lib/trace-cmd/Makefile
index 9086eb6..5f7b111 100644
--- a/lib/trace-cmd/Makefile
+++ b/lib/trace-cmd/Makefile
@@ -16,6 +16,7 @@ OBJS += trace-output.o
 OBJS += trace-recorder.o
 OBJS += trace-util.o
 OBJS += trace-filter-hash.o
+OBJS += trace-msg.o
 
 # Additional util objects
 OBJS += trace-blk-hack.o
diff --git a/tracecmd/trace-msg.c b/lib/trace-cmd/trace-msg.c
similarity index 100%
rename from tracecmd/trace-msg.c
rename to lib/trace-cmd/trace-msg.c
diff --git a/tracecmd/Makefile b/tracecmd/Makefile
index 6968f83..d491aae 100644
--- a/tracecmd/Makefile
+++ b/tracecmd/Makefile
@@ -30,7 +30,6 @@ TRACE_CMD_OBJS += trace-check-events.o
 TRACE_CMD_OBJS += trace-show.o
 TRACE_CMD_OBJS += trace-list.o
 TRACE_CMD_OBJS += trace-usage.o
-TRACE_CMD_OBJS += trace-msg.o
 
 ALL_OBJS := $(TRACE_CMD_OBJS:%.o=$(bdir)/%.o)
 
-- 
2.21.0

