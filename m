Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCB3FC433EF
	for <linux-trace-devel@archiver.kernel.org>; Mon,  8 Nov 2021 08:04:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A613F61265
	for <linux-trace-devel@archiver.kernel.org>; Mon,  8 Nov 2021 08:04:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237461AbhKHIHE (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 8 Nov 2021 03:07:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237488AbhKHIHE (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 8 Nov 2021 03:07:04 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01011C061714
        for <linux-trace-devel@vger.kernel.org>; Mon,  8 Nov 2021 00:04:20 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id x15so27689356edv.1
        for <linux-trace-devel@vger.kernel.org>; Mon, 08 Nov 2021 00:04:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PRKOUpSPz2MrFKoCTUfyi5fFSUBgMvydm8xx2NyGkh0=;
        b=DcX9kNEG82wtAoPfUz2gwAxFZi1fTvCr8l9dh81A/JbaxmHo0EQH/AnXvmsFMnUemT
         IC6WzSwMaPRHYWsMR4t8/XAsfm7OWTvjwmZVAsKB/fO3Hyk8FUP3hzvT2cp6wrk6APkj
         +xVZc247ogl/SlnTN3E/ufoaWuFF99qTYSv0jAeFPWcoKmCQHkI1pEl7YroFtKRA5Mcb
         8AHb2rUEoU/MDup4JyVf6QF5QoW2LMltC06wuxoF8ClEWUXfUTM7xQCK0UtKMaQMfTvu
         NEpmQ86TaWZL/uUBEUC5iNII4uPXiw7nd/cEPpZkogAlPMJFUYfiXL+7vehD0QuuY/PO
         GxuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PRKOUpSPz2MrFKoCTUfyi5fFSUBgMvydm8xx2NyGkh0=;
        b=gqeOH1T3rjl/FCl9+H/XphFc9b+f0BBPDU2aliWnMSasB/c/i+U99PPqM0l9mWqz5y
         Tr+kgRZIQoYpRql9riva8illu7myezeqEhRsMj6e9z/Jbh7651TQHeI8IoHOqAqXzpuc
         gBGZMwN0i3Eabh7OKusPBASllVTxPOivicz5Gra2YDL5Bm+HoiMkhAG21tyEwhY0ynOf
         +RkvOT7gNJ+lE/N7tSXn4Wl/d/KxAfoiJLaHH/U23oeaCIIm1qIjc6SVTYJWyk2/r8Pl
         J10SjZrw31zje7O9W//OkWMEq529rKP6JvZt69rr5wOg8yhPUBHrmI2zoc0Zsiz5i9b3
         sz3Q==
X-Gm-Message-State: AOAM533eSL/aM08kJbg518N6JhebcE0VR1WsPuUzE/p+sD7z7WeYH/99
        9QhwV9Xw5fFOUE1neXv3iOshfi/pzQGRJw==
X-Google-Smtp-Source: ABdhPJxcUXBHBBd92kB9PJzuTrHwG5WckczXIxGwL/MEDHTBjtBw9AN3AACxgl0BqMxSKqq0anO5DA==
X-Received: by 2002:a05:6402:27ce:: with SMTP id c14mr36495577ede.321.1636358658673;
        Mon, 08 Nov 2021 00:04:18 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id mp5sm7962309ejc.68.2021.11.08.00.04.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Nov 2021 00:04:18 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org, y.karadz@gmail.com
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v6 12/12] libtracefs: Do not clean sqlhist man page source
Date:   Mon,  8 Nov 2021 10:04:04 +0200
Message-Id: <20211108080404.55814-13-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211108080404.55814-1-tz.stoyanov@gmail.com>
References: <20211108080404.55814-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The "make doc_clean" command assumes that all *.1 files are being
generated with "make doc" command and removes all of them. This
assumption is wrong, as the sources of man pages from section one
have prefix "*.txt.1" and must not be removed. A more precise filtering
is added, so only files generated during "make doc" are removed.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 Documentation/Makefile | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/Documentation/Makefile b/Documentation/Makefile
index 0c00505..92a67aa 100644
--- a/Documentation/Makefile
+++ b/Documentation/Makefile
@@ -197,7 +197,8 @@ endif
 CLEAN_FILES =					\
 	$(MAN_XML) $(addsuffix +,$(MAN_XML))	\
 	$(MAN_HTML) $(addsuffix +,$(MAN_HTML))	\
-	$(DOC_MAN3) *.3 *.1 *.m
+	$(filter-out $(MAN1_TEXT),$(wildcard *.1)) \
+	$(DOC_MAN3) *.3 *.m
 
 clean:
 	$(Q) $(RM) $(CLEAN_FILES)
-- 
2.31.1

