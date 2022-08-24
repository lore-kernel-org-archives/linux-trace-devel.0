Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4199CC00140
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Aug 2022 13:55:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235329AbiHXNzy (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 24 Aug 2022 09:55:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238377AbiHXNyw (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 24 Aug 2022 09:54:52 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80FCA7FE74
        for <linux-trace-devel@vger.kernel.org>; Wed, 24 Aug 2022 06:53:13 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 40245222D9;
        Wed, 24 Aug 2022 13:53:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1661349192; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=bvT9tRNw7oFkSqp7gxmYbaprDYSAcxOzkA6sV8LDHa8=;
        b=A2KQ5SBtNueOCJ6VNlagvRnzkH6s3udYA0fE0YPf+AYM5CDaHA+TXVj6r9M7RuTjHWilcX
        XhlqZ0bZ++5olfh5QCM1GfwbGgkNOlx5pJhuFLPJ6dykQLwnOgLofPPmu0URvFw3HMNuk9
        L6D6n1aoYdiwYQYHkD5fl6JZjD+J/K0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1661349192;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=bvT9tRNw7oFkSqp7gxmYbaprDYSAcxOzkA6sV8LDHa8=;
        b=5y3fuSr2czXoUB3oCkJbqrld3kL38HJEZOjTLAqM5wkrJJrZz+VEPOfPIuJXSFDQ32+Qer
        Wmyl8WfHofSk1OBA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 31AD113780;
        Wed, 24 Aug 2022 13:53:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id nOcPDEgtBmOwdgAAMHmgww
        (envelope-from <dwagner@suse.de>); Wed, 24 Aug 2022 13:53:12 +0000
From:   Daniel Wagner <dwagner@suse.de>
To:     linux-trace-devel@vger.kernel.org
Cc:     Daniel Wagner <dwagner@suse.de>
Subject: [PATCH kernelshark] kernel-shark: Build missed_event as GUI plugin
Date:   Wed, 24 Aug 2022 15:53:09 +0200
Message-Id: <20220824135309.5347-1-dwagner@suse.de>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

missed_events depends on GUI elements hence it should be build as GUI
plugin.

Signged-off-by: Daniel Wagner <dwagner@suse.de>
---

I had some build errors due to global build flags in our build service:

  Linker flags : -flto=auto -Wl,--as-needed -Wl,--no-undefined -Wl,-z,now

 src/plugins/CMakeLists.txt | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/src/plugins/CMakeLists.txt b/src/plugins/CMakeLists.txt
index e9d906863424..49aee3ed7560 100644
--- a/src/plugins/CMakeLists.txt
+++ b/src/plugins/CMakeLists.txt
@@ -61,8 +61,8 @@ if (Qt5Widgets_FOUND AND TT_FONT_FILE)
 
 endif (Qt5Widgets_FOUND AND TT_FONT_FILE)
 
-BUILD_PLUGIN(NAME missed_events
-             SOURCE missed_events.c MissedEvents.cpp)
+BUILD_GUI_PLUGIN(NAME missed_events
+		 SOURCE missed_events.c MissedEvents.cpp)
 list(APPEND PLUGIN_LIST "missed_events")
 
 install(TARGETS ${PLUGIN_LIST}
-- 
2.37.1

