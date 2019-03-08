Return-Path: <SRS0=Frhw=RL=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AD8CC4360F
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Mar 2019 14:31:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3A8112085A
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Mar 2019 14:31:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726615AbfCHObc (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Mar 2019 09:31:32 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:42584 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726565AbfCHObb (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Mar 2019 09:31:31 -0500
Received: by mail-wr1-f67.google.com with SMTP id r5so21576983wrg.9
        for <linux-trace-devel@vger.kernel.org>; Fri, 08 Mar 2019 06:31:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Qn3Ovm26CMQF4CDJU/28ZXQFBZMpgXkLqaLJM18hw5E=;
        b=Me2yqThq7SxZu5jYl1/sTsazb+DtNHNzFC9TiqEGjDH36h+tyDzMQgtVYbmCC3RXrh
         vsVKw+8L5g7Jt/L17vGrDis7dhTZ2EmhJtaliSnM1pZNixhBnUn+xmz7jNdMQB+W7mHy
         kFx856xMo5tMYxniX9niz82Vk9N9EI9rVES3ahRrF5xQDf6Ygf1/Ih0OY7q8EHISMD4l
         WUjiS0qHZy+/6kUaWZrAB76CoClJfyCae63I6kC8dPRPZqwj5NTqgUK88s/shy+hS4x4
         Hpwd0A5vYbx6Fl44Nbbhz4fDgN+fyd/tOqGlnx6+pCcoAsFfZz/wtNhLZ3qTM3tF4geH
         5sxg==
X-Gm-Message-State: APjAAAV8jalu8pXYCOXFe234ri5WMbaKz5CaoBQ7rDRJcKiPfCEfEGWI
        c2OM5SG7309RGxR0kUlrvgg=
X-Google-Smtp-Source: APXvYqwzqurCUEWvcoXXTlueXYr0xAePPmoEhbRjfygDWDOOXOYfTKYA7EaCNGMIKfyXWQ6t8eyEgQ==
X-Received: by 2002:a5d:6288:: with SMTP id k8mr11981053wru.173.1552055490264;
        Fri, 08 Mar 2019 06:31:30 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id t3sm13495654wmc.20.2019.03.08.06.31.29
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 08 Mar 2019 06:31:29 -0800 (PST)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 3/7] trace-cmd: Fix "trace-cmd reset -a -d" segfault
Date:   Fri,  8 Mar 2019 16:31:21 +0200
Message-Id: <20190308143125.31168-4-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190308143125.31168-1-tstoyanov@vmware.com>
References: <20190308143125.31168-1-tstoyanov@vmware.com>
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

