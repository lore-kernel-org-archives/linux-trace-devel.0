Return-Path: <SRS0=Frhw=RL=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DC63C43381
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Mar 2019 14:31:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 714892085A
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Mar 2019 14:31:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726591AbfCHObb (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Mar 2019 09:31:31 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:43125 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726528AbfCHObb (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Mar 2019 09:31:31 -0500
Received: by mail-wr1-f67.google.com with SMTP id d17so21584067wre.10
        for <linux-trace-devel@vger.kernel.org>; Fri, 08 Mar 2019 06:31:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=B0LSgheigQKYDNu87C/yhSfypvVN6mgElsvHHKqMVDU=;
        b=f4LRVDBiMsJ/bJu+7KVLxNU+ZsffCAUGuK2tNmRfnHKbVPDOfKcrmr4bajlSk1umBo
         dDVJacMRbFpMmQDDZtwRJUN+5kLh60w+4Q1so38KrT985A9DY1KeBxnkNYo9gC4AgWvO
         aF2WaajSQRrCFW0FRnTOhAseFP90MhG2frq06ohjEHYY8gb6hAgqvYIDWaCxWPrHr3G3
         bAiDQY8Bnbf9kPrKxeSU419E58T3sm3UirTZU2M5p4/D5D/olPHGQ4g2lJZelvp9pWXx
         +7SfcdzHshzi6t8FjnQJTpCcDGZHyipgl+I1LxXG6XMfXJMoG8XCiVO9LPKBF5Gm1dY5
         IZUQ==
X-Gm-Message-State: APjAAAWL2KEBPlXhmjQiPVKBFd7YKxXcSeZUqoXBVz+FPnTIdXHu4u7F
        fMBoxdSLvMUnqbf32X4Bt8+9Kx68
X-Google-Smtp-Source: APXvYqxaRCJP8LeX/L1FEhCZG5Y6Ptk5b+9zs1YWIJXs7qMV0xfroS1Fl7NCpt/ZXluLUsKH3KpF1g==
X-Received: by 2002:a05:6000:124a:: with SMTP id j10mr10909014wrx.26.1552055489379;
        Fri, 08 Mar 2019 06:31:29 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id t3sm13495654wmc.20.2019.03.08.06.31.28
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 08 Mar 2019 06:31:28 -0800 (PST)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 2/7] trace-cmd: Fix "trace-cmd reset" command to restore "tracng_on"
Date:   Fri,  8 Mar 2019 16:31:20 +0200
Message-Id: <20190308143125.31168-3-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190308143125.31168-1-tstoyanov@vmware.com>
References: <20190308143125.31168-1-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The "trace-cmd reset" command should restore ftrace to its default state.
By default, "tracing/current_tracer" is "nop" and "tracing/tracing_on" is "1".
This patch sets "tracing/tracing_on" to 1, when the command "trace-cmd reset"
is executed.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 tracecmd/trace-record.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 8beefab..fc658b2 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -4496,6 +4496,8 @@ void trace_reset(int argc, char **argv)
 	clear_triggers();
 	tracecmd_remove_instances();
 	clear_func_filters();
+	/* restore tracing_on to 1 */
+	tracecmd_enable_tracing();
 	exit(0);
 }
 
-- 
2.20.1

