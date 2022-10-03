Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60D6EC433FE
	for <linux-trace-devel@archiver.kernel.org>; Mon,  3 Oct 2022 15:41:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229516AbiJCPl0 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 3 Oct 2022 11:41:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229583AbiJCPlY (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 3 Oct 2022 11:41:24 -0400
X-Greylist: delayed 71 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 03 Oct 2022 08:41:23 PDT
Received: from smtprelay04.ispgateway.de (smtprelay04.ispgateway.de [80.67.18.16])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6EBA15FF5
        for <linux-trace-devel@vger.kernel.org>; Mon,  3 Oct 2022 08:41:23 -0700 (PDT)
Received: from [87.162.49.60] (helo=enterprise.apron)
        by smtprelay04.ispgateway.de with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <andrej.stender@thermalcircle.de>)
        id 1ofNYR-0000Ot-VW; Mon, 03 Oct 2022 17:40:28 +0200
Date:   Mon, 3 Oct 2022 17:40:09 +0200
From:   Andrej Stender <andrej.stender@thermalcircle.de>
To:     Yordan Karadzhov <y.karadz@gmail.com>,
        linux-trace-devel@vger.kernel.org
Cc:     Andrej Stender <andrej.stender@thermalcircle.de>
Subject: [PATCH] kernel-shark: Fix function_graph indent monospace
Message-ID: <ce193c5260178313eaaab3dcf49dfcbb9526be0b.1664810553.git.andrej.stender@thermalcircle.de>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Df-Sender: YW5kcmVqLnN0ZW5kZXJAdGhlcm1hbGNpcmNsZS5kZQ==
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Show content of KsTraceViewer table in monospaced font. When using
function_graph tracer, its C-style indentation of traced functions is
now shown correctly.

Use system font, so the font used in the table can still can be
configured via window manager, same as the fonts in title and menus. The
font in the horizontal header of the table stays regular non-monospaced
as before.

Tested on KDE Plasma 5.25.4, Qt 5.15.4.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=216404
Signed-off-by: Andrej Stender <andrej.stender@thermalcircle.de>
---
 src/KsTraceViewer.cpp | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/src/KsTraceViewer.cpp b/src/KsTraceViewer.cpp
index afd5a859de72..be0a41941db2 100644
--- a/src/KsTraceViewer.cpp
+++ b/src/KsTraceViewer.cpp
@@ -129,6 +129,9 @@ KsTraceViewer::KsTraceViewer(QWidget *parent)
 	_view.setSelectionBehavior(QAbstractItemView::SelectRows);
 	_view.setSelectionMode(QAbstractItemView::SingleSelection);
 	_view.verticalHeader()->setDefaultSectionSize(FONT_HEIGHT * 1.25);
+	_view.setFont(QFontDatabase::systemFont(QFontDatabase::FixedFont));
+	_view.horizontalHeader()->setFont(
+		QFontDatabase::systemFont(QFontDatabase::GeneralFont));
 
 	 _proxyModel.setSource(&_model);
 	_view.setModel(&_proxyModel);
-- 
2.20.1

