Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC0AEC433E0
	for <linux-trace-devel@archiver.kernel.org>; Wed, 17 Mar 2021 16:42:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5E1E864F6A
	for <linux-trace-devel@archiver.kernel.org>; Wed, 17 Mar 2021 16:42:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232509AbhCQQlm (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 17 Mar 2021 12:41:42 -0400
Received: from smtpx.feld.cvut.cz ([147.32.210.153]:59303 "EHLO
        smtpx.feld.cvut.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232335AbhCQQld (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 17 Mar 2021 12:41:33 -0400
Received: from localhost (styx [192.168.200.7])
        by smtpx.feld.cvut.cz (Postfix) with ESMTP id 145F9424C3;
        Wed, 17 Mar 2021 17:41:23 +0100 (CET)
X-Virus-Scanned: IMAP STYX AMAVIS
Received: from smtpx.feld.cvut.cz ([192.168.200.2])
        by localhost (styx.feld.cvut.cz [192.168.200.7]) (amavisd-new, port 10060)
        with ESMTP id rmKow8IAIgEm; Wed, 17 Mar 2021 17:41:21 +0100 (CET)
Received: from steelpick.2x.cz (ip-94-112-192-124.net.upcbroadband.cz [94.112.192.124])
        (Authenticated sender: sojkam1)
        by smtpx.feld.cvut.cz (Postfix) with ESMTPSA id 1770D422E4;
        Wed, 17 Mar 2021 17:41:21 +0100 (CET)
Received: (nullmailer pid 30931 invoked by uid 1000);
        Wed, 17 Mar 2021 16:41:20 -0000
From:   Michal Sojka <michal.sojka@cvut.cz>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        linux-trace-devel@vger.kernel.org,
        Michal Sojka <michal.sojka@cvut.cz>
Subject: [PATCH 0/4] kernel-shark: CMake changes
Date:   Wed, 17 Mar 2021 17:40:57 +0100
Message-Id: <20210317164101.30848-1-michal.sojka@cvut.cz>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This patch series is a follow up to my previous patch for the older
kernel-shark repo. The first two patches will make life easier for
distributions like NixOS, the last two patches replace my previous
patch.

Note that I didn't add kshark-su-record to a separate component, as
suggested by Yordan, because it is not necessary. The generated polkit
action will refer to the correct path and I think it is preferable to
have all kernelshark binaries in the same directory.

Michal Sojka (4):
  kernel-shark: Allow specifying PKG_CONFIG_DIR on cmake command line
  kernel-shark: Allow specifying TT_FONT_FILE on cmake command line
  kernel-shark: Allow installing polkit policy separately
  kernel-shark: Do not use sudo in install_gui.sh + update README

 CMakeLists.txt       | 12 ++++++++++--
 README               |  2 +-
 build/install_gui.sh | 10 +++++++++-
 src/CMakeLists.txt   | 10 ++++++----
 4 files changed, 26 insertions(+), 8 deletions(-)

-- 
2.30.1

