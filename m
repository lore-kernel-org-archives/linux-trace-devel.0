Return-Path: <SRS0=ctSi=Q6=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4310C43381
	for <linux-trace-devel@archiver.kernel.org>; Sat, 23 Feb 2019 12:24:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7C14A20651
	for <linux-trace-devel@archiver.kernel.org>; Sat, 23 Feb 2019 12:24:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="JAv+XPGw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725859AbfBWMYJ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sat, 23 Feb 2019 07:24:09 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:40413 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725820AbfBWMYI (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sat, 23 Feb 2019 07:24:08 -0500
Received: by mail-wm1-f67.google.com with SMTP id t15so4179542wmi.5
        for <linux-trace-devel@vger.kernel.org>; Sat, 23 Feb 2019 04:24:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QBi08iwwT07Rw/ceQH06cxz37xnf5vMEMrIJy/hLwyI=;
        b=JAv+XPGwNfwBn2LHkDW8/KsmV+wz2EiFaXFdRnG5T31KNw3d4pfXtbLFxrPkDZqFSv
         XxuvnEbAQOyxVIFkp+nAMv1+bS0arm954Z/wAQ65fdfeXVxxEc3K1O2kCsxGdpehY7ee
         pyYz2Kqm2H7joDQ49wxD1DX9QkfV4DF9w86hSUWgjKEKMWlwDvts/caPIHX+2M8/Cj1V
         F1fOkPRt4fo4+4mNgvCasG1DeSBN2xChhqZpOnxwzf/0dB2OgkARPV/RFw0yVnm9hfT7
         2G4DlPxzg3xoCW8utMzPK8O4ym81DPM++9czZF5TJuMZqFj6UXI7RBT/04r8zHJuaNTp
         SYeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QBi08iwwT07Rw/ceQH06cxz37xnf5vMEMrIJy/hLwyI=;
        b=QN131yNn8VwJenoxwW25N0Lpp9Eis8xCnOIPK8NUA13K1mXi5QPwfOMg5xaOjv9bUt
         /oiP+nGxID9sn6J5qtTVxwdmQ+ql5xhZRuutQlB67gRLD0l/dwy+GOrF8JimNL+tfVoY
         C/BeVZ8zxUiTprKQQiG0QcpcJusrK3C/NAUWOZ2DYSdGM0pAtU9TJcmXuZyyHZRPF/nd
         SckGM1Sbx45T5dDknlJOa/MftHLLwigDf5432jsQNto6hdvb83RaMfUcC7cnLqppFWFy
         wVQnFoPliALYtpL/O2IpSCbIA50nG/crzR6BbSM7s/w/6CAQoeHTbqwuCmMhakmK0yzz
         fDOQ==
X-Gm-Message-State: AHQUAuYZmgW1r/L+VUxlvaxIKLGlV1ILE9c5ImcohrT12p+p25OFznr5
        PLjsxDNpn2I7f3uzkUoMX6g=
X-Google-Smtp-Source: AHgI3IZ5JOJMpTNmHxxklgKXqbLDH9ax1+rwNLX3Vz1MSgtLrLl2D6tPz/Zy7tctDrNkZVAfELnFbQ==
X-Received: by 2002:a1c:2d4c:: with SMTP id t73mr5380625wmt.142.1550924647170;
        Sat, 23 Feb 2019 04:24:07 -0800 (PST)
Received: from ex.fritz.box (p2003005F6E330C0149A35D2FD657FC21.dip0.t-ipconnect.de. [2003:5f:6e33:c01:49a3:5d2f:d657:fc21])
        by smtp.gmail.com with ESMTPSA id a74sm5819822wma.22.2019.02.23.04.24.06
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 23 Feb 2019 04:24:06 -0800 (PST)
From:   Mathias Krause <minipli@googlemail.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org,
        Mathias Krause <minipli@googlemail.com>
Subject: [PATCH] tools lib traceevent: Fix BOF in arg_eval() when printing large negative values
Date:   Sat, 23 Feb 2019 13:24:04 +0100
Message-Id: <20190223122404.21137-1-minipli@googlemail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The buffer for printing large negative values is one byte too small as
can be seen below when trying to print LONG_MIN:

  $ printf "%lld" $[0x8000000000000000] | wc -c
  20

The number already needs 20 bytes, plus the '\0' terminator makes it 21
bytes. This results in a buffer overflow that gets detected by the
_FORTIFY_SOURCE logic and, in turn, ends up in an abort(3) call.

Resize the buffer to 22 bytes to have yet another spare byte.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
---
This commit should probably be backported to, at least, the
trace-cmd-stable-v2.6 branch as I ran into the issue there by using the
stock Debian/testing version of trace-cmd, trying to do a 'trace-cmd report'
on a large trace file.
---
 lib/traceevent/event-parse.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/traceevent/event-parse.c b/lib/traceevent/event-parse.c
index 6f7f4be3c4ea..a8a4366d51cc 100644
--- a/lib/traceevent/event-parse.c
+++ b/lib/traceevent/event-parse.c
@@ -2457,7 +2457,7 @@ static int arg_num_eval(struct tep_print_arg *arg, long long *val)
 static char *arg_eval (struct tep_print_arg *arg)
 {
 	long long val;
-	static char buf[20];
+	static char buf[22];
 
 	switch (arg->type) {
 	case TEP_PRINT_ATOM:
-- 
2.20.1

