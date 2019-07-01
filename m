Return-Path: <SRS0=mM2H=U6=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05892C0650E
	for <linux-trace-devel@archiver.kernel.org>; Mon,  1 Jul 2019 12:17:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D2B2520B7C
	for <linux-trace-devel@archiver.kernel.org>; Mon,  1 Jul 2019 12:17:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ot6+i+MQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727948AbfGAMRr (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 1 Jul 2019 08:17:47 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:46694 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727945AbfGAMRr (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 1 Jul 2019 08:17:47 -0400
Received: by mail-wr1-f68.google.com with SMTP id n4so13560969wrw.13
        for <linux-trace-devel@vger.kernel.org>; Mon, 01 Jul 2019 05:17:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3hXycDovfQWD+AG7HeRPGWsGfiOOqD+0Zug5nqKlVXo=;
        b=Ot6+i+MQ631SF06DQx140Yd7m2n3tjx9JXwp+n5NGFK62GL3w9CY4xu4exbJAP1+7W
         82v0iSVBcGXSAIKAUpLn8AukxC7phtMNFnXsCpxc10SjFdRiAZYlQ4DSyv+S0WwTcrg6
         VoICJs97hQ1x2c8bvHNc8og6/VAhT+LAYRGgLcseICjjDX8By01+0WK7fFS/hpmJHHX/
         NdFl4UnOf5jiHAmrOVBfRNnDvpOD4Mp9rwkwjjLqLa/0Mnp8JpOqpL6m+4spDYBQ/rfx
         6kMhxz0PNEURuQT0wEx4rcSnuYEzeQ7eRN6JK4SmyAoptEoslekffQdybuDKOBXnwtur
         ZmVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3hXycDovfQWD+AG7HeRPGWsGfiOOqD+0Zug5nqKlVXo=;
        b=k6679WK9Xx9qh8HTSlLt7IvKPqn4C0V77fiJFHiwWLWIG4PeF9eg++vhlA9ZfPsb6c
         PH0oJtBVqsGKBZrWhdbORmYwun58Sy+Mt/44QU4HUk3w0m3y7nk9adhpUjlxHz7UJsnw
         cxsZj1gvrAzRJ5hD8j4Q793t/pwlQIr2Sc9PYDAgEtskPDeI/nxoBRcLQh23iZPR9wHn
         0SNxcqFYO8ePoxJp52uL9kzR1Ph/Fdf/ugC0hvaKbBbtpgRbTTCxqR1qP54H8pikO/qR
         tFGxcQBu3MghZgRQSbJ0ex2dUxI6OztTrPF1Si6n1IfaIP5OD2k79HoByDpnBs2hDFfb
         W0Sg==
X-Gm-Message-State: APjAAAVClID9FuoXy6XRHLhXHy9w07QR4kuMofSd4Fi7MOiAl6pJD0z2
        UsTkOsUdyBaDYkt/duMNiKiQd4owMEQ=
X-Google-Smtp-Source: APXvYqw5yX7mnNdN/QRXcRBwVv5cdcKVht3DcJctaYVMbWMFl9/HKmkaMmt26kFvt+HTgvs6G/KJxw==
X-Received: by 2002:adf:dd03:: with SMTP id a3mr10901846wrm.87.1561983465410;
        Mon, 01 Jul 2019 05:17:45 -0700 (PDT)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id g11sm8382520wru.24.2019.07.01.05.17.44
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 01 Jul 2019 05:17:45 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [RFC PATCH 3/3] kernel-shark: Add text rendering to the plotting example
Date:   Mon,  1 Jul 2019 15:17:20 +0300
Message-Id: <20190701121720.18009-4-y.karadz@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190701121720.18009-1-y.karadz@gmail.com>
References: <20190701121720.18009-1-y.karadz@gmail.com>
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
 kernel-shark/examples/dataplot.cpp | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/kernel-shark/examples/dataplot.cpp b/kernel-shark/examples/dataplot.cpp
index 94841e7..1f06dc9 100644
--- a/kernel-shark/examples/dataplot.cpp
+++ b/kernel-shark/examples/dataplot.cpp
@@ -27,6 +27,9 @@ using namespace std;
 
 #define default_file (char*)"trace.dat"
 
+struct ksplot_font font;
+const char *font_file = "/usr/share/fonts/truetype/msttcorefonts/times.ttf";
+
 struct kshark_trace_histo	histo;
 vector<KsPlot::Graph *>		graphs;
 
@@ -72,6 +75,11 @@ void drawShapes()
 	r.setFill(false);
 	r.draw();
 
+	if (ksplot_init_font(&font, 60, font_file)) {
+		struct ksplot_color col = {100, 255, 0};
+		ksplot_print_text(&font, &col, 250, 70, "Hello Kernel!");
+	}
+
 	glFlush();
 }
 
-- 
2.20.1

