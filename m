Return-Path: <SRS0=ndxz=QU=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 296F9C282CA
	for <linux-trace-devel@archiver.kernel.org>; Wed, 13 Feb 2019 16:13:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EC9D120700
	for <linux-trace-devel@archiver.kernel.org>; Wed, 13 Feb 2019 16:13:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404349AbfBMQNE (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 13 Feb 2019 11:13:04 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:40139 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404347AbfBMQNE (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 13 Feb 2019 11:13:04 -0500
Received: by mail-wr1-f67.google.com with SMTP id q1so3145118wrp.7
        for <linux-trace-devel@vger.kernel.org>; Wed, 13 Feb 2019 08:13:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dA42NAyp03OmKSnXPKzpIZYNjCBZS1suUM1XVRJ8X2Q=;
        b=ruEcghU152EO2H1lKw+fQOwm23QOILaoh5sS/k51iCLI4bYgrmMofxy4i2Mei55ieK
         wTl/6Ydx49zv1hkRAdam4aO5L9+yliZ7HVM2aEosr9Lnh6lDl56xnUJQO2d+jPBI6q21
         RshlH4rm7flZaU55g5BIG0MztSB2AyU0DpLPjoedgQS5FMH1PBPvO2LNg5TymXK2Zy9j
         BAihEiDF0Tm/5+Z9uAO0h3qiJApsihpUeJtNahj53iWTuAFub4C3+YXBARr+fJNN8IwG
         CKEIqZk9IIx5DDx0mS4h8El0oDy62t/090a68PGMjPsQSb8Q3Qz2iwK/zu9QY6BCmsrn
         z4Ow==
X-Gm-Message-State: AHQUAuZV/WbxkIBMDPF9pdZ5e5dsTnXCL95L4kXeJ2EHrQ1oKWkTtCTC
        26VoyP1OgoowQQSXqE/IRMvPjDpB
X-Google-Smtp-Source: AHgI3Ibm5DAQXZkW4S/CQl7esTc+IKbmI/mBoWfX0B6jMURE+Omjmjb2feop6YVVjb0MLIburhKOqA==
X-Received: by 2002:adf:d0c9:: with SMTP id z9mr1029442wrh.132.1550074382420;
        Wed, 13 Feb 2019 08:13:02 -0800 (PST)
Received: from localhost.localdomain ([95.87.211.218])
        by smtp.gmail.com with ESMTPSA id h9sm3111631wrv.11.2019.02.13.08.13.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 13 Feb 2019 08:13:02 -0800 (PST)
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        Yordan Karadzhov <ykaradzhov@vmware.com>
Subject: [PATCH 7/8] trace-cmd: Fix the printout of the KernelShark executable path
Date:   Wed, 13 Feb 2019 18:12:15 +0200
Message-Id: <20190213161216.14438-8-ykaradzhov@vmware.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190213161216.14438-1-ykaradzhov@vmware.com>
References: <20190213161216.14438-1-ykaradzhov@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Adding  ‘@’ to the line that is echoing in order to suppress echoing
the line itself.

Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index f0f7e92..b780718 100644
--- a/Makefile
+++ b/Makefile
@@ -258,8 +258,8 @@ $(kshark-dir)/build/Makefile: $(kshark-dir)/CMakeLists.txt
 
 gui: force $(CMD_TARGETS) $(kshark-dir)/build/Makefile
 	$(Q)$(MAKE) $(S) -C $(kshark-dir)/build
-	echo "gui build complete"
-	echo "  kernelshark located at $(kshark-dir)/bin"
+	@echo "gui build complete"
+	@echo "  kernelshark located at $(kshark-dir)/bin"
 
 trace-cmd: force $(LIBTRACEEVENT_STATIC) $(LIBTRACECMD_STATIC)
 	$(Q)$(MAKE) -C $(src)/tracecmd $(obj)/tracecmd/$@
-- 
2.17.1

