Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79EC9C433F5
	for <linux-trace-devel@archiver.kernel.org>; Sun, 23 Jan 2022 02:08:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231425AbiAWCI0 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sat, 22 Jan 2022 21:08:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229897AbiAWCIZ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sat, 22 Jan 2022 21:08:25 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A45E6C06173B
        for <linux-trace-devel@vger.kernel.org>; Sat, 22 Jan 2022 18:08:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 93835CE0ACD
        for <linux-trace-devel@vger.kernel.org>; Sun, 23 Jan 2022 02:08:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BFAEC004E1;
        Sun, 23 Jan 2022 02:08:21 +0000 (UTC)
Date:   Sat, 22 Jan 2022 21:08:19 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Dario Faggioli <dfaggioli@suse.com>
Cc:     linux-trace-devel@vger.kernel.org,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Subject: Re: [PATCH 0/2] (Trivial) README fix and libtracecmd SONAME
Message-ID: <20220122210819.45bd85d5@rorschach.local.home>
In-Reply-To: <164267787600.9929.14996075092071019143.stgit@work>
References: <164267787600.9929.14996075092071019143.stgit@work>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 20 Jan 2022 12:34:08 +0100
Dario Faggioli <dfaggioli@suse.com> wrote:

> Hi!
> 
> So, patch 1 of this small series just get rid of a stale mention to
> libparsevent in the README file.
> 
> About patch 2. Some distributions have the requirement that the package
> name contains/is related to the SONAME (for packages that ship libraries,
> of course).
> 
> Currently, the SONAME of libtracecmd is something like libtracecmd.so.0.0.1
> or libtracecmd.so.1.0.0. This is not a problem, but I think libtracecmd.so.0
> (libtracecmd.so.1) is a bit more convenient.
> 
> It is also how things are for libtracefs and libtraceevent.
> 
> So, patch 2 does exactly that for libtracecmd, if that could be
> interesting. :-)
> 
> If, instead, it was intentional and there is an actual reason for the
> SONAME of libtracecmd to be the entire file name of the .so file, then I
> guess I've missed it. In which case, sorry for the noise.
> 
> 

Applied. Thanks Dario.

Although I had to tweak the subjects to have them start with a capital
letter (like a sentence). And I also fixed a typo in the change log of
the second patch.

-- Steve
