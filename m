Return-Path: <SRS0=YLRJ=DZ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 992BFC433DF
	for <linux-trace-devel@archiver.kernel.org>; Sun, 18 Oct 2020 21:21:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 55EF122280
	for <linux-trace-devel@archiver.kernel.org>; Sun, 18 Oct 2020 21:21:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mePniag4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727286AbgJRVVV (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sun, 18 Oct 2020 17:21:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726458AbgJRVVU (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sun, 18 Oct 2020 17:21:20 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 727C8C061755;
        Sun, 18 Oct 2020 14:21:20 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id b8so9254114wrn.0;
        Sun, 18 Oct 2020 14:21:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=pcBDk3xTi1JpIx/rgIRMpOmHCerqPvdUMi9HOx3oj3w=;
        b=mePniag4SSMtgAZxS5stq3QdzAbv0c5IBDOSONkEib/DMXJPx9qBbw2c4iB1RTWkzR
         JKPoa8YDmPieZtnVB6inE1J4Zf7BM7zD9EQOuTqmTV/Oju/GQMh2/1tcQBt98TaM46Xq
         3QoY0nLca67hr+/SDR69NPKu+XUAxH5nbSmGOZBh1m3iWDfap5ewAJ6JL000o/OpQ6Rx
         IUZDgVXVr7qyM26qbSe3pbFlGWZuuWZMc+SMeyqNMsj4vJW03JOCMGRSoEzVE95SQ2zf
         dDakLrYg34P3XLFMiAtQmuMaqImmjXSvxXmM8tNFzHu8x1KhSx1WrwEEQUBR6hwAjH/u
         VfkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=pcBDk3xTi1JpIx/rgIRMpOmHCerqPvdUMi9HOx3oj3w=;
        b=PEL8pRBuHubpv3Xat0yNyVSeTvHdNW4aQ+Dwh5Sipwc93Pn3Xl86c0fh3sJiVxEhX2
         dQzv4egnBVLMrcRhoeVDY5c+lM5TWyKNoAxZIhiung3m87aMGDCYEkGwPgqi1uPll0Vh
         yh4S331rl9FqWae98pQC+WVtCRo0CGCDU7qKrbF/99pu+bYdxvhd8XltmKrsWbQm+z2D
         mbZS3iBw9AHE682iot2feyIp/2IHoX1sH9Ssg8lrdQjJvBZ/l2/B9Wvzv8phtbDA/Lds
         OB4afOtAe4Aa4iLrGmc0c0VwVn5KYPCgTp8ZmuxfhIVAN9crMSliE4aNw4yrF5Ugoz3e
         2cUQ==
X-Gm-Message-State: AOAM531QiQb9VjrZeo24GaJz87Uc0bQToDYaCXncr6RJm24rgWUaDbOj
        B1+Dlj5NlxVp5ulKoI7bwm4=
X-Google-Smtp-Source: ABdhPJxiX2HOwBjI9jdgFUDWLYUHd/xUuLEf/MELhyxbRZ1i8WKf40v2OCt+8Bz6Q/pfrl1R/CM5cw==
X-Received: by 2002:adf:9069:: with SMTP id h96mr17229331wrh.358.1603056078979;
        Sun, 18 Oct 2020 14:21:18 -0700 (PDT)
Received: from localhost.localdomain (host-92-5-241-147.as43234.net. [92.5.241.147])
        by smtp.gmail.com with ESMTPSA id r1sm15642149wro.18.2020.10.18.14.21.17
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 18 Oct 2020 14:21:18 -0700 (PDT)
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Steven Rostedt <rostedt@goodmis.org>, acme@redhat.com
Cc:     linux-kernel@vger.kernel.org, linux-trace-devel@vger.kernel.org,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH] libtraceevent: install html files
Date:   Sun, 18 Oct 2020 22:19:12 +0100
Message-Id: <20201018211912.17541-1-sudipm.mukherjee@gmail.com>
X-Mailer: git-send-email 2.11.0
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Only the man pages were installed using "make install". Add rules to
install html files also.

Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---
 tools/lib/traceevent/Documentation/Makefile | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/tools/lib/traceevent/Documentation/Makefile b/tools/lib/traceevent/Documentation/Makefile
index aa72ab96c3c1..dd3d62b17140 100644
--- a/tools/lib/traceevent/Documentation/Makefile
+++ b/tools/lib/traceevent/Documentation/Makefile
@@ -147,7 +147,7 @@ html: $(MAN_HTML)
 
 $(MAN_HTML) $(DOC_MAN3): asciidoc.conf
 
-install: install-man
+install: install-man install-html
 
 check-man-tools:
 ifdef missing_tools
@@ -161,12 +161,22 @@ do-install-man: man
 
 install-man: check-man-tools man do-install-man
 
-uninstall: uninstall-man
+do-install-html: html
+	$(call QUIET_INSTALL, Documentation-html) \
+		$(INSTALL) -d -m 755 $(DESTDIR)$(htmldir); \
+		$(INSTALL) -m 644 $(OUTPUT)*.html $(DESTDIR)$(htmldir);
+
+install-html: check-man-tools html do-install-html
+
+uninstall: uninstall-man uninstall-html
 
 uninstall-man:
 	$(call QUIET_UNINST, Documentation-man) \
 		$(Q)$(RM) $(addprefix $(DESTDIR)$(man3dir)/,$(DOC_MAN3))
 
+uninstall-html:
+	$(call QUIET_UNINST, Documentation-html) \
+		$(Q)$(RM) $(addprefix $(DESTDIR)$(htmldir)/,$(MAN_HTML))
 
 ifdef missing_tools
   DO_INSTALL_MAN = $(warning Please install $(missing_tools) to have the man pages installed)
-- 
2.11.0

