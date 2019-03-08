Return-Path: <SRS0=Frhw=RL=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E886EC10F09
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Mar 2019 13:44:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BAEC020661
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Mar 2019 13:44:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726737AbfCHNoL (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Mar 2019 08:44:11 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:37818 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726171AbfCHNoL (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Mar 2019 08:44:11 -0500
Received: by mail-wr1-f68.google.com with SMTP id w6so21411787wrs.4
        for <linux-trace-devel@vger.kernel.org>; Fri, 08 Mar 2019 05:44:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Qn3Ovm26CMQF4CDJU/28ZXQFBZMpgXkLqaLJM18hw5E=;
        b=VDSFo2mBCcWtPiuXCmwUfpPVJyh8Wqcyhf2O0Wro3XQnhhW2YkYBrIyDkphYzc+g7p
         W2d27Dg6zkN/G7DVbxq30nOIG+uyKTNXl/NtDnSZZ3gPlK5aD+8Lzv4ZzcgMX5qkhZUQ
         QIYynMili3R/B6FUNVlJQMcsTRyCSd/glIxcJupbwE5MiEsT9m56KVViiaXzunLkpMXU
         i8NHYrHOFUPg84Gp13Im3NhN8jO/GNE1wTSs2heKjnBW5iVGkOzWGFFfB1uIHQHNk3H/
         oiuebnpWQo4y17tk5+7Lyg6+NyQVIEUy4ml/hMcUB5lOW3z63UUaTZpJC2pdoBibyYYQ
         LhBQ==
X-Gm-Message-State: APjAAAVFumEe9am6ZFasrv240PVKhM6gCVrwZa8jUWqKX6X4CU/gfaOt
        ybk+AbQNLz8x6UGHdriKQ3Y=
X-Google-Smtp-Source: APXvYqx5YPp0yBHjvitYMzR5AVZry88JCrHRTqrZJTFnPEebwMX7305XEiiGqIf8myq10+HyaPa5sA==
X-Received: by 2002:adf:ef4a:: with SMTP id c10mr10983555wrp.180.1552052649620;
        Fri, 08 Mar 2019 05:44:09 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id t16sm5650943wmj.47.2019.03.08.05.44.08
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 08 Mar 2019 05:44:08 -0800 (PST)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 2/6] trace-cmd: Fix "trace-cmd reset -a -d" segfault
Date:   Fri,  8 Mar 2019 15:44:01 +0200
Message-Id: <20190308134405.21921-3-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190308134405.21921-1-tstoyanov@vmware.com>
References: <20190308134405.21921-1-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This patch fixes a segfault when "trace-cmd reset -a -d"
is executed and there is at least one ftrace instance created.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 tracecmd/trace-record.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index fc658b2..d7267fe 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -4472,14 +4472,14 @@ void trace_reset(int argc, char **argv)
 		case 'a':
 			last_specified_all = 1;
 			add_all_instances();
-			for_each_instance(instance) {
-				instance->flags |= BUFFER_FL_KEEP;
+			for_each_instance(inst) {
+				inst->flags |= BUFFER_FL_KEEP;
 			}
 			break;
 		case 'd':
 			if (last_specified_all) {
 				for_each_instance(inst) {
-					instance->flags &= ~BUFFER_FL_KEEP;
+					inst->flags &= ~BUFFER_FL_KEEP;
 				}
 			} else {
 				if (is_top_instance(instance))
-- 
2.20.1

