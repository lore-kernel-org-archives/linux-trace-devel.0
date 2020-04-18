Return-Path: <SRS0=eGBV=6C=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E71CC2BA19
	for <linux-trace-devel@archiver.kernel.org>; Sat, 18 Apr 2020 23:31:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A65C52072C
	for <linux-trace-devel@archiver.kernel.org>; Sat, 18 Apr 2020 23:31:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UhmtvMuP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725827AbgDRXb3 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sat, 18 Apr 2020 19:31:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725824AbgDRXb2 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sat, 18 Apr 2020 19:31:28 -0400
Received: from mail-qv1-xf42.google.com (mail-qv1-xf42.google.com [IPv6:2607:f8b0:4864:20::f42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA6B4C061A0C
        for <linux-trace-devel@vger.kernel.org>; Sat, 18 Apr 2020 16:31:28 -0700 (PDT)
Received: by mail-qv1-xf42.google.com with SMTP id fb4so2881815qvb.7
        for <linux-trace-devel@vger.kernel.org>; Sat, 18 Apr 2020 16:31:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=X/fKrMwLR2flw4++sTIe9k1BY9BNfyjbOkdrjHWrsB4=;
        b=UhmtvMuPMcw7L4nkbupnBhM+ouMvae7dR1tgS68CIwahEQo2eD8j0w/7Z/KeW8hfap
         CoiKGWgdx6IKIaudb+qNA18Gv2oZxVpz6EbhRLgnYJNwSOIoJnRDM0QybSZjD8fi7hW/
         Uz3oHT+1zl8BFZSZL5+/DZtOux83GtKT9c66Fth494I/BmH+Ef2vjBZdTxr13uPs0jEI
         mEuJR+zaPDQRliQzOy/IQdnkDu7DLoo678JqScinRfHUpzgeJ2qlo0rY83AhsV2NXblZ
         V4IuPixpPRTyCtGTfhPNQg6sUL/bao80kGmL5FmdUj+nH1YS+70ua5cvmkhk0wQOpLIl
         wCbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=X/fKrMwLR2flw4++sTIe9k1BY9BNfyjbOkdrjHWrsB4=;
        b=c2c+qKQFxEtJI9f3Ui3BChZ9fG9PesJCvszOCgS4TB9oNP/imELxmJb9MXPQXLiK6H
         14U5p2aTHlsAy0J6h8jF4ly6mBoP8AX6zIm15LgWHkBUQcJKMNHU3KnYlLT0+gcgRA+X
         ot/Gj1Q2YW1i5U0zkV6yPmopKKxsXVBV618HFSw4f7y7dXLjJjzdjpt9FQlQUkUkG5g4
         LfnzPTj+lRFno4DpMh2WapEJXk036SbLMcRR97E++URJvgwlCI4pyowPWAQpXvbtbC2T
         BXHG6oxBUD/px0WjAG3PpyEhtbvqaS7p8nEZ397kKnA3mskGuQPLnVtw+zdl8sz+Q3oW
         fOgQ==
X-Gm-Message-State: AGi0PuatbuxTwqBvf4nUT1RXYB8Zf04oTt/MjMvtKmf+KBnkJtR4HIvz
        msUaNr/oblY6XRp3LeNyfRI=
X-Google-Smtp-Source: APiQypLnWE32HuM2ukv3KwXWZWeYdaElIbD4BXx5OS9/G4a/zY48bx2cvZRX26kM461dY30VHRva3g==
X-Received: by 2002:ad4:5a01:: with SMTP id ei1mr9151302qvb.63.1587252687635;
        Sat, 18 Apr 2020 16:31:27 -0700 (PDT)
Received: from localhost.localdomain (cpe-65-30-164-238.wi.res.rr.com. [65.30.164.238])
        by smtp.gmail.com with ESMTPSA id j14sm6044022qkk.92.2020.04.18.16.31.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Apr 2020 16:31:27 -0700 (PDT)
From:   Bijan Tabatabai <bijan311@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        Bijan Tabatabai <bijan311@yahoo.com>
Subject: [PATCH RESEND] trace-cmd: Stop recording when processes traced with -P exit
Date:   Sat, 18 Apr 2020 18:30:22 -0500
Message-Id: <20200418233022.31033-1-bijan311@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Bijan Tabatabai <bijan311@yahoo.com>

When the -F flag is used in trace-cmd record, trace-cmd stops recording
when the executable it is tracing terminates.
This patch makes the -P flag act similarly.

Signed-off-by: Bijan Tabatabai <bijan311@yahoo.com>
---
 Resending this because the mailing server did not like my original
 email address.

 tracecmd/trace-record.c | 21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index d89b32d..b5cd4c4 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -121,8 +121,10 @@ struct filter_pids {
 };
 
 static struct filter_pids *filter_pids;
+static struct filter_pids *process_pids;
 static int nr_filter_pids;
 static int len_filter_pids;
+static int nr_process_pids = 0;
 
 static int have_set_event_pid;
 static int have_event_fork;
@@ -5799,7 +5801,9 @@ static void parse_record_options(int argc,
 			while (pid) {
 				add_filter_pid(atoi(pid), 0);
 				pid = strtok_r(NULL, ",", &sav);
+				nr_process_pids++;
 			}
+			process_pids = filter_pids;
 			free(pids);
 			break;
 		case 'c':
@@ -6273,10 +6277,19 @@ static void record_trace(int argc, char **argv,
 					ptrace_attach(pid->pid);
 			}
 		}
-		/* sleep till we are woken with Ctrl^C */
-		printf("Hit Ctrl^C to stop recording\n");
-		while (!finished)
-			trace_or_sleep(type);
+		if (nr_process_pids) {
+			for (pid = process_pids; pid && nr_process_pids; pid = pid->next) {
+				if (!pid->exclude)
+					/* Wait for the process to end */
+					while(!kill(pid->pid, 0));
+				nr_process_pids--;
+			}
+		} else {
+			/* sleep till we are woken with Ctrl^C */
+			printf("Hit Ctrl^C to stop recording\n");
+			while (!finished)
+				trace_or_sleep(type);
+		}
 	}
 
 	tell_guests_to_stop();
-- 
2.17.1

