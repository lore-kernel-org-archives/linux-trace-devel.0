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
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC2A9C4338F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 05:10:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9336261019
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 05:10:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234024AbhG2FKv (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 29 Jul 2021 01:10:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234016AbhG2FKv (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 29 Jul 2021 01:10:51 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4E01C061757
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 22:10:47 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id p21so6365748edi.9
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 22:10:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gGjxlL/QYZSQ9mqXy+WWO0qfdySoTW4BFaiNTXbOwKM=;
        b=gXvnSgJbm5E8zBV57fbLo85cExu+ZZkLRVhikmMIY6h22wTm48oJIkDtYhgw6jlLB/
         EukvU0pwyTn01Wae02mrtCsz4wskmTrqv6pBHk3iA+5CI0MXuCNOWkcfEYq/WqPPr3MP
         JiTgZR1mg/yef4vP5U3pWS9adE/aRSjC2m3X54rjf2XIJ3FFwlPJRDeavIIDcESiOaSt
         I3AqeAhXyL0HouxIoBLga8DkqsO5nmysGR4h9b/3rBH+Murp/Cf1fhj0NJTkBZi1OUi4
         M6/rETKbC2CJtYtS7ndUaHMdeOnTvzcdzL6ZSepMgF+EJ6zcFfs1u3jHtXiuRYpFvnci
         5/DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gGjxlL/QYZSQ9mqXy+WWO0qfdySoTW4BFaiNTXbOwKM=;
        b=rXnwg6sG3pBWeoeAZsansWZYRptNlvHYO1S7RsjfiB0Yfny7a4qbCe55Dfz3Q3DsW/
         Ox3y84cmBz2apobHThhOdDzlQYNV1dCQwf8jVfXA/cUUY+DA48i8tijbqaHfSfgE9gDn
         0l3B3D1EhYNi1OjN47qPlBgBx3p6RVZJU3GNbtG2e8H5spuuKE96qWs+GPcZms71lIC+
         MJfdGmBqXD2m6oq/WfFlPoaL3gnpQWV65BcBQ3X/jRLRoCVuyW9EUilW3sjfbRwnteXK
         9kXIoBRuMmVzTUXMWtzbUso7lbknYpYZ3tUKPfncmhQBF16AXCp8Qjq8dbVTA8QHQzFn
         Y6rg==
X-Gm-Message-State: AOAM5314mdgEDuZitIp04/aL82ohVS/8xVjDS/n2CfiQM+ic3fcigZwy
        27CrE8KVge06VHDvz6saBHw=
X-Google-Smtp-Source: ABdhPJxoGKTVxSAqm6/hUYXflWZZclSsCal22g3k5x/UT82Rog1a++QO04T17EwNjWR1a1bQf/KohA==
X-Received: by 2002:a05:6402:1601:: with SMTP id f1mr3889210edv.388.1627535446489;
        Wed, 28 Jul 2021 22:10:46 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id s20sm530615eji.116.2021.07.28.22.10.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 22:10:45 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 46/87] tarce-cmd library: Do not use local variables when reading CPU stat option
Date:   Thu, 29 Jul 2021 08:09:18 +0300
Message-Id: <20210729050959.12263-47-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210729050959.12263-1-tz.stoyanov@gmail.com>
References: <20210729050959.12263-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Trace file version 7 can have more than one options section. Assuming
that all CPUSTAT options are in a single options section could be wrong,
that's why using local variable to track the CPUSTAT size is not
correct. Use input handler context instead.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-input.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index f447c8d7..d8c8b9b0 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -150,6 +150,7 @@ struct tracecmd_input {
 
 	struct host_trace_info	host;
 	double			ts2secs;
+	unsigned int		cpustats_size;
 	char *			cpustats;
 	char *			uname;
 	char *			version;
@@ -2909,7 +2910,6 @@ static int handle_options(struct tracecmd_input *handle)
 	unsigned short option;
 	unsigned int size;
 	char *cpustats = NULL;
-	unsigned int cpustats_size = 0;
 	struct input_buffer_instance *buffer;
 	struct hook_list *hook;
 	char *buf;
@@ -2987,12 +2987,16 @@ static int handle_options(struct tracecmd_input *handle)
 			break;
 		case TRACECMD_OPTION_CPUSTAT:
 			buf[size-1] = '\n';
-			cpustats = realloc(cpustats, cpustats_size + size + 1);
-			if (!cpustats)
-				return -ENOMEM;
-			memcpy(cpustats + cpustats_size, buf, size);
-			cpustats_size += size;
-			cpustats[cpustats_size] = 0;
+			cpustats = realloc(handle->cpustats,
+					   handle->cpustats_size + size + 1);
+			if (!cpustats) {
+				ret = -ENOMEM;
+				return ret;
+			}
+			memcpy(cpustats + handle->cpustats_size, buf, size);
+			handle->cpustats_size += size;
+			cpustats[handle->cpustats_size] = 0;
+			handle->cpustats = cpustats;
 			break;
 		case TRACECMD_OPTION_BUFFER:
 			/* A buffer instance is saved at the end of the file */
-- 
2.31.1

