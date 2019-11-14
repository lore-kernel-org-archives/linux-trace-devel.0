Return-Path: <SRS0=uJmw=ZG=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EFFDC432C3
	for <linux-trace-devel@archiver.kernel.org>; Thu, 14 Nov 2019 13:37:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 56B4A2070E
	for <linux-trace-devel@archiver.kernel.org>; Thu, 14 Nov 2019 13:37:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="T3Vuqdji"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726969AbfKNNhm (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 14 Nov 2019 08:37:42 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:38028 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726330AbfKNNhm (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 14 Nov 2019 08:37:42 -0500
Received: by mail-wm1-f68.google.com with SMTP id z19so5934195wmk.3;
        Thu, 14 Nov 2019 05:37:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=OxTRAJXVXXdIFzpBwIyZ5uK1YGGka2CVY+xla7v0Bcg=;
        b=T3Vuqdjiywjp0KnFG75MQwPuEkjO5rPNDR5x4F8/XMosdwKaRkMA3k98MYU0cGS22n
         ARwOo4F4Smb/6BICAVJcoLnIscZoGroXjYpTkIJ9acv+LhiH2r5/fbaESd5AbsF1lDKT
         iQA/V9lSPU8tTjOpTPR1dlL/t/sV4wxiyECjOL+l5zMApMh2gwisykLhEHib6rQk2utH
         LUlNOr429N3TVFuf2+5zgJqmMritaOzngYgYANXCjawOKRSd4kQEBKDzQyvWV8/4ug8M
         qwe7fHFPi4n6oB/JJgvWndDHv+EEmDMapB5f+JJZozBbpFPZICLE+GXY173qHUmUMLQv
         yebw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=OxTRAJXVXXdIFzpBwIyZ5uK1YGGka2CVY+xla7v0Bcg=;
        b=hsuXNdQVlK227F3IXvrS1ldXpTkfkHWw0wxW7NnD75qbzSR2sB6SbLk+Q1qtYPEOMJ
         c8BIzPWTCq7ByyoYuCSqi6CwDzKVnO1Y/8yanjb9vXZrL6yFeF1kKEAN7Uwoq5urmiAF
         I7MMpGeK1U8gi6w2Y0LuGPMyixiFraMJWH6zdzmmF3sEP0PAP9C3Q0eEc0hV1vmcveji
         PZi7fNrAGPV8fLw8SNS+mCjacgoad5DJj9q6ifugUan+LxQ0oe02FAuckukPa1sxJ6C2
         iP5ITKc1KnjEJRNlPVkAKFocNgHecC+aWdJrF6kH34nAu9jNDSGD9lolyXewe/bGc3US
         jINw==
X-Gm-Message-State: APjAAAVXQV/++7g7Svhuu83ssranxQgucpMHE453Yi0IMi1uR2bNShUg
        byopugLLOLYAUNyyxLkVFUO+xFE4
X-Google-Smtp-Source: APXvYqwatI+kxUiWoajpho7DBVdcdQYAe4QmtGLMrCmKGz9+ia3rSKGuIZyLoXCQbWq+XHBOtiMQNg==
X-Received: by 2002:a1c:dc09:: with SMTP id t9mr7738207wmg.65.1573738659943;
        Thu, 14 Nov 2019 05:37:39 -0800 (PST)
Received: from debian.office.codethink.co.uk ([167.98.27.226])
        by smtp.gmail.com with ESMTPSA id j63sm6317143wmj.46.2019.11.14.05.37.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 14 Nov 2019 05:37:39 -0800 (PST)
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-kernel@vger.kernel.org, linux-trace-devel@vger.kernel.org,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH] libtraceevent: fix header installation
Date:   Thu, 14 Nov 2019 13:37:19 +0000
Message-Id: <20191114133719.309-1-sudipm.mukherjee@gmail.com>
X-Mailer: git-send-email 2.11.0
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

When we passed some location in DESTDIR, install_headers called
do_install with DESTDIR as part of the second argument. But do_install
is again using '$(DESTDIR_SQ)$2', so as a result the headers were
installed in a location $DESTDIR/$DESTDIR. In my testing I passed
DESTDIR=/home/sudip/test and the headers were installed in:
/home/sudip/test/home/sudip/test/usr/include/traceevent.
Lets remove DESTDIR from the second argument of do_install so that the
headers are installed in the correct location.

Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---

Hi Steve,
sent this earlier as an attachment to an email thread, not sure if you
saw it, so sending it now properly.
The other problem with the pkgconfig, I guess we can live with that for
now as that folder is given by pc_path.

 tools/lib/traceevent/Makefile | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/lib/traceevent/Makefile b/tools/lib/traceevent/Makefile
index 5315f3787f8d..cbb429f55062 100644
--- a/tools/lib/traceevent/Makefile
+++ b/tools/lib/traceevent/Makefile
@@ -232,10 +232,10 @@ install_pkgconfig:
 
 install_headers:
 	$(call QUIET_INSTALL, headers) \
-		$(call do_install,event-parse.h,$(DESTDIR)$(includedir_SQ),644); \
-		$(call do_install,event-utils.h,$(DESTDIR)$(includedir_SQ),644); \
-		$(call do_install,trace-seq.h,$(DESTDIR)$(includedir_SQ),644); \
-		$(call do_install,kbuffer.h,$(DESTDIR)$(includedir_SQ),644)
+		$(call do_install,event-parse.h,$(includedir_SQ),644); \
+		$(call do_install,event-utils.h,$(includedir_SQ),644); \
+		$(call do_install,trace-seq.h,$(includedir_SQ),644); \
+		$(call do_install,kbuffer.h,$(includedir_SQ),644)
 
 install: install_lib
 
-- 
2.11.0

