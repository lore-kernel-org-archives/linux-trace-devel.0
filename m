Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87429C433FE
	for <linux-trace-devel@archiver.kernel.org>; Thu, 24 Feb 2022 00:10:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245147AbiBXAK0 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 23 Feb 2022 19:10:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245143AbiBXAKZ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 23 Feb 2022 19:10:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EA4E5F24D;
        Wed, 23 Feb 2022 16:09:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EE05160B49;
        Thu, 24 Feb 2022 00:09:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 491C0C340E7;
        Thu, 24 Feb 2022 00:09:54 +0000 (UTC)
Date:   Wed, 23 Feb 2022 19:09:52 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     LKML <linux-kernel@vger.kernel.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        "linux-trace-users@vger.kernel.org" 
        <linux-trace-users@vger.kernel.org>,
        Daniel Bristot de Oliveira <bristot@redhat.com>
Cc:     Zamir SUN <sztsian@gmail.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, zsun@redhat.com,
        Vitaly Chikunov <vt@altlinux.org>,
        Tzvetomir Stoyanov <tstoyanov@vmware.com>,
        Yordan Karadzhov <ykaradzhov@vmware.com>,
        Ben Hutchings <ben@decadent.org.uk>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Tony Jones <tonyj@suse.de>, John Kacur <jkacur@redhat.com>,
        Clark Williams <williams@redhat.com>,
        Jes Sorensen <jes.sorensen@gmail.com>
Subject: Re: [ANNOUNCE] libtracefs 1.3
Message-ID: <20220223190952.084f4685@rorschach.local.home>
In-Reply-To: <20220223183939.3650aabd@rorschach.local.home>
References: <20220223183939.3650aabd@rorschach.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

[ Resend as one of my emails was corrupted]

On Wed, 23 Feb 2022 18:39:39 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:

> Long over due, but libtracefs 1.3 has finally been released!

And I forgot to post the links:

git repo: https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/

tarball: https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/snapshot/libtracefs-1.3.0.tar.gz

man pages: https://www.trace-cmd.org/Documentation/libtracefs/libtracefs.html

-- Steve
