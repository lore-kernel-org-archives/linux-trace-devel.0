Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1205EB64D9
	for <linux-trace-devel@archiver.kernel.org>; Thu, 15 Jun 2023 17:45:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229711AbjFORpK (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 15 Jun 2023 13:45:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231906AbjFORpI (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 15 Jun 2023 13:45:08 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95EAF271E
        for <linux-trace-devel@vger.kernel.org>; Thu, 15 Jun 2023 10:45:07 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 423A81FE59;
        Thu, 15 Jun 2023 17:45:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1686851106; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=c/RRtAeTRx2Ghm/zrMjnkM4u7B94w4oA3e/FbfvaDnk=;
        b=XzWUtElVBLjd46rloUOjpm7CB+4Db9gbQr+ZEol1KqofYgbDyErYRYBQKK9CGfyxbTdHuy
        nDVqvVGA97QN80XyDWlkYPBHjwtUCaPSkcG2YwVRGOREMTFM5uSI1WyBtZR+8hL+JqJteZ
        CRFs+dyGhS5g8ZGHVOTtw13Gt6gaTkw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1686851106;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=c/RRtAeTRx2Ghm/zrMjnkM4u7B94w4oA3e/FbfvaDnk=;
        b=hg5Q2nj/gqecrbyruZYnnmqZU8rq0wK3jsSyfPo7BPI7zb/O5a/LulcqzKUPUZJlFdy3IN
        aYSEmba2OnLM5kBw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 341F213467;
        Thu, 15 Jun 2023 17:45:06 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id jqSDDCJOi2QcVQAAMHmgww
        (envelope-from <dwagner@suse.de>); Thu, 15 Jun 2023 17:45:06 +0000
From:   Daniel Wagner <dwagner@suse.de>
To:     linux-trace-devel@vger.kernel.org
Cc:     Steven Rostedt <rostedt@goodmis.org>, Tony Jones <tonyj@suse.com>,
        Daniel Wagner <dwagner@suse.de>
Subject: [PATCH 2/2] trace-cmd: Add explicit pthread and dl dependency to meson
Date:   Thu, 15 Jun 2023 19:45:00 +0200
Message-Id: <20230615174500.9158-2-dwagner@suse.de>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230615174500.9158-1-dwagner@suse.de>
References: <20230615174500.9158-1-dwagner@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Older version of meson do not add automatically the pthread and dl
dependency. Thus add it explicitly to the build.

Signed-off-by: Daniel Wagner <dwagner@suse.de>
---
 meson.build | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/meson.build b/meson.build
index 906ac8168f4f..fbdf016f67a7 100644
--- a/meson.build
+++ b/meson.build
@@ -27,6 +27,9 @@ conf = configuration_data()
 libtraceevent_dep = dependency('libtraceevent', version: '>= 1.5.0', required: true)
 libtracefs_dep = dependency('libtracefs', version: '>= 1.6.0', required: true)
 
+threads_dep = dependency('threads', required: true)
+dl_dep = cc.find_library('dl', required : false)
+
 zlib_dep = dependency('zlib', required: false)
 conf.set('HAVE_ZLIB', zlib_dep.found(), description: 'Is zlib avialable?')
 
-- 
2.40.1

