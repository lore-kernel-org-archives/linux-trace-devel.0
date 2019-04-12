Return-Path: <SRS0=k/vv=SO=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC1C4C282CE
	for <linux-trace-devel@archiver.kernel.org>; Fri, 12 Apr 2019 13:38:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A26522084D
	for <linux-trace-devel@archiver.kernel.org>; Fri, 12 Apr 2019 13:38:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726826AbfDLNiQ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 12 Apr 2019 09:38:16 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:39456 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726884AbfDLNiQ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 12 Apr 2019 09:38:16 -0400
Received: by mail-wr1-f65.google.com with SMTP id j9so12011264wrn.6
        for <linux-trace-devel@vger.kernel.org>; Fri, 12 Apr 2019 06:38:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ajjyB1oXnzRIg9g9v5mJwY6aetnydGPN6FUpkexlbTo=;
        b=dNiPl0bXDa1fFE1NVXqd5ehGb0HoR5YnQKtfEiC3KOJmMMTueqHNZb768iSolPaojD
         +aS70CWO6/HafJyzy1AHWxKHSb2equFItTb2ikoBXEfc1qSwP85txOJ8r7mkt39YXg86
         j2PLQSibsOaoobbTHN0Vac6NyQKRp5Lzx4eolaXV+tVK4a4aF8ra6c0YVDEMq5Oe4eyJ
         mx2+vVu9oPOXUdWEG3mMVHXx4kulqKa8BpybiNHWf8eWmgpHfvIO9tTM1kXIMpIu8Ea3
         nPgtHAmQ6Cl3UMWIJUbd25aNAmFbNFRd39VybYQPivzc+ApOxa6N9aObunO6MZi5ZUUf
         0UXQ==
X-Gm-Message-State: APjAAAWi3sutXx4DAUAf4iBWquz7OWF9kkpSetPZL5F0LBuDltY8IKXJ
        IHe/FoTSjNTCnztiXEAkvxXPfIw7
X-Google-Smtp-Source: APXvYqwvxT1uJCeQJoNQskFIoQ/4Uc0yAt5x9u5+csNdG+dewE1V4QK91GtYMbUnx5N5MBhZ/FUQUA==
X-Received: by 2002:a5d:6a0b:: with SMTP id m11mr34887231wru.290.1555076294750;
        Fri, 12 Apr 2019 06:38:14 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id x205sm11594682wmg.9.2019.04.12.06.38.13
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 12 Apr 2019 06:38:14 -0700 (PDT)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v5 02/30] tools/lib/traceevent: Add support for man pages with multiple names
Date:   Fri, 12 Apr 2019 16:37:43 +0300
Message-Id: <20190412133811.15878-3-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190412133811.15878-1-tstoyanov@vmware.com>
References: <20190412133811.15878-1-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Added support for man pages with multiple names, used to combine
the description of several APIs into one page.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 .../traceevent/Documentation/asciidoc.conf    | 35 +++++++++++++++++--
 1 file changed, 32 insertions(+), 3 deletions(-)

diff --git a/tools/lib/traceevent/Documentation/asciidoc.conf b/tools/lib/traceevent/Documentation/asciidoc.conf
index 1b03c63fb73a..07595717f06e 100644
--- a/tools/lib/traceevent/Documentation/asciidoc.conf
+++ b/tools/lib/traceevent/Documentation/asciidoc.conf
@@ -74,12 +74,41 @@ template::[header-declarations]
 <refmeta>
 <refentrytitle>{mantitle}</refentrytitle>
 <manvolnum>{manvolnum}</manvolnum>
-<refmiscinfo class="source">trace-cmd</refmiscinfo>
+<refmiscinfo class="source">libtraceevent</refmiscinfo>
 <refmiscinfo class="version">{libtraceevent_version}</refmiscinfo>
-<refmiscinfo class="manual">trace-cmd Manual</refmiscinfo>
+<refmiscinfo class="manual">libtraceevent Manual</refmiscinfo>
 </refmeta>
 <refnamediv>
-  <refname>{manname}</refname>
+  <refname>{manname1}</refname>
+  <refname>{manname2}</refname>
+  <refname>{manname3}</refname>
+  <refname>{manname4}</refname>
+  <refname>{manname5}</refname>
+  <refname>{manname6}</refname>
+  <refname>{manname7}</refname>
+  <refname>{manname8}</refname>
+  <refname>{manname9}</refname>
+  <refname>{manname10}</refname>
+  <refname>{manname11}</refname>
+  <refname>{manname12}</refname>
+  <refname>{manname13}</refname>
+  <refname>{manname14}</refname>
+  <refname>{manname15}</refname>
+  <refname>{manname16}</refname>
+  <refname>{manname17}</refname>
+  <refname>{manname18}</refname>
+  <refname>{manname19}</refname>
+  <refname>{manname20}</refname>
+  <refname>{manname21}</refname>
+  <refname>{manname22}</refname>
+  <refname>{manname23}</refname>
+  <refname>{manname24}</refname>
+  <refname>{manname25}</refname>
+  <refname>{manname26}</refname>
+  <refname>{manname27}</refname>
+  <refname>{manname28}</refname>
+  <refname>{manname29}</refname>
+  <refname>{manname30}</refname>
   <refpurpose>{manpurpose}</refpurpose>
 </refnamediv>
 endif::backend-docbook[]
-- 
2.20.1

