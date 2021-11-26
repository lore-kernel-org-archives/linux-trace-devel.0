Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 677C7C433F5
	for <linux-trace-devel@archiver.kernel.org>; Fri, 26 Nov 2021 18:33:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238318AbhKZSgm (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 26 Nov 2021 13:36:42 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:39014 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241440AbhKZSem (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 26 Nov 2021 13:34:42 -0500
X-Greylist: delayed 496 seconds by postgrey-1.27 at vger.kernel.org; Fri, 26 Nov 2021 13:34:42 EST
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5CC1D62321
        for <linux-trace-devel@vger.kernel.org>; Fri, 26 Nov 2021 18:23:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23DA0C93056;
        Fri, 26 Nov 2021 18:23:12 +0000 (UTC)
Date:   Fri, 26 Nov 2021 13:23:03 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Masami Hiramatsu <mhiramat@kernel.org>
Cc:     Beau Belgrave <beaub@linux.microsoft.com>,
        linux-trace-devel@vger.kernel.org,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Subject: Re: [PATCH v2] libtraceevent: Add __rel_loc relative location
 attribute support
Message-ID: <20211126132303.25f4fd4d@oasis.local.home>
In-Reply-To: <20211126212026.e6b035ac8ec318b06030221f@kernel.org>
References: <20211122223909.15f6fb50@rorschach.local.home>
        <163767457857.543504.6091850281066240970.stgit@devnote2>
        <20211124180708.599aa110@gandalf.local.home>
        <20211126212026.e6b035ac8ec318b06030221f@kernel.org>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 26 Nov 2021 21:20:26 +0900
Masami Hiramatsu <mhiramat@kernel.org> wrote:

> > We need to be careful about modifying content in event-parse.h. Because
> > this is exposed outside he library.  
> 
> Oh, I thought this is an internal header, because it is under src/ directory.
> However, indeed "TEP_FIELD_IS_*" referred from perf-tools, so this might be
> need to be exposed.

Yeah, we need to fix this.

The issue was that this is loaded with legacy code. The code was
created in trace-cmd, ported to the kernel into tools/lib/traceevent,
then pulled out into it's own directory. The poor library had so many
foster parents, that it wasn't ready to go out on its own.

I'll fix some of this before posting a new version.

-- Steve
