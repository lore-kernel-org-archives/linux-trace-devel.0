Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E036C6379F
	for <linux-trace-devel@archiver.kernel.org>; Thu,  9 Feb 2023 07:14:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229831AbjBIHOT (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 9 Feb 2023 02:14:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229801AbjBIHON (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 9 Feb 2023 02:14:13 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC2693EFF9;
        Wed,  8 Feb 2023 23:14:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=p2B+Zdq4U49rLYu84/NTGAjEl2MB0ddOAhuj34qTL7c=; b=aP5v4lCpy3z/oH1tdkSZMR2eae
        KZivTs6+Vn5Kov0r5ZaV8ZnJk3NLPEFSt369nOHQL4sD8LGB8rAsvgQhoTz8vNKJbKrvyNjP52q0K
        lZBWhVl3azxlBolsQ/rcUsRQ7WvlEOZvzVurySVocPK8b2YxokZIOggeUvbaMcMVgUMf+0UoIh27Q
        INkGsP7fQ5XPd6+0i2ZzSqOPmI+hlePGGIT0zQGIOfvqPKY8BSzR+ADeclF4dIYEKLLRerVCx9ugd
        PcgDLty32/d1pPLvYvReRuUBdCCW/hCsmFnkMv4vTLVpTOu3MDHlmrsZOCqhUQOQDI9b03CHy0NpL
        adHTBJ0Q==;
Received: from [2601:1c2:980:9ec0::df2f] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pQ18G-000LPt-FX; Thu, 09 Feb 2023 07:14:12 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     linux-kernel@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Daniel Bristot de Oliveira <bristot@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        linux-trace-devel@vger.kernel.org,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: [PATCH 19/24] Documentation: tools/rtla: correct spelling
Date:   Wed,  8 Feb 2023 23:13:55 -0800
Message-Id: <20230209071400.31476-20-rdunlap@infradead.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230209071400.31476-1-rdunlap@infradead.org>
References: <20230209071400.31476-1-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Correct spelling problems for Documentation/tools/rtla/ as reported
by codespell.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Daniel Bristot de Oliveira <bristot@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-trace-devel@vger.kernel.org
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: linux-doc@vger.kernel.org
Acked-by: Daniel Bristot de Oliveira <bristot@kernel.org>
Acked-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 Documentation/tools/rtla/rtla-timerlat-top.rst |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -- a/Documentation/tools/rtla/rtla-timerlat-top.rst b/Documentation/tools/rtla/rtla-timerlat-top.rst
--- a/Documentation/tools/rtla/rtla-timerlat-top.rst
+++ b/Documentation/tools/rtla/rtla-timerlat-top.rst
@@ -128,7 +128,7 @@ and then when the *timerlat* thread was
 then be used as the starting point of a more fine-grained analysis.
 
 Note that **rtla timerlat** was dispatched without changing *timerlat* tracer
-threads' priority. That is generally not needed because these threads hava
+threads' priority. That is generally not needed because these threads have
 priority *FIFO:95* by default, which is a common priority used by real-time
 kernel developers to analyze scheduling delays.
 
