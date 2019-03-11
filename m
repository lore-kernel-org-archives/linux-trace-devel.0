Return-Path: <SRS0=t4cO=RO=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D56E3C43381
	for <linux-trace-devel@archiver.kernel.org>; Mon, 11 Mar 2019 08:33:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9EEB22084D
	for <linux-trace-devel@archiver.kernel.org>; Mon, 11 Mar 2019 08:33:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726567AbfCKIdp (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 11 Mar 2019 04:33:45 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:38439 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725850AbfCKIdp (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 11 Mar 2019 04:33:45 -0400
Received: by mail-wr1-f67.google.com with SMTP id g12so4014472wrm.5
        for <linux-trace-devel@vger.kernel.org>; Mon, 11 Mar 2019 01:33:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Qn3Ovm26CMQF4CDJU/28ZXQFBZMpgXkLqaLJM18hw5E=;
        b=CHm/Hzyb9uHt7Cjr0fjbUx37MjABrAWbwuuZK0GsZ+iOfIi0JV2kOyaFgdW0sEPsMK
         qc1XYlGbz0gskwrK4bnw3NGKcxme3/xj1hSlhiRqUtX3ZzW+Sir3yZk7SO0372+8vrlc
         FBZL+VCfYjR+TgrhLEr5uJ/64SLuJlUNfq6OJctk6gx3Gmnf78tfG1elrT4WkQHDW8zH
         wd+cINYmrbZgdcAylu76qZt065fKjyna+3WgxZqjsnYpq3HkKJzEfoO9wlF8PT5QYWQv
         pLCzsUMfyVtPWqBRe82qIFABiVQJCW1dG3D/E70KDPSClKMMLsPP2FfscgpvYnapAUsU
         UXcQ==
X-Gm-Message-State: APjAAAVq3LanLxNMuyhSIppSBWcs4qdrjW7DUGflgUF0paut5L1WlPF5
        oTDd5Z2j8f9t6OPLwkHKWCc=
X-Google-Smtp-Source: APXvYqypAg+OMiGpF9jMVSE2fuO42spKkUkoADsgvUck8F6X0iNjNGHcXhtOl3HMpFpChKjhPKo/og==
X-Received: by 2002:a5d:4583:: with SMTP id p3mr4996810wrq.114.1552293223181;
        Mon, 11 Mar 2019 01:33:43 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id x17sm19683835wrd.95.2019.03.11.01.33.42
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 11 Mar 2019 01:33:42 -0700 (PDT)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 2/6] trace-cmd: Fix "trace-cmd reset -a -d" segfault
Date:   Mon, 11 Mar 2019 10:33:35 +0200
Message-Id: <20190311083339.21581-3-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190311083339.21581-1-tstoyanov@vmware.com>
References: <20190311083339.21581-1-tstoyanov@vmware.com>
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

