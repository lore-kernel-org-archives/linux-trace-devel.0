Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95BF7C10F1B
	for <linux-trace-devel@archiver.kernel.org>; Wed, 21 Dec 2022 17:08:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230103AbiLURIu (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 21 Dec 2022 12:08:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229620AbiLURIt (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 21 Dec 2022 12:08:49 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D10B6FADB
        for <linux-trace-devel@vger.kernel.org>; Wed, 21 Dec 2022 09:08:48 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 4327A16E2B;
        Wed, 21 Dec 2022 17:08:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1671642527; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=2f8f1F8uEfJc/qPbA3BJCWGXsaEMwp70q3lYqnE7I3o=;
        b=DB1pcG7FCn/AIUqVvZkQSOURmBYT1Wdd8KSqz5DJaawVsP20R0bAEdwiBCIMGGfAmgWKFB
        n08XP1VipVDQNrBBr6AQ4moq3MwNZlLMj7rJLxD6FpO3M0TCSnCPG8rWqgOGcOAwPGKqJR
        nVmHVoFP6LIuioipYXHgSp4FwmtcjRg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1671642527;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=2f8f1F8uEfJc/qPbA3BJCWGXsaEMwp70q3lYqnE7I3o=;
        b=LJebCjaOTtv8rAu9FH9Y1/gJbMy5untIT9tSMZjO1FjIX+BclYoOol7zpL8UAaSoJeTFTH
        tSKkJcWtbOaGJsBw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 33A641390E;
        Wed, 21 Dec 2022 17:08:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id lWCSDJ89o2MYXQAAMHmgww
        (envelope-from <dwagner@suse.de>); Wed, 21 Dec 2022 17:08:47 +0000
From:   Daniel Wagner <dwagner@suse.de>
To:     linux-trace-devel@vger.kernel.org
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Daniel Wagner <dwagner@suse.de>
Subject: [PATCH v1 0/2] Add initial support for meson
Date:   Wed, 21 Dec 2022 18:08:42 +0100
Message-Id: <20221221170844.10977-1-dwagner@suse.de>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

A first rough version of mesioning libtracecmd and trace-cmd. I've
created to meson project for this, as I understood the goal is to
split the code base into two pieces eventually. I think it would also
possible just to have one meson project which creates the binaries
which would propably make a few awkard hacks in this attempt go away,
e.g. trace-cmd wants statically build libtracecmd.

Daniel Wagner (2):
  libtracecmd: Add initial support for meson
  trace-cmd: Add initial support for meson

 Documentation/libtracecmd/list-txt.sh     |   5 +
 Documentation/libtracecmd/meson.build     | 115 ++++++++++++++++++++++
 Documentation/trace-cmd/list-txt.sh       |   5 +
 Documentation/trace-cmd/meson.build       | 115 ++++++++++++++++++++++
 lib/Documentation                         |   1 +
 lib/meson.build                           | 107 ++++++++++++++++++++
 lib/meson_options.txt                     |  23 +++++
 lib/trace-cmd/include/meson.build         |   5 +
 lib/trace-cmd/include/private/meson.build |  14 +++
 lib/trace-cmd/meson.build                 |  61 ++++++++++++
 meson.build                               | 112 +++++++++++++++++++++
 meson_options.txt                         |  25 +++++
 python/meson.build                        |  40 ++++++++
 tracecmd/meson.build                      |  47 +++++++++
 utest/meson.build                         |  18 ++++
 15 files changed, 693 insertions(+)
 create mode 100644 Documentation/libtracecmd/list-txt.sh
 create mode 100644 Documentation/libtracecmd/meson.build
 create mode 100644 Documentation/trace-cmd/list-txt.sh
 create mode 100644 Documentation/trace-cmd/meson.build
 create mode 120000 lib/Documentation
 create mode 100644 lib/meson.build
 create mode 100644 lib/meson_options.txt
 create mode 100644 lib/trace-cmd/include/meson.build
 create mode 100644 lib/trace-cmd/include/private/meson.build
 create mode 100644 lib/trace-cmd/meson.build
 create mode 100644 meson.build
 create mode 100644 meson_options.txt
 create mode 100644 python/meson.build
 create mode 100644 tracecmd/meson.build
 create mode 100644 utest/meson.build

-- 
2.39.0

