Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D544C433EF
	for <linux-trace-devel@archiver.kernel.org>; Thu, 20 Jan 2022 11:34:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230476AbiATLeQ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 20 Jan 2022 06:34:16 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:40786 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231657AbiATLeQ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 20 Jan 2022 06:34:16 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 70BA8218A9;
        Thu, 20 Jan 2022 11:34:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1642678455; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=C/TxB5tTLoXGK1CTFhuQ/n+zoSIA/Ycq/E6UMAP4+Uw=;
        b=fwizvZ+xATTzWLtJ2c+ajWDS+SbVIZB4lztJGAmsPov32BvC+20rx2ceQPuPjvSkC95EYx
        n4JtjX/KJuReVZ7Mlge1blMO0eEMb50mliLBnNpnGASuEyZBy3PaXA/BiQxiJ9FtJ1mWjl
        M0xUdLzQlgbuBt/MD0wN/LK/Lgc49XM=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 41C6C13E46;
        Thu, 20 Jan 2022 11:34:15 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id Yc2dDbdI6WGNRgAAMHmgww
        (envelope-from <dfaggioli@suse.com>); Thu, 20 Jan 2022 11:34:15 +0000
Subject: [PATCH 1/2] README: remove stale mention to libparsevent
From:   Dario Faggioli <dfaggioli@suse.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Date:   Thu, 20 Jan 2022 12:34:14 +0100
Message-ID: <164267845474.9929.18346649306258248794.stgit@work>
In-Reply-To: <164267787600.9929.14996075092071019143.stgit@work>
References: <164267787600.9929.14996075092071019143.stgit@work>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Signed-off-by: Dario Faggioli <dfaggioli@suse.com>
---
Cc: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
---
 README |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/README b/README
index 9a3533d..9d8c127 100644
--- a/README
+++ b/README
@@ -14,9 +14,7 @@ These files make up the code that create the trace-cmd programs.
 This includes the GUI interface application kernelshark as well
 as trace-graph and trace-view.
 
-These files also make up the code to create the libraries
-
-  libtracecmd and libparsevent
+These files also make up the code to create the libtracecmd library.
 
 The applications are licensed under the GNU General Public License 2.0
 (see COPYING) and the libraries are licensed under the GNU


