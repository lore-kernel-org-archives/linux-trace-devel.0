Return-Path: <SRS0=58xy=ST=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63C9DC282DA
	for <linux-trace-devel@archiver.kernel.org>; Wed, 17 Apr 2019 13:10:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 33DB521773
	for <linux-trace-devel@archiver.kernel.org>; Wed, 17 Apr 2019 13:10:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731566AbfDQNKQ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 17 Apr 2019 09:10:16 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:52689 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726800AbfDQNKP (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 17 Apr 2019 09:10:15 -0400
Received: by mail-wm1-f68.google.com with SMTP id a184so3332486wma.2
        for <linux-trace-devel@vger.kernel.org>; Wed, 17 Apr 2019 06:10:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6OulcOxxjv8L1vaza+xTg6NxldFrGfio2FXUOa850qI=;
        b=fp4euOmeRYXkR0ey+RuOz5lpqNNOTvYmLKDcxtBmuXKw89phPPNz91ptSmcXbwuwCh
         d1OAqXoZQG3iGK0PhElgmJs340vY/Bb4VjDqeyNg40F6n+wpI61w+y/LsReJVuNT/U9I
         uVaBN+VDo629P030tNz7fx8XIJoA9Ag6FTEcYY42f53cq8ojFUuRR7Pu1mgoUN2tWjVw
         Jf49hyc7IlF1g/ATRJaGP/D54ZipZALzuGKsWOcCeQKd50vNiUF1lAE3gJ++pPrUFIC/
         VXokBS1ZrIthAHuiS+Q2ggxLoX+zW2Dng1YzWlVlzTy4iZdPBe2/mWM3F5Znx1vZJs/S
         gVbw==
X-Gm-Message-State: APjAAAVTCjM5teuQh09AbG1hJB/gdj2OGg/jhiBcdJp6Xthc9WEVzp4g
        TJ2HV3OdgqdQZq6JqZKSbg==
X-Google-Smtp-Source: APXvYqyxNn7R3Dxn/um1cPjE5Rek52R+KUBu1LAy9T4NFjMfQBH2HsRdTEebfIQYBxAFCCf6DHMjhQ==
X-Received: by 2002:a1c:9dc8:: with SMTP id g191mr32144296wme.132.1555506613352;
        Wed, 17 Apr 2019 06:10:13 -0700 (PDT)
Received: from localhost.localdomain ([151.251.252.188])
        by smtp.gmail.com with ESMTPSA id d16sm48124303wrs.68.2019.04.17.06.10.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 17 Apr 2019 06:10:12 -0700 (PDT)
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, pauld@redhat.com,
        ykaradzhov@vmware.com, jbacik@fb.com, tstoyanov@vmware.com,
        slavomir.kaslev@gmail.com
Subject: [PATCH v4 2/2] trace-cmd: Document record --no-filter option in record's man page
Date:   Wed, 17 Apr 2019 16:09:59 +0300
Message-Id: <20190417130959.10064-3-kaslevs@vmware.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190417130959.10064-1-kaslevs@vmware.com>
References: <20190417130959.10064-1-kaslevs@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Add a section about the new --no-filter argument of `trace-cmd record`
to its man page.

Signed-off-by: Slavomir Kaslev <kaslevs@vmware.com>
---
 Documentation/trace-cmd-record.1.txt | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/trace-cmd-record.1.txt b/Documentation/trace-cmd-record.1.txt
index 68afa16..b230aa8 100644
--- a/Documentation/trace-cmd-record.1.txt
+++ b/Documentation/trace-cmd-record.1.txt
@@ -83,6 +83,10 @@ OPTIONS
 
     The above are usually safe to use to compare fields.
 
+*--no-filter*::
+    Do not set any event filters, including the default one which ignores events
+    caused by trace-cmd itself.
+
 *-R* 'trigger'::
     Specify a trigger for the previous event. This must come after a *-e*. 
     This will add a given trigger to the given event. To only enable the trigger
-- 
2.19.1

