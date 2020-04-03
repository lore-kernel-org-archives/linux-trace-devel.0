Return-Path: <SRS0=6Q4x=5T=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D11E2C43331
	for <linux-trace-devel@archiver.kernel.org>; Fri,  3 Apr 2020 16:02:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 96B68206E9
	for <linux-trace-devel@archiver.kernel.org>; Fri,  3 Apr 2020 16:02:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="tD1hT/xk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727989AbgDCQCp (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 3 Apr 2020 12:02:45 -0400
Received: from mail-lf1-f42.google.com ([209.85.167.42]:32996 "EHLO
        mail-lf1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727969AbgDCQCp (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 3 Apr 2020 12:02:45 -0400
Received: by mail-lf1-f42.google.com with SMTP id h6so1731156lfc.0
        for <linux-trace-devel@vger.kernel.org>; Fri, 03 Apr 2020 09:02:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LwGb8mkjWKC5oMkDNAsw/R4wBb3oaWZJjW7nCMsOeZE=;
        b=tD1hT/xklnUEMb1tnyBruOAyewFwsx9McqwgUwyTr85FsHv7deaKzbcKYjFUAphjgV
         YD4sJjGMvMjDbmQZSKqDqp3kXxE7oRjpc6Z/IFwa5g6Uqcg1H6hRyWXr465h0ziL/nmN
         M5zS3EMxSIGVIuviRCLu4pshtETH0cK/eUUPg11cV3JmGwpfMQ9hbPcCb14QKf5ZtC6F
         JULUm7uukNvcOYYVonkH+xmtmq/RQGOfmtdgVeL80yzpPO0EEFprWJVSfr1CRA8Fj72w
         cmu6kdNnKotcahRBntcMK18DDHxRgmgrxWRhAYe9XblH657krnxNFqCLn74mZB5/ts5P
         sc5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LwGb8mkjWKC5oMkDNAsw/R4wBb3oaWZJjW7nCMsOeZE=;
        b=Jx4G6e2t1KJcTe45LfA/WLZeldvLjAjpyA76bFxce54zpqk1xh/2/zILJYjwiecea8
         MKpPqOCZqWv1PXHjxRKYEtXFBhKVVIXFj/xUua3PeAskz3laJKYGh2KJvJp0kRXxHKtm
         PD/6LRxFLWcIvspwjosmj5mrH1td4fu934KcoGjgcN9leeb6my/J+KMj32iU931p/iv3
         A6TntPkF8mstd+pLmWO1/URZiK935tb9yXrA8HtQK3Xs4YmWpL0ggrZP2UwcIT0kLM/w
         bwK5YqxRtw8ASU7QyDrlCH0BK01FcXKYIpj5gLpBasixYRVQX//GpsCbr/3NswtmFkQA
         H+AQ==
X-Gm-Message-State: AGi0Puaa/zBjoL3fVjffY8H192J13mbjG8ycsLmt2ckJfhf5rJPIocNZ
        lX9N5B+Z+zbSBuzYg0k7754=
X-Google-Smtp-Source: APiQypJB4IgSfnMgfGEHqkSmkRAEdVxXLl6WRYyoKC+FESA4ENJVx3q/uTik0OJofFJY1BcJQzcEdA==
X-Received: by 2002:a19:43:: with SMTP id 64mr5683694lfa.67.1585929762515;
        Fri, 03 Apr 2020 09:02:42 -0700 (PDT)
Received: from localhost.localdomain ([84.40.73.10])
        by smtp.gmail.com with ESMTPSA id b16sm6252747lfq.34.2020.04.03.09.02.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Apr 2020 09:02:41 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 1/2] kernel-shark-2.alpha: Allow appending multiple datafiles from command line
Date:   Fri,  3 Apr 2020 19:02:29 +0300
Message-Id: <20200403160230.11185-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Multiple data files can be appended using the "-a" command line option.
This can be done with:

kernelshark -i foo -a bar1 -a bar2

or

kernelshark -i foo -a "bar1 bar2"

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/kernelshark.cpp | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/src/kernelshark.cpp b/src/kernelshark.cpp
index bb51f88..590783f 100644
--- a/src/kernelshark.cpp
+++ b/src/kernelshark.cpp
@@ -17,7 +17,8 @@
 
 #define default_input_file (char*)"trace.dat"
 
-static char *prior_input_file, *app_input_file;
+static char *prior_input_file;
+QStringList appInputFiles;
 
 void usage(const char *prog)
 {
@@ -57,7 +58,7 @@ int main(int argc, char **argv)
 			break;
 
 		case 'a':
-			app_input_file = optarg;
+			appInputFiles << QString(optarg).split(" ", QString::SkipEmptyParts);
 			break;
 
 		case 'p':
@@ -99,8 +100,8 @@ int main(int argc, char **argv)
 		if (prior_input_file)
 			ks.loadDataFile(QString(prior_input_file));
 
-		if (app_input_file)
-			ks.appendDataFile(QString(app_input_file));
+		for (auto const &f: appInputFiles)
+			ks.appendDataFile(f);
 	}
 
 	ks.show();
-- 
2.20.1

