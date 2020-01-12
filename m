Return-Path: <SRS0=c7rX=3B=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60122C33CA2
	for <linux-trace-devel@archiver.kernel.org>; Sun, 12 Jan 2020 19:05:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 35D99214D8
	for <linux-trace-devel@archiver.kernel.org>; Sun, 12 Jan 2020 19:05:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qqEyKDxZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733180AbgALTFj (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sun, 12 Jan 2020 14:05:39 -0500
Received: from mail-qv1-f74.google.com ([209.85.219.74]:41153 "EHLO
        mail-qv1-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732957AbgALTFj (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sun, 12 Jan 2020 14:05:39 -0500
Received: by mail-qv1-f74.google.com with SMTP id u11so5062360qvo.8
        for <linux-trace-devel@vger.kernel.org>; Sun, 12 Jan 2020 11:05:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=6NzsR4ctp5hW12AUwjvqmUeevYaG6W27v1XKfWdwNg0=;
        b=qqEyKDxZCHKMVjJezlTg2WCQ7FknIJJH3hs45Gnb2kXhnpeUjC9EJXQkUpsBz16KtM
         nQqK6BY/qNjUKMSuhqNX1KPlgt1TdGNZLLt0xtbfZFYlYeO63qVn/wREFYdJkcCvdb3K
         j5LavypN1J7yCNG8J3bd2nXYh17WB3eQEnZJCgYG03P9yxVpX/o7I2r8Gp4aG/F/TkcW
         TyGFCSFRLFLuheSuxZFLpVT5iKS4QsxxeKjIMJqKs8YU+FZLdVmqrmj6ouhDCj1WMPmg
         lvV60/waXCiP5C3oUDOcsWjPfZRGv57Hti2RfQCmAiBuMiuBTvmkYyD19Fbi9C0nO0wA
         6VjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=6NzsR4ctp5hW12AUwjvqmUeevYaG6W27v1XKfWdwNg0=;
        b=dNqO4dxRi4cDij9fGK2t88mOFj49b/csjTgxTl380+zzvzV8MOyiNLGlPOWXy5SI3r
         JvxqBRycFYnDUaKOQV2dLchnctYTCN/fFLVciYUyHKJuewmrFMMy2ZIdOKdiRxex1b3J
         tZC8LgtEXgxvQqcTXlauI7nWJlORnjTsXNQrB/HpN7075FpK3H0MURsr9YktjqnY0rvx
         4OZEnqs2OS1QPv4hcdQKXxaXF2NZ7SbeO0fIoZTVLnQcsugG+d+xhw7kkGMZs2V/vmG8
         iOWa6I5Hec72HpgiEuhIo6STv1JQQzVFpCI64/dRaBNxIAx9q2l7k6YdxFF3XSysYjZv
         t14A==
X-Gm-Message-State: APjAAAXxWR9ywcJOHt9ocTGd9XkbzJhvvGOduBeppWcDWLtbB06U6F3z
        4KA1Q9EPnN3xDd78yj/Qm2UE8Kz2wjtRyIW+0A8=
X-Google-Smtp-Source: APXvYqyUCGnChABqOGJmlzNVIri71qGMU7KMqnq4Il2bFEJfeRxOur+oZnPP6qCVb344wzCQaI+xWiWuhnMZz5xdXRA=
X-Received: by 2002:a37:aa11:: with SMTP id t17mr8106225qke.69.1578855938550;
 Sun, 12 Jan 2020 11:05:38 -0800 (PST)
Date:   Sun, 12 Jan 2020 14:05:37 -0500
Message-Id: <20200112190537.170197-1-marcgonzalez@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.25.0.rc1.283.g88dfdc4193-goog
Subject: [PATCH] trace-cmd: generate cscope.files when building cscope index
From:   Marcelo Diop-Gonzalez <marcgonzalez@google.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Currently, running 'make cscope' gives this output:

rm -f cscope*
find . -name '\.pc' -prune -o -name '*\.[ch]' -print -o -name '*\.[ch]pp' ! -name '\.#' -print | cscope -b -q
cscope: no source files found
make: *** [Makefile:351: cscope] Error 1

By default, cscope looks in cscope.files for the list of
sources, so printing the source file list to this file
fixes the above error.

Signed-off-by: Marcelo Diop-Gonzalez <marcgonzalez@google.com>
---
 Makefile | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index efd9ed4..0b15bf5 100644
--- a/Makefile
+++ b/Makefile
@@ -348,7 +348,8 @@ TAGS:	force
 
 cscope: force
 	$(RM) cscope*
-	$(call find_tag_files) | cscope -b -q
+	$(call find_tag_files) > cscope.files
+	cscope -b -q
 
 install_plugins_traceevent: force
 	$(Q)$(MAKE) -C $(src)/lib/traceevent/plugins install_plugins
-- 
2.20.1

