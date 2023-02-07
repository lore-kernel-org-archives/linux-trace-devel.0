Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E76BC636D6
	for <linux-trace-devel@archiver.kernel.org>; Tue,  7 Feb 2023 15:11:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230450AbjBGPLB (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 7 Feb 2023 10:11:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231274AbjBGPK6 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 7 Feb 2023 10:10:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 071BF3A5A2
        for <linux-trace-devel@vger.kernel.org>; Tue,  7 Feb 2023 07:10:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 19897B8171E
        for <linux-trace-devel@vger.kernel.org>; Tue,  7 Feb 2023 15:10:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75B48C4339C;
        Tue,  7 Feb 2023 15:10:03 +0000 (UTC)
Date:   Tue, 7 Feb 2023 10:10:01 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Daniel Wagner <dwagner@suse.de>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v6 0/2] Add initial support for meson
Message-ID: <20230207101001.5ef90b44@gandalf.local.home>
In-Reply-To: <20230207134825.uexdcqlopkuqehuy@carbon.lan>
References: <20230207124634.6515-1-dwagner@suse.de>
        <20230207134825.uexdcqlopkuqehuy@carbon.lan>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 7 Feb 2023 14:48:25 +0100
Daniel Wagner <dwagner@suse.de> wrote:

> On Tue, Feb 07, 2023 at 01:46:32PM +0100, Daniel Wagner wrote:
> > This version brings a few cleanups on the documentation intallation path
> > and pkg-config depenedency updates.
> > 
> > Changes:
> > 
> > v6:
> >   - lib: isntall trace-cmd.h directly in /usr/include and not subdir
> >     trace-cmd. kernelshark builds breaks otherwise  
> 
> No, this is not the real problem. The Makefile also installs it under
> /usr/include/trace-cmd.

But `pkg-config --cflags libtracecmd` should give the right path:

  -I/usr/include/trace-cmd -I/usr/include/tracefs -I/usr/include/traceevent

This is the way it's always been. Why are your kernelshark builds breaking?

-- Steve
