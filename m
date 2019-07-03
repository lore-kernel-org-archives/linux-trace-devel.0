Return-Path: <SRS0=Bo3z=VA=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3723BC0650E
	for <linux-trace-devel@archiver.kernel.org>; Wed,  3 Jul 2019 12:10:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0F4FC218A0
	for <linux-trace-devel@archiver.kernel.org>; Wed,  3 Jul 2019 12:10:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="L5hv2qu6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726430AbfGCMKy (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 3 Jul 2019 08:10:54 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:33188 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726217AbfGCMKy (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 3 Jul 2019 08:10:54 -0400
Received: by mail-wr1-f67.google.com with SMTP id n9so2552906wru.0
        for <linux-trace-devel@vger.kernel.org>; Wed, 03 Jul 2019 05:10:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LEm0l9hVj8EW4iPdVS2asIRhJZoEnRbQpB+HpcDZEuk=;
        b=L5hv2qu6fMkYGY84sr2YW3/sqXUJrHF37jCa7KL3pNOag1RRLj4EEjzjC43W780Pge
         ar4Ugk3Y1RfuK467uFw4zhcm8ospmI4+7lbW/zdaWdwDPgsHoH7YhnM/0+d7fQjZrNMR
         2A2GRR2R2q8KmI+7n9ZK2D7dRrqTKblR9gdsuKSqMHrbTdVGNcskv9/zJP37y3MvQtWa
         jRR1awkSkwkAK0YgCqmWIQwVPTCt1Prd8h/Jl8crepdPlUhDBBxs2AdGGKumq9+vQ5lD
         6KhjjysWrGGbam9avQ2Xzt4HZa/krVJ/pundSru0Dp+KH6yEyBr3S39n32J4PaXkSagh
         +y+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LEm0l9hVj8EW4iPdVS2asIRhJZoEnRbQpB+HpcDZEuk=;
        b=sMJBNYg3LZh7l/DOCP21auKyWEIhN4r5hwdX4Tlyg7/Upgz/dQkPvx0phnGwWAxZSd
         nMyMOO85Nl6ODcAhtgV45r7TKArlpyOoq4UmmbY1XFS7qNMX3+JqnDagUNlN3WmXHXwW
         WhlsXO0Q31lmfc+tvo5BhMmo9XbBW3wUdzJRgOdRBR1tj1jpn23PqeXzL2U6U2WbyxEB
         5fHPa94L6zitnhKiHQPgGXdvx2od4qh7pSKhFDlK7g8lzrRcqOVgtrZUNBnU4TkOn1fb
         ESpiznhgtCxX2ehMRF+PXPaqcvu23VEcckxX7Q/QwLxjxlY7PEZk2KYi5BXw9IHJpXQu
         c5Iw==
X-Gm-Message-State: APjAAAUHLO/b5d/qA0NcPDwcUfYBkucSPdC1YmErETC+vInXmXDk1a/N
        /mQzR6kFEgASc+agVFHfSAY=
X-Google-Smtp-Source: APXvYqxvLzEDQ/247wVE225YuZrzxg2ewrYRKwmax1N5YVhnqu44wPT3SrSsJOlpfYdz13WxdI/lRA==
X-Received: by 2002:a5d:67cd:: with SMTP id n13mr28989087wrw.138.1562155852811;
        Wed, 03 Jul 2019 05:10:52 -0700 (PDT)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id u18sm2321587wmd.19.2019.07.03.05.10.52
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 03 Jul 2019 05:10:52 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [RFC PATCH v2 3/5] kernel-shark: Add text rendering to the plotting example
Date:   Wed,  3 Jul 2019 15:10:21 +0300
Message-Id: <20190703121023.16655-4-y.karadz@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190703121023.16655-1-y.karadz@gmail.com>
References: <20190703121023.16655-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

run:
kernel-shark/bin/dplot -s

And if the font file is loaded successfully you will see "Hello Kernel!"
rendered.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 kernel-shark/examples/dataplot.cpp | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/kernel-shark/examples/dataplot.cpp b/kernel-shark/examples/dataplot.cpp
index 94841e7..11b4fd9 100644
--- a/kernel-shark/examples/dataplot.cpp
+++ b/kernel-shark/examples/dataplot.cpp
@@ -44,6 +44,12 @@ void usage(const char *prog)
 /* An example function drawing something. */
 void drawShapes()
 {
+	char *font_file = ksplot_find_font_file("FreeMono", "FreeMonoBold");
+	struct ksplot_font font;
+
+	ksplot_init_font(&font, 40, font_file);
+	free(font_file);
+
 	/* Clear the screen. */
 	glClear(GL_COLOR_BUFFER_BIT);
 
@@ -57,6 +63,11 @@ void drawShapes()
 	t._color = {100, 200, 50};
 	t.draw();
 
+	/* Print/draw "Hello Kernel!". */
+	if (!ksplot_font_is_loaded(&font))
+		ksplot_print_text(&font, t._color.color_c_ptr(), 250, 70,
+				  "Hello Kernel!");
+
 	KsPlot::Rectangle r;
 	KsPlot::Point d(400, 200), e(400, 300), f(500, 300), g(500, 200);
 	r.setPoint(0, d);
-- 
2.20.1

