Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F811C54EBC
	for <linux-trace-devel@archiver.kernel.org>; Tue, 10 Jan 2023 13:18:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233891AbjAJNSm (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 10 Jan 2023 08:18:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231863AbjAJNSO (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 10 Jan 2023 08:18:14 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44687615F;
        Tue, 10 Jan 2023 05:18:13 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id CF8E576049;
        Tue, 10 Jan 2023 13:18:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1673356691; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=dZqqazlG3Y9JpfBvsAQu9itiq0NGswEh6VZzATNttmI=;
        b=XjSrUouDnoHbLDwAdUKO1R/fssBxhAuYmeNEey/JJzfd7ox0E0URqSl9J+g6D0sMKy8pxH
        jzJt0MmBUuaHwrfQs5wOPsH80F+mtFIMpEubf+yExaAM+3sG0DGpy5lkmFGTZ1ZxbUPe9W
        zH/Pr/cAK94uns80mnBUduO/weIXDA0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1673356691;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=dZqqazlG3Y9JpfBvsAQu9itiq0NGswEh6VZzATNttmI=;
        b=ycgqBNNZ4Z2y5izcR0QhfDh9ifbIrdfxQYtuv/PtZ0hIHB/7OwpTU9COIcbeHD3P2EXVy7
        XJNhK7khO1Z96XBg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id C0FD013338;
        Tue, 10 Jan 2023 13:18:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id syATL5NlvWPyNgAAMHmgww
        (envelope-from <dwagner@suse.de>); Tue, 10 Jan 2023 13:18:11 +0000
From:   Daniel Wagner <dwagner@suse.de>
To:     Daniel Bristot de Oliveira <bristot@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Daniel Wagner <dwagner@suse.de>
Subject: [PATCH] tools/rtla: Explicitly list libtraceevent dependency
Date:   Tue, 10 Jan 2023 14:18:05 +0100
Message-Id: <20230110131805.16242-1-dwagner@suse.de>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The current libtracefs.pkg file lists the dependency on
libtraceevent ("pkg-config --libs libtracefs" -> "-ltracefs
-ltraceevent").

Dan Nicholson's Guide to pkg-config[1] stats that "Libs: The link
flags specific to this package and any required libraries that don't
support pkg-config". Thus the current libtracefs.pkg is not correct.

rtla is depending on libtraceevent but it doesn't express this in
'pkg-config' part to retrieve the correct build flags.

In order to be able to update the "Libs:" section in the libtracefs
project we need to list the dependency explicitly to avoid future linker
failures.

[1] https://people.freedesktop.org/~dbn/pkg-config-guide.html

Signed-off-by: Daniel Wagner <dwagner@suse.de>
---

I've got this fallout with because I am using libtraceevent and libtracefs build
with Meson. Meson generates different pkg files which seems to align with Dan's
Guide.

 tools/tracing/rtla/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/tracing/rtla/Makefile b/tools/tracing/rtla/Makefile
index 22e28b76f800..0664e2db22c1 100644
--- a/tools/tracing/rtla/Makefile
+++ b/tools/tracing/rtla/Makefile
@@ -32,7 +32,7 @@ TRACEFS_HEADERS	:= $$($(PKG_CONFIG) --cflags libtracefs)
 
 CFLAGS	:=	-O -g -DVERSION=\"$(VERSION)\" $(FOPTS) $(MOPTS) $(WOPTS) $(TRACEFS_HEADERS) $(EXTRA_CFLAGS)
 LDFLAGS	:=	-ggdb $(EXTRA_LDFLAGS)
-LIBS	:=	$$($(PKG_CONFIG) --libs libtracefs)
+LIBS	:=	$$($(PKG_CONFIG) --libs libtracefs libtraceevent)
 
 SRC	:=	$(wildcard src/*.c)
 HDR	:=	$(wildcard src/*.h)
-- 
2.39.0

