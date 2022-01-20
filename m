Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D848C433EF
	for <linux-trace-devel@archiver.kernel.org>; Thu, 20 Jan 2022 11:34:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230037AbiATLeL (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 20 Jan 2022 06:34:11 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:40746 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231657AbiATLeK (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 20 Jan 2022 06:34:10 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id AA23D2170E;
        Thu, 20 Jan 2022 11:34:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1642678449; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=2G4Yrtvu7ms+/Jllm2TU4OZVaycXJQNAxMVXsSRjXIo=;
        b=q2lTTSNygAhdyFzXt2QQu1S+Q/tZ9DiHruxsHi2Um7gPfoRNHYlBK6kTSEQHY4JJhBD40U
        2RRL/2V2xl9XT/MkSxy934XvdqMy/P6NMzm7ewbTWtFkpsZ8/pBkqJ8puTr2szO0k20vF9
        8vZfiNJnus6FQyrlSjltX1lM7Kz+j8Y=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 7AE1013E46;
        Thu, 20 Jan 2022 11:34:09 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 68l7G7FI6WF8RgAAMHmgww
        (envelope-from <dfaggioli@suse.com>); Thu, 20 Jan 2022 11:34:09 +0000
Subject: [PATCH 0/2] (Trivial) README fix and libtracecmd SONAME
From:   Dario Faggioli <dfaggioli@suse.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Date:   Thu, 20 Jan 2022 12:34:08 +0100
Message-ID: <164267787600.9929.14996075092071019143.stgit@work>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi!

So, patch 1 of this small series just get rid of a stale mention to
libparsevent in the README file.

About patch 2. Some distributions have the requirement that the package
name contains/is related to the SONAME (for packages that ship libraries,
of course).

Currently, the SONAME of libtracecmd is something like libtracecmd.so.0.0.1
or libtracecmd.so.1.0.0. This is not a problem, but I think libtracecmd.so.0
(libtracecmd.so.1) is a bit more convenient.

It is also how things are for libtracefs and libtraceevent.

So, patch 2 does exactly that for libtracecmd, if that could be
interesting. :-)

If, instead, it was intentional and there is an actual reason for the
SONAME of libtracecmd to be the entire file name of the .so file, then I
guess I've missed it. In which case, sorry for the noise.

Regards
---
Dario Faggioli (2):
      README: remove stale mention to libparsevent
      libtracecmd: use major version as SONAME

 lib/trace-cmd/Makefile | 2 +-
 scripts/utils.mk       | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)
--
Dario Faggioli, Ph.D
http://about.me/dario.faggioli
Virtualization Software Engineer
SUSE Labs, SUSE https://www.suse.com/
-------------------------------------------------------------------
<<This happens because _I_ choose it to happen!>> (Raistlin Majere)

