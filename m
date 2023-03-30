Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7A49C6FD1D
	for <linux-trace-devel@archiver.kernel.org>; Thu, 30 Mar 2023 18:52:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230465AbjC3Swc (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 30 Mar 2023 14:52:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230513AbjC3Sw2 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 30 Mar 2023 14:52:28 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48701E194
        for <linux-trace-devel@vger.kernel.org>; Thu, 30 Mar 2023 11:52:20 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 7AF3F219E1;
        Thu, 30 Mar 2023 18:52:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1680202339; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=ygLXcYMwcwtOwFrAIs62/crx9RWc0eOwWPWu6ECjZwI=;
        b=wSb5BC7TzNt0e7rRaHWf5DhKoQ102Ee/WYQ155tph/ClP40X+EePhFTVofpFK9gGQYOqXg
        NptStTWsGgEY5toytrF9yEEBvubiPgaPGy3JfWiJY6ki6flc5cwJne5s1lJqmmRFB0gFqv
        L5EGn53+HQUptTNkDUf1+/7O9MC4Fz4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1680202339;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=ygLXcYMwcwtOwFrAIs62/crx9RWc0eOwWPWu6ECjZwI=;
        b=lBBAGF8Nq7KOzREGO4CcA7UJB7eW/hHsoD8MJZuOEC++7Mv1MeLUxUtPbLrK/cjXMPfAQR
        lFj4MtpC5xjIJUAQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id F2B7F133E0;
        Thu, 30 Mar 2023 18:52:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id x25fJ2LaJWSkMgAAMHmgww
        (envelope-from <krisman@suse.de>); Thu, 30 Mar 2023 18:52:18 +0000
From:   Gabriel Krisman Bertazi <krisman@suse.de>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@suse.de>
Subject: [PATCH trace-cmd v2 0/3] trace-cmd filtering
Date:   Thu, 30 Mar 2023 15:52:08 -0300
Message-Id: <20230330185211.5604-1-krisman@suse.de>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi Steve,

This implements my fix to restore single input filtering behavior
(bz217038) and adds support for global filters, as you requested.

On another topic, a current behavior that seems weird in my opinion is
that the following negates the second filter as well.

  "trace-cmd -i trace.dat.1 -v -F tp1 -i trace.dat.2 -F tp2"

I'd prefer that -v would apply only to the following -F. It'd allow me
to do:

  "trace-cmd -v -F 'mm_page_alloc' -i trace.dat.1 -i trace.dat.2 ... \
             -i trace.dat.10 -F 'mm_page_alloc:order==1'"

It obviously breaks the interface, so I didn't implement it here.  Would
like to hear your input, though.  We could have a new syntax:

  "trace-cmd ! -F tp1 -F tp2 ! -F tp3"

Thanks,

Gabriel Krisman Bertazi (3):
  trace-cmd report: Ensure filter is applied to single input file
  trace-cmd-report: Support global filters
  documentation: trace-cmd-report: Document filter scope

 .../trace-cmd/trace-cmd-report.1.txt          |  8 +++-
 tracecmd/trace-read.c                         | 45 ++++++++++++-------
 2 files changed, 34 insertions(+), 19 deletions(-)

-- 
2.40.0

